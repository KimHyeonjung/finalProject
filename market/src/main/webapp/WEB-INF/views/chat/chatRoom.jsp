<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅방 목록</title>
</head>
<body>
    <h2>채팅방 목록</h2>
    <div class="chat-room-list">
        <c:forEach var="chatRoom" items="${chatRooms}">
            <div class="chat-room-box">
                <div class="profile-image" style="background-color: #ccc;"></div> <!-- 프로필 이미지 색칠된 동그라미 -->
                <div class="chat-room-info">
                    <strong>${chatRoom.getTargetMember().member_nick}</strong> <!-- 발신자 닉네임 -->
                    <p>${chatRoom.getLastChat().chat_content}</p> <!-- 가장 최근 채팅 내용 (추가 필요 시) -->
                    <span>${chatRoom.getChatRoom().chatRoom_date}</span> <!-- 마지막 채팅 시간 (추가 필요 시) -->
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>
