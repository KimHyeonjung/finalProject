package com.team3.market.dao;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import com.team3.market.model.vo.WalletVO;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface WalletDAO {
    // 결제 정보를 저장하는 메서드
    void insertPoint(PointVO pointVO);

    MemberVO selectMemberById(Integer senderMemberNum);
    
	void updatePoint(MemberVO memberVO);

	List<PointVO> selectPointHistory(int member_num);

	void updatePayment(PointVO senderPointLog);

	void deletePayment(PointVO senderPointLog);

	void insertPayment(PointVO receiverPointLog);

	void updateFakeMoney(MemberVO sender);

	ChatRoomVO selectChatRoomById(int chatRoomNum);

	
	void updateChatRoomStayMoney(ChatRoomVO chatRoom);

	List<MemberVO> getChatRoomMembers(int chatRoomNum);

	void insertWalletEntry(WalletVO walletEntry);

	List<ChatRoomVO> getOtherChatRooms(Map<String, Object> params);


}
