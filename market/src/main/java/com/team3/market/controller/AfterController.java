package com.team3.market.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.handler.SocketHandler;
import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.AfterService;

@Controller
@RequestMapping("/after")
public class AfterController {
	
	@Autowired
	AfterService afterService;
	@Autowired
    private NotificationWebSocketHandler notificationHandler;
	@Autowired
    private SocketHandler socketHandler; // SocketHandler 주입


    @GetMapping("/review/{post_num}")
    public String review(Model model, HttpSession session, @PathVariable("post_num")int post_num) {
        // 로그인 여부 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
        
		/*
		 * if (user == null) { // 로그인이 되어 있지 않으면 메인 페이지로 리다이렉트 return "redirect:/login";
		 * // 로그인 페이지로 변경 가능 }
		 */
        
        // 추가적으로 post_num을 사용하여 필요한 정보를 모델에 추가할 수 있습니다.
        
        model.addAttribute("post_num", post_num);
        
        return "/after/review"; // 리뷰 작성 페이지로 이동
    }
    
    // 리뷰 생성 처리
    @PostMapping("/review")
    public String insertReview(@RequestParam("post_num") int postNum, Model model, AfterVO review, HttpSession session, @RequestParam("after_review_sum") float afterReviewSum) {
        System.out.println("Request received"); // 디버깅 메시지 추가
        System.out.println("postNum: " + postNum); // post_num 값 확인

        MemberVO user = (MemberVO) session.getAttribute("user");

        // 리뷰 생성 처리 및 member_score 업데이트
        boolean res = afterService.insertReview(review, user, afterReviewSum);

        MessageDTO message;

        if (res) {
            message = new MessageDTO("/", "리뷰를 등록했습니다.");
        } else {
            message = new MessageDTO("/after/review", "리뷰를 등록하지 못했습니다.");
        }

        model.addAttribute("message", message);

        return "/main/message";
    }
    
    @GetMapping("/board")
    public String reviewList(Model model, HttpSession session) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 로그인하지 않은 경우 로그인 페이지로 리다이렉트
        if (user == null) {
            return "redirect:/login";
        }
        
        // 로그인한 사용자의 리뷰 목록만 조회
        List<Map<String, Object>> reviews = afterService.selectUserReviews(user.getMember_num());
        model.addAttribute("reviews", reviews);
        
        return "/after/board";
    }	
}