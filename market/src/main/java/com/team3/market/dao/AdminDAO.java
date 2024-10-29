package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import com.team3.market.model.vo.ReportCategoryVO;

public interface AdminDAO {

	List<Map<String, Object>> selectPostReportList();

	List<Map<String, Object>> selectUserReportList();
	
	List<ReportCategoryVO> selectReportCategoryPostList(String post);

	List<ReportCategoryVO> selectReportCategoryMemberList(String member);

	List<Map<String, Object>> selectReportPostListByCaNum(int category_num);

	List<Map<String, Object>> selectReportMemberListByCaNum(int category_num);

}