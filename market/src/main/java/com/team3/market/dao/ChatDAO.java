package com.team3.market.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;

@Repository
public interface ChatDAO {

    List<ChatRoomVO> selectChatRoomsByMember(int member_num);

    MemberVO selectSenderByChatRoom(int chatRoom_num);

    ChatVO selectLatestChatByRoom(int chatRoom_num);
    
    MemberVO selectMemberById(int member_num); // 회원 번호로 회원 정보 조회 추가

    List<ChatVO> selectChatsByRoom(int chatRoom_num); // 특정 채팅방의 채팅 내역 조회

	void insertChat(ChatVO chatVO);
}
