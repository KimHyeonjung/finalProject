<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>채팅 페이지</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/chatPageStyle.css">
</head>
<body>
    <div class="chat-container">
        <!-- 왼쪽: 채팅방 리스트 -->
        <div class="chat-rooms">
            <jsp:include page="chatRoom.jsp" />
        </div>

        <!-- 오른쪽: 채팅창 -->
        <div class="chat-window">
            <jsp:include page="chat.jsp" />
        </div>
    </div>
    <script type="text/javascript">
    var socket = null;

    function connect() {
        socket = new WebSocket("ws://localhost:8080/market/ws/chat");

        socket.onopen = function() {
            console.log("WebSocket 연결 성공");
        };

        // 메시지가 오면 처리
        socket.onmessage = function(event) {
            var messageData = JSON.parse(event.data);
            updateChatWindow(messageData);
            updateChatRoomList(messageData);
        };

        socket.onclose = function() {
            console.log("WebSocket 연결 종료");
        };
    }

    // 채팅창에 메시지 업데이트
    function updateChatWindow(messageData) {
        if (messageData.chatRoomId == currentChatRoomId) {
            document.getElementById("chatLog").innerHTML += messageData.content + "<br>";
        }
    }

    // 채팅방 목록에 최신 메시지 업데이트
    function updateChatRoomList(messageData) {
        var chatRoomElement = document.getElementById("chatRoom_" + messageData.chatRoomId);
        if (chatRoomElement) {
            chatRoomElement.querySelector(".lastMessage").innerHTML = messageData.content;
            chatRoomElement.querySelector(".lastTime").innerHTML = messageData.time;
        }
    }

    window.onload = connect;
</script>
</body>
</html>