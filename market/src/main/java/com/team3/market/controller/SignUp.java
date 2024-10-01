package com.team3.market.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

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
	public String SignUp(Model model, MemberVO member) {
		if (member == null || member.getMember_id() == "" || member.getMember_pw() == "" || member.getMember_nick() == "" || member.getMember_phone() == "" || member.getMember_email() == "") {
			model.addAttribute("message", "회원가입에 실패하였습니다.");
			return "/signup";
		}
		boolean res = memberService.insertMember(member);
		if (res) {
			model.addAttribute("message", "회원가입이 성공적으로 완료되었습니다!");
			return "/index";
		}
		model.addAttribute("message", "회원가입에 실패하였습니다.");
		return "/signup";
	}
	
}
