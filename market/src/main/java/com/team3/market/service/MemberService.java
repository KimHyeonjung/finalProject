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
	
	public boolean updateMember(MemberVO user, MemberVO member, HttpSession session) {
		
		if(user == null || member == null) {
			return false;
		}
		
		member.setMember_id(user.getMember_id());
		member.setMember_nick(user.getMember_nick());
		member.setMember_auth(user.getMember_auth());
		member.setMember_pw(user.getMember_pw());
		
		member.setMember_email(member.getMember_email());
		
		member.setMember_phone(member.getMember_phone());
		
		boolean update = memberDao.updateMember(member);
		
		if(update) {
			session.setAttribute("user", member);
		}
		
		return update;
	}
	
	public boolean deleteMember(MemberVO user) {
		if(user == null) {
			return false;
		}
		return memberDao.deleteMember(user);
	}

	public boolean changepw(MemberVO member, MemberVO user, String oldPassword, String newPassword) {
		
		if(passwordEncoder.matches(oldPassword, member.getMember_pw())) {
            user.setMember_pw(passwordEncoder.encode(newPassword)); // 새 비밀번호 해시
            return true;
        }
		
		return false;
	}

}