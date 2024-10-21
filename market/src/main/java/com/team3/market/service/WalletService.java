package com.team3.market.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.team3.market.dao.WalletDAO;
import com.team3.market.model.vo.PointVO;

@Service
public class WalletService {
	
	@Autowired
    private WalletDAO walletDao;
	
	private RestTemplate restTemplate;
	
	@Autowired
    public WalletService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

	// 결제 처리 메서드
    public PointVO processPayment(PointVO point) {
        // 결제 날짜 설정
        point.setPoint_date(new Date());

        // 결제 방식에 따라 분기 처리
        if ("kakao".equalsIgnoreCase(point.getPoint_type())) {
            return processKakaoPay(point);
        } else if ("toss".equalsIgnoreCase(point.getPoint_type())) {
            return processTossPay(point);
        }
        return point;
    }

    // 카카오페이 결제 처리
    private PointVO processKakaoPay(PointVO point) {
        // 카카오페이 API 호출
        String apiUrl = "https://kapi.kakao.com/v1/payment/ready"; // 카카오페이 결제 준비 API URL
        // 결제 요청에 필요한 데이터
        String requestBody = "{\"cid\": \"TC0ONETIME\", \"partner_order_id\": \"12345\", \"partner_user_id\": \"${user.member_id}\", "
                + "\"item_name\": \"중고날아\", \"quantity\": 1, \"total_amount\": " + point.getPoint_money()
                + ", \"tax_free_amount\": 0, \"approval_url\": \"http://localhost:8080/market/wallet/paymentResult\", "
                + "\"cancel_url\": \"http://localhost:8080/market\", \"fail_url\": \"http://localhost:8080/market/wallet/paymentResult\"}";

        // 카카오페이 API 호출
        String response = restTemplate.postForObject(apiUrl, requestBody, String.class);

        // API 호출 응답 처리 (실제 호출 시에는 JSON 응답을 객체로 변환해야 함)
        System.out.println("KakaoPay Response: " + response);

        // 결제 정보를 DB에 저장
        walletDao.insertPayment(point);

        return point;
    }

    // 토스페이 결제 처리
    private PointVO processTossPay(PointVO point) {
        // 토스페이 API 호출
        String apiUrl = "https://api.tosspayments.com/v1/charges"; // 토스페이 결제 API URL
        // 결제 요청에 필요한 데이터
        String requestBody = "{\"amount\": " + point.getPoint_money() + ", \"orderId\": \"12345\", "
                + "\"orderName\": \"중고날아\", \"successUrl\": \"http://localhost:8080/market/wallet/paymentResult\", "
                + "\"cancelUrl\": \"http://localhost:8080/market/wallet/paymentResult\"}";

        // 헤더에 Authorization 추가
        String authHeader = "Bearer " + "test_ck_GePWvyJnrK2N9XBJpgPOVgLzN97E";

        // RestTemplate을 사용하여 POST 요청 보내기
        String response = restTemplate.postForObject(apiUrl, requestBody, String.class, authHeader);

        // API 호출 응답 처리 (실제 호출 시에는 JSON 응답을 객체로 변환해야 함)
        System.out.println("TossPay Response: " + response);

        // 결제 정보를 DB에 저장
        walletDao.insertPayment(point);

        return point;
    }

}
