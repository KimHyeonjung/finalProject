package com.team3.market.controller;

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

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	PostService postService;
	
    @GetMapping("/insert")
    public String insert(Model model) {
        // 카테고리 목록을 가져와서 뷰에 전달
        List<String> categoryList = postService.getCategoryList();
        model.addAttribute("categoryList", categoryList);	
        
        return "/post/insert";
    }
	
    // 게시글 생성 처리
    @PostMapping("/insert")
    public String insertPost(Model model, PostVO post, HttpSession session, MultipartFile[] fileList) {
    	System.out.println("파일 길이 : " +fileList.length);
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
			message = new MessageDTO("/post/list", "게시글을 등록했습니다.");
		}else {
			message = new MessageDTO("/post/insert", "게시글을 등록하지 못했습니다.");
		}
		
		model.addAttribute("message",message);
		
		return "/main/message";
    }
	
	@GetMapping("/detail/{post_num}")
	public String detail(Model model, @PathVariable("post_num")int post_num, HttpSession session) {
		postService.updateView(post_num);
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, Object> post = postService.getPostMap(post_num);
		List<FileVO> fileList = postService.selectFileList(post_num, "post");
		WishVO wish = postService.getWish(post_num, user);
		ReportVO report = postService.getReportPost(post_num, user);
		model.addAttribute("report", report);		
		model.addAttribute("wish", wish);
		model.addAttribute("post", post);
		model.addAttribute("fileList", fileList);
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
		return res;
	}
}