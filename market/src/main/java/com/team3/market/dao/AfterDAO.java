package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.team3.market.model.vo.AfterVO;

public interface AfterDAO {
	
	boolean insertAfter(AfterVO after);
	
    // post_num을 통해 post_member_num을 조회하는 메서드
    int findPostMemberNum(int post_num);

    // member_score를 업데이트하는 메서드
    boolean updateMemberScore(@Param("member_num") int member_num, @Param("after_review_sum") float afterReviewSum);
    
    // 사용자의 리뷰 목록을 조회하는 메서드
    List<Map<String, Object>> selectUserReviews(int member_num);
}
