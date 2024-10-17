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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
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
	
	@GetMapping("/detail")
	public String detail(Model model) {
		postService.updateView(1);
//		PostVO post = postService.getPost(1);
		Map<String, Object> post = postService.getPostMap(1);
		model.addAttribute("post", post);
		
		return "/post/detail";
	}
	
	@GetMapping("/delete/{post_num}")
	public String delete(@PathVariable("post_num") int post_num) {
		boolean res = postService.deletePost(post_num);
		if(res) {
			return "redirect:/post/list";
		} else {
			return "redirect:/post/detail/"+ post_num;
		}
	}
	
}
