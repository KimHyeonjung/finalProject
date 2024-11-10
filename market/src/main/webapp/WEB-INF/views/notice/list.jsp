<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
</head>
<body>
<div class="container-notice">
<div class="notice-container">
    <div class="notice-header">공지사항</div>
    
    <c:forEach var="notice" items="${pinnedNotices}">
	    <div class="notice-item pinned">
	        <div class="notice-title">
	            <a href="/market/notice/detail?notice_num=${notice.notice_num}">
	                <strong></strong> ${notice.notice_title}
	            </a>
	        </div>
	        <div class="notice-date">
	            <fmt:formatDate value="${notice.notice_date}" pattern="yyyy/MM/dd" />
	        </div>
	    </div>
	</c:forEach>
    
    <c:forEach var="notice" items="${regularNotices}">
	    <div class="notice-item">
	        <div class="notice-title">
	            <a href="/market/notice/detail?notice_num=${notice.notice_num}">
	                ${notice.notice_title}
	            </a>
	        </div>
	        <div class="notice-date">
	            <fmt:formatDate value="${notice.notice_date}" pattern="yyyy/MM/dd" />
	        </div>
	    </div>
	</c:forEach>
    <c:if test="${user != null && memberAuth == 'ADMIN'}">
	    <button class="insert-button notice-list" onclick="location.href='/market/notice/insert'">글쓰기</button>
	</c:if>
	
</div>
</div>
</body>
</html>
