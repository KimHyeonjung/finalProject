package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WishVO {
	private int wish_num; 
	private int wish_post_num; 
	private int wish_member_num; 
	private Date wish_date;
}
