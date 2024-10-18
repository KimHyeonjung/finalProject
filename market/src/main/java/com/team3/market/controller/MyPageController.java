package com.team3.market.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.pagination.MyPostCriteria;
import com.team3.market.pagination.PageMaker;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	
	@Autowired
	PostService postService;
	
	@GetMapping({"/wish/list/{sort_type}","/wish/list"})
	public String wishList(Model model, @PathVariable(name = "sort_type", required = false)String sort_type, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<PostVO> list = postService.getWishPostList(user, sort_type);
		model.addAttribute("list", list);
		return "/mypage/wish";
	}
	@ResponseBody
	@PostMapping("/wish/delete")
	public boolean wishDelete(@RequestBody Map<String, List<String>> nums, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<String> post_nums = nums.get("post_nums");
		boolean res = postService.deleteWishList(post_nums, user);
		return res;
	}
	@GetMapping("/post/list")
	public String postList(Model model, HttpSession session, MyPostCriteria cri) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user != null) {
			cri.setMember_num(user.getMember_num());
		}
		List<PostVO> list = postService.getMyPostList(cri);
		PageMaker pm = postService.getPageMaker(cri);
		model.addAttribute("list", list);
		model.addAttribute("pm", pm);
		
		return "/mypage/post_list";
	}
	@PostMapping("/post/state")
	@ResponseBody
	public PostVO postState(@RequestBody PostVO post) {
		return postService.updatePosition(post);
	}
	@PostMapping("/post/delete") // 게시글 삭제
	@ResponseBody
	public boolean postDelete(@RequestParam("post_num") int post_num, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");	
		boolean res = postService.deletePost(post_num, user);
			
		return res;
	}
	@PostMapping("/post/refresh") // 끌올
	@ResponseBody
	public boolean postRefresh(@RequestParam("post_num") int post_num, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");	
		boolean res = postService.refresh(post_num, user);
			
		return res;
	}
	
}
