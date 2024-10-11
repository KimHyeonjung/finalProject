package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;

public interface PostDAO {

	PostVO selectPost(int post_num);

	Map<String, Object> selectPostMap(int post_num);

	void updateView(int post_num);

	boolean deletePost(int post_num);

	List<PostVO> selectPostList();

	List<Report_categoryVO> selectReport_category();

	boolean insertReportPost(ReportVO report, String member_id);

}
