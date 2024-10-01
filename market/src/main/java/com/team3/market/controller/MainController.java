package com.team3.market.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.team3.market.model.vo.CategoryVO;
import com.team3.market.service.PostService;

@Controller
public class MainController {
	
	private PostService postService;
	
	@GetMapping("/")
	public String Main(Model model) {
		return "index";
	}
	
	@GetMapping("index")
	public String categorytList(Model model) {
		List<CategoryVO> category = postService.getCategoryList();
		model.addAttribute("category", category);
		return "index";
	}
	
//	@GetMapping("/post/list/{category_num}")
//	public String postList(Model model, @PathVariable int category_num) {
//		List<CategoryVO> list = postService.getPostList();
//		List<CategoryVO> category = postService.getCategoryList();
//		model.addAttribute("list", list);
//		model.addAttribute("category", category);
//		return "post/list";
//	}
	
}
