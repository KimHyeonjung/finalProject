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
	
    public FileVO(String file_name, String file_ori_name, String file_target_table, int file_target_num) {
        this.file_name = file_name;
        this.file_ori_name = file_ori_name;
        this.file_target_table = file_target_table;
        this.file_target_num = file_target_num;
    }
	
}