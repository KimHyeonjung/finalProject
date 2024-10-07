package com.team3.market.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.MemberDAO;
import com.team3.market.model.vo.MemberVO;

@Service
public class MemberService {
	
	@Autowired
    private MemberDAO memberDao;
	
	public void registerMember(MemberVO member) {
        memberDao.insertMember(member);
    }

	
	
}
