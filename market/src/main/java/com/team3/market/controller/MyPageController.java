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
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	
	@Autowired
	PostService postService;
	
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
}
