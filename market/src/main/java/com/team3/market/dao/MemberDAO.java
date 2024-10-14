package com.team3.market.dao;

import org.apache.ibatis.annotations.Mapper;

import com.team3.market.model.vo.MemberVO;

@Mapper
public interface MemberDAO {
    // 아이디로 회원 조회
    MemberVO getMemberById(String member_id);
    
    // 이메일로 회원 조회
    MemberVO getMemberByEmail(String member_email);
    
    // 회원 정보 삽입
    boolean insertMember(MemberVO member);

	void updateMemberCookie(MemberVO user);

	MemberVO getMemberBySessionId(String sessionId);

	MemberVO selectMember(String id);

	boolean deleteMember(MemberVO user);

	boolean updatepw(MemberVO user);

	boolean updateemail(MemberVO user);

	boolean updatephone(MemberVO user);

}