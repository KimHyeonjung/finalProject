package com.team3.market.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.team3.market.handler.SocketHandler;
import com.team3.market.service.ChatService;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

	@Autowired
	ChatService chatService;
	
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
    	// /chat 엔드포인트에 WebSocket 핸들러 등록
        registry.addHandler(new SocketHandler(chatService), "/chat/echo.do")
                .setAllowedOrigins("*");  // 필요한 경우 특정 오리진만 허용 가능
    }
    
    
    
}