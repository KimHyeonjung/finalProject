package com.team3.market.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;

@Mapper
public interface ChatDAO {

	List<ChatRoomVO> selectChatRoomsByMember(int member_num);

	MemberVO selectSenderByChatRoom(int chatRoom_num);

	ChatVO selectLatestChatByRoom(int chatRoom_num);
    
}
