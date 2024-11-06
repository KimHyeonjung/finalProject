<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
	<div class="wrapper">
        <h2>비밀번호 찾기</h2>
        <form action="<c:url value='/findPassword'/>" method="post">
            <div class="form-field">
                <input type="text" name="member_id" required placeholder="아이디">
            </div>
            <div class="form-field">
                <input type="text" name="member_nick" required placeholder="닉네임">
            </div>
            <div class="form-field">
                <input type="email" name="member_email" required placeholder="이메일">
            </div>
            <button type="submit" class="button-submit">비밀번호 찾기</button>
        </form>
    </div>
</div>
</body>
</html>