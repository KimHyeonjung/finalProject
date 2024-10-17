package com.team3.market.service;

import java.util.Random;

import org.springframework.stereotype.Service;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class SmsService {

    private final DefaultMessageService messageService;

    public SmsService() {
        // API 키와 시크릿 키로 Coolsms SDK 초기화
        this.messageService = NurigoApp.INSTANCE.initialize(
                "NCSQEX1OGT6BRIY2", "1YSO6X4OXDDBK8YF8XIPBYQW92PQRWUI", "https://api.coolsms.co.kr");
    }

    
    public String generateVerificationCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));  // 000000 ~ 999999
    }

    
    public String sendVerificationCode(String phoneNumber) {
        String verificationCode = generateVerificationCode();  // 인증번호 생성

        Message message = new Message();
        message.setFrom("01089965296"); // 발신자 번호 (등록된 번호 사용)
        message.setTo(phoneNumber);     // 수신자 번호
        message.setText("[중고날아] 인증번호 " + verificationCode + "를 입력해주세요.");

        try {
            SingleMessageSentResponse response = messageService.sendOne(
                    new SingleMessageSendingRequest(message));
            System.out.println("SMS 발송 결과: " + response);
            return verificationCode;  // 인증번호 반환
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("SMS 발송에 실패했습니다.");
        }
    }
}