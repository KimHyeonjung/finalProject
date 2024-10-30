package com.team3.market.model.dto;

import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.PostVO;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CombinePostWithFileDTO {
	private PostVO post;
	private FileVO file;
}
