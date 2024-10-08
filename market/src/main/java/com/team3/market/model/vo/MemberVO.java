package com.team3.market.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberVO {
	private int member_num;	// 회원 번호
	private String member_id;   // 아이디
    private String member_pw;   // 비밀번호
    private String member_nick; // 닉네임
    private String member_phone; // 전화번호
    private String member_email; // 이메일
    private String member_auth; // 권한 (USER, ADMIN 등)
    private String member_state; // 상태
    private int member_report; // 신고횟수
    private double member_score; // 회원 평점
    private int member_money; // 잔액
    private int member_fail; // 실패 횟수
    private boolean member_autoLogin; // 자동 로그인
    private String member_cookie; // 쿠키
}
