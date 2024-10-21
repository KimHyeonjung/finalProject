<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.team3.market.model.vo.MemberVO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
// 세션에서 'user'라는 이름으로 저장된 MemberVO 객체 가져오기
MemberVO user = (MemberVO) session.getAttribute("user");
%>
<html>
<head>
<title>Home</title>
</head>
<body>
	<h1>Hello world!</h1>

	<P>The time on the server is ${serverTime}.</P>
</body>
<script>
	var socket;
	var isUserLoggedIn = <%= (user != null) ? "true" : "false" %>;
	console.log(isUserLoggedIn);
	window.onload = function() {
		// 세션에 사용자 정보가 있는지 확인
		if (isUserLoggedIn) {
			console.log("로그인한 사용자 세션이 존재합니다.");

			// 웹소켓 연결
			socket = new WebSocket("ws://localhost:8080/market/chat");

			socket.onopen = function() {
				console.log("WebSocket connection established.");
			};

		} else {
			console.log("로그인하지 않은 사용자입니다.");
		}
	};
</script>
</html>
