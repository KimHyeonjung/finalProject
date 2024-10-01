package com.team3.market.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.NoArgsConstructor;


@Controller
@NoArgsConstructor
public class Login {
	@GetMapping("/login")
	public String login() {
		return "/login";
	}
}
