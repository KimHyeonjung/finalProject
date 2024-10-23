<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Website</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <header>
        <tiles:insertAttribute name="header" />
    </header>

    <main>
        <tiles:insertAttribute name="content" />
    </main>

    <footer>
        <tiles:insertAttribute name="footer" />
    </footer>
<script type="text/javascript">
var userId = `${user.member_id}`; // 예시로 현재 로그인한 사용자의 ID

// WebSocket 연결 설정
var socket = new WebSocket('ws://localhost:8080/notifications');

// WebSocket이 열렸을 때 사용자 정보를 서버로 전송
socket.onopen = function(event) {
    console.log("WebSocket 연결 성공");
    // 서버로 사용자 ID를 전송 (필요에 따라 JSON 형식으로 보낼 수도 있음)
    socket.send(JSON.stringify({ userId: userId }));
};

// 서버에서 메시지를 받았을 때 실행
socket.onmessage = function(event) {
    var message = event.data;
    alert("알림: " + message); // 알림을 표시
};

// WebSocket이 닫혔을 때 처리
socket.onclose = function(event) {
    console.log("WebSocket 연결 종료");
};

// WebSocket 오류 발생 시 처리
socket.onerror = function(error) {
    console.log("WebSocket 오류 발생: ", error);
};
</script>
</body>
</html>