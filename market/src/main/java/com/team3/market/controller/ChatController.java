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

//    	List<ChatRoomVO> chatRooms = chatService.getChatRoomsByMember(user.getMember_num());
		List<ChatRoomDTO> chatRoomDTOs = chatService.getChatRoomsWithMembers(user.getMember_num());

//    	model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("chatRooms", chatRoomDTOs);

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
//		List<ChatVO> chats = chatService.getChatsByRoom(chatRoomNum);
		List<ChatRoomDTO> chatDTOs = chatService.getChatsByRoom(chatRoomNum);
//		model.addAttribute("chats", chats);
		model.addAttribute("chatDTOs", chatDTOs);
		model.addAttribute("chatRoomNum", chatRoomNum);

		return "/chat/chat";
	}
	
	
	@PostMapping("/sendMoney")
	public String sendMoney(
	        @RequestParam("amount") Integer amount,
	        @RequestParam("chatRoomNum") Integer chatRoomNum,
	        @RequestParam("targetMemberNum") Integer targetMemberNum, // 이 줄이 필요합니다
	        HttpSession session,
	        RedirectAttributes redirectAttributes) {
		
	    // 세션에서 송금자 정보 가져오기
	    MemberVO user = (MemberVO) session.getAttribute("user");
	    Integer senderMemberNum = user != null ? user.getMember_num() : null;
	    
	    if (senderMemberNum == null) {
	        return "redirect:/login"; // 사용자가 로그인하지 않았다면 로그인 페이지로 리다이렉트
	    }

	    try {
	        // 세션에 값 저장 후 로그 출력
	        System.out.println("Session updated points: " + session.getAttribute("point"));
	        
	        System.out.println("Sender Member Number: " + senderMemberNum);
	        System.out.println("Target Member Number: " + targetMemberNum);
	        System.out.println("Amount: " + amount);
	        
	        // 송금 서비스 호출
	        walletService.transferMoney(senderMemberNum, targetMemberNum, amount);
	        
	        // 송금 후 포인트가 제대로 업데이트되는지 확인하는 로그 추가
	        Integer updatedPoints = walletService.getUpdatedPoints(senderMemberNum);
	        System.out.println("Updated Points after transfer: " + updatedPoints);

	        // 세션에 업데이트된 포인트 저장
	        session.setAttribute("point", updatedPoints);

	        // 성공 시 성공 메시지를 추가
	        redirectAttributes.addFlashAttribute("successMessage", "송금이 완료되었습니다.");

	    } catch (Exception e) {
	        // 실패 시 에러 메시지를 추가
	        redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
	    }
	    
	    return "redirect:/chat?chatRoomNum=" + chatRoomNum;
	}
	
}
