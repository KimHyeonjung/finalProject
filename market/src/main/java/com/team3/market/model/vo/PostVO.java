package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PostVO {
	
    private int post_num; // 게시글 번호
    private int post_member_num; // 회원 번호
    private int post_position_num; // 위치 번호
    private int post_way_num; // 거래 방법 번호
    private int post_category_num; // 카테고리 번호
    private String post_title; // 게시글 제목
    private String post_content; // 게시글 내용
    private int post_price; // 가격
    private boolean post_deal; // 거래 여부
    private Date post_date; // 등록일
    private Date post_refresh; // 갱신일
    private String post_address; // 주소

}
