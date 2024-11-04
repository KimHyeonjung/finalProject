package com.team3.market.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.model.dto.CombineNotificationWithFileDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.PostService;

@RestController
@RequestMapping("/notification")
public class NotificationController {
	
	@Autowired
	PostService postService;
    
	@Autowired
    private NotificationWebSocketHandler notificationHandler;

    @PostMapping("/notify-user") // test sample
    public String notifyUser(String userId, String message) {
        try {
            notificationHandler.sendNotificationToUser(userId, message);
            return "Notification sent";
        } catch (Exception e) {
            e.printStackTrace();
            return "Failed to send notification";
        }
    }
	
	@PostMapping("/count")
	public int count(HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		int notReadCount = postService.getNotReadCount(user);
		return notReadCount;
	}
	@PostMapping("/list")
	public Map<String, Object> list(HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, Object> map = new HashMap<String, Object>();
		List<CombineNotificationWithFileDTO> list = postService.getNotificationListWithFile(user);
		map.put("list", list);
		return map;
	}
	@PostMapping("/checked")
	public boolean checked(@RequestParam("notification_num") int notification_num, HttpSession session){
		MemberVO user = (MemberVO)session.getAttribute("user");
		boolean res = postService.checkedNotification(notification_num, user);
		return res;
	}
}
