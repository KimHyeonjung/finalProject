package com.team3.market.controller;

import java.util.Date;
import java.util.List;

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
    public String point(HttpSession session, Model model) {
    	// 세션에서 사용자 정보 가져오기
    	MemberVO user = (MemberVO) session.getAttribute("user");
    	
        // 로그인된 사용자 정보가 없으면 로그인 페이지로 리다이렉트
 		if (user == null) {
 			return "redirect:/login"; // 로그인 페이지로 리다이렉트
 		}
 		
 		// 세션에서 포인트 정보 가져오기
 	    Integer point = (Integer) session.getAttribute("point");
 	    
 	    if (point == null) {
 	        // 만약 세션에 포인트 정보가 없다면, 데이터베이스에서 가져와서 세션에 저장
 	    	point = walletService.getUpdatedPoints(user.getMember_num());
 	        session.setAttribute("point", point);
 	    }

 	    // 모델에 포인트 정보 추가
 	    model.addAttribute("point", point);
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
        
        walletService.updatePoint(pointRequest);
        
        int updatePoint = walletService.getUpdatedPoints(user.getMember_num());
        
        session.setAttribute("point", updatePoint);
        
        model.addAttribute("processedPoint", processedPoint); 
        model.addAttribute("updatedPoint", updatePoint); 

        return "/wallet/paymentResult";
    }
     
    
    @GetMapping("/paymentResult")
    public String result() {
    	return "/wallet/paymentResult";
    }
    
    @GetMapping("/list")
    public String viewPointHistory(Model model, HttpSession session) {
        
        // 세션에서 사용자 정보 가져오기
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 사용자의 포인트 충전 기록 조회
        List<PointVO> pointList = walletService.PointList(user.getMember_num());
        
        // 조회된 기록을 모델에 추가
        model.addAttribute("pointList", pointList);

        // JSP로 이동
        return "/wallet/list";
    }
}
	