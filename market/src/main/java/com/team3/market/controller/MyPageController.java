package com.team3.market.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	
	@Autowired
	PostService postService;
	
	@GetMapping("/wish/list")
	public String wishList(Model model, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<PostVO> list = postService.getWishPostList(user);
		model.addAttribute("list", list);
		return "/mypage/wish";
	}
}
