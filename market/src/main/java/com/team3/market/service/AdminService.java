package com.team3.market.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.AdminDAO;

@Service
public class AdminService {
	
	@Autowired
	AdminDAO adminDao;

	public List<Map<String, Object>> getReportPostList() {
		return adminDao.selectPostReportList();
	}

	public List<Map<String, Object>> getReportUserList() {
		return adminDao.selectUserReportList();
	}

}
