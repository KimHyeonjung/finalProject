package com.team3.market.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.AdminDAO;
import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportVO;

@Service
public class AdminService {
	
	@Autowired
	AdminDAO adminDao;
	@Autowired
	PostDAO postDao;

	public List<Map<String, Object>> getReportPostList() {
		return adminDao.selectPostReportList();
	}

	public List<Map<String, Object>> getReportUserList() {
		return adminDao.selectUserReportList();
	}

	public boolean reportPostcheck(int post_num, MemberVO user) {
		// 신고자 중복 체크
		List<ReportVO> reportPostList = postDao.getReport(post_num);
		for(ReportVO reportPost : reportPostList) {
			if(reportPost.getReport_member_num() == user.getMember_num()) {
				return true;
			}
		}
		return false;
	}

}
