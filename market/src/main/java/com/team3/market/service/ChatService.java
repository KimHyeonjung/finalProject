package com.team3.market.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.ChatDAO;
import com.team3.market.model.vo.ChatRoomVO;

@Service
public class ChatService {

	@Autowired
    private ChatDAO chatDAO; // ChatDAO를 필드 주입

    // 모든 채팅방 목록을 가져오는 메서드
    public List<ChatRoomVO> getAllChatRooms() {
        return chatDAO.getAllChatRooms(); // ChatDAO의 메서드 호출
    }

}
