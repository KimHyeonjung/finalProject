package com.team3.market.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.ChatService;
import com.team3.market.service.WalletService;


@Controller
public class ChatController {

    @Autowired
    private ChatService chatService; // ChatService 주입
    
    @Autowired
    private WalletService walletService; 

	@GetMapping("/chatRoom")
	public String chatRoom(HttpSession session, Model model) {
		// 세션에서 로그인된 사용자 정보 가져오기
		MemberVO user = (MemberVO) session.getAttribute("user");

		// 로그인된 사용자 정보가 없으면 로그인 페이지로 리다이렉트
		if (user == null) {
			return "redirect:/login"; // 로그인 페이지로 리다이렉트
		}
		
		System.out.println(user.getMember_num());

		List<ChatRoomDTO> chatRoomDTOs = chatService.getChatRoomsWithMembers(user.getMember_num());

		model.addAttribute("chatRooms", chatRoomDTOs);
		model.addAttribute("member", user);

		return "/chat/chatRoom";
	}
    
	// 채팅방 클릭 시 해당 채팅방의 채팅 내역을 보여주는 메서드
	@GetMapping("/chat")
	public String chat(@RequestParam("chatRoomNum") int chatRoomNum, HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			return "redirect:/login";
		}

		// 해당 채팅방의 채팅 내역 가져오기
		List<ChatRoomDTO> chatDTOs = chatService.getChatsByRoom(chatRoomNum);
		model.addAttribute("chatDTOs", chatDTOs);
		model.addAttribute("member", user);
		model.addAttribute("chatRoomNum", chatRoomNum);

		return "/chat/chat";
	}
	

}