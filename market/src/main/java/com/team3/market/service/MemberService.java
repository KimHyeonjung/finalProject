package com.team3.market.service;

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