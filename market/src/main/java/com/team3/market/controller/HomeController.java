package com.team3.market.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tiles.request.Request;
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
import com.team3.market.service.MemberService;


@Controller
public class HomeController {
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		// 세션에 사용자 정보가 없을 때 자동 로그인 체크
		if (session.getAttribute("user") == null) {
			// 쿠키에서 "AL" 값을 확인
			Cookie[] cookies = request.getCookies();
			if (cookies != null) {
				for (Cookie cookie : cookies) {
					if (cookie.getName().equals("AL")) {
						String cookieValue = cookie.getValue();
						// 쿠키 값으로 사용자 확인
						MemberVO user = memberService.checkAutoLogin(cookieValue);

						// 유효한 쿠키가 있으면 자동 로그인 처리
						if (user != null) {
							session.setAttribute("user", user);
							break; // 자동 로그인이 성공하면 더 이상 반복하지 않음
						} else {
							// 만료된 쿠키라면 삭제 처리
							Cookie expiredCookie = new Cookie("AL", null);
							expiredCookie.setMaxAge(0);
							expiredCookie.setPath("/");
							response.addCookie(expiredCookie);
						}
					}
				}
			}
		}
		return "/home"; // 타일즈에서 /*로 했기 때문에 /를 붙임
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
    public String guestLoginPost(MemberVO member, HttpSession session, 
    		HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		MemberVO user = memberService.login(member);

		if (user != null) {
			session.setAttribute("user", user); // 로그인 성공 시 세션에 사용자 정보 저장
			
			//자동 로그인 쿠키 생성
			Cookie cookie = memberService.createCookie(user,request);
			response.addCookie(cookie);
            
			redirectAttributes.addFlashAttribute("message", "로그인 성공!");
			return "redirect:/";  // 홈으로 리다이렉트
		} else {
			redirectAttributes.addFlashAttribute("error", "로그인 실패! 아이디 또는 비밀번호가 올바르지 않습니다.");
			return "redirect:/login"; // 로그인 실패 시 로그인 페이지로 리다이렉트
		}
	}
    
    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();  // 세션 무효화
        
        //자동 로그인 쿠키 삭제
        Cookie cookie = new Cookie("AL", null);
        cookie.setMaxAge(0); // 쿠키 즉시 삭제
        cookie.setPath("/"); // 애플리케이션 전체에서 쿠키 삭제 적용
        response.addCookie(cookie);
        
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