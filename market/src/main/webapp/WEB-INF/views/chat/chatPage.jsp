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
</body>
</html>