package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PostVO {

	private int post_num;
	private int post_member_num;
	private int post_state_num;
	private int post_position_num; 
	private int post_way_num; 
	private int post_category_num; 
	private String post_title;
	private String post_content;
	private int post_price;
	private boolean post_deal;
	private Date post_date;
	private Date post_refresh;
	private String post_address;
	private int post_view;
	private int post_report;
	private int post_timepassed; // 게시 후 지난 시간
	private int post_wishcount; // 찜한 수 

}