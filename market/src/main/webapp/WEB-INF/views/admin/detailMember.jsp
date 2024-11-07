<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div class="container">
	<h3 class="report-title mt-3">회원 신고 내역</h3>	
	<div>
		<span>${post.member_id }(${post.member_nick }) / </span><span>${post.post_date }</span>
	</div>			
	<hr>
	<div id="table-post">
		<table class="table table-hover">
	    	<colgroup>
		        <col style="width: 180px;">
		        <col style="width: 100px;">
		        <col style="width: 100px;">
		        <col style="width: 400px;">
		    </colgroup>
	    	<thead>
		      <tr>
		        <th>분류</th>
		        <th>신고일</th>
		        <th>신고자</th>
		        <th>내용</th>		           
		      </tr>
		    </thead>
		    <tbody>
		    	<c:forEach items="${list }" var="report">
			      <tr> 			        
			        <td>${report.report_category_name}</td>
			        <td>
			        	<fmt:formatDate value="${report.report_date}" pattern="yyyy-MM-dd"/>
			        </td>
			        <td>
			        	<div>${report.member_id}</div>
			        	<div style="font-weight: bold;">${report.member_nick}</div>
			        </td>
			        <td>${report.report_content}</td>
			      </tr>
		    	</c:forEach>
		    </tbody>
	  	</table>
	</div>
	
</div>
<script>
$(document).ready(function(){
	
});
</script>
</body>
</html>