package com.team3.market.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.MemberService;


@Controller
public class HomeController {
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
	
		return "/home";//타일즈에서 /*로 했기 때문에 /를 붙임
	}
	
	 @GetMapping("/signup")
	    public String showSignupForm() {
	        return "/member/signup";
	    }

	    @PostMapping("/signup")
	    public String processSignup(Model model, MemberVO member) {
	        
	        boolean res = memberService.signup(member);
	        
	        MessageDTO message;
	        if(res) {
	            message = new MessageDTO("/", "회원가입에 성공했습니다.");
	        } else {
	            message = new MessageDTO("/signup", "아이디나 이메일이 중복되었습니다.");
	        }
	        
	        model.addAttribute("message", message);
	        return "/main/message";
	    }
	
}
