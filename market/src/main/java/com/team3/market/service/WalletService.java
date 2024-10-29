package com.team3.market.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.team3.market.dao.WalletDAO;
import com.team3.market.model.dto.ApproveResponse;
import com.team3.market.model.dto.ReadyResponse;
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
       
       HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
       
       RestTemplate template = new RestTemplate();
       String url = "https://open-api.kakaopay.com/online/v1/payment/ready";
       
       ResponseEntity<ReadyResponse> responseEntity = template.postForEntity(url, requestEntity, ReadyResponse.class);
       log.info("결제준비 응답객체: " + responseEntity.getBody());
       return responseEntity.getBody();
   }
   
   public ApproveResponse payApprove(String tid, String pgToken) {
       Map<String, String> parameters = new HashMap<>();
       parameters.put("cid", "TC0ONETIME");
       parameters.put("tid", tid);
       parameters.put("partner_order_id", "1234567890");
       parameters.put("partner_user_id", "roommake");
       parameters.put("pg_token", pgToken);
       
       HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
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
   
}
