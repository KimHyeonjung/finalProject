package com.team3.market.dao;

import java.util.List;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;

public interface WalletDAO {

	void insertPayment(PointVO point);

	boolean updatePoint(MemberVO user);

	MemberVO selectMemberById(int point_member_num);

	List<PointVO> pointList(int member_num);

	void deletePayment(PointVO senderPointLog);

}
