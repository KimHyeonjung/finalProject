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
</script>
</html>
