<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>공지사항 상세보기</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
</head>
<body>
<div class="container-notice">
    <h1 class="title">${notice.notice_title}</h1>
    <div class="info">
         <fmt:formatDate value="${notice.notice_date}" pattern="yyyy/MM/dd" />
    </div>
    <div class="content">
        <c:out value="${notice.notice_content}" escapeXml="false" />
    </div>
    <div class="frame">
		<c:if test="${user != null && user.member_auth == 'ADMIN'}">
	        <button onclick="location.href='/market/notice/update?notice_num=${notice.notice_num}'" class="custom-btn btn-10">Edit</button>
	        <button onclick="deleteNotice(${notice.notice_num})" class="custom-btn btn-10">Delete</button>
	        
			<form id="pinForm" action="<c:url value='/market/notice/pin' />" method="post">
			    <input type="hidden" name="notice_num" value="${notice.notice_num}">
			    <input type="hidden" name="notice_pin" value="false">
			    <label>
			        <input type="checkbox" id="pin-checkbox" name="notice_pin" value="true"
			               <c:if test="${notice.notice_pin}">checked</c:if> 
			               onchange="pin(${notice.notice_num})"> 고정
			    </label>
			</form>
	        
	    </c:if>
    </div>
  
    <div style="margin-top: 10px;">
        <a href="/market/notice/list" class="btn btn-secondary">목록으로</a>
    </div>
    
</div>
<script>
function deleteNotice(noticeNum) {
    if (confirm("삭제 할까말까할까말까할까말까할까말까?")) {
        
        const form = document.createElement("form");
        form.method = "post";
        form.action = "/market/notice/delete";
        
        const hiddenField = document.createElement("input");
        hiddenField.type = "hidden";
        hiddenField.name = "notice_num";
        hiddenField.value = noticeNum;
        
        form.appendChild(hiddenField);
        document.body.appendChild(form);
        form.submit();
    }
}
function pin(noticeNum) {
    try {
        const isPinned = document.getElementById("pin-checkbox").checked;

        const form = document.createElement("form");
        form.method = "post";
        form.action = "/market/notice/pin";

        const hiddenField = document.createElement("input");
        hiddenField.type = "hidden";
        hiddenField.name = "notice_num";
        hiddenField.value = noticeNum;

        const pinField = document.createElement("input");
        pinField.type = "hidden";
        pinField.name = "notice_pin";
        pinField.value = isPinned ? "true" : "false";

        form.appendChild(hiddenField);
        form.appendChild(pinField);
        document.body.appendChild(form);

        form.submit();
    } catch (error) {
        console.error("Error in pin function:", error);
    }
}
</script>
</body>
</html>
