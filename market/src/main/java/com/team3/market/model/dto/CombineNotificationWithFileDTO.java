package com.team3.market.model.dto;

import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.NotificationVO;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CombineNotificationWithFileDTO {
	private NotificationVO notification;
	private FileVO file;
}
