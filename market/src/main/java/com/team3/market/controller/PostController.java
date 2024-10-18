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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mysql.cj.ParseInfo;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.WishVO;
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
	
	@GetMapping("/detail/{post_num}")
	public String detail(Model model, @PathVariable("post_num")int post_num, HttpSession session) {
		postService.updateView(post_num);
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, Object> post = postService.getPostMap(post_num);
		WishVO wish = postService.getWish(post_num, user);
		ReportVO report = postService.getReportPost(post_num, user);
		model.addAttribute("report", report);		
		model.addAttribute("wish", wish);
		model.addAttribute("post", post);
		return "/post/detail";
	}	
	
	@ResponseBody
	@PostMapping("/wish")
	public boolean wish(Model model, @RequestParam("post_num") int post_num, HttpSession session) {
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
}
