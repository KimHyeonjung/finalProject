package com.team3.market.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import com.team3.market.model.vo.MemberVO;


public class HttpSessionHandshakeInterceptor implements HandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> session) throws Exception {
        // ServerHttpRequest를 HttpServletRequest로 변환
        HttpServletRequest httpRequest = ((ServletServerHttpRequest) request).getServletRequest();
        HttpSession httpSession = httpRequest.getSession(false);
        
        if (httpSession != null) {
            MemberVO user = (MemberVO) httpSession.getAttribute("user");
        	session.put("user", user);
        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {
        // Handshake 이후 처리
    }
}


