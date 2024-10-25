package com.team3.market.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.team3.market.interceptor.HttpSessionHandshakeInterceptor;
import com.team3.market.utils.NotificationWebSocketHandler;

@Configuration
@EnableWebSocket
@ComponentScan(basePackages = "com.team3.market")
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new NotificationWebSocketHandler(), "/ws/notify") // 클라이언트에서 접속할 수 있는 URL
                .setAllowedOrigins("*")
                .addInterceptors(new HttpSessionHandshakeInterceptor()); 
    }
    
    @Bean
    public NotificationWebSocketHandler notificationWebSocketHandler() {
        return new NotificationWebSocketHandler();
    }
}



