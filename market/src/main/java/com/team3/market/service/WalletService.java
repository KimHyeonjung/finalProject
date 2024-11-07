package com.team3.market.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.team3.market.dao.WalletDAO;
import com.team3.market.model.dto.ApproveResponse;
import com.team3.market.model.dto.ReadyResponse;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WalletService {
	
	@Autowired
	WalletDAO walletDao;
	
	public ReadyResponse payReady(String name, int totalPrice) {
       Map<String, String> parameters = new HashMap<>();
       parameters.put("cid", "TC0ONETIME");
       parameters.put("partner_order_id", "1234567890");
       parameters.put("partner_user_id", "roommake");
       parameters.put("item_name", name);
       parameters.put("quantity", "1");
       parameters.put("total_amount", String.valueOf(totalPrice));
       parameters.put("tax_free_amount", "0");
       parameters.put("approval_url", "http://localhost:8080/market/wallet/pay/completed");
       parameters.put("cancel_url", "http://localhost:8080/market/wallet/pay/cancel");
       parameters.put("fail_url", "http://localhost:8080/market/wallet/pay/fail");
       
       HttpEntity<Map<String, String>> requestEntity = new HttpEntity<Map<String, String>>(parameters, this.getHeaders());
       
       RestTemplate template = new RestTemplate();
       String url = "https://open-api.kakaopay.com/online/v1/payment/ready";
       
       ResponseEntity<ReadyResponse> responseEntity = template.postForEntity(url, requestEntity, ReadyResponse.class);
       log.info("결제준비 응답객체: " + responseEntity.getBody());
       return responseEntity.getBody();
   }
   
   public ApproveResponse payApprove(String tid, String pgToken) {
       Map<String, String> parameters = new HashMap<String, String>();
       parameters.put("cid", "TC0ONETIME");
       parameters.put("tid", tid);
       parameters.put("partner_order_id", "1234567890");
       parameters.put("partner_user_id", "roommake");
       parameters.put("pg_token", pgToken);
       
       HttpEntity<Map<String, String>> requestEntity = new HttpEntity<Map<String, String>>(parameters, this.getHeaders());
       RestTemplate template = new RestTemplate();
       String url = "https://open-api.kakaopay.com/online/v1/payment/approve";
       ApproveResponse approveResponse = template.postForObject(url, requestEntity, ApproveResponse.class);
       log.info("결제승인 응답객체: " + approveResponse);
       return approveResponse;
   }

   private HttpHeaders getHeaders() {
       HttpHeaders headers = new HttpHeaders();
       headers.set("Authorization", "SECRET_KEY DEV30E5B7E8E62918CD3056B123793265D2C9A78");
       headers.set("Content-type", "application/json");
       return headers;
   }

	public void updatePoint(int member_num, int totalPrice, HttpSession session) {
		
		PointVO pointVO = new PointVO();
        pointVO.setPoint_member_num(member_num);
        pointVO.setPoint_money(totalPrice);
        walletDao.insertPoint(pointVO); // 포인트 충전 기록 저장
        
        MemberVO memberVO = walletDao.selectMemberById(member_num); 
        if (memberVO != null) {
            // 3. 잔액을 업데이트하고 다시 저장
            int updateMoney = memberVO.getMember_money() + totalPrice;
            memberVO.setMember_money(updateMoney);
            walletDao.updatePoint(memberVO); // 잔액 업데이트
            
            MemberVO user = (MemberVO) session.getAttribute("user");
            
            if (user != null && user.getMember_num() == member_num) {
            	user.setMember_money(updateMoney);  // 세션의 잔액 정보 갱신
                session.setAttribute("user", user);  // 세션에 다시 저장
            }
            
        } else {
            throw new IllegalArgumentException("해당 멤버를 찾을 수 없습니다.");
        }
	}

	public List<PointVO> getPointHistory(int member_num) {
		return walletDao.selectPointHistory(member_num);
	}


	@Transactional(rollbackFor = Exception.class)
	public void transferMoney(Integer senderMemberNum, Integer targetMemberNum, int amount) throws Exception {
	    // 1. 송금할 금액이 유효한지 확인
	    if (amount <= 0) {
	        throw new IllegalArgumentException("송금 금액이 유효하지 않습니다."); // 예외를 던져 클라이언트에 알리기
	    }

	    // 2. 송금자의 포인트 정보 조회
	    MemberVO sender = walletDao.selectMemberById(senderMemberNum);
	    int senderBalance = sender.getMember_money();
	    int senderfake = sender.getMember_fake_money();
	    int totalMoney = senderBalance + senderfake;

	    if (totalMoney < amount) {
	        throw new IllegalStateException("잔액이 부족합니다."); // 예외를 던져 클라이언트에 알리기
	    }
	    
	    int senderaftermoney = senderfake - amount;

	    // 3. 수신자의 포인트 정보 조회
	    MemberVO receiver = walletDao.selectMemberById(targetMemberNum);
	    int receiverfake = receiver.getMember_fake_money();
	    int receiveraftermoney = receiverfake + amount;

	    // 4. 송금자의 포인트 차감
	    sender.setMember_fake_money(senderaftermoney);
	    walletDao.updateFakeMoney(sender);

	    // 5. 수신자의 포인트 추가
	    receiver.setMember_fake_money(receiveraftermoney);
	    walletDao.updateFakeMoney(receiver);

	    // 6. 송금 및 수신 내역을 포인트 기록으로 남김 (옵션)
	    PointVO senderPointLog = new PointVO();
	    senderPointLog.setPoint_member_num(senderMemberNum);
	    senderPointLog.setPoint_money(-amount); // 포인트 차감
	    senderPointLog.setPoint_type("거래 송금");
	    senderPointLog.setPoint_date(new Date());
	    walletDao.deletePayment(senderPointLog);

	    PointVO receiverPointLog = new PointVO();
	    receiverPointLog.setPoint_member_num(targetMemberNum);
	    receiverPointLog.setPoint_money(amount); // 포인트 증가
	    receiverPointLog.setPoint_type("거래 입금");
	    receiverPointLog.setPoint_date(new Date());
	    walletDao.insertPayment(receiverPointLog);
	    
	}
	
	public void updateSessionMoney(Integer memberNum, HttpSession session) {
	    MemberVO member = walletDao.selectMemberById(memberNum);
	    if (member != null) {
	        // member_money와 member_fake_money를 더합니다.
	        int totalMoney = member.getMember_money() + member.getMember_fake_money();
	        session.setAttribute("totalMoney", totalMoney);
	        
	        log.info("세션에 업데이트된 totalMoney: " + totalMoney);
	    }
	}
	
	public MemberVO getMember(int memberNum) {
	    MemberVO member = walletDao.selectMemberById(memberNum);
	    if (member == null) {
	        throw new IllegalArgumentException("해당 멤버를 찾을 수 없습니다.");
	    }
	    return member;
	}
	
	@Transactional
	public void updateChatRoomStayMoney(int chatRoomNum, int amount) {
	    ChatRoomVO chatRoom = walletDao.selectChatRoomById(chatRoomNum);
	    if (chatRoom != null) {
	        int updatedStayMoney = chatRoom.getChatRoom_stay_money() + amount;
	        chatRoom.setChatRoom_stay_money(updatedStayMoney);
	        walletDao.updateChatRoomStayMoney(chatRoom);
	    } else {
	        throw new IllegalArgumentException("해당 채팅방을 찾을 수 없습니다.");
	    }
	}

}
