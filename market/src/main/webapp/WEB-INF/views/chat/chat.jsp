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
</head>
<body>
	<!-- 게시물 정보 표시 영역 -->
	<div class="post-info" 
	     style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; background-color: #f9f9f9; cursor: pointer;" 
	     onclick="window.location.href='<c:url value='/post/detail/${post.post_num}' />'">
		<!-- 게시물 프로필 이미지 (썸네일) -->
		<%-- <img src="${post.post_thumbnail}" alt="게시물 이미지" style="width: 100px; height: 100px; object-fit: cover; margin-right: 15px; display: inline-block;"> --%>
		
		<!-- 게시물 제목 및 가격 -->
		<div style="display: inline-block; vertical-align: top;">
			<h3>${post.post_title}</h3> <!-- 게시물 제목 -->
			<p><strong>가격:</strong> ${post.post_price}원</p> <!-- 게시물 가격 -->
		</div>
	</div>
	
	<!-- 채팅 내용 표시 영역 -->
	<div id="chat-history">
		<c:forEach var="chatDTO" items="${chatDTOs}">
			<div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
				<strong>${chatDTO.getTargetMember().member_nick}</strong>: 
				<span>${chatDTO.getChat().chat_content}</span>
				<p style="font-size: small;">[${chatDTO.getChat().chat_date}]</p>
			</div>
		</c:forEach>
	</div>
	<!-- 메시지 입력창 -->
	<input type="text" id="message" placeholder="메시지를 입력하세요." style="width: 80%;" onkeypress="checkEnter(event)">
    <!-- 메시지 전송 버튼 -->
	<button onclick="sendMessage()">Send</button>
	
	<form action="${pageContext.request.contextPath}/sendMoney" method="post">
		<input type="hidden" name="chatRoomNum" value="${chatRoomNum}"/>
		<input type="number" name="amount" placeholder="송금할 금액" required />
		<button type="submit" class="send-money-button">송금</button>
	</form>

  
	<script>
		//let websocket = new WebSocket("http://localhost:8080/market/chat/echo.do?chatRoomNum=${chatRoomNum}&member_nick=${member.member_nick}");
		let websocket = new WebSocket("http://localhost:8080/market/ws/notify?chatRoomNum=${chatRoomNum}&member_nick=${member.member_nick}");
		websocket.onopen = function(evt) {
			console.log("open websocket");
			//websocket.send(JSON.stringify({ type: "join", chatRoomNum: ${chatRoomNum} }));
			onOpen(evt)
		};
		websocket.onmessage = function(evt) {
			onMessage(evt)
		};
		websocket.onerror = function(evt) {
			onError(evt)
		};

		// WebSocket 연결
		function onOpen(evt) {
			writeToScreen("WebSocket 연결!");
			doSend($("#message").val());
		}
		
		// 메시지 수신
		function onMessage(evt) {
			writeToScreen("메시지 수신 : " + evt.data);
			
			//location.reload(true);
			
			$("#chat-history").load(window.location.href + " #chat-history");
			
			 // 새로운 메시지를 수신할 때마다 채팅 내역을 갱신
		    //refreshChatHistory();
			
			/* const message = JSON.parse(evt.data); // 서버로부터 받은 데이터를 JSON으로 파싱
	        const chatArea = document.querySelector(".chat-history");
	        
	        // 상대방이 보낸 메시지를 화면에 출력
	        const messageElement = document.createElement("div");
	        messageElement.classList.add("message-container", "their-message");

	        messageElement.innerHTML = `
	        	<div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
				<strong>\${message.member_nick}</strong>: 
				<span>\${message.chatVO.chat_content}</span>
				<p style="font-size: small;">[\${message.chatVO.chat_date}]</p>
			</div>
	        `;
			console.log(chatArea);
	        chatArea.appendChild(messageElement);
	        chatArea.scrollTop = chatArea.scrollHeight; */
		}
		
		// 에러 발생
		function onError(evt) {
			writeToScreen("에러 : " + evt.data);
		}

		function doSend(message) {
			writeToScreen("메시지 송신 : " + message);
			websocket.send(message);
		}

		function writeToScreen(message) {
			$("#outputDiv").append("<p>" + message + "</p>");
		}

		function sendMessage() {
			const content = document.getElementById("message").value;
			if (content === "") {
                return;
            }
			
			const message = {
				//type : "chat",			
				chat_member_num : '${member.member_num}', // 세션 또는 전역 변수에서 사용자 ID 가져옴
				chat_chatRoom_num : '${chatRoomNum}',
				chat_content : content,
			};
			// WebSocket을 통해 메시지 전송
		    websocket.send(JSON.stringify(message));

		    // 메시지 입력 필드 초기화
		    document.getElementById("message").value = '';
		    
			//알림
			let member_num = ${member.member_num};
			let chatRoom_num = ${chatRoomNum};
			let obj = {
					member_num : member_num,
					chatRoom_num : chatRoom_num,
					content : content
			}
			console.log(obj)
			$.ajax({
				async : true, //비동기 : true(비동기), false(동기)
				url : '<c:url value="/chat/notification"/>', 
				type : 'post', 
				data : JSON.stringify(obj), 
				contentType : "application/json; charSet=utf-8",
				success : function (data){	
					if(data){
						console.log("채팅 알람 전송");
					}
				}, 
				error : function(jqXHR, textStatus, errorThrown){
					console.log(jqXHR);
				}
			});	
		}
		
		function refreshChatHistory() {
            $.ajax({
                url: '/market/chat/loadChatHistory',
                type: 'GET',
                data: {
                    chatRoomNum: '${chatRoomNum}' // 현재 채팅방 번호 전송
                },
                success: function(response) {
                    // 채팅 기록 부분만 업데이트
                    $('#chat-history').html(response);
                },
                error: function(error) {
                    console.log("채팅 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }
		
		function checkEnter(event) {
            if (event.keyCode === 13) { // Enter 키가 눌렸을 때
                event.preventDefault(); // 기본 동작 방지
                sendMessage(); // 메시지 전송
            }
        }
		/* 
		function checkEnter(event) {
            if (event.key === "Enter") { // Enter 키가 눌렸을 때
                event.preventDefault(); // 기본 동작 방지
                sendMessage(); // 메시지 전송
            }
        }
		 */
	    window.onload = function() {
			// 에러 메시지가 존재하는지 확인
			var errorMessage = "<c:out value='${errorMessage}' />";
			if (errorMessage) {
				alert(errorMessage);
			}
	
			// 성공 메시지가 존재하는지 확인
			var successMessage = "<c:out value='${successMessage}' />";
			if (successMessage) {
				alert(successMessage);
			
			}
		};
	</script>
</body>
</html>