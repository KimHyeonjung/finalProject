<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Chat Rooms</title>
<script>
	// 채팅방 클릭 시 해당 채팅방으로 이동하는 함수
	function openChatRoom(chatRoomNum) {
		// 선택한 채팅방 번호를 URL 쿼리 파라미터로 전달
		window.location.href = "/market/chatPage?chatRoomNum=" + chatRoomNum;
	}
</script>
</head>
<body>
	<!-- 로그인한 사용자 ID 표시 -->
	<h2>${member.member_nick}</h2>
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
		</c:forEach>
	</div>
</body>
</html>
