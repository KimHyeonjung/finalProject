package com.team3.market.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.team3.market.model.vo.PostVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	PostService postService;
	
	@GetMapping("/insert")
	public String insert() {

		return "/post/insert";
	}
	
	@GetMapping("/detail")
	public String detail(Model model) {
		
		PostVO post = postService.getPost(1);
		model.addAttribute("post", post);
		
		return "/post/detail";
	}
}
