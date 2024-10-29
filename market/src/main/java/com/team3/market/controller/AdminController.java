package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportCategoryVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.service.AdminService;
import com.team3.market.service.PostService;

@Controller
public class AdminController {
	
	@Autowired
	PostService postService;
	@Autowired
	AdminService adminService;
	
	@ResponseBody
	@PostMapping("/report/category/{type}")	
	public Map<String, Object> report(@PathVariable("type")String type ,@RequestParam("post_num")int post_num, HttpSession session){
		Map<String, Object> map = new HashMap<String, Object>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<ReportCategoryVO> list = postService.getReportCategory(type);
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
			//게시물 신고 횟수 추가
			postService.updatePostReport(report.getReport_post_num());
			PostVO post = postService.getPost(report.getReport_post_num());
			if(post.getPost_report() > 10) {
				//유저 신고 횟수 추가
				postService.updateMemberReport(report.getReport_member_num2());
			}
		}
		return res;
	}
	@ResponseBody
	@PostMapping("/report/user") // 유저 신고
	public int reportMember(@RequestBody ReportVO report, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		int res = postService.reportMember(report, user);	
		if(res == 1) {
			//유저 신고 횟수 추가
			postService.updateMemberReport(report.getReport_member_num2());
		}
		return res;
	}
	
	@GetMapping("/report/list") // 신고 현황 페이지
	public String reportList(Model model) {
		List<Map<String, Object>> postList = adminService.getReportPostList();
		List<Map<String, Object>> userList = adminService.getReportUserList();
		List<ReportCategoryVO> reportCategoryPostList = adminService.getReportCategoryPostList("post");
		List<ReportCategoryVO> reportCategoryMemberList = adminService.getReportCategoryMemberList("member");
		
		model.addAttribute("rcp", reportCategoryPostList);
		model.addAttribute("rcm", reportCategoryMemberList);
		model.addAttribute("postList", postList);
		model.addAttribute("userList", userList);
		return "/admin/report";
	}
	
	@PostMapping("/report/list/post") 
	public String reportListPost(Model model, @RequestParam("category_num")int category_num, HttpSession session){
		List<Map<String, Object>> list = adminService.getReportPostListByCaNum(category_num);
		
		model.addAttribute("list", list);
		return "admin/categoryPost";
	}
	@PostMapping("/report/list/member") 
	public String reportListMember(Model model, @RequestParam("category_num")int category_num, HttpSession session){
		List<Map<String, Object>> list = adminService.getReportMemberListByCaNum(category_num);
		
		model.addAttribute("list", list);
		return "admin/categoryMember";
	}
}