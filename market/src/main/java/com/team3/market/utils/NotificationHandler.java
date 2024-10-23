package com.team3.market.utils;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.team3.market.model.vo.MemberVO;

public class NotificationHandler extends TextWebSocketHandler {

    // 사용자 ID를 기준으로 WebSocketSession을 관리할 맵
    private Map<String, WebSocketSession> sessions = new HashMap<>();

    // 클라이언트가 연결되었을 때 호출 (사용자 세션 저장)
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // 예를 들어, 사용자 ID는 세션에서 가져온다고 가정 
    	String userId = (String) session.getAttributes().get("userId");
        sessions.put(userId, session);
        System.out.println("사용자 " + userId + " 연결됨");
    }

    // 클라이언트가 연결을 끊었을 때 호출 (세션 제거)
    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) throws Exception {
    	String userId = (String) session.getAttributes().get("userId");
        sessions.remove(userId);
        System.out.println("사용자 " + userId + " 연결 종료됨");
    }

    // 특정 사용자에게 알림을 보내는 메서드
    public void sendNotificationToUser(String userId, String message) throws Exception {
        WebSocketSession session = sessions.get(userId);
        if (session != null && session.isOpen()) {
            session.sendMessage(new TextMessage(message));
        }
    }

    // 그룹 또는 여러 사용자에게 메시지 보내기 (예시)
    public void sendNotificationToGroup(String[] userIds, String message) throws Exception {
        for (String userId : userIds) {
            WebSocketSession session = sessions.get(userId);
            if (session != null && session.isOpen()) {
                session.sendMessage(new TextMessage(message));
            }
        }
    }
}

