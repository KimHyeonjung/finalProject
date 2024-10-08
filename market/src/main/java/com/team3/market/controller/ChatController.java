package com.team3.market.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.service.ChatService;

@Controller
@RequestMapping("/chatRoom")
public class ChatController {
	
	@Autowired
	ChatService chatService;
	
	@GetMapping
    public String getChatRoomList(Model model) {
        // 예시 데이터로 채팅방 목록 추가
        List<ChatRoomVO> chatRooms = chatService.getAllChatRooms();
        model.addAttribute("chatRooms", chatRooms);
        return "chat/chatRoom";  // chatRoom.jsp를 반환
    }

}
