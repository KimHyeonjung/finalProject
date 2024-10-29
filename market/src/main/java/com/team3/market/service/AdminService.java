package com.team3.market.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.AdminDAO;
import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportCategoryVO;
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
		List<ReportVO> reportPostList = postDao.selectReportByPost(post_num);
		for(ReportVO reportPost : reportPostList) {
			if(reportPost.getReport_member_num() == user.getMember_num()) {
				return true;
			}
		}
		return false;
	}

	public List<ReportCategoryVO> getReportCategoryPostList(String post) {
		return adminDao.selectReportCategoryPostList(post);
	}

	public List<ReportCategoryVO> getReportCategoryMemberList(String member) {
		return adminDao.selectReportCategoryMemberList(member);
	}

	public List<Map<String, Object>> getReportPostListByCaNum(int category_num) {
		return adminDao.selectReportPostListByCaNum(category_num);
	}

	public List<Map<String, Object>> getReportMemberListByCaNum(int category_num) {
		return adminDao.selectReportMemberListByCaNum(category_num);
	}

}