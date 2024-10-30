package com.team3.market.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.ChatDAO;
import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;

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
	
	public boolean notify(Map<String, Object> item, MemberVO user) {
		int type = 1;
		int member_num = (Integer) item.get("member_num");
		String propStr = "<div>읽지 않은 채팅이 있습니다.</div>";
		
		return chatDAO.insertNotification(member_num, type, null, propStr);
	}

	public Integer getTargetMemberNumByChatRoomNum(int chatRoomNum, int senderMemberNum) {
	    Map<String, Integer> params = new HashMap<>();
	    params.put("chatRoomNum", chatRoomNum);
	    params.put("senderMemberNum", senderMemberNum);

	    List<MemberVO> members = chatDAO.selectChatRoomByMember(params);
	    
	    if (!members.isEmpty()) {
	        return members.get(0).getMember_num(); // 상대방을 반환
	    }

	    return null; // 상대방을 찾지 못한 경우
	}
}