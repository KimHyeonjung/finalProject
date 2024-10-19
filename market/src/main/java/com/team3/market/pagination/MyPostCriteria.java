package com.team3.market.pagination;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MyPostCriteria extends Criteria{
	private int member_num = 0;

	@Override
	public String toString() {
		return super.toString() + "&member_num=" + member_num;
	}
	
}
