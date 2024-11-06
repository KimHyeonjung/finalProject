<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Chat Rooms</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
<script>
	// 채팅방 클릭 시 해당 채팅방으로 이동하는 함수
	function openChatRoom(chatRoomNum) {
		// 선택한 채팅방 번호를 URL 쿼리 파라미터로 전달
		window.location.href = "/market/chat?chatRoomNum=" + chatRoomNum;
	}
	var socket;

	window.onload = function() {
	    var isUserLoggedIn = <%= (session.getAttribute("user") != null) ? "true" : "false" %>;

	    if (isUserLoggedIn) {
	        // 웹소켓 연결
	        connectWebSocket();
	    }
	}

	function connectWebSocket() {
	    if (!socket || socket.readyState !== WebSocket.OPEN) {
	        socket = new WebSocket("ws://localhost:8080/market/chat");

	        socket.onopen = function() {
	            console.log("WebSocket connection established.");
	        };

	        socket.onmessage = function(event) {
	            console.log("Message received:", event.data);
	        };

	        socket.onclose = function() {
	            console.log("WebSocket connection closed.");
	        };
	    }
	}
	
	function leaveChatRoom(chatRoomNum) {
        // 서버로 채팅방 나가기 요청을 보냄
        fetch(`/market/chat/leave?chatRoomNum=\${chatRoomNum}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                alert("채팅방을 나갔습니다.");
                // 채팅방 목록을 새로 고침하거나 페이지를 리로드할 수 있음
                location.reload();
            } else {
                alert("채팅방 나가기에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error("오류:", error);
        });
    }
</script>
</head>
<body>
<div class="container">
	<div id="chatRoomList">
		<!-- 채팅방 목록을 반복하여 표시 -->
		<c:forEach var="chatRoom" items="${chatRooms}">
			<div class="chat-room"
				onclick="openChatRoom('${chatRoom.getChatRoom().chatRoom_num}')">
				<!-- 클릭 시 해당 채팅방으로 이동 -->
				<img src="/market/resources/img/none_profile_image.png"
					alt="Profile" class="profile-img">
				<!-- 프로필 이미지 -->
				<div class="chat-room-info">
					<span class="nickname">${chatRoom.getTargetMember().member_nick}</span>
					<!-- 상대방 닉네임 -->
					<span class="last-message">${chatRoom.getChat().chat_content}</span>
					<!-- 마지막 메시지 내용 -->
				</div>
				<span class="last-time">${chatRoom.getChat().chat_date}</span>
				<!-- 마지막 메시지 시간 -->
			</div>
			<button onclick="leaveChatRoom('${chatRoom.getChatRoom().chatRoom_num}')">채팅방 나가기</button>
		</c:forEach>
	</div>
</div>
</body>
</html>
