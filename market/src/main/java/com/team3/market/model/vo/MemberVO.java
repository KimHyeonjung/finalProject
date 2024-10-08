package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberVO {
	private String member_id;   // 아이디
    private String member_pw;   // 비밀번호
    private String member_nick; // 닉네임
    private String member_phone; // 전화번호
    private String member_email; // 이메일
    private String member_auth; // 권한 (USER, ADMIN 등)
	private String member_cookie;
	private Date member_limit;
		
		
	
}
