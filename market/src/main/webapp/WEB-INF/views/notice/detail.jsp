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
    <style>
    	button {
		  margin: 5px;
		  outline: none;
		}
		.frame {
		  width: 90%;
		  margin: 40px auto;
		  text-align: center;
		  display: flex;
		  gap: 10px; /* 버튼 간격 조정 */
		  justify-content: center;
		}
    	.custom-btn {
		  width: 130px;
		  height: 40px;
		  padding: 10px 25px;
		  border: 2px solid #000;
		  font-family: 'Lato', sans-serif;
		  font-weight: 500;
		  background: transparent;
		  cursor: pointer;
		  transition: all 0.3s ease;
		  display: flex;
		  align-items: center;
		  justify-content: center;
		  text-align: center;
		}
		.btn-10 {
		  transition: all 0.3s ease;
		  overflow: hidden;
		  position: relative;
		}
		.btn-10:after {
		  position: absolute;
		  content: " ";
		  top: 0;
		  left: 0;
		  z-index: -1;
		  width: 100%;
		  height: 100%;
		  transition: all 0.3s ease;
		  -webkit-transform: scale(.1);
		  transform: scale(.1);
		}
		.btn-10:hover {
		  color: #fff;
		}
		.btn-10:hover:after {
		  background: #9395F0;
		  -webkit-transform: scale(1);
		  transform: scale(1);
		}
        .container {
            width: 80%;
            margin: 20px auto;
            font-family: Arial, sans-serif;
        }
        .title {
            font-size: 1.8em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .info {
            color: #777;
            font-size: 0.9em;
            margin-bottom: 20px;
        }
        .content {
            font-size: 1.2em;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<div class="container">
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
  
    <div style="margin-top: 20px;">
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
