package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import com.team3.market.model.vo.WalletVO;

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

	void updateMoney(MemberVO sender);

	ChatRoomVO selectChatRoomById(int chatRoomNum);

	
	void updateChatRoomStayMoney(ChatRoomVO chatRoom);

	List<MemberVO> getChatRoomMembers(int chatRoomNum);

	void insertWalletEntry(WalletVO walletEntry);

	List<ChatRoomVO> getOtherChatRooms(Map<String, Object> params);

	Integer selectTargetMemberByChatRoomNum(Map<String, Integer> params);

	int selectPostNumByChatRoomNum(int chatRoomNum);

	void insertTransaction(WalletVO transaction);

	WalletVO selectTransaction(WalletVO existWallet);

	void updateTransaction(WalletVO transaction);

	WalletVO selectWalletForCheck(WalletVO wallet);

	void updateTransactionBuyerCancel(WalletVO existWallet);

	boolean updateWalletShipmentByWalletNum(int wallet_num);

	WalletVO selectWalletByWalletNum(Integer wallet_num);

	void updatePostPosition(@Param("post_num")int post_num, @Param("position_num")int position_num);


}
