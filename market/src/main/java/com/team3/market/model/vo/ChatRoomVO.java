package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatRoomVO {
    private int chatRoom_num;          // 채팅방 번호
    private int chatRoom_member_num;   // 채팅방에 참여하는 회원 번호 1
    private int chatRoom_member_num2;  // 채팅방에 참여하는 회원 번호 2
    private int chatRoom_post_num;     // 연관된 게시물 번호
    private Date chatRoom_date;        // 채팅방 생성 날짜
}
