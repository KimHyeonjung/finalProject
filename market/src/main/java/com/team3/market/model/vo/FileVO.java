package com.team3.market.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class FileVO {
	
	private int file_num;
	private String file_name;
	private String file_ori_name;
	private String file_target_table;
	private int file_target_num;
	
}