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

import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.model.dto.ApproveResponse;
import com.team3.market.model.dto.OrderCreateForm;
import com.team3.market.model.dto.ReadyResponse;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import com.team3.market.model.vo.WalletVO;
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
	
//	@Autowired
//    private SocketHandler socketHandler; // SocketHandler 주입
	@Autowired
    private NotificationWebSocketHandler notificationHandler;
	
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
	    MemberVO user = (MemberVO)session.getAttribute("user");

	    Map<String, String> response = new HashMap<>();

	    if (user == null) {
	        response.put("message", "로그인 후 송금을 시도하십시오.");
	        response.put("redirectUrl", "/login");
	        return ResponseEntity.ok(response);
	    }
	    // 구매자(송금) 번호
	    int senderMemberNum = user.getMember_num();

	    // ChatService를 통해 판매자(상대방)의 member_num 과 게시물 번호 가져오기
	    Integer targetMemberNum = walletService.getTargetMemberNumByChatRoomNum(chatRoomNum, senderMemberNum);
	    int postNum = walletService.getPostNumByChatRoomNum(chatRoomNum);
	    
	    // targetMemberNum이 null인지 확인
	    if (targetMemberNum == null) {
	        response.put("message", "상대방의 정보를 찾을 수 없습니다.");
	        return ResponseEntity.badRequest().body(response);
	    }

	    try {
	        // 송금 서비스 호출
	        int senderAfterMoney = walletService.transferMoney(senderMemberNum, targetMemberNum, amount, postNum);
//	        walletService.updateSessionMoney(senderMemberNum, session);
	        
//	        walletService.updateChatRoomStayMoney(chatRoomNum, amount);

	        // chatRoom 정보를 가져오기
//	        ChatRoomVO chatRoom = chatService.getChatRoomByNum(chatRoomNum);

	        // 송금 알림 전송
	        sendTransferNotification(targetMemberNum, amount, senderMemberNum, chatRoomNum);
	        
	        // 소켓을 통해 메시지 전송
	        notificationHandler.sendMessage2("null", chatRoomNum);
	        // 세션 갱신
	        user.setMember_money(senderAfterMoney);
	        session.setAttribute("user", user);
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
	@ResponseBody
	@PostMapping("/sendMoneyCancel")
	public ResponseEntity<Map<String, String>> sendMoneyCancel(@RequestBody Map<String, Integer> requestData, HttpSession session) {
		Integer chatRoomNum = requestData.get("chatRoomNum");
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, String> response = new HashMap<>();
		if (user == null) {
			response.put("message", "로그인 후 시도하십시오.");
			response.put("redirectUrl", "/login");
			return ResponseEntity.ok(response);
		}
		// 구매자(송금) 번호
		int senderMemberNum = user.getMember_num();
		// ChatService를 통해 판매자(상대방)의 member_num 과 게시물 번호 가져오기
		Integer targetMemberNum = walletService.getTargetMemberNumByChatRoomNum(chatRoomNum, senderMemberNum);
		int postNum = walletService.getPostNumByChatRoomNum(chatRoomNum);
		// targetMemberNum이 null인지 확인
		if (targetMemberNum == null) {
			response.put("message", "상대방의 정보를 찾을 수 없습니다.");
			return ResponseEntity.badRequest().body(response);
		}
		try {
			// 송금취소 서비스 호출
			int senderAfterMoney = walletService.transferMoneyCancel(senderMemberNum, targetMemberNum, postNum);
			// 송금취소 알림 전송
			sendTransferCancelNotification(targetMemberNum, senderMemberNum, chatRoomNum);
			// 소켓을 통해 메시지 전송
			notificationHandler.sendMessage2("null", chatRoomNum);
			// 세션에 머니 갱신
			user.setMember_money(senderAfterMoney);
			session.setAttribute("user", user);
			response.put("message", "송금이 취소되었습니다.");
			return ResponseEntity.ok(response);
		} catch (IllegalArgumentException | IllegalStateException e) {
			response.put("message", e.getMessage());
			return ResponseEntity.badRequest().body(response);
		} catch (Exception e) {
			response.put("message", "송금취소 중 오류가 발생했습니다.");
			e.printStackTrace(); // 스택 트레이스를 콘솔에 출력하여 디버깅
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	@ResponseBody
	@PostMapping("/cancelTrade")
	public ResponseEntity<Map<String, String>> cancelTrade(@RequestBody Map<String, Integer> requestData, HttpSession session) {
		Integer wallet_num = requestData.get("wallet_num");
		Integer chatRoomNum = requestData.get("chatRoomNum");
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, String> response = new HashMap<>();
		if (user == null) {
			response.put("message", "로그인 후 시도하십시오.");
			response.put("redirectUrl", "/login");
			return ResponseEntity.ok(response);
		}
		WalletVO wallet = walletService.getWalletByWalletNum(wallet_num);
		
		if (wallet == null) {
			response.put("message", "거래 정보를 찾을 수 없습니다.");
			return ResponseEntity.badRequest().body(response);
		}
		if (wallet.getWallet_seller() != user.getMember_num()) {
			response.put("message", "잘못된 거래 정보입니다.");
			return ResponseEntity.badRequest().body(response);
		}
		try {
			// 거래 취소 처리
			walletService.tradeCancel(wallet);
			// 거래 취소 알림 전송
			tradeCancelNotification(wallet, chatRoomNum);
			// 소켓을 통해 메시지 전송
			notificationHandler.sendMessage2("null", chatRoomNum);
			// 세션에 머니 갱신
			response.put("message", "거래가 취소되었습니다..");
			return ResponseEntity.ok(response);
		} catch (IllegalArgumentException | IllegalStateException e) {
			response.put("message", e.getMessage());
			return ResponseEntity.badRequest().body(response);
			
		} catch (Exception e) {
			response.put("message", "거래 취소 중 오류가 발생했습니다.");
			e.printStackTrace(); // 스택 트레이스를 콘솔에 출력하여 디버깅
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	@ResponseBody
	@PostMapping("/tradeCompleted")
	public ResponseEntity<Map<String, String>> tradeCompleted(@RequestBody Map<String, Integer> requestData, HttpSession session) {
		Integer wallet_num = requestData.get("wallet_num");
		Integer chatRoomNum = requestData.get("chatRoomNum");
		MemberVO user = (MemberVO)session.getAttribute("user");
		Map<String, String> response = new HashMap<>();
		if (user == null) {
			response.put("message", "로그인 후 시도하십시오.");
			response.put("redirectUrl", "/login");
			return ResponseEntity.ok(response);
		}
		WalletVO wallet = walletService.getWalletByWalletNum(wallet_num);
		
		if (wallet == null) {
			response.put("message", "거래 정보를 찾을 수 없습니다.");
			return ResponseEntity.badRequest().body(response);
		}
		if (wallet.getWallet_buyer() != user.getMember_num()) {
			response.put("message", "잘못된 거래 정보입니다.");
			return ResponseEntity.badRequest().body(response);
		}
		try {
			// 구매확인 처리
			int amount = walletService.tradeCompleted(wallet);
			// 구매확인 알림 전송
			tradeCompletedNotification(wallet, chatRoomNum, amount);
			// 소켓을 통해 메시지 전송
			notificationHandler.sendMessage2("null", chatRoomNum);
			// 세션에 머니 갱신
			response.put("message", "거래가 완료되었습니다.");
			return ResponseEntity.ok(response);
		} catch (IllegalArgumentException | IllegalStateException e) {
			response.put("message", e.getMessage());
			return ResponseEntity.badRequest().body(response);
			
		} catch (Exception e) {
			response.put("message", "거래 완료 중 오류가 발생했습니다.");
			e.printStackTrace(); // 스택 트레이스를 콘솔에 출력하여 디버깅
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping("/remittance")
	@ResponseBody
	public Integer getRemittance(@RequestBody WalletVO wallet, HttpSession session) {
		WalletVO walletAmount = walletService.getSendAmount(wallet);
		return walletAmount.getWallet_amount();
	}
	@PostMapping("/sendproduct")
	@ResponseBody
	public boolean sendProduct(@RequestBody Map<String, Integer> requestData, HttpSession session) {
		Integer chatRoomNum = requestData.get("chatRoomNum");
		Integer wallet_num = requestData.get("wallet_num");
		WalletVO wallet = walletService.getWalletByWalletNum(wallet_num);
		boolean res = walletService.updateWalletShipmentByWalletNum(wallet_num);
		sendProductNotification(wallet, chatRoomNum);
		return res;
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
	
	private void sendTransferNotification(Integer targetMemberNum, Integer amount, Integer senderMemberNum, int chatRoomNum) {
	    // 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
	    MemberVO senderMember = walletService.getMember(senderMemberNum); // 송금자 정보
	    MemberVO targetMember = walletService.getMember(targetMemberNum); // 수신자 정보
	    
	    // 알림 내용 생성
	    String content = String.format("님이 %d원을 송금했습니다.", amount);
	    
	    // 알림을 위한 객체 생성
	    Map<String, Object> notificationData = new HashMap<>();
	    notificationData.put("chatRoom_num", chatRoomNum); // 채팅방 번호
	    notificationData.put("content", content); // 알림 내용
	    
	    // 알림 전송 로직 (ChatService의 notify 메서드 호출)
	    if(chatService.notify(notificationData, senderMember, targetMember)) {
	    	try {
				notificationHandler.sendNotificationToUser(targetMember.getMember_id(), "notification");
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
	}
	private void sendTransferCancelNotification(Integer targetMemberNum, int senderMemberNum, Integer chatRoomNum) {
		// 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
	    MemberVO senderMember = walletService.getMember(senderMemberNum); // 송금자 정보
	    MemberVO targetMember = walletService.getMember(targetMemberNum); // 수신자 정보
	    
	    // 알림 내용 생성
	    String content = String.format("송금을 취소하였습니다.");
	    
	    // 알림을 위한 객체 생성
	    Map<String, Object> notificationData = new HashMap<>();
	    notificationData.put("chatRoom_num", chatRoomNum); // 채팅방 번호
	    notificationData.put("content", content); // 알림 내용
	    
	    // 알림 전송 로직 (ChatService의 notify 메서드 호출)
	    if(chatService.notify(notificationData, senderMember, targetMember)) {
	    	try {
				notificationHandler.sendNotificationToUser(targetMember.getMember_id(), "notification");
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
		
	}
	private void tradeCancelNotification(WalletVO wallet, Integer chatRoomNum) {
		// 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
	    MemberVO buyer = walletService.getMember(wallet.getWallet_buyer()); // 송금자 정보
	    MemberVO seller = walletService.getMember(wallet.getWallet_seller()); // 수신자 정보
	    
	    // 알림 내용 생성
	    String content = String.format("거래를 취소하였습니다.");
	    
	    // 알림을 위한 객체 생성
	    Map<String, Object> notificationData = new HashMap<>();
	    notificationData.put("chatRoom_num", chatRoomNum); // 채팅방 번호
	    notificationData.put("content", content); // 알림 내용
	    
	    // 알림 전송 로직 (ChatService의 notify 메서드 호출)
	    if(chatService.notify(notificationData, seller, buyer)) {
	    	try {
				notificationHandler.sendNotificationToUser(buyer.getMember_id(), "notification");
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
	}
	private void sendProductNotification(WalletVO wallet, Integer chatRoomNum) {
		// 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
		MemberVO buyer = walletService.getMember(wallet.getWallet_buyer()); // 송금자 정보
		MemberVO seller = walletService.getMember(wallet.getWallet_seller()); // 수신자 정보
		
		// 알림 내용 생성
		String content = String.format("상품을 발송하였습니다.");
		
		// 알림을 위한 객체 생성
		Map<String, Object> notificationData = new HashMap<>();
		notificationData.put("chatRoom_num", chatRoomNum); // 채팅방 번호
		notificationData.put("content", content); // 알림 내용
		
		// 알림 전송 로직 (ChatService의 notify 메서드 호출)
		if(chatService.notify(notificationData, seller, buyer)) {
			try {
				notificationHandler.sendNotificationToUser(buyer.getMember_id(), "notification");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private void tradeCompletedNotification(WalletVO wallet, Integer chatRoomNum, int amount) {
		// 송금자 정보를 가져오기 위해 MemberVO 객체를 생성
		MemberVO buyer = walletService.getMember(wallet.getWallet_buyer()); // 송금자 정보
		MemberVO seller = walletService.getMember(wallet.getWallet_seller()); // 수신자 정보
		
		// 알림 내용 생성
		String content = String.format("거래완료 / %d원이 입금되었습니다.", amount);
		
		// 알림을 위한 객체 생성
		Map<String, Object> notificationData = new HashMap<>();
		notificationData.put("chatRoom_num", chatRoomNum); // 채팅방 번호
		notificationData.put("content", content); // 알림 내용
		
		// 알림 전송 로직 (ChatService의 notify 메서드 호출)
		if(chatService.notify(notificationData, buyer, seller)) {
			try {
				notificationHandler.sendNotificationToUser(seller.getMember_id(), "notification");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	 
}
