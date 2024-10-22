package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NotificationVO {
	private int notification_num;
	private int notification_member_num;
	private int notification_type_num;
	private String notification_message; 
	private boolean notification_read; 
	private Date notification_date;
}
