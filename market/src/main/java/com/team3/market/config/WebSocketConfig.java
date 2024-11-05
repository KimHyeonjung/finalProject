package com.team3.market.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.interceptor.HttpSessionHandshakeInterceptor;
import com.team3.market.service.ChatService;

@Configuration
@EnableWebSocket
@ComponentScan(basePackages = "com.team3.market")
public class WebSocketConfig implements WebSocketConfigurer {

	@Autowired
	ChatService chatService;

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(new NotificationWebSocketHandler(chatService), "/ws/notify") // 클라이언트에서 접속할 수 있는 URL
				.setAllowedOrigins("*").addInterceptors(new HttpSessionHandshakeInterceptor());
//		registry.addHandler(new SocketHandler(chatService), "/chat/echo.do")
//				.setAllowedOrigins("*"); // 필요한 경우 특정 오리진만
//		registry.addHandler(new SocketHandler(chatService), "/ws/notify")
//				.setAllowedOrigins("*"); // 필요한 경우 특정 오리진만
																										// 허용 가능
	}

	@Bean
	public NotificationWebSocketHandler notificationWebSocketHandler() {
		return new NotificationWebSocketHandler(chatService);
	}
}
