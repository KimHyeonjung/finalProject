package com.team3.market.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.team3.market.handler.ChatWebSocketHandler;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
    	// /chat 엔드포인트에 WebSocket 핸들러 등록
        registry.addHandler(new ChatWebSocketHandler(), "/chat")
                .setAllowedOrigins("*");  // 필요한 경우 특정 오리진만 허용 가능
    }
}
