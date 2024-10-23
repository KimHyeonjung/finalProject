package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.NotificationVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/notification")
public class NotificationController {
	
	@Autowired
	PostService postService;
	
	@PostMapping("/count")
	@ResponseBody
	public int count(HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		int notReadCount = postService.getNotReadCount(user);
		return notReadCount;
	}
	@PostMapping("/list")
	@ResponseBody
	public Map<String, Object> list(HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, Object> map = new HashMap<String, Object>();
		List<NotificationVO> list = postService.getNotification(user);;
		map.put("list", list);
		return map;
	}
	@PostMapping("/checked")
	@ResponseBody
	public boolean checked(@RequestParam("notification_num") int notification_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		boolean res = postService.checkedNotification(notification_num, user);
		return res;
	}
}
