<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div class="container">
    <div class="wrapper">
        <h2 class="mb-3">아이디 찾기</h2>
        <form action="<c:url value='/findId'/>" method="post">
            <div class="form-field">
                <input type="text" id="nickname" name="member_nick" required placeholder="닉네임">
            </div>
            <div class="form-field">
                <input type="email" id="email" name="member_email" required placeholder="이메일">
            </div>
            <button type="submit" class="button-submit">아이디 찾기</button>
        </form>
    </div>
</div>
</body>
</html>