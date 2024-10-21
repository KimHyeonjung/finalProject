package com.team3.market.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

import com.team3.market.model.vo.FileVO;

import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.pagination.MyPostCriteria;

public interface PostDAO {

	PostVO selectPost(int post_num);

	Map<String, Object> selectPostMap(int post_num);

	void updateView(int post_num);

	boolean deletePost(int post_num);

	List<PostVO> selectPostList();

	List<Report_categoryVO> selectReport_category();

	int insertReportPost(@Param("report")ReportVO report, @Param("member_num")int member_num);

	void updatePostReport(int report_post_num);

	List<ReportVO> getReport(int report_post_num);

	ReportVO selectReportPost(@Param("post_num")int post_num, @Param("member_num")int member_num);

	WishVO selectWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	boolean insertWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	boolean deleteWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	List<PostVO> selectWishPostList(@Param("member_num")int member_num, @Param("sort_type")String sort_type);

	List<PostVO> selectMyPostList(MyPostCriteria cri);

	int selectTotalCountMyPost(MyPostCriteria cri);

	void updatePosition(PostVO post);

  boolean insertPost(PostVO post);
    
  List<String> selectCategoryList();
	
  // 파일 정보를 DB에 저장하는 메서드
  boolean insertFile(FileVO file);

}
