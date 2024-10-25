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
	
	// 결제 처리 메서드
    public PointVO processPayment(PointVO point, String paymentMethod) {
    	
        // 결제 날짜 설정
        point.setPoint_date(new Date());
        
        switch (paymentMethod.toLowerCase()) {
        case "kakao":
            return processKakaoPay(point);
        case "toss":
            return processTossPay(point);
        default:
            return point;
        }
    }

	// 카카오페이 결제 처리
    private PointVO processKakaoPay(PointVO point) {
        String apiUrl = "https://kapi.kakao.com/v1/payment/ready";
        String requestBody = String.format(
                "{\"cid\": \"TC0ONETIME\", \"partner_order_id\": \"12345\", \"partner_user_id\": \"%d\", "
                + "\"item_name\": \"중고날아\", \"quantity\": 1, \"total_amount\": %d, \"tax_free_amount\": 0, "
                + "\"approval_url\": \"http://localhost:8080/market/wallet/paymentResult\", "
                + "\"cancel_url\": \"http://localhost:8080/market\", \"fail_url\": \"http://localhost:8080/market/wallet/paymentResult\"}",
                point.getPoint_member_num(), point.getPoint_money()
        );

        String response = restTemplate.postForObject(apiUrl, requestBody, String.class);
        System.out.println("KakaoPay Response: " + response);

        walletDao.insertPayment(point);
        return point;
    }

    // 토스페이 결제 처리
    private PointVO processTossPay(PointVO point) {
    	String apiUrl = "https://api.tosspayments.com/v1/charges";
        String requestBody = String.format(
                "{\"amount\": %d, \"orderId\": \"12345\", \"orderName\": \"중고날아\", "
                + "\"successUrl\": \"http://localhost:8080/market/wallet/paymentResult\", "
                + "\"cancelUrl\": \"http://localhost:8080/market/wallet/paymentResult\"}",
                point.getPoint_money()
        );

        String authHeader = "Bearer test_ck_GePWvyJnrK2N9XBJpgPOVgLzN97E";
        String response = restTemplate.postForObject(apiUrl, requestBody, String.class, authHeader);
        System.out.println("TossPay Response: " + response);

        walletDao.insertPayment(point);
        return point;
    }

	public void updatePoint(PointVO pointRequest) {
		
		MemberVO member = walletDao.selectMemberById(pointRequest.getPoint_member_num());
        int newMemberPoint = member.getMember_money() + pointRequest.getPoint_money();

        member.setMember_money(newMemberPoint);
        walletDao.updatePoint(member);
		
	}

	public List<PointVO> PointList(int member_num) {
		return walletDao.pointList(member_num);
	}

	@Transactional(rollbackFor = Exception.class)
    public Integer transferMoney(Integer senderMemberNum, Integer targetMemberNum, int amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("송금 금액이 유효하지 않습니다.");
        }

        // 송금자 포인트 조회 및 차감
        MemberVO sender = walletDao.selectMemberById(senderMemberNum);
        if (sender.getMember_money() < amount) {
            throw new IllegalStateException("잔액이 부족합니다.");
        }

        // 수신자 포인트 조회 및 추가
        MemberVO receiver = walletDao.selectMemberById(targetMemberNum);

        sender.setMember_money(sender.getMember_money() - amount);
        receiver.setMember_money(receiver.getMember_money() + amount);

        walletDao.updatePoint(sender);
        walletDao.updatePoint(receiver);

        // 송금 내역 기록
        logTransaction(senderMemberNum, -amount, "거래 송금");
        logTransaction(targetMemberNum, amount, "거래 입금");

        return sender.getMember_money();
    }

	private void logTransaction(int memberNum, int amount, String type) {
        PointVO pointLog = new PointVO();
        pointLog.setPoint_member_num(memberNum);
        pointLog.setPoint_money(amount);
        pointLog.setPoint_type(type);
        pointLog.setPoint_date(new Date());

        walletDao.insertPayment(pointLog);
    }
	
	public int getUpdatedPoints(int memberNum) {
	    MemberVO member = walletDao.selectMemberById(memberNum);
	    return member != null ? member.getMember_money() : 0; // 멤버가 없으면 0 반환
	}

}
