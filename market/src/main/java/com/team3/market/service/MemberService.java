package com.team3.market.service;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team3.market.dao.MemberDAO;
import com.team3.market.model.vo.MemberVO;

@Service
public class MemberService {
	
	@Autowired
    private MemberDAO memberDao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	public boolean signup(MemberVO member) {
        // 아이디나 이메일 중복 체크
        if(memberDao.getMemberById(member.getMember_id()) != null || 
           memberDao.getMemberByEmail(member.getMember_email()) != null) {
            return false; // 중복되면 회원가입 실패
        }
        //비밀번호 암호화
        String encPw = passwordEncoder.encode(member.getMember_pw());
		member.setMember_pw(encPw);
        // 회원가입 처리
        return memberDao.insertMember(member);
    }

	public MemberVO login(MemberVO member) {
		if(member == null) {
			return null;
		}
		//회원 정보를 가져옴(아이디를 이용)
		MemberVO user = memberDao.getMemberById(member.getMember_id());
		//아아디 일치하지 않음
		if(user == null) {
			return null;
		}
		
		if (user.getMember_locked() != null && user.getMember_locked().after(new Date())) {
	        // 계정 잠금이 현재 시간보다 이후일 경우
	        return null;  // 계정이 잠긴 상태로 로그인 불가
	    }
		
		//비번 확인
		if (passwordEncoder.matches(member.getMember_pw(), user.getMember_pw())) {
	        // 로그인 성공 시 실패 횟수 초기화
	        resetFailAttempts(user);
	        return user;
	    } else {
	        // 로그인 실패 처리
	        handleFailedLogin(user);
	        return null;
	    }
	}
   
	
	private void handleFailedLogin(MemberVO user) {
		int failAttempts = user.getMember_fail() + 1;
	    user.setMember_fail(failAttempts);

	    if (failAttempts >= 3) {  // 3회 이상 실패하면 계정 잠금
	        int lockTime = 30 * 60 * 1000; // 30분 동안 잠금
	        Date lockUntil = new Date(System.currentTimeMillis() + lockTime);
	        user.setMember_locked(lockUntil);  
	    }
	    memberDao.updateMemberFail(user);  
		
	}

	private void resetFailAttempts(MemberVO user) {
		user.setMember_fail(0);  // 실패 횟수 초기화
	    user.setMember_locked(null);  // 계정 잠금 해제
	    memberDao.updateMemberFail(user);
		
	}

	public MemberVO getMemberById(String memberId) {
		return memberDao.getMemberById(memberId);
	}


	public Cookie createCookie(MemberVO user, HttpServletRequest request) {
	    if (user == null) {
	        return null;
	    }
	    HttpSession session = request.getSession();
	    String member_cookie = session.getId(); // 세션 ID로 쿠키 값을 설정
	    Cookie cookie = new Cookie("AL", member_cookie);
	    cookie.setPath("/");
	    int time = 30; // 7일 동안 유지
	    cookie.setMaxAge(time);
	    user.setMember_cookie(member_cookie); // MemberVO 객체에 쿠키 값 설정

	    // 만료 시간 설정
	    Date date = new Date(System.currentTimeMillis() + time * 1000);
	    user.setMember_limit(date);
	    
	    // 데이터베이스에 업데이트
	    memberDao.updateMemberCookie(user);
	    return cookie;
	}
	
	public void updateMemberCookie(MemberVO user) {
	    memberDao.updateMemberCookie(user);
	}

	public void clearAutoLogin(String member_id) {
		System.out.println("Clearing auto-login for member: " + member_id);
		 MemberVO user = new MemberVO();
		    user.setMember_id(member_id);
		    user.setMember_cookie(null); // 쿠키 정보 삭제
		    user.setMember_limit(null); // 만료 시간 정보 삭제
		    memberDao.updateMemberCookie(user); // 데이터베이스 업데이트
		    System.out.println("Auto-login data cleared for member: " + member_id);
		
	}

	public MemberVO checkLoginBefore(String sessionId) {
		return memberDao.getMemberBySessionId(sessionId);
	}

	public boolean idCheck(String sns, String id) {
		
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		MemberVO user = memberDao.selectMember(id);
		System.out.println(id);
		return user != null;
	}

	@Transactional
	public boolean signupSns(String sns, String id, String email) {
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		
	    
	   
	    MemberVO memberVO = new MemberVO(id,email);
		return memberDao.insertMember(memberVO);
	}

	

	public MemberVO loginSns(String sns, String id) {
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		return memberDao.selectMember(id);
	}

	
	
	public boolean deleteMember(MemberVO user) {
		if(user == null) {
			return false;
		}
		return memberDao.deleteMember(user);
	}

	public boolean changepw(MemberVO user, HttpSession session, String oldPassword, String newPassword) {
		
		user.setMember_id(user.getMember_id());
		
		if(passwordEncoder.matches(oldPassword, user.getMember_pw())) {
			user.setMember_pw(passwordEncoder.encode(newPassword));
			boolean update = memberDao.updatepw(user);
			if(update) {
				session.setAttribute("user", user);
			}
			return update;
        }
		
		return false;
	}

	public boolean changeemail(MemberVO user, HttpSession session, String newEmail) {
		
		user.setMember_id(user.getMember_id());
		
		user.setMember_email(newEmail);
		
		System.out.println(user);
		
		boolean update = memberDao.updateemail(user);
		
		System.out.println(user);
		
		if(update) {
			session.setAttribute("user", user);
		}
		return update;
	}

	public boolean changephone(MemberVO user, HttpSession session, String newPhone) {
		
		user.setMember_id(user.getMember_id());
		
		user.setMember_phone(newPhone);
		
		System.out.println(user);
		
		boolean update = memberDao.updatephone(user);
		
		System.out.println(user);
		
		if(update) {
			session.setAttribute("user", user);
		}
		return update;
	}

}