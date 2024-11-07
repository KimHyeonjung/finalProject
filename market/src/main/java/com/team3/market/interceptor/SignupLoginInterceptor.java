package com.team3.market.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.team3.market.model.vo.MemberVO;


public class SignupLoginInterceptor extends HandlerInterceptorAdapter{
	
	@Override
	public boolean preHandle(HttpServletRequest request, 
			HttpServletResponse response, 
			Object handler)
			throws Exception {
			//로그인한 회원 정보를 가져옴
			MemberVO user = (MemberVO)request.getSession().getAttribute("user");
			//로그인 했으면 메인페이지로
			if(user != null) {
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().write("<script>alert(\"회원은 접근할 수 없습니다.\")</script>");
				response.getWriter().write("<script>location.href=\""+ request.getContextPath() + "/" + "\"</script>");
				response.flushBuffer();
				return false;
			}
			//아니면 가려던 길로 
			else {
				return true;
			}
			
	}
	
}
