<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .chat-room {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #e0e0e0;
            cursor: pointer;
        }
        .chat-room:hover {
            background-color: #f5f5f5;
        }
        .profile-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .chat-details {
            flex-grow: 1;
        }
        .nickname {
            font-weight: bold;
        }
        .last-message {
            color: #888;
            font-size: 14px;
        }
        .timestamp {
            font-size: 12px;
            color: #aaa;
        }
    </style>
</head>
<body>

    <div class="container mt-4">
        <h2>채팅방 목록</h2>
        <div class="chat-rooms">
            <c:forEach var="chatRoom" items="${chatRooms}">
                <div class="chat-room" onclick="location.href='<c:url value='/chat/${chatRoom.chatRoom_num}' />'">
                    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .chat-room {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #e0e0e0;
            cursor: pointer;
        }
        .chat-room:hover {
            background-color: #f5f5f5;
        }
        .profile-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .chat-details {
            flex-grow: 1;
        }
        .nickname {
            font-weight: bold;
        }
        .last-message {
            color: #888;
            font-size: 14px;
        }
        .timestamp {
            font-size: 12px;
            color: #aaa;
        }
    </style>
</head>
<body>

    <div class="container mt-4">
        <h2>채팅방 목록</h2>
        <div class="chat-rooms">
            <c:forEach var="chatRoom" items="${chatRooms}">
                <div class="chat-room" onclick="location.href='<c:url value='/chat/${chatRoom.chatRoom_num}' />'">
                    <img class="profile-img" src="<c:out value='${chatRoom.profileImage}' />" alt="Profile Image">
                    <div class="chat-details">
                        <div class="nickname"><c:out value='${chatRoom.member_nick}' /></div>
                        <div class="last-message"><c:out value='${chatRoom.lastMessage}' /></div>
                    </div>
                    <div class="timestamp"><c:out value='${chatRoom.chatRoom_date}' /></div>
                </div>
            </c:forEach>
        </div>
    </div>
    
</body>
</html>