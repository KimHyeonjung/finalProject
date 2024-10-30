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
    <style>
        .notice-container {
            width: 80%;
            margin: 0 auto;
            font-family: Arial, sans-serif;
        }
        .notice-header {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #ddd;
            padding-bottom: 10px;
        }
        .notice-item {
            padding: 15px 0;
            border-bottom: 1px solid #ddd;
        }
        .notice-title {
            font-weight: bold;
            color: #333;
            text-decoration: none;
            font-size: 1.1em;
        }
        .notice-title a {
            text-decoration: none;
            color: inherit;
        }
        .notice-title a:hover {
            text-decoration: underline;
        }
        .notice-date {
            color: #888;
            font-size: 0.9em;
            margin-top: 5px; /* 제목과 날짜 사이의 여백 */
        }
        .notice-item.pinned {
		    background-color: #f9f9f9;
		    border-left: 5px solid #ff9800;
		}
		.notice-title strong {
		    color: #ff9800;
		}
    </style>
</head>
<body>
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
	    <button class="insert-button" onclick="location.href='/market/notice/insert'">글쓰기</button>
	</c:if>
	
</div>
</body>
</html>
