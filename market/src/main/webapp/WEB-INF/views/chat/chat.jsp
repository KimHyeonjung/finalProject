<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Chat Window</title>
<style>
/* 메시지 레이아웃 스타일 정의 */
.message-container {
	display: flex; /* Flexbox 사용 */
	margin-bottom: 10px; /* 메시지 간 간격 */
	align-items: center; /* 수직 정렬 */
}

.my-message {
	justify-content: flex-end; /* 내 메시지는 오른쪽 정렬 */
}

.their-message {
	justify-content: flex-start; /* 상대 메시지는 왼쪽 정렬 */
}

.message-content {
	padding: 10px; /* 메시지 내용 여백 */
	border-radius: 10px; /* 메시지 모서리 둥글게 */
	max-width: 60%; /* 메시지 최대 너비 */
}

.my-message .message-content {
	background-color: #dcf8c6; /* 내 메시지 배경색 */
}

.their-message .message-content {
	background-color: #ececec; /* 상대방 메시지 배경색 */
}

.message-time {
	font-size: 12px; /* 시간 글자 크기 */
	margin-left: 10px; /* 시간과 메시지 간격 */
	color: #888; /* 시간 글자 색상 */
}

.nickname {
	font-weight: bold; /* 닉네임 볼드체 */
}

.profile-img {
	width: 40px; /* 프로필 이미지 너비 */
	height: 40px; /* 프로필 이미지 높이 */
	border-radius: 50%; /* 프로필 이미지 원형 */
	margin-right: 10px; /* 이미지와 메시지 간격 */
}
</style>
<script>
	var chatRoomNum = "${chatRoomNum}"; // JSP에서 채팅방 번호를 가져옴
	
	window.onload = function() {
        if (socket && socket.readyState === WebSocket.OPEN) {
            console.log("chat.jsp에서 기존 웹소켓 사용 가능");
        } else {
            console.log("웹소켓이 연결되지 않음. 재연결 필요");
            connectWebSocket();  // 필요 시 재연결
        }
    }

    function sendMessage(messageContent) {
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify({ content: messageContent }));
            console.log("메시지 전송:", messageContent);
        } else {
            console.error("웹소켓이 열려 있지 않습니다.");
        }
    }

	// WebSocket 연결 설정
	function connect() {
		// WebSocket 연결 생성
		ws = new WebSocket("ws://localhost:8080/market/chat");
		// 메시지를 수신할 때 호출되는 이벤트 핸들러
		ws.onmessage = function(event) {
			var message = JSON.parse(event.data); // JSON 문자열을 객체로 변환
			displayMessage(message); // 메시지 출력 함수 호출
		};
	}

	// 메시지를 서버로 전송하는 함수
	function sendMessage() {
		var message = document.getElementById("message").value; // 입력한 메시지 가져오기
		var msgObj = {
			chatRoomNum : chatRoomNum, // 채팅방 번호
			content : message, // 메시지 내용
			sender : "${member.member_nick}", // 발신자 ID
			time : new Date().toLocaleTimeString()
		// 현재 시간
		};
		ws.send(JSON.stringify(msgObj)); // JSON 형태로 메시지 전송
		document.getElementById("message").value = ""; // 메시지 전송 후 입력창 초기화
	}

	// 메시지를 화면에 출력하는 함수
	function displayMessage(message) {
		var messageContainer = document.createElement("div"); // 메시지 컨테이너 생성
		var content = document.createElement("div"); // 메시지 내용 div 생성
		var time = document.createElement("span"); // 시간 정보 span 생성

		time.className = "message-time"; // 시간 스타일 클래스 추가
		time.textContent = message.time; // 시간 설정

		content.className = "message-content"; // 메시지 내용 스타일 클래스 추가
		content.textContent = message.content; // 메시지 내용 설정

		if (message.sender === "${member.member_nick}") {
			// 내 메시지인 경우
			messageContainer.className = "message-container my-message"; // 오른쪽 정렬 스타일 적용
		} else {
			// 상대방 메시지인 경우
			messageContainer.className = "message-container their-message"; // 왼쪽 정렬 스타일 적용

			var nickname = document.createElement("span"); // 닉네임 span 생성
			nickname.className = "nickname"; // 닉네임 스타일 클래스 추가
			nickname.textContent = message.sender; // 닉네임 설정

			var profileImg = document.createElement("img"); // 프로필 이미지 생성
			profileImg.className = "profile-img"; // 프로필 이미지 스타일 클래스 추가
			profileImg.src = "/market/resources/img/none_profile_image.png"; // 기본 프로필 이미지 경로 설정

			messageContainer.appendChild(profileImg); // 프로필 이미지 추가
			messageContainer.appendChild(nickname); // 닉네임 추가
		}

		messageContainer.appendChild(content); // 메시지 내용 추가
		messageContainer.appendChild(time); // 시간 정보 추가

		document.getElementById("chatWindow").appendChild(messageContainer); // 채팅창에 메시지 추가
	}
</script>
</head>
<body onload="connect()">
	<!-- 페이지 로드 시 WebSocket 연결 -->
	<div id="chatWindow" style="height: 300px; overflow-y: scroll;"></div>
	<!-- 채팅 내용 표시 영역 -->
	<input type="text" id="message" style="width: 80%;">
	<!-- 메시지 입력창 -->
	<button onclick="sendMessage()">Send</button>
	<!-- 메시지 전송 버튼 -->
</body>
</html>
