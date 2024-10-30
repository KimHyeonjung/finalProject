package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;

@Repository
public interface ChatDAO {

    List<ChatRoomVO> selectChatRoomsByMember(int member_num);

    MemberVO selectSenderByChatRoom(int chatRoom_num);

    ChatVO selectLatestChatByRoom(int chatRoom_num);
    
    MemberVO selectMemberById(int member_num); // 회원 번호로 회원 정보 조회 추가

    List<ChatVO> selectChatsByRoom(int chatRoom_num); // 특정 채팅방의 채팅 내역 조회

	void insertChat(ChatVO chatVO);

	PostVO selectChatRoomPost(int chatRoomNum);

	boolean deleteChatRoom(int chatRoomNum);

	boolean insertNotification(@Param("member_num") int member_num, @Param("type") int type, @Param("chatRoom_num") int chatRoom_num, @Param("content") String content);

	MemberVO selectChatRoomByMember(@Param("chatRoom_num") Integer chatRoom_num, @Param("member_num") Integer member_num);
	
	List<MemberVO> selectChatRoomByMember(Map<String, Integer> params);

}
