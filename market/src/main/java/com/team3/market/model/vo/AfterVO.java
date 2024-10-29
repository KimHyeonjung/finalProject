package com.team3.market.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AfterVO {
	private int after_num; 
	private int after_member_num; 
	private int after_post_num;
	private String after_message;
	private int after_review1;
	private int after_review2;
	private int after_review3;
}
