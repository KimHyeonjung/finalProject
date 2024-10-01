package com.team3.market.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;




@Controller
@NoArgsConstructor
public class Login {
	
	@GetMapping("/login")
	public String Login() {
		return "/login";
	}
	
	@PostMapping("/login")
	public String Login(@RequestParam("member_id")String me_id, @RequestParam("member_pw")String me_pw) {
		System.out.printf(me_id);
		System.out.printf(me_pw);
		return "/index";
	}
	
	
}
