package com.team3.market.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import com.team3.market.utils.NotificationHandler;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // "/notifications" 경로로 WebSocket 핸들러를 등록
        registry.addHandler(new NotificationHandler(), "/notifications").setAllowedOrigins("*")
        .addInterceptors(new HttpSessionHandshakeInterceptor()); // HandshakeInterceptor 추가;
    }
}


