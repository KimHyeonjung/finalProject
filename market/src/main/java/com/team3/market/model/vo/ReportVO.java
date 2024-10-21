package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ReportVO {
	private int report_num;
	private int report_member_num;
	private int report_member_num2;
	private int report_post_num;
	private int report_category_num; 
	private String report_content;
	private Date report_date;
}