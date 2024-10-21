<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>채팅방 목록</title>
</head>
<body>
	<h2>채팅방 목록</h2>
	<div class="chat-room-list">
		<c:forEach var="chatRoom" items="${chatRooms}">
			<!-- 클릭 시 해당 chatRoom_num을 넘겨서 채팅창으로 이동 -->
			<a href="<c:url value='/chat?chatRoomNum=${chatRoom.getChatRoom().chatRoom_num}' />">
				<div class="profile-image" style="background-color: #ccc;"></div> <!-- 프로필 이미지 -->
				<div class="chat-room-info">
					<strong>${chatRoom.getTargetMember().member_nick}</strong>
					<!-- 발신자 닉네임 -->
					<p>${chatRoom.getChat().chat_content}</p>
					<!-- 가장 최근 채팅 내용 -->
					<span>${chatRoom.getChatRoom().chatRoom_date}</span>
					<!-- 마지막 채팅 시간 -->
				</div>
			</a>
		</c:forEach>
	</div>
</body>
</html>
