package com.team3.market.interceptor;

import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import javax.servlet.http.HttpSession;
import java.util.Map;

public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor {

    @Override
    public boolean beforeHandshake(
            org.springframework.http.server.ServerHttpRequest request,
            org.springframework.http.server.ServerHttpResponse response,
            org.springframework.web.socket.WebSocketHandler wsHandler,
            Map<String, Object> attributes) throws Exception {

        HttpSession session = ((javax.servlet.http.HttpServletRequest) request).getSession();
        String memberId = (String) session.getAttribute("user");  // 사용자 ID를 세션에서 가져옴

        if (memberId != null) {
            attributes.put("memberId", memberId);
        }

        return super.beforeHandshake(request, response, wsHandler, attributes);
    }
}
