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
		
		// 사용자 포인트 정보를 데이터베이스에서 가져옴
	    Integer updatedPoints = walletService.getUpdatedPoints(user.getMember_num());
	    model.addAttribute("point", updatedPoints); // 포인트 정보를 모델에 추가

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
	
	
	@PostMapping("/sendMoney")
	public String sendMoney(
	        @RequestParam("amount") Integer amount,
	        @RequestParam("chatRoomNum") Integer chatRoomNum,
	        HttpSession session,
	        RedirectAttributes redirectAttributes) {
	    
	    // 세션에서 송금자 정보 가져오기
	    Integer senderMemberNum = (Integer) session.getAttribute("memberNum");
	    
	    if (senderMemberNum == null) {
	        return "redirect:/login"; // If sender is not logged in, redirect to login
	    }

	    try {
	        // Get the chat room information to determine the target member
//	        List<ChatRoomDTO> chatRoomDTOs = chatService.getChatRoomsWithMembers(senderMemberNum);
//	        ChatRoomDTO targetChatRoom = null;

//	        System.out.println("Chat Rooms Found: " + chatRoomDTOs.size());

	        // Find the chat room that matches the chatRoomNum
//	        for (ChatRoomDTO chatRoomDTO : chatRoomDTOs) {
//	            System.out.println("Checking chat room: " + chatRoomDTO.getChatRoom().getChatRoom_num());
//	            if (chatRoomDTO.getChatRoom().getChatRoom_num() == chatRoomNum) {
//	                targetChatRoom = chatRoomDTO;
//	                break;
//	            }
//	        }
//
//	        if (targetChatRoom == null) {
//	            throw new IllegalStateException("채팅방을 찾을 수 없습니다."); // Handle case where chat room is not found
//	        }
//
//	        Integer targetMemberNum = targetChatRoom.getTargetMember().getMember_num(); // Get the target member number
//	        System.out.println("Target Member Num: " + targetMemberNum);
	        
	        Integer targetMemberNum = 1;

	        // 송금 서비스 호출
	        walletService.transferMoney(senderMemberNum, targetMemberNum, amount);
	        
	        // 송금 후 포인트 업데이트 (예시)
	        Integer updatedPoints = walletService.getUpdatedPoints(senderMemberNum);
	        session.setAttribute("point", updatedPoints); // 세션에 최신 포인트 저장
	        
	        // 성공 시 성공 메시지를 추가
	        redirectAttributes.addFlashAttribute("successMessage", "송금이 완료되었습니다.");

	    } catch (Exception e) {
	    	// 실패 시 에러 메시지를 추가
	        redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
	    }
	    
	    return "redirect:/chat?chatRoomNum=" + chatRoomNum;
	}


}