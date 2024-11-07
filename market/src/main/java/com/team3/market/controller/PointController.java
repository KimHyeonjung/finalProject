package com.team3.market.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team3.market.handler.SocketHandler;
import com.team3.market.model.dto.ApproveResponse;
import com.team3.market.model.dto.OrderCreateForm;
import com.team3.market.model.dto.ReadyResponse;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import com.team3.market.service.ChatService;
import com.team3.market.service.WalletService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/wallet")
public class PointController {
	
	@Autowired
	WalletService walletService;
	
	@Autowired
	ChatService chatService;
	
	@Autowired
    private SocketHandler socketHandler; // SocketHandler 주입
	
	@GetMapping("/point")
	public String point() {
		return "/wallet/point";
	}
	
	@PostMapping("/pay/ready")
	public @ResponseBody ReadyResponse payReady(@RequestBody OrderCreateForm orderCreateForm, HttpSession session) {
		String name = orderCreateForm.getName();
		int totalPrice = orderCreateForm.getTotalPrice();
		log.info("주문 상품 이름: " + name);
		log.info("주문 금액: " + totalPrice);
		
		// 카카오 결제 준비하기
		ReadyResponse readyResponse = walletService.payReady(name, totalPrice);
		
		// 세션에 결제 고유번호(tid) 저장
		session.setAttribute("tid", readyResponse.getTid());
		session.setAttribute("totalPrice", totalPrice);  // 결제 금액을 세션에 저장
		log.info("결제 고유번호: " + readyResponse.getTid());
		return readyResponse;
		
	}
	
	@GetMapping("/pay/completed")
	public String payCompleted(@RequestParam("pg_token") String pgToken, HttpSession session, Model model) {
		
		String tid = (String) session.getAttribute("tid");
		int totalPrice = (Integer) session.getAttribute("totalPrice");  // 세션에서 결제 금액 가져오기
		MemberVO user = (MemberVO) session.getAttribute("user");
		
		log.info("결제승인 요청을 인증하는 토큰: " + pgToken);
		log.info("결제 고유번호: " + tid);
		
		// 카카오 결제 요청하기
		ApproveResponse approveResponse = walletService.payApprove(tid, pgToken);
		
		// 결제 승인 후 포인트 충전 내역 업데이트 및 잔액 추가
		if (approveResponse != null) {
			walletService.updatePoint(user.getMember_num(), totalPrice, session);
			walletService.updateSessionMoney(user.getMember_num(), session);
			
			// totalMoney 세션에 저장
			int updatedTotalMoney = (int) session.getAttribute("totalMoney");
			model.addAttribute("totalMoney", updatedTotalMoney); // JSP에서 사용할 수 있도록 모델에 추가
		}
		
		return "redirect:/wallet/completed";
		
	}
	
	@GetMapping("/completed")
	public String pay() {
		return "/wallet/completed";
	}
	
	@GetMapping("/list")
    public String getPointHistory(HttpSession session, Model model) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        if (user != null) {
            int member_num = user.getMember_num();
            List<PointVO> pointList = walletService.getPointHistory(member_num);
            model.addAttribute("pointList", pointList); // pointList를 모델에 추가
        } else {
            return "redirect:/login"; // 로그인 안 되어 있으면 로그인 페이지로 이동
        }

        return "/wallet/list"; // JSP 파일로 이동
    }
	
	@ResponseBody
	@PostMapping("/sendMoney")
	public ResponseEntity<Map<String, String>> sendMoney(@RequestBody Map<String, Integer> requestData, HttpSession session) {
	    Integer amount = requestData.get("amount");
	    Integer chatRoomNum = requestData.get("chatRoomNum");

	    Integer senderMemberNum = (Integer) session.getAttribute("memberNum");

	    Map<String, String> response = new HashMap<>();

	    if (senderMemberNum == null) {
	        response.put("message", "로그인 후 송금을 시도하십시오.");
	        response.put("redirectUrl", "/login");
	        return ResponseEntity.ok(response);
	    }

	    // ChatService를 통해 상대방의 member_num 가져오기
	    Integer targetMemberNum = chatService.getTargetMemberNumByChatRoomNum(chatRoomNum, senderMemberNum);
	    
	    // targetMemberNum이 null인지 확인
	    if (targetMemberNum == null) {
	        response.put("message", "상대방의 정보를 찾을 수 없습니다.");
	        return ResponseEntity.badRequest().body(response);
	    }

	    try {
	        // 송금 서비스 호출
	        walletService.transferMoney(senderMemberNum, targetMemberNum, amount);
	        walletService.updateSessionMoney(senderMemberNum, session);
	        
	        walletService.updateChatRoomStayMoney(chatRoomNum, amount);

	        // chatRoom 정보를 가져오기
	        ChatRoomVO chatRoom = chatService.getChatRoomByNum(chatRoomNum);

	        // 송금 알림 전송
	        sendTransferNotification(targetMemberNum, amount, senderMemberNum);
	        
	        // 소켓을 통해 메시지 전송
	        socketHandler.sendMessage2("null", chatRoom.getChatRoom_num());

	        response.put("message", "송금이 완료되었습니다.");
	        return ResponseEntity.ok(response);
	        
	    } catch (IllegalArgumentException | IllegalStateException e) {
	        response.put("message", e.getMessage());
	        return ResponseEntity.badRequest().body(response);
	        
	    } catch (Exception e) {
	        response.put("message", "송금 중 오류가 발생했습니다.");
	        e.printStackTrace(); // 스택 트레이스를 콘솔에 출력하여 디버깅
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	
	@GetMapping("/balance")
	@ResponseBody
	public Map<String, Object> getBalance(HttpSession session) {
	    Integer memberNum = (Integer) session.getAttribute("memberNum");
	    if (memberNum == null) {
	        return Collections.singletonMap("totalMoney", 0); // 사용자 미로그인 시 0 반환
	    }

	    // 세션에서 사용자의 잔액 계산
	    Integer totalMoney = (Integer) session.getAttribute("totalMoney"); // null 체크 추가
	    if (totalMoney == null) {
	        totalMoney = 0;
	    }

	    Map<String, Object> response = new HashMap<>();
	    response.put("totalMoney", totalMoney);
	    System.out.println("Total Money: " + totalMoney); // 로그 출력
	    return response;
	}
	
	private void sendTransferNotification(Integer targetMemberNum, Integer amount, Integer senderMemberNum) {
	    // 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
	    MemberVO senderMember = walletService.getMember(senderMemberNum); // 송금자 정보
	    MemberVO targetMember = walletService.getMember(targetMemberNum); // 수신자 정보
	    
	    // 알림 내용 생성
	    String content = String.format("님이 %d원을 송금했습니다.", amount);
	    
	    // 알림을 위한 객체 생성
	    Map<String, Object> notificationData = new HashMap<>();
	    notificationData.put("chatRoom_num", chatService.getChatRoomNumByMembers(senderMemberNum, targetMemberNum)); // 채팅방 번호
	    notificationData.put("content", content); // 알림 내용
	    
	    // 알림 전송 로직 (ChatService의 notify 메서드 호출)
	    chatService.notify(notificationData, senderMember, targetMember);
	}

	 
}
