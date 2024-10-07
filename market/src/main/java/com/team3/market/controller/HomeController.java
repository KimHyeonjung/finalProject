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
        return "signup"; // 회원가입 폼을 보여주는 JSP로 이동
    }
	
	@PostMapping("/signup")
    public String signup(MemberVO member, RedirectAttributes rttr) {
        // 비밀번호 암호화 (추후 구현 예정)
        // member.setMember_pw(암호화된 비밀번호);
        
		try {
            memberService.registerMember(member);
            rttr.addFlashAttribute("msg", "회원가입 성공!");
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "회원가입 실패!");
        }

        return "redirect:/login"; // 회원가입 후 로그인 페이지로 이동
    }
	
	
}
