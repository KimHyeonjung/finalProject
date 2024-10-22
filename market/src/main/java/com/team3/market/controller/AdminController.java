package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.ReportCategoryVO;
import com.team3.market.service.AdminService;
import com.team3.market.service.PostService;

@Controller
public class AdminController {
	
	@Autowired
	PostService postService;
	@Autowired
	AdminService adminService;
	
	@ResponseBody
	@PostMapping("/report/category")	
	public Map<String, Object> report(@RequestParam("post_num")int post_num, HttpSession session){
		Map<String, Object> map = new HashMap<String, Object>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<ReportCategoryVO> list = postService.getReportCategory();
		boolean res = adminService.reportPostcheck(post_num, user);
		map.put("list", list);
		map.put("res", res);
		return map;
	}
	
	@ResponseBody
	@PostMapping("/report/post") // 게시글 신고
	public int reportPost(@RequestBody ReportVO report, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		int res = postService.reportPost(report, user);	
		if(res == 1) {
			postService.updatePostReport(report.getReport_post_num());
		}
		return res;
	}
	
	@GetMapping("/report/list") // 신고 현황 페이지
	public String reportList(Model model) {
		List<Map<String, Object>> postList = adminService.getReportPostList();
		List<Map<String, Object>> userList = adminService.getReportUserList();
		
		model.addAttribute("postList", postList);
		model.addAttribute("userList", userList);
		return "/admin/report";
	}
}