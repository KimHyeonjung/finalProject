package com.team3.market.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.team3.market.service.WalletService;


@Controller
public class HomeController {
	
	@Autowired
	MemberService memberService;
	@Autowired
	PostService postService;
	@Autowired
	WalletService walletService;
	
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
	public String processSignup(Model model, MemberVO member, @RequestParam("verificationCode") String enteredCode, HttpSession session) {
        
        boolean res = memberService.signup(member, session, enteredCode);
        
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
			session.setAttribute("memberNum", user.getMember_num()); // 로그인 성공 시 세션에 memberNum 저장 // chatRoom 송금 시 사용
			
	        // 사용자 포인트 정보를 데이터베이스에서 가져옴
		    Integer updatedPoints = walletService.getUpdatedPoints(user.getMember_num());
		    session.setAttribute("point", updatedPoints); // 포인트 세션에 저장
		    
		    session.setAttribute("memberAuth", user.getMember_auth()); // 사용자 권한 정보를 세션에 저장

			
			// 자동 로그인 체크 여부 확인
			String auto = request.getParameter("autoLogin");
			if (auto != null && auto.equals("Y")) {
				Cookie cookie = memberService.createCookie(user, request);
				response.addCookie(cookie);
			}
					
			MessageDTO message = new MessageDTO("/", "로그인에 성공했습니다.");
			model.addAttribute("message", message);
			return "/main/message";  // 메시지 페이지로 이동
		    } else {
		    	MemberVO failedUser = memberService.getMemberById(member.getMember_id());
		    	if (failedUser != null && failedUser.getMember_locked() != null && failedUser.getMember_locked().after(new Date())) {
		            // 계정이 잠긴 경우
		            String lockTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(failedUser.getMember_locked());
		            redirectAttributes.addFlashAttribute("message", new MessageDTO("/login", 
		                "계정이 잠겼습니다. " + lockTime + "까지 로그인이 불가능합니다."));
		    	}else {
		    		// 로그인 실패 시 리다이렉트와 메시지 설정
		    		redirectAttributes.addFlashAttribute("message", new MessageDTO("/login", "아이디 혹은 비밀번호가 맞지 않습니다. 3회연속 로그인 실패시 계정이 30분동안 비활성화 됩니다."));
		    	}
		    	return "redirect:/login";
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
    public boolean checkId(@RequestParam("member_id") String memberId) {
    	
        MemberVO member = memberService.getMemberById(memberId);
        
        return member != null;
    }
    
    @GetMapping("/checkNick")
    @ResponseBody
    public boolean checkNick(@RequestParam("member_nick") String memberNick) {
    	
        MemberVO member = memberService.getMemberByNick(memberNick);
        
        return member != null;  
    }
    @GetMapping("/checkPhone")
    @ResponseBody
    public boolean checkPhone(@RequestParam("member_phone") String memberPhone) {
        MemberVO member = memberService.getMemberByPhone(memberPhone);
        
        return member != null;  
    }
    
    @GetMapping("/mypage")
	public String mypage() {
		return "/member/mypage";
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
		
		model.addAttribute("message", message);
	    return "/main/message";
		
	}
	
	@GetMapping("/findId")
	public String showFindIdForm() {
	    return "/member/findid";  // 아이디 찾기 폼 페이지로 이동
	}
	
	@PostMapping("/findId")
	public String findId(@RequestParam("member_nick") String memberNick, 
	                     @RequestParam("member_email") String memberEmail, Model model) {
	    
	    // 닉네임과 이메일을 사용해 아이디 조회
	    MemberVO member = memberService.findMemberId(memberNick, memberEmail);
	    
	    model.addAttribute("findId", member);
	    
	    return "/member/findidresult";  // 결과 메시지 페이지로 이동
	}
	
	@GetMapping("/findPassword")
	public String showFindPwForm() {
	    return "/member/findpw";  // 비밀번호 찾기 폼 페이지로 이동
	}
	
	@PostMapping("/findPassword")
	public String findPassword(@RequestParam("member_id") String memberId,
	                           @RequestParam("member_nick") String memberNick,
	                           @RequestParam("member_email") String memberEmail,
	                           Model model) {

	    // 회원 정보 조회
	    MemberVO user = memberService.findMemberPw(memberId, memberNick, memberEmail);

	    if (user != null) {
	        // 임시 비밀번호 생성
	        String tempPassword = memberService.generateTempPassword();

	        // 암호화된 임시 비밀번호 저장
	        memberService.updatePassword(user, tempPassword);

	        model.addAttribute("tempPassword", tempPassword);
	    } else {
	        model.addAttribute("tempPassword", null);
	    }

	    return "/member/findpwresult";  // 결과 메시지 페이지로 이동
	}
	
}