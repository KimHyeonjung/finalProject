<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅 화면</title>
</head>
<body>
    <h2>채팅방</h2>
    <div>
        <c:forEach var="chatMessage" items="${chatMessages}">
            <c:if test="${chatMessage.chat_member_num == sessionScope.user.member_num}">
                <div>
                    ${chatMessage.chat_content} [${chatMessage.chat_read}] - ${chatMessage.chat_date}
                </div>
            </c:if>
            <c:if test="${chatMessage.chat_member_num != sessionScope.user.member_num}">
                <div>
                    <strong>${chatMessage.member_nick}</strong>: ${chatMessage.chat_content} 
                    [${chatMessage.chat_read}] - ${chatMessage.chat_date}
                </div>
            </c:if>
        </c:forEach>
    </div>
    <form action="/sendMessage" method="post">
        <input type="hidden" name="chat_chatRoom_num" value="${param.chatRoomNum}" />
        <input type="text" name="chat_content" placeholder="메시지를 입력하세요" required />
        <button type="submit">전송</button>
    </form>
</body>
</html>