package com.team3.market.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;
import com.team3.market.service.AdminService;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/report")
public class ReportController {
	
	@Autowired
	PostService postService;
	@Autowired
	AdminService adminService;
	
	@ResponseBody
	@PostMapping("/category")	
	public List<Report_categoryVO> report(){
		List<Report_categoryVO> list = postService.getReport_category();
		return list;
	}
	
	@ResponseBody
	@PostMapping("/post") // 게시글 신고
	public int reportPost(@RequestBody ReportVO report, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		int res = postService.reportPost(report, user);	
		if(res == 1) {
			postService.updatePostReport(report.getReport_post_num());
		}
		return res;
	}
	
	@GetMapping("/list") // 신고 현황 페이지
	public String reportList(Model model) {
		List<Map<String, Object>> postList = adminService.getReportPostList();
		List<Map<String, Object>> userList = adminService.getReportUserList();
		
		model.addAttribute("postList", postList);
		model.addAttribute("userList", userList);
		return "/admin/report";
	}
}
