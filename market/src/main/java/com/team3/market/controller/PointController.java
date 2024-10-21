package com.team3.market.controller;

import java.util.Date;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import com.team3.market.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class PointController {

    @Autowired
    private WalletService walletService;
    
    @GetMapping("/point")
    public String point() {
    	return "/wallet/point";
    }
    
    @PostMapping("/point")
    public String chargePoint(@ModelAttribute PointVO pointRequest, @RequestParam("paymentMethod") String paymentMethod, Model model, HttpSession session) {
    	
        // 세션에서 사용자 정보 가져오기
    	MemberVO user = (MemberVO)session.getAttribute("user");
        pointRequest.setPoint_member_num(user.getMember_num());

        // 현재 날짜 설정
        pointRequest.setPoint_date(new Date());

        // 결제 처리 서비스 호출
        PointVO processedPoint = walletService.processPayment(pointRequest, paymentMethod);
        
        int updatedMemberPoint = user.getMember_money() + processedPoint.getPoint_money();
        user.setMember_money(updatedMemberPoint);
        
        walletService.updatePoint(pointRequest);
        
        session.setAttribute("user", user);
        
        // 모델에 결과 추가
        model.addAttribute("point", processedPoint);
        return "/wallet/paymentResult";
    }
     
    
    
    @GetMapping("/paymentResult")
    public String result() {
    	return "/wallet/paymentResult";
    }
}
	