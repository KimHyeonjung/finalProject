package com.team3.market.controller;

import org.springframework.stereotype.Controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.MemberService;



@Controller
@AllArgsConstructor
public class SignUp {
	
	private MemberService memberService;
	
	@GetMapping("/signup")
	public String SignUp() {
		return "/signup";
	}
	
	@PostMapping("/signup")
	public String SignUp(MemberVO member) {
		boolean res = memberService.insertMember(member);
		if (res) {
			return "/index";
		}
		return "/signup";
	}
	
}
