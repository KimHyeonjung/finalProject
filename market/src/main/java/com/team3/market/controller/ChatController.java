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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.WalletVO;
import com.team3.market.service.ChatService;
import com.team3.market.service.WalletService;


@Controller
public class ChatController {

    @Autowired
    private ChatService chatService; // ChatService 주입
    
    @Autowired
    private WalletService walletService; 
    
	@Autowired
    private NotificationWebSocketHandler notificationHandler;

	@GetMapping("/chatRoom")
	public String chatRoom(HttpSession session, Model model) {
		// 세션에서 로그인된 사용자 정보 가져오기
		MemberVO user = (MemberVO) session.getAttribute("user");

		// 로그인된 사용자 정보가 없으면 로그인 페이지로 리다이렉트
		if (user == null) {
			return "redirect:/login"; // 로그인 페이지로 리다이렉트
		}
		
		walletService.updateSessionMoney(user.getMember_num(), session);
	    int updatedTotalMoney = (int) session.getAttribute("totalMoney");
		model.addAttribute("totalMoney", updatedTotalMoney); // JSP에서 사용할 수 있도록 모델에 추가
		
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

		PostVO post = chatService.getChatRoomPost(chatRoomNum);
		WalletVO wallet = walletService.getWalletForCheck(post.getPost_num(), user.getMember_num());
		// 해당 채팅방의 채팅 내역 가져오기
		List<ChatRoomDTO> chatDTOs = chatService.getChatsByRoom(chatRoomNum);
		model.addAttribute("wallet", wallet);
		model.addAttribute("chatDTOs", chatDTOs);
		model.addAttribute("member", user);
		model.addAttribute("post", post);
		model.addAttribute("chatRoomNum", chatRoomNum);

		return "/chat/chat";
	}
	
	@PostMapping("/chat/leave")
    public String leaveChatRoom(@RequestParam("chatRoomNum") int chatRoomNum, HttpSession session) {
        // 세션에서 사용자 정보 가져오기
        MemberVO member = (MemberVO) session.getAttribute("user");
        if (member == null) {
            return "redirect:/login"; // 로그인하지 않은 사용자라면 로그인 페이지로 리다이렉트
        }

        // 채팅방 삭제 로직 호출
        boolean result = chatService.deleteChatRoom(chatRoomNum);

        if (result) {
            return "redirect:/chatRoom"; // 성공 시 채팅 목록 페이지로 리다이렉트
        } else {
            return "redirect:/chatRoom?error=true"; // 실패 시 에러 메시지와 함께 리다이렉트
        }
    }
	
	@PostMapping("/chat/notification")
	public boolean chatNoti(@RequestBody Map<String, Object> item, HttpSession session) {
		boolean res = false;
		System.out.println("13579");
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(item == null || user == null) {
			return false;
		}
		MemberVO postUser = chatService.getMember((Integer)item.get("chatRoom_num"), (Integer)item.get("member_num"));
		System.out.println(postUser.toString());
		res = chatService.notify(item, user, postUser);
		System.out.println(res);
		if(res) {
			try {
				notificationHandler.sendNotificationToUser(postUser.getMember_id(), "notification");
				return true;
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		return res;
	}
	
	@RequestMapping(value = "/chat/loadChatHistory", method = RequestMethod.GET)
	public String loadChatHistory(@RequestParam("chatRoomNum") int chatRoomNum, HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		PostVO post = chatService.getChatRoomPost(chatRoomNum);
	    List<ChatRoomDTO> chatDTOs = chatService.getChatsByRoom(chatRoomNum); // 채팅방 번호로 채팅 내역 가져오기
	    model.addAttribute("chatDTOs", chatDTOs);
	    model.addAttribute("member", user);
		model.addAttribute("post", post);
		model.addAttribute("chatRoomNum", chatRoomNum);
	    return "chat/chat"; // 채팅 내역을 출력할 JSP 조각
	}
	
	
}