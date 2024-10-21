package com.team3.market.controller;

import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
	
		return "/main/home";//타일즈에서 /*로 했기 때문에 /를 붙임
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
    public String guestLoginPost(Model model, MemberVO member, HttpSession session, 
            RedirectAttributes redirectAttributes,
            HttpServletRequest request,HttpServletResponse response) {
			MemberVO user = memberService.login(member);
			
			if (user != null) {
			session.setAttribute("user", user); // 로그인 성공 시 세션에 사용자 정보 저장
			
			// 자동 로그인 체크 여부 확인
			String auto = request.getParameter("autoLogin");
			System.out.println("AutoLogin Parameter: " + auto);
			if (auto != null && auto.equals("Y")) {
				Cookie cookie = memberService.createCookie(user, request);
				response.addCookie(cookie);
			}
					
			redirectAttributes.addFlashAttribute("message", "로그인 성공!");
			return "redirect:/";  // 홈으로 리다이렉트
		} else {
			redirectAttributes.addFlashAttribute("error", "로그인 실패! 아이디 또는 비밀번호가 올바르지 않습니다.");
			return "redirect:/login"; // 로그인 실패 시 로그인 페이지로 리다이렉트
		}
	}
    
    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
    	MemberVO user = (MemberVO) session.getAttribute("user");
    	if(user != null) {
			user.setMember_cookie(null);
			user.setMember_limit(null);
			memberService.updateMemberCookie(user);
			
			Cookie cookie = new Cookie("AL", null);
	        cookie.setMaxAge(0); // 쿠키 만료
	        cookie.setPath("/");
	        response.addCookie(cookie);
		}
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
    
    @GetMapping("/mypage")
	public String mypage() {
		return "/mypage";
	}
	
	@PostMapping("/delete")
	public String deleteAccount(Model model, HttpSession session, MemberVO member) {
		
		MemberVO user = (MemberVO)session.getAttribute("user");
    
	    boolean res = memberService.deleteMember(user);
	    
	    MessageDTO message;
	    if(res) {
	        message = new MessageDTO("/", "회원 탈퇴에 성공했습니다.");
	    } else {
	        message = new MessageDTO("/redirect:/mypage", "회원 탈퇴에 실패했습니다.");
	    }
	    
	    model.addAttribute("message", message);
	    return "/main/message";
	}
	
	@GetMapping("/updatepw")
	public String updatepw() {
		return "/updatepw";
	}
	
	@PostMapping("/updatepw")
	@ResponseBody
	public String updatepw(Model model, HttpSession session,
						@RequestParam("new_member_pw") String newPassword, 
						@RequestParam("member_pw") String oldPassword, 
						@RequestParam("new_member_pw2") String newPasswordConfirm) {
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		MessageDTO message;
		
		if(!newPassword.equals(newPasswordConfirm)) {
			message = new MessageDTO("/updatepw", "비밀번호가 일치하지 않습니다.");
		}
		
		boolean change = memberService.changepw(user, session, oldPassword, newPassword);
		
		if(change) {
			return "/market/mypage";
		}
		else {
			message = new MessageDTO("/updatepw", "비밀번호 변경 실패. 올바른 비밀 번호인지 확인하세요");
		}
		
		model.addAttribute("message", message);
	    return "/main/message";
		
	}
	
	@GetMapping("/updateemail")
	public String updateemail() {
		return "/updateemail";
	}
	
	
	@PostMapping("/updateemail")
	@ResponseBody
	public String updateemail(Model model, HttpSession session,
						@RequestParam("member_email") String newEmail) {
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		MessageDTO message;
		
		boolean change = memberService.changeemail(user, session, newEmail);
		
		if(change) {
			return "/market/mypage";
		}
		else {
			message = new MessageDTO("/updateemail", "비밀번호 변경 실패. 올바른 비밀 번호인지 확인하세요");
		}
		
		model.addAttribute("message", message);
	    return "/main/message";
		
	}
	
	@GetMapping("/updatephone")
	public String updatephone() {
		return "/updatephone";
	}
	
	
	@PostMapping("/updatephone")
	@ResponseBody
	public String updatephone(Model model, HttpSession session,
						@RequestParam("member_phone") String newPhone) {
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		MessageDTO message;
		
		boolean change = memberService.changephone(user, session, newPhone);
		
		if(change) {
			return "/market/mypage";
		}
		else {
			message = new MessageDTO("/updatephone", "비밀번호 변경 실패. 올바른 비밀 번호인지 확인하세요");
		}
		
		System.out.println(user);
		
		model.addAttribute("message", message);
	    return "/main/message";
		
	}
	
}