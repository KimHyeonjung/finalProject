package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.pagination.MyPostCriteria;
import com.team3.market.pagination.PageMaker;
import com.team3.market.service.ChatService;
import com.team3.market.service.MemberService;
import com.team3.market.service.PostService;
import com.team3.market.service.WalletService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	
	@Autowired
	PostService postService;
	@Autowired
	ChatService chatService;
	@Autowired
	WalletService walletService;
	@Autowired
	MemberService memberService;
	
	@GetMapping({"/wish/list/{sort_type}","/wish/list"})
	public String wishList(Model model, @PathVariable(name = "sort_type", required = false)String sort_type, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<PostVO> list = postService.getWishPostList(user, sort_type);
		model.addAttribute("list", list);
		return "/mypage/wish";
	}
	@ResponseBody
	@PostMapping("/wish/delete")
	public boolean wishDelete(@RequestBody Map<String, List<String>> nums, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<String> post_nums = nums.get("post_nums");
		boolean res = postService.deleteWishList(post_nums, user);
		return res;
	}
	@GetMapping("/post/list")
	public String postList(Model model, HttpSession session, MyPostCriteria cri) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user != null) {
			cri.setMember_num(user.getMember_num());
		}
		List<PostVO> list = postService.getMyPostList(cri);
		PageMaker pm = postService.getPageMaker(cri);
		model.addAttribute("list", list);
		model.addAttribute("pm", pm);
		
		return "/mypage/myList";
	}
	@PostMapping("/post/state")
	@ResponseBody
	public PostVO postState(@RequestBody PostVO post) {
		return postService.updatePosition(post);
	}
	@PostMapping("/post/delete") // 게시글 삭제
	@ResponseBody
	public boolean postDelete(@RequestParam("post_num") int post_num, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");	
		boolean res = postService.deletePost(post_num, user);
		return res;
	}
	@PostMapping("/post/refresh") // 끌올
	@ResponseBody
	public boolean postRefresh(@RequestParam("post_num") int post_num, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");	
		boolean res = postService.refresh(post_num, user);
		return res;
	}
	@PostMapping("/refresh/check") // 끌올 가능 체크
	@ResponseBody
	public int refreshCheck(@RequestParam("post_num") int post_num) {
		int res = postService.refreshCheck(post_num);
		return res;
	}
	@PostMapping("/post/thumbnail") // 썸네일
	@ResponseBody
	public FileVO postThumbnail(@RequestParam("post_num") int post_num) {
		FileVO file = postService.getFileThumbnail("post", post_num);
		return file;
	}
	
	// 채팅방 리스트 반환 메서드
    @ResponseBody
    @GetMapping("/chatRooms")
    public List<ChatRoomDTO> getChatRoomsForUser(@SessionAttribute("memberNum") Integer memberNum) {
        return chatService.getChatRoomsWithMembers(memberNum);
    }

    @PostMapping("/completeTransaction")
    public ResponseEntity<Map<String, String>> completeTransaction(@RequestBody Map<String, Object> requestData) {
        Map<String, String> response = new HashMap<>();
        try {
            int chatRoomNum = (int) requestData.get("chatRoomNum"); // JSON 데이터에서 chatRoomNum 추출
            chatService.completeTransaction(chatRoomNum);
            response.put("message", "거래가 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("message", "거래 완료 중 오류가 발생했습니다.");
            e.printStackTrace(); // 서버 로그에서 구체적인 오류를 확인할 수 있습니다.
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

	@ResponseBody
	@PostMapping("/updateprofile")
    public String updateProfile(Model model, HttpSession session, MultipartFile file) {
    	System.out.println("Request received"); // 디버깅 메시지 추가
    	System.out.println("파일 길이 : " + file.getOriginalFilename());
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
    	boolean res = memberService.updateProfile(user, file, session);
    	
    	if(res) {
    		return "UPDATE_PROFILE";
    	}else {
    		return "FAIL_UPDATE";
    	}
    }
}