<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<!-- 폰트어썸 -->
<script src="https://kit.fontawesome.com/c9d8812a57.js"
	crossorigin="anonymous"></script>
<style>

</style>
</head>
<body>
	<div class="container">
		<h2>게시글 신고 </h2>
		<table class="table table-hover">
	    	<thead>
		      <tr>
		        <th>제목</th>
		        <th>날짜</th>
		        <th>작성자</th>
		        <th>게시글 신고 횟수</th>        
		      </tr>
		    </thead>
		    <tbody>
		    	<c:forEach items="${postList }" var="post">
			      <tr>
			        <td>${post.post_title}</td>
			        <td>${post.post_date}</td>
			        <td>${post.member_id}(${post.member_nick})</td>
			        <td>${post.post_report}</td>
			      </tr>
		    	</c:forEach>
		    </tbody>
	  	</table>
		<h2>유저 신고 </h2>
		<table class="table table-hover">
	    	<thead>
		      <tr>
		        <th>신고받은 회원</th>
		        <th>회원 상태</th>
		        <th>회원 점수</th>
		        <th>신고 횟수</th> 
		      </tr>
		    </thead>
		    <tbody>
		    	<c:forEach items="${userList }" var="user">
			      <tr>
			        <td>${user.member_id}(${user.member_nick})</td>
			        <td>${user.member_state}</td>
			        <td>${user.member_score}</td>
			        <td>${user.member_report}</td>
			      </tr>
		    	</c:forEach>
		    </tbody>
	  	</table>
	</div>
<script>
	
</script>
</body>
</html>