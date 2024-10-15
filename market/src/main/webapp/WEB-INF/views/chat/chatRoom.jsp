<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>채팅방 목록</title>
<%-- <link rel="stylesheet" href="<c:url value='/resources/css/chatRoomStyle.css' />"> --%> <!-- CSS 파일 연결 -->
</head>
<body>
	<%-- <h2>채팅방 목록</h2>
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
	</div> --%>
	<div class="chat-room-container">
        <h2>${member.member_nick}</h2> <!-- 세션에서 멤버 닉네임 가져오기 -->
        <div class="chat-room-list">
            <c:forEach var="chatRoom" items="${chatRooms}">
                <div class="chat-room" onclick="goToChatRoom(${chatRoom.getChatRoom().chatRoom_num})"> <!-- 클릭 시 채팅창으로 이동 -->
                    <div class="chat-room-image">
                        <%-- <img src="${chatRoom.profileImageUrl}" alt="${chatRoom.charRoom_post_name}"> --%>
                    </div>
                    <div class="chat-room-details">
                        <div class="chat-room-title">
                            ${chatRoom.getTargetMember().member_nick} <!-- 채팅방 제목 -->
                        </div>
                        <div class="chat-room-message">
                            ${chatRoom.getChat().chat_content} <!-- 최신 메시지 -->
                        </div>
                        <div class="chat-room-time">
                            ${chatRoom.getChat().chat_date} <!-- 마지막 메시지 시간 -->
                        </div>
                        <div class="chat-room-unread">
                            <%-- <span>${chatRoom.unreadCount}</span> --%> <!-- 읽지 않은 메시지 수 -->
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
<script>
        // 클릭 시 채팅방으로 이동하는 함수
        function goToChatRoom(chatRoomNum) {
            location.href = '/chatRoom/' + chatRoomNum; // 채팅방 번호를 URL에 추가하여 이동
        }
    </script>
</html>
