package com.team3.market.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

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
