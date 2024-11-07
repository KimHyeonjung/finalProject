package com.team3.market.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.AfterDAO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.MemberVO;

@Service
public class AfterService {

	@Autowired
	AfterDAO afterDao;
	
//	@Resource
//	String uploadPath;
	
	public boolean insertReview(AfterVO after, MemberVO user, float afterReviewSum) {
	    // 리뷰 작성자 ID 설정
		after.setAfter_member_num(user.getMember_num());

	    // review에서 after_post_num을 가져와서 post_member_num 조회
	    int postMemberNum = afterDao.findPostMemberNum(after.getAfter_post_num());

	    // post_member_num을 통해 member 테이블에서 member_score 업데이트
	    afterDao.updateMemberScore(postMemberNum, afterReviewSum);

	    // 리뷰 데이터 삽입
	    return afterDao.insertAfter(after);
	    
	}
	
    public List<Map<String, Object>> selectUserReviews(int memberNum) {
        return afterDao.selectUserReviews(memberNum);
    }
}