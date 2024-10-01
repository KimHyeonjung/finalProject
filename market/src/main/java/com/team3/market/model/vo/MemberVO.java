package com.team3.market.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberVO {
	private int member_num;
	private String member_id;
	private String member_pw;
	private String member_nick;
	private String member_phone;
	private String member_email;
	private String member_auth;
	private String member_state;
	private int member_report;
	private float member_score;
	private int member_money;
}
