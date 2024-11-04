package com.team3.market.handler;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.team3.market.handler.SocketHandler;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.service.ChatService;

@Component // 빈으로 등록
public class NotificationWebSocketHandler extends TextWebSocketHandler {

	private static ConcurrentHashMap<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

	private ChatService chatService; // ChatService 주입

	private final Logger logger = LoggerFactory.getLogger(SocketHandler.class);
	private Set<WebSocketSession> sessionSet = new HashSet<WebSocketSession>();
	private ObjectMapper objectMapper = new ObjectMapper(); // JSON 파싱을 위한 ObjectMapper

	public NotificationWebSocketHandler(ChatService chatService) {
		this.chatService = chatService;
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		MemberVO user = getUserIdFromSession(session); // 세션에서 사용자 ID 추출
		sessions.put(user.getMember_id(), session); // 사용자 세션 저장

		super.afterConnectionEstablished(session);
		String query = session.getUri().getQuery();
		if (query != null) {
			String[] params = query.split("&"); // 여러 파라미터를 '&'로 나눔
			for (String param : params) {
				String[] keyValue = param.split("=");
				if (keyValue.length == 2) {
					String key = keyValue[0];
					String value = keyValue[1];

					if ("chatRoomNum".equals(key)) {
						session.getAttributes().put("chatRoomNum", value); // 세션에 채팅방 번호 저장
						logger.info("세션 연결됨. 채팅방 번호: " + value);
					} else if ("member_nick".equals(key)) {
						session.getAttributes().put("member_nick", value); // 세션에 닉네임 저장
						logger.info("세션 연결됨. 회원 닉네임: " + value);
					}
				}
			}
			sessionSet.add(session); // 세션 저장
		} else {
			logger.warn("쿼리 파라미터가 없는 세션 연결됨.");
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		MemberVO user = getUserIdFromSession(session);
		sessions.remove(user.getMember_id()); // 연결 종료 시 세션 제거

		super.afterConnectionClosed(session, status);
		sessionSet.remove(session);
		this.logger.info("세션 제거!");
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

	// 클라이언트로부터 메시지가 도착했을 때 호출
	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		super.handleMessage(session, message);
		this.logger.info("메시지 수신 : " + message.toString());

		// 수신한 메시지를 확인
		String payload = message.getPayload().toString();
		if (payload == null || payload.trim().isEmpty()) {
			this.logger.warn("수신된 메시지가 비어 있습니다.");
			return;
		}
		System.out.println(payload);

		try {
			// 메시지를 ChatVO로 변환
			ChatVO chatVO = objectMapper.readValue(payload, ChatVO.class);
			chatVO.setChat_date(new Date());
			int chatRoomNum = chatVO.getChat_chatRoom_num(); // 메시지의 채팅방 번호
			System.out.println(chatVO);
			// 받은 메시지를 DB에 저장
			chatService.saveChatMessage(chatVO);

			Map<String, Object> chatData = new HashMap<String, Object>();
			chatData.put("chatVO", chatVO); // chatVO 객체 추가
			chatData.put("member_nick", session.getAttributes().get("member_nick")); // member_nick 문자열 추가

			String jsonString = objectMapper.writeValueAsString(chatData);

			sendMessage(jsonString, chatRoomNum);
		} catch (Exception e) {
			this.logger.error("메시지 파싱 오류: " + e.getMessage(), e);
			// 필요하다면 여기에서 클라이언트에 에러 메시지를 전송할 수 있습니다.
		}
	}

	// 전송 에러 발생할 때 호출
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		this.logger.error("웹소켓 에러!", exception);
	}

	// WebSocketHandler가 부분 메시지를 처리할 때 호출
	@Override
	public boolean supportsPartialMessages() {
		this.logger.info("메소드 호출!");

		return super.supportsPartialMessages();
	}

	public void sendMessage(String message, int chatRoomNum) {
		for (WebSocketSession session : this.sessionSet) {
			if (session.isOpen()) {
				try {
					// session에서 chatRoomNum을 String으로 가져옴
					String sessionChatRoomNumStr = (String) session.getAttributes().get("chatRoomNum");

					// String을 int로 변환 후 비교
					if (sessionChatRoomNumStr != null && Integer.parseInt(sessionChatRoomNumStr) == chatRoomNum) {
						session.sendMessage(new TextMessage(message));
					}
				} catch (Exception ignored) {
					this.logger.error("메시지 전송 실패!", ignored);
				}
			}
		}
	}

	public void sendMessage2(String message, int chatRoomNum) {
		for (WebSocketSession session : this.sessionSet) {
			if (session.isOpen()) {
				try {
					// session에서 chatRoomNum을 String으로 가져옴
					String sessionChatRoomNumStr = (String) session.getAttributes().get(chatRoomNum);

					// String을 int로 변환 후 비교
					if (sessionChatRoomNumStr != null && Integer.parseInt(sessionChatRoomNumStr) == chatRoomNum) {
						session.sendMessage(new TextMessage(message));
					}
				} catch (Exception ignored) {
					this.logger.error("메시지 전송 실패!", ignored);
				}
			}
		}
	}

	public void afterPropertiesSet() throws Exception {
		Thread thread = new Thread() {
			int i = 0;

			@Override
			public void run() {
				while (true) {
					try {
// 						sendMessage("실시간 서버 송신 메시지 : " + i++);
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
						break;
					}
				}
			}
		};

		thread.start();
	}
}
