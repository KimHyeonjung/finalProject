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
import com.team3.market.service.MemberService;
import com.team3.market.service.PostService;

@Controller
public class AdminController {
	
	@Autowired
	PostService postService;
	@Autowired
	AdminService adminService;
	@Autowired
	MemberService memberService;
	
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
//		List<Map<String, Object>> postList = adminService.getReportPostList();
//		List<Map<String, Object>> userList = adminService.getReportUserList();
//		List<ReportCategoryVO> reportCategoryPostList = adminService.getReportCategoryPostList("post");
//		List<ReportCategoryVO> reportCategoryMemberList = adminService.getReportCategoryMemberList("member");
//		
//		model.addAttribute("rcp", reportCategoryPostList);
//		model.addAttribute("rcm", reportCategoryMemberList);
//		model.addAttribute("postList", postList);
//		model.addAttribute("userList", userList);
		return "/admin/report";
	}
	@PostMapping("/report/postList") // 게시물 신고 현황 페이지
	public String reportPostList(Model model) {
		List<Map<String, Object>> postList = adminService.getReportPostList();
		List<ReportCategoryVO> reportCategoryPostList = adminService.getReportCategoryPostList("post");
		
		model.addAttribute("rcList", reportCategoryPostList);
		model.addAttribute("list", postList);
		return "admin/reportPost";
	}
	@PostMapping("/report/memberList") // 유저 신고 현황 페이지
	public String reportMemberList(Model model) {
		List<Map<String, Object>> userList = adminService.getReportUserList();
		List<ReportCategoryVO> reportCategoryMemberList = adminService.getReportCategoryMemberList("member");
		
		model.addAttribute("rcList", reportCategoryMemberList);
		model.addAttribute("list", userList);
		return "admin/reportMember";
	}
	// 게시물 카테고리별
	@PostMapping("/report/list/post") 
	public String reportListPost(Model model, @RequestParam("category_num")int category_num, HttpSession session){
		List<Map<String, Object>> list = adminService.getReportPostListByCaNum(category_num);
		
		model.addAttribute("list", list);
		return "admin/categoryPost";
	}
	// 유저 카테고리별
	@PostMapping("/report/list/member") 
	public String reportListMember(Model model, @RequestParam("category_num")int category_num, HttpSession session){
		List<Map<String, Object>> list = adminService.getReportMemberListByCaNum(category_num);
		
		model.addAttribute("list", list);
		return "admin/categoryMember";
	}
	@GetMapping("/report/detail/post/{post_num}")
	public String reportDetailPost(Model model, @PathVariable("post_num")int post_num) {
		Map<String, Object> post = postService.getPostMap(post_num);
		List<Map<String, Object>> list = adminService.getPostReportListByPostNum(post_num);
		model.addAttribute("list", list);
		model.addAttribute("post", post);
		return "/admin/detailPost";
	}
	@GetMapping("/report/detail/member/{member_num}")
	public String reportDetailMember(Model model, @PathVariable("member_num")int member_num) {
		MemberVO user = postService.getMember(member_num);
		List<Map<String, Object>> list = adminService.getPostReportListByMemberNum(member_num);
		model.addAttribute("list", list);
		model.addAttribute("user", user);
		return "/admin/detailPost";
	}
	@ResponseBody
	@PostMapping("/report/post/hide") // 게시물 숨김 처리
	public boolean reportPostHide(@RequestParam("post_num")int post_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			return false;
		}
		boolean res = user.getMember_auth().equals("ADMIN");
		if(res) {
			res = postService.updatePostHide(post_num);
			return res;
		}
		return false;
	}	
	@ResponseBody
	@PostMapping("/report/post/use") // 게시물 사용 처리
	public boolean reportPostUse(@RequestParam("post_num")int post_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			return false;
		}
		boolean res = user.getMember_auth().equals("ADMIN");
		if(res) {
			res = postService.updatePostUse(post_num);
			return res;
		}
		return false;
	}	
	@ResponseBody
	@PostMapping("/report/member/suspend") // 유저 정지 처리
	public boolean reportMemberSuspend(@RequestParam("member_num")int member_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			return false;
		}
		boolean res = user.getMember_auth().equals("ADMIN");
		if(res) {
			res = memberService.updateMemberSuspend(member_num);
			return res;
		}
		return false;
	}	
	@ResponseBody
	@PostMapping("/report/member/use") // 유저 사용 처리
	public boolean reportMemberUse(@RequestParam("member_num")int member_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			return false;
		}
		boolean res = user.getMember_auth().equals("ADMIN");
		if(res) {
			res = memberService.updateMemberUse(member_num);
			return res;
		}
		return false;
	}	
}