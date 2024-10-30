package com.team3.market.utils;

import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.team3.market.model.vo.MemberVO;

@Component  // 빈으로 등록
public class NotificationWebSocketHandler extends TextWebSocketHandler {

    private static ConcurrentHashMap<String, WebSocketSession> sessions = new ConcurrentHashMap<String, WebSocketSession>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        MemberVO user = getUserIdFromSession(session); // 세션에서 사용자 ID 추출
        sessions.put(user.getMember_id(), session); // 사용자 세션 저장
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
    	MemberVO user = getUserIdFromSession(session);
        sessions.remove(user.getMember_id()); // 연결 종료 시 세션 제거
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // 클라이언트로부터 받은 메시지 처리 (필요한 경우)
    }

    // 사용자에게 알림 전송 메소드
    public void sendNotificationToUser(String userId, String notification) throws Exception {
        WebSocketSession session = sessions.get(userId);
        if (session != null && session.isOpen()) {
            session.sendMessage(new TextMessage(notification));
        }
    }

    private MemberVO getUserIdFromSession(WebSocketSession session) {
        // 세션에서 사용자 ID를 가져오는 로직 (예: JWT, 세션 정보 등)
        return (MemberVO) session.getAttributes().get("user");
    }
}

