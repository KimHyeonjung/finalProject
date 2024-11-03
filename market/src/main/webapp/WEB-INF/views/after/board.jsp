<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 게시판</title>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<style>
        .no-reviews {
            color: gray;         /* 글자 색상 회색 */
            font-weight: bold;   /* 글자 굵게 */
            text-align: center;  /* 가운데 정렬 */
            margin-top: 20px;    /* 위쪽 여백 */
        }
        
		/* 테이블 셀 텍스트 가운데 정렬 (강제 적용) */
        th, td {
            text-align: center !important;
        }
        /* 테이블 구분선 추가 */
        .w3-table-all, .w3-table-all th, .w3-table-all td {
            border: 1px solid #ddd;
            border-collapse: collapse;
        }
    </style>
</head>
<body>
<div class="w3-container">
    <h2>리뷰 게시판</h2>
    <hr>
    <c:choose>
        <c:when test="${empty reviews}">
            <p class="no-reviews">작성한 리뷰가 없습니다.</p> <!-- 스타일 적용된 메시지 -->
        </c:when>
        <c:otherwise>
            <table class="w3-table-all w3-hoverable">
                <thead>
                    <tr class="w3-light-grey">
                        <th>게시글 제목</th>
                        <th>내용</th>
                        <th>가격 별점</th>
                        <th>매너 별점</th>
                        <th>시간 및 배송 별점</th>
                        <th>작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="review" items="${reviews}">
                        <tr>
                            <td>${review.post_title}</td>
                            <td>${review.after_message}</td>
                            <td>${review.after_review1}</td>
                            <td>${review.after_review2}</td>
                            <td>${review.after_review3}</td>
                            <td>${review.after_date}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <hr>
    <br>
</div>
</body>
</html>
