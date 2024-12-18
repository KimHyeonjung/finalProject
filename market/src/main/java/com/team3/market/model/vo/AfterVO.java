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
	private float after_review_sum;
	private float after_review1;
	private float after_review2;
	private float after_review3;
	
    public void setAfter_post_num(int after_post_num) {
        this.after_post_num = after_post_num;
    }	
}
