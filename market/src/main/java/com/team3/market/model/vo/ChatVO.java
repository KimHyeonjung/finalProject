package com.team3.market.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
public class ChatVO {
	private int chat_num;               // 채팅 메시지 번호
    private int chat_member_num;        // 메시지를 보낸 회원 번호
    private int chat_chatRoom_num;      // 관련된 채팅방 번호
    private String chat_content;         // 채팅 내용
    private boolean chat_read;          // 읽음 여부
    private Date chat_date;             // 메시지 전송 날짜
    
    public ChatVO(int member_num, int chatRoom_num, String propStr) {
    	this.chat_member_num = member_num;
    	this.chat_chatRoom_num = chatRoom_num;
    	this.chat_content = propStr;
    }
}
