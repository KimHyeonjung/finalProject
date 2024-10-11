package com.team3.market.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;
import com.team3.market.service.PostService;

@Controller
public class ReportController {
	
	@Autowired
	PostService postService;
	
	@ResponseBody
	@PostMapping("/report")	
	public List<Report_categoryVO> report(){
		List<Report_categoryVO> list = postService.getReport_category();
		return list;
	}
	
	@ResponseBody
	@PostMapping("/report/post")	
	public boolean reportPost(@RequestBody ReportVO report, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		boolean res = postService.reportPost(report, user);
		return res;
	}
}
