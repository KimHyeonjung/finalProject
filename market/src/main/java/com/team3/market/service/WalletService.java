package com.team3.market.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.team3.market.dao.WalletDAO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;

@Service
public class WalletService {
	
	@Autowired
    private WalletDAO walletDao;
	
	@Autowired
	private RestTemplate restTemplate;
	
	@Autowired
    public WalletService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

	// 결제 처리 메서드
    public PointVO processPayment(PointVO point, String paymentMethod) {
    	
        // 결제 날짜 설정
        point.setPoint_date(new Date());
        
        // 결제 방식에 따라 분기 처리
        if ("kakao".equalsIgnoreCase(paymentMethod)) {
            return processKakaoPay(point);
        } else if ("toss".equalsIgnoreCase(paymentMethod)) {
            return processTossPay(point);
        }
        
        walletDao.insertPayment(point);
        
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

	public void updatePoint(PointVO pointRequest) {
		
		MemberVO member = walletDao.selectMemberById(pointRequest.getPoint_member_num());
        
        // 현재 사용자의 기존 포인트 가져오기
        int currentMemberPoint = member.getMember_money();
        
        // 새로운 포인트 계산 (기존 포인트 + 충전한 포인트)
        int newMemberPoint = currentMemberPoint + pointRequest.getPoint_money();
        
        // 업데이트된 포인트를 DB에 반영
        member.setMember_money(newMemberPoint);
        
        // 업데이트된 포인트 저장
        walletDao.updatePoint(member);
		
	}

	public List<PointVO> PointList(int member_num) {
		return walletDao.pointList(member_num);
	}

	@Transactional(rollbackFor = Exception.class)
	public void transferMoney(Integer senderMemberNum, int targetMemberNum, int amount) {
		
		// 1. 송금할 금액이 유효한지 확인
	    if (amount <= 0) {
	        throw new IllegalArgumentException("송금 금액이 유효하지 않습니다.");
	    }

	    // 2. 송금자의 포인트 정보 조회
	    MemberVO sender = walletDao.selectMemberById(senderMemberNum);
	    int senderBalance = sender.getMember_money();

	    if (senderBalance < amount) {
	        throw new IllegalStateException("잔액이 부족합니다.");
	    }

	    // 3. 수신자의 포인트 정보 조회
	    MemberVO receiver = walletDao.selectMemberById(targetMemberNum);
	    int receiverBalance = receiver.getMember_money();

	    // 4. 송금자의 포인트 차감
	    sender.setMember_money(senderBalance - amount);
	    walletDao.updatePoint(sender);

	    // 5. 수신자의 포인트 추가
	    receiver.setMember_money(receiverBalance + amount);
	    walletDao.updatePoint(receiver);

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
    

}
