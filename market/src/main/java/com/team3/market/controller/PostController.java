package com.team3.market.controller;

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
		
		return "/post/insert";
	}
	
	@PostMapping("/insert")
	public String insertPost(Model model, PostVO post, MultipartFile [] fileList, HttpSession session) {
		System.out.println(post);
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		if (postService.insertPost(post, user, fileList)) {
			model.addAttribute("url", "/post/list");
			model.addAttribute("msg", "게시글을 등록했습니다.");
		}else {
			model.addAttribute("url", "/post/insert");
			model.addAttribute("msg", "게시글을 등록하지 못했습니다.");
		}
		
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
