package com.team3.market.service;

import org.springframework.stereotype.Service;

import com.team3.market.dao.MemberDAO;
import com.team3.market.model.vo.MemberVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class MemberService {
	private MemberDAO memberDAO;

	public boolean insertMember(MemberVO member) {
		if(member == null) {
			return false;
		}
		try {
			return memberDAO.insertMember(member);
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
