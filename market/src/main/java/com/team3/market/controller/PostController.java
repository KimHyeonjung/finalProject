package com.team3.market.controller;

import java.util.Arrays;
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
    @ResponseBody
    @PostMapping("/insert")
    public String insertPost(Model model, PostVO post, HttpSession session, MultipartFile[] files) {
//    	System.out.println("Request received"); // 디버깅 메시지 추가
//    	System.out.println("파일 길이 : " + files.length);
//    	System.out.println(post);
	    // 파일 선택 체크
	    if (files == null || files.length == 0) {
	        return "FILE_NOT_EXIST";
	    }
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
		
    	int post_num = postService.insertPost(post, user, files);
		
		for(MultipartFile file : files) {
			System.out.println(file.getOriginalFilename());
		}
		
		if(post_num > 0 ) {	
			return "REGISTRATION_POST::" + post_num;
		}else {
			return "FAIL_REGISTRATION";
		}
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
		FileVO profileImg = postService.getProfileImg("member", (Integer)post.get("post_member_num"));
		model.addAttribute("report", report);		
		model.addAttribute("wish", wish);
		model.addAttribute("post", post);
		model.addAttribute("fileList", fileList);
		model.addAttribute("profile", profileImg);
		return "/post/detail";
	}	
	@GetMapping("/update/{post_num}")
	public String postUpdate(Model model, @PathVariable("post_num")int post_num, HttpSession session) {
		Map<String, Object> post = postService.getPostMap(post_num);
		List<FileVO> fileList = postService.selectFileList(post_num, "post");
		List<String> categoryList = postService.getCategoryList();
        model.addAttribute("categoryList", categoryList);    
		model.addAttribute("post", post);
		model.addAttribute("fileList", fileList);
		return "/post/update";
	}	
	@ResponseBody
	@PostMapping("/update")
    public String updatePost(Model model, PostVO post, HttpSession session, MultipartFile[] files, int[] existingFileNums) {
//    	System.out.println("Request received"); // 디버깅 메시지 추가
//    	System.out.println("post : " + post);
//    	System.out.println("파일 길이 : " + files.length);
//    	Arrays.stream(existingFileNums).forEach(System.out::println);
    	
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
    	boolean res = postService.updatePost(post, user, files, existingFileNums);
    	
    	if(res) {
    		return "UPDATE_POST";
    	}else {
    		return "FAIL_UPDATE";
    	}
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