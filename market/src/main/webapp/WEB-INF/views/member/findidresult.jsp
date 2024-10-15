<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
    <style>
   
    </style>
</head>
<body>
	<div class="wrapper">
        <div class="result-box">
            <c:choose>
                <c:when test="${empty findId}">
                    <p class="inquiry">조회 결과가 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <p>찾은 아이디: ${findId.member_id}</p>
                </c:otherwise>
            </c:choose>
        </div>
        <a href="<c:url value='/findId'/>" class="back-button">다시 찾기</a>
    </div>
</body>
</html>
