package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Chat_roomVO {
	private int chatRoom_num;
	private int chatRoom_member_num; 
	private int chatRoom_member_num2; 
	private int chatRoom_post_num; 
	private Date chatRoom_date;
}