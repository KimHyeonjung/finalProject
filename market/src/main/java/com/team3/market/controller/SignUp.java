package com.team3.market.controller;

import org.springframework.stereotype.Controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
@AllArgsConstructor
public class SignUp {
	@GetMapping("/signup")
	public String SignUp() {
		return "/signup";
	}
}
