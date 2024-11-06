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
        <p class="message">
            <c:choose>
                <c:when test="${empty tempPassword}">
                    일치하는 회원 정보가 없습니다.
                </c:when>
                <c:otherwise>
                    임시 비밀번호가 발급되었습니다: <strong>${tempPassword}</strong>
                </c:otherwise>
            </c:choose>
        </p>
        <a href="<c:url value='/login'/>" class="back-button">로그인 페이지로 이동</a>
    </div>
</div>
</body>
</html>