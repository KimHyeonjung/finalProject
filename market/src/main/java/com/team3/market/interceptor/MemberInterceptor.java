package com.team3.market.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.team3.market.model.vo.MemberVO;

public class MemberInterceptor extends HandlerInterceptorAdapter{
	
	@Override
	public void postHandle(
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Object handler, 
	    ModelAndView modelAndView)
	    throws Exception {
		 //구현   
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, 
			HttpServletResponse response, 
			Object handler)
			throws Exception {
			
		//로그인한 회원 정보를 가져옴
		MemberVO user = (MemberVO)request.getSession().getAttribute("user");
		//로그인하지 않았으면 로그인 페이지로
		if(user == null) {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert(\"회원만 접근할 수 있습니다.\")</script>");
			response.getWriter().write("<script>location.href=\""+ request.getContextPath() + "/login" + "\"</script>");
			response.flushBuffer();
			return false;
		}
		//로그인했으면 가려던 길로 
		else {
			return true;
		}
	}
}