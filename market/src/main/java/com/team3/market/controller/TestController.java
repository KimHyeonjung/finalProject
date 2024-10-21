package com.team3.market.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.team3.market.model.vo.MemberVO;

import javax.servlet.http.HttpSession;

@Controller
public class TestController {

    @GetMapping("/test")
    public String test(HttpSession session) {
        // 테스트용 MemberVO 객체 생성
        MemberVO testMember = new MemberVO();
        testMember.setMember_num(1);
        testMember.setMember_id("qwe");
        testMember.setMember_pw("qweqwe");
        testMember.setMember_nick("qweqweqwe");
        testMember.setMember_phone("010-1234-5678");
        testMember.setMember_email("qwe@example.com");
        testMember.setMember_auth("USER");
        testMember.setMember_state("ACTIVE");
        testMember.setMember_report(0);
        testMember.setMember_score(4.5);
        testMember.setMember_money(10000);

        // 세션에 저장
        session.setAttribute("user", testMember); // 'user' 키로 세션에 저장

        // 테스트 페이지로 리다이렉트 또는 포워드
        return "/home"; // 'test.jsp' 페이지로 이동
    }
}