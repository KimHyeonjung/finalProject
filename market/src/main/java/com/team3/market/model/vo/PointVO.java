package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PointVO {
	
	private int point_num;
	private int point_member_num;
	private int point_money;
	private Date point_date;
	private String point_type;
	
}