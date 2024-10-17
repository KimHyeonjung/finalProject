package com.team3.market.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team3.market.service.SmsService;

@RestController
@RequestMapping("/api/sms")
public class SmsController {

    private final SmsService smsService;

    @Autowired
    public SmsController(SmsService smsService) {
        this.smsService = smsService;
    }

    /**
     * 인증번호 발송 API
     */
    @PostMapping("/send")
    public String sendVerificationCode(@RequestParam String phoneNumber, HttpSession session) {
        try {
            String verificationCode = smsService.sendVerificationCode(phoneNumber);
            
            // 세션에 인증번호 저장
            session.setAttribute("verificationCode", verificationCode);
            System.out.println("발송된 인증번호: " + verificationCode);
            
            return "인증번호가 발송되었습니다.";
        } catch (RuntimeException e) {
            return e.getMessage();  // 실패 메시지 반환
        }
    }
    
    @PostMapping("/verify")
    public boolean verifyCode(@RequestParam String userInputCode, HttpSession session) {
        String sessionCode = (String) session.getAttribute("verificationCode");
        return sessionCode != null && sessionCode.equals(userInputCode); // 인증번호 일치 여부 확인
    }
}
