<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:choose>
	<c:when test="${user ne null}">
		<div class="btn btn-<c:if test="${wish.wish_member_num != user.member_num}">outline-</c:if>success" 
			id="wish" data-post_num="${post_num}">찜하기</div>
		<div class="btn btn-<c:if test="${report.report_member_num != user.member_num}">outline-</c:if>danger" 
			id="report" data-post_num="${post_num}">신고하기</div>
	</c:when>
	<c:otherwise>
		<div class="btn btn-dark" 
			id="wish">찜하기</div>
		<div class="btn btn-dark" 
			id="report">신고하기</div>
	</c:otherwise>
</c:choose>

