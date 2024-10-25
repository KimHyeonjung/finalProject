package com.team3.market.handler;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.core.io.doubleparser.JavaBigDecimalParser;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;

//WebSocket 핸들러 클래스
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {
	// 채팅방별 WebSocket 세션 저장
	private final Map<String, WebSocketSession> sessions = new HashMap<String, WebSocketSession>();
	private final ObjectMapper objectMapper = new ObjectMapper();

	// 클라이언트가 연결될 때 호출
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		String chatRoomNum = getChatRoomNumFromSession(session); // 세션에서 채팅방 번호 가져오기
		sessions.put(chatRoomNum, session); // 채팅방 번호에 해당하는 세션 저장
	}

	// 메시지를 수신했을 때 호출
	@Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // 메시지를 문자열로 받기
        String payload = message.getPayload();
        
        // 받은 JSON 문자열을 출력 (디버깅용)
        System.out.println("Received message: " + payload);
        
        // 채팅 메시지 처리
//        processChatMessage(payload);
    }
	
//	private void processChatMessage(String chatMessage) {
//        // JSON 파싱을 위한 JsonNode 객체 생성
//        JsonNode jsonNode;
//        try {
//            // JSON 문자열을 JsonNode로 파싱
//            jsonNode = objectMapper.readTree(chatMessage);
//            
//            // 필요한 데이터 추출
//            int memberNum = jsonNode.get("memberNum").asInt();
//            int chatRoomNum = jsonNode.get("chatRoomNum").asInt();
//            String chatContent = jsonNode.get("chatContent").asText();
//
//            // DB에 메시지 저장
//            saveChatMessage(memberNum, chatRoomNum, chatContent);
//            
//            // 다른 클라이언트에 메시지 전송
//            sendMessageToAllClients(chatRoomNum, chatContent);
//        } catch (Exception e) {
//            e.printStackTrace(); // 예외 처리
//        }
//    }

	// 클라이언트가 연결 해제될 때 호출
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		String chatRoomNum = getChatRoomNumFromSession(session); // 세션에서 채팅방 번호 가져오기
		sessions.remove(chatRoomNum); // 채팅방 번호에 해당하는 세션 제거
	}

	// 세션에서 채팅방 번호를 가져오는 메서드
	private String getChatRoomNumFromSession(WebSocketSession session) {
		return session.getAttributes().get("chatRoomNum").toString(); // 세션 속성에서 채팅방 번호 추출
	}
}