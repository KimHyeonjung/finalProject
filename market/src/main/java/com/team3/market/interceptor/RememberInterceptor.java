package com.team3.market.interceptor;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.MemberService;

public class RememberInterceptor extends HandlerInterceptorAdapter {

    @Autowired 
    MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) 
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("AL".equals(cookie.getName())) {
                        String sessionId = cookie.getValue();
                        MemberVO user = memberService.checkLoginBefore(sessionId);
                        
                        if (user != null && user.getMember_limit() != null) {
                        	
                        	System.out.println("Member limit: " + user.getMember_limit());
                            System.out.println("Current time: " + new Date());
                            // 만료 시간이 현재 시간보다 이전이면 자동 로그인 해제
                            if (user.getMember_limit().before(new Date())) {
                            	System.out.println("Auto-login expired. Clearing auto-login data.");
                                // 자동 로그인 정보 삭제
                                memberService.clearAutoLogin(user.getMember_id());
                                
                                // 쿠키 삭제
                                cookie.setMaxAge(0);
                                cookie.setPath("/");
                                response.addCookie(cookie);
                                
                                // 세션 무효화
                                if (session != null) {
                                    session.invalidate();
                                }
                                return true; // 자동 로그인 해제 후 종료
                            }
                            // 만료되지 않았다면 로그인 세션 설정
                            session = request.getSession();
                            session.setAttribute("user", user);
                        }
                    }
                }
            }
        }
        return true;
    }
}