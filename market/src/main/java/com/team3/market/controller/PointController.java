package com.team3.market.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.team3.market.model.vo.PointVO;
import com.team3.market.service.WalletService;

@RestController
@RequestMapping("/wallet")
public class PointController {

    @Autowired
    private WalletService walletService;
    
    @GetMapping("/point")
    public String point() {
    	return "/wallet/point";
    }
    
    // 결제 요청 처리
    @PostMapping("/charge")
    public String chargePoint(@ModelAttribute PointVO pointRequest, Model model) {
        // 결제 처리 서비스 호출
        PointVO processedPoint = walletService.processPayment(pointRequest);

        // 결제 처리 후 결제 성공/실패 여부를 모델에 담아서 리턴
        model.addAttribute("point", processedPoint);
        return "/wallet/paymentResult";
    }
    
    @GetMapping("/paymentResult")
    public String result() {
    	return "/wallet/paymentResult";
    }
}
	