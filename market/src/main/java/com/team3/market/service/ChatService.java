package com.team3.market.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.ChatDAO;
import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ChatService {

    @Autowired
    private ChatDAO chatDAO;

	public List<ChatRoomDTO> getChatRoomsWithMembers(int member_num) {
        List<ChatRoomVO> chatRooms = chatDAO.selectChatRoomsByMember(member_num);
        List<ChatRoomDTO> chatRoomWithMembers = new ArrayList<ChatRoomDTO>();
        

        for (ChatRoomVO chatRoom : chatRooms) {
            // 발신자 정보를 DB에서 가져옴
            MemberVO targetMember = getSenderByChatRoomId(chatRoom.getChatRoom_num());
            // 최신 채팅 메시지 가져오기
            ChatVO lastChat = chatDAO.selectLatestChatByRoom(chatRoom.getChatRoom_num());
            chatRoomWithMembers.add(new ChatRoomDTO(chatRoom, targetMember, lastChat));
        }
        
        return chatRoomWithMembers;
    }

	private MemberVO getSenderByChatRoomId(int chatRoom_num) {
		return chatDAO.selectSenderByChatRoom(chatRoom_num);
	}
	
	// 특정 채팅방의 채팅 내역 가져오기
    public List<ChatRoomDTO> getChatsByRoom(int chatRoomNum) {
    	List<ChatVO> chats = chatDAO.selectChatsByRoom(chatRoomNum);
        List<ChatRoomDTO> chatRoomDTOs = new ArrayList<ChatRoomDTO>();

        for (ChatVO chat : chats) {
        	MemberVO member = chatDAO.selectMemberById(chat.getChat_member_num());
            ChatRoomDTO dto = new ChatRoomDTO(null, member, chat);
            chatRoomDTOs.add(dto);
        }

        return chatRoomDTOs;
    }

	public void saveChatMessage(ChatVO chatVO) {
		chatDAO.insertChat(chatVO);
	}

	public PostVO getChatRoomPost(int chatRoomNum) {
		return chatDAO.selectChatRoomPost(chatRoomNum);
	}

	public boolean deleteChatRoom(int chatRoomNum) {
		return chatDAO.deleteChatRoom(chatRoomNum);
	}
	
	public boolean notify(Map<String, Object> item, MemberVO user, MemberVO postUser) {
		int type = 4;
		int chatRoom_num = (Integer)item.get("chatRoom_num");
		String content = (String)item.get("content");
		
		int maxLength = 15;
	    if (content.length() > maxLength) {
	        content = content.substring(0, maxLength) + "..."; // 15자를 넘으면 자르고 "..." 추가
	    }
		
		String propStr = "<div>" + user.getMember_id() + "(" + user.getMember_nick() 
		+ ")</div>" + "<div>" + content + "</div>";
		
		System.out.println(propStr);
		
		return chatDAO.insertNotification(postUser.getMember_num(), type, chatRoom_num, propStr);
	}

	public MemberVO getMember(Integer chatRoom_num, Integer member_num) {
		return chatDAO.selectChatRoomByMember(chatRoom_num, member_num);
	}

    
}