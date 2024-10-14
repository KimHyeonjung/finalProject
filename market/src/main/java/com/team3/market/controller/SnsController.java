package com.team3.market.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.MemberService;

@Controller
public class SnsController {

	@Autowired
	MemberService memberService;
	
	@ResponseBody
	@PostMapping("/sns/{sns}/check/id")
	public boolean snsCheckId(@PathVariable("sns")String sns, @RequestParam("id")String id) {
		
		return memberService.idCheck(sns, id);
	}
	@ResponseBody
	@PostMapping("/sns/{sns}/signup")
	public boolean snsSignup(@PathVariable("sns")String sns, @RequestParam("id")String id,@RequestParam("email")String email) {
		
		return memberService.signupSns(sns, id, email);
	}
	@ResponseBody
	@PostMapping("/sns/{sns}/login")
	public boolean snsLogin(@PathVariable("sns")String sns, @RequestParam("id")String id, HttpSession session) {
		MemberVO user = memberService.loginSns(sns, id); 
		session.setAttribute("user", user);
		return user != null;
	}
}