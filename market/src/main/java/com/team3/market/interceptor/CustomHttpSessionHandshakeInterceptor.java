package com.team3.market.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import com.team3.market.model.vo.MemberVO;

public class CustomHttpSessionHandshakeInterceptor extends HttpSessionHandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        if (request instanceof org.springframework.http.server.ServletServerHttpRequest) {
            HttpServletRequest servletRequest = ((org.springframework.http.server.ServletServerHttpRequest) request).getServletRequest();
            HttpSession session = servletRequest.getSession(false);

            if (session != null) {
                // HttpSession에서 사용자 정보 가져오기
                MemberVO user = (MemberVO) session.getAttribute("user");
                if (user != null) {
                    // WebSocketSession의 attributes에 사용자 ID를 저장
                    attributes.put("userId", user.getMember_id());
                }
            }
        }
        return super.beforeHandshake(request, response, wsHandler, attributes);
    }
}

