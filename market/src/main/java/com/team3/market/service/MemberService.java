package com.team3.market.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.MemberDAO;
import com.team3.market.model.vo.MemberVO;

@Service
public class MemberService {
	
	@Autowired
    private MemberDAO memberDao;
	
	public boolean signup(MemberVO member) {
        // 아이디나 이메일 중복 체크
        if(memberDao.getMemberById(member.getMember_id()) != null || 
           memberDao.getMemberByEmail(member.getMember_email()) != null) {
            return false; // 중복되면 회원가입 실패
        }
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
		if (user != null && user.getMember_pw().equals(member.getMember_pw())) {
            return user;  // 로그인 성공 시 해당 회원 정보 반환
        } else {
            return null;
        }
	}

}
