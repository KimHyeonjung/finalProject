package com.team3.market.service;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

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
        return memberDao.insertMember(member) > 0;
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
		//비번 확인
		if(passwordEncoder.matches(member.getMember_pw(), user.getMember_pw())) {
			return user;
		}
            return null;
    }
	

	public MemberVO getMemberById(String memberId) {
		
		return memberDao.getMemberById(memberId);
	}

	public Cookie createCookie(MemberVO user, HttpServletRequest request) {
		if (user == null) {
	        return null;
	    }
	    
	    HttpSession session = request.getSession();
	    String member_cookie = session.getId(); // 세션 ID를 쿠키 값으로 사용
	    Cookie cookie = new Cookie("AL", member_cookie);
	    
	    // 쿠키 설정
	    cookie.setPath("/");
	    int time = 60 * 60 * 24 * 7; // 1주일
	    cookie.setMaxAge(time);
	    // DB에 쿠키 값 및 만료 시간 저장
	    user.setMember_cookie(member_cookie);
	    Date date = new Date(System.currentTimeMillis() + time * 1000); // 만료 시간 계산
	    user.setMember_limit(date);
	    
	    // DB 업데이트 (쿠키 값 및 만료 시간)
	    memberDao.updateMemberCookie(user);
	    
	    return cookie;
	}

	public MemberVO checkAutoLogin(String cookieValue) {
		// DB에서 쿠키 값으로 사용자 정보를 조회
		MemberVO user = memberDao.findByCookie(cookieValue);

		// 사용자가 없거나 만료된 쿠키인 경우
		if (user == null || user.getMember_limit().before(new Date())) {
			// 쿠키가 만료되었으면 DB에서 쿠키 값 삭제
			if (user != null) {
				updateAutoLogin(user.getMember_id(), null, false);
			}
			return null;
		}

		// 유효한 쿠키인 경우 사용자 정보를 반환
		return user;
	}
}
