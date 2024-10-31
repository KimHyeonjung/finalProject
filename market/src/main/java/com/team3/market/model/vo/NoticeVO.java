package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NoticeVO {

	private int notice_num;
	private int notice_member_num;  
	private String notice_title;
	private String notice_content;
	private Date notice_date;
	private boolean notice_pin;
}
