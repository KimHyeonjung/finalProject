package com.team3.market.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.service.MemberService;
import com.team3.market.service.PostService;


@Controller
public class HomeController {
	
	@Autowired
	MemberService memberService;
	@Autowired
	PostService postService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
		List<PostVO> list = postService.getPostList();
		model.addAttribute("list", list);
	
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
    @GetMapping("/login")
    public String showLoginForm() {
        return "/member/login";
    }
    @PostMapping("/login")
    public String guestLoginPost(Model model, MemberVO member, HttpSession session, RedirectAttributes redirectAttributes) {
		MemberVO user = memberService.login(member);

		if (user != null) {
			session.setAttribute("user", user); // 로그인 성공 시 세션에 사용자 정보 저장
			redirectAttributes.addFlashAttribute("message", "로그인 성공!");
			return "redirect:/";  // 홈으로 리다이렉트
		} else {
			redirectAttributes.addFlashAttribute("error", "로그인 실패! 아이디 또는 비밀번호가 올바르지 않습니다.");
			return "redirect:/login"; // 로그인 실패 시 로그인 페이지로 리다이렉트
		}
	}
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();  // 세션 무효화
        return "redirect:/";  // 홈으로 리다이렉트
    }
    
    // 아이디 중복 체크
    @GetMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam("member_id") String memberId) {
        MemberVO member = memberService.getMemberById(memberId);
        if (member != null) {
            return "EXISTS"; // 중복된 아이디
        }
        return "OK"; // 사용 가능한 아이디
    }
}