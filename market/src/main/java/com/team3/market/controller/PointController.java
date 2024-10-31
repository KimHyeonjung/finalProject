package com.team3.market.controller;

import java.util.Collections;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team3.market.model.dto.ApproveResponse;
import com.team3.market.model.dto.OrderCreateForm;
import com.team3.market.model.dto.ReadyResponse;
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
	
	@PostMapping("/sendMoney")
	public String sendMoney(@RequestBody Map<String, Integer> requestData, HttpSession session, RedirectAttributes redirectAttributes) {
	    Integer amount = requestData.get("amount");
	    Integer chatRoomNum = requestData.get("chatRoomNum");

	    // 세션에서 송금자 정보 가져오기
	    Integer senderMemberNum = (Integer) session.getAttribute("memberNum");

	    if (senderMemberNum == null) {
	        return "redirect:/login"; // If sender is not logged in, redirect to login
	    }

	    // ChatService를 통해 상대방의 member_num 가져오기
	    Integer targetMemberNum = chatService.getTargetMemberNumByChatRoomNum(chatRoomNum, senderMemberNum);

	    try {
	        // 송금 서비스 호출
	        walletService.transferMoney(senderMemberNum, targetMemberNum, amount);
	        walletService.updateSessionMoney(senderMemberNum, session);
	        
			redirectAttributes.addFlashAttribute("successMessage", "송금이 완료되었습니다.");

	    } catch (Exception e) {
	    	redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
	    }
	    
	    return "redirect:/chat?chatRoomNum=" + chatRoomNum;
	}
	
	@GetMapping("/balance")
	@ResponseBody
	public Map<String, Object> getBalance(HttpSession session) {
	    Integer memberNum = (Integer) session.getAttribute("memberNum");
	    if (memberNum == null) {
	        return Collections.singletonMap("totalMoney", 0); // 사용자 미로그인 시 0 반환
	    }

	    // 세션에서 사용자의 잔액 계산
	    int totalMoney = (int) session.getAttribute("totalMoney");
	    
	    Map<String, Object> response = new HashMap<>();
	    response.put("totalMoney", totalMoney);
	    return response;
	}
}
