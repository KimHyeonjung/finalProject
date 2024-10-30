package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.handler.SocketHandler;
import com.team3.market.model.dto.CombinePostWithFileDTO;
import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.service.PostService;
import com.team3.market.utils.NotificationWebSocketHandler;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	PostService postService;
	@Autowired
    private NotificationWebSocketHandler notificationHandler;
	@Autowired
    private SocketHandler socketHandler; // SocketHandler 주입

	
    @GetMapping("/insert")
    public String insert(Model model, HttpSession session) {
        // 로그인 여부 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
        if (user == null) {
            // 로그인이 되어 있지 않으면 메인 페이지로 리다이렉트
            return "redirect:/login"; // 로그인 페이지로 변경 가능
        }

        // 카테고리 목록을 가져와서 뷰에 전달
        List<String> categoryList = postService.getCategoryList();
        model.addAttribute("categoryList", categoryList);    
        
        return "/post/insert";
    }
	
    // 게시글 생성 처리
    @PostMapping("/insert")
    public String insertPost(Model model, PostVO post, HttpSession session, MultipartFile[] fileList) {
    	System.out.println("Request received"); // 디버깅 메시지 추가
    	System.out.println("파일 길이 : " + fileList.length);
	    // 파일 선택 체크
	    if (fileList == null || fileList.length == 0) {
	        model.addAttribute("message", new MessageDTO("/post/insert", "파일을 선택하지 않았습니다."));
	        return "/main/message";
	    }
    	
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
    	System.out.println(post);
		
    	boolean res = postService.insertPost(post, user, fileList);

		MessageDTO message;
		
		for(MultipartFile file : fileList) {
			System.out.println(file.getOriginalFilename());
		}
		
		if(res) {	
			message = new MessageDTO("/", "게시글을 등록했습니다.");
		}else {
			message = new MessageDTO("/post/insert", "게시글을 등록하지 못했습니다.");
		}
		
		model.addAttribute("message",message);
		
		return "/main/message";
    }
    
    @GetMapping("/review")
    public String review(Model model, HttpSession session) {
        // 로그인 여부 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
		/*
		 * if (user == null) { // 로그인이 되어 있지 않으면 메인 페이지로 리다이렉트 return "redirect:/login";
		 * // 로그인 페이지로 변경 가능 }
		 */

        return "/post/review";
    }
    
    // 게시글 생성 처리
    @PostMapping("/review")
    public String insertReview(Model model, AfterVO review, HttpSession session) {
    	System.out.println("Request received"); // 디버깅 메시지 추가
    	
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
    	System.out.println(review);
		
    	boolean res = postService.insertReview(review, user);

		MessageDTO message;
		
		if(res) {	
			message = new MessageDTO("/", "리뷰를 등록했습니다.");
		}else {
			message = new MessageDTO("/post/review", "리뷰를 등록하지 못했습니다.");
		}
		
		model.addAttribute("message",message);
		
		return "/main/message";
    }
    
    @GetMapping("/list/{category_num}")
    public String postList(Model model, @PathVariable("category_num") int category_num) {
    	List<CombinePostWithFileDTO> list = postService.getPostListWithFileByCategory(category_num);
    	String category_name = postService.getCategoryName(category_num);
    	model.addAttribute("list", list);
    	model.addAttribute("category_name", category_name);
    	return "/post/list";
    }
	
	@GetMapping("/detail/{post_num}")
	public String postDetail(Model model, @PathVariable("post_num")int post_num, HttpSession session) {
		postService.updateView(post_num);
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, Object> post = postService.getPostMap(post_num);
		List<FileVO> fileList = postService.selectFileList(post_num, "post");
		WishVO wish = postService.getWish(post_num, user);
		ReportVO report = postService.getReportPost(post_num, user);
		FileVO profileImg = postService.getProfileImg((Integer)post.get("post_member_num"), "member");
		model.addAttribute("report", report);		
		model.addAttribute("wish", wish);
		model.addAttribute("post", post);
		model.addAttribute("fileList", fileList);
		model.addAttribute("profile", profileImg);
		return "/post/detail";
	}	
	
	@ResponseBody
	@PostMapping("/wish")
	public boolean wish(@RequestParam("post_num") int post_num, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		WishVO wish = postService.getWish(post_num, user);
		boolean res = false;
		if(wish == null) {
			postService.insertWish(post_num, user);
			res = true;			
		}else {
			postService.deleteWish(post_num, user);
			res = false;
		}
		return res;
	}
	@ResponseBody
	@PostMapping("/propose")
	public boolean propose(@RequestBody Map<String, Object> post, HttpSession session) {
		boolean res = false;
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(post == null || user == null) {
			return false;
		}
		ChatRoomVO chatRoom = postService.getChatRoom(post, user); 
		if(chatRoom == null) {
			res = postService.makeChatRoom(post, user);
		}else {
			res = postService.addChat(post, chatRoom);
		}
		res = postService.notify(post, user);
		if(res) {
			MemberVO postUser = postService.getMember((Integer)post.get("member_num"));
			try {
				notificationHandler.sendNotificationToUser(postUser.getMember_id(), "notification");
				socketHandler.sendMessage2("null", chatRoom.getChatRoom_num());
				return true;
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		return res;
	}
	
	@ResponseBody
	@PostMapping("/chat")
	public Map<String, Object> requestChat(@RequestBody Map<String, Object> post, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		Map<String, Object> result = new HashMap<String, Object>();

		if (post == null || user == null) {
			result.put("success", false);
			return result;
		}

		ChatRoomVO chatRoom = postService.getChatRoom(post, user);
		if (chatRoom == null) {
			// 채팅방이 없으면 생성
			boolean chatRoomCreated = postService.makeChatRoom2(post, user);
			if (chatRoomCreated) {
				chatRoom = postService.getChatRoom(post, user); // 새로 생성된 채팅방 가져오기
			}
		}

		if (chatRoom != null) {
			// 채팅방 번호를 반환해서 해당 채팅방으로 이동
			System.out.println("ChatRoomNum: " + chatRoom.getChatRoom_num());
			
			result.put("chatRoomNum", chatRoom.getChatRoom_num());
			result.put("success", true);
		} else {
			result.put("success", false);
		}

		return result;
	}

}