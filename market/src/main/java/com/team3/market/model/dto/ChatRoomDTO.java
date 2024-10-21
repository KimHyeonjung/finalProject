package com.team3.market.model.dto;

import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoomDTO {
    private ChatRoomVO chatRoom; // ChatRoomVO 객체
    private MemberVO targetMember;
    private ChatVO Chat;
}