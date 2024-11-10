<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리 분류</title>
</head>
<body>

<div class="container">
    <h3 class="mt-3">${category_name}</h3>
    <div class="product-grid">
    	<c:forEach items="${list }" var="item"> 
    		<div class="product-item" data-post_num="${item.post.post_num}">
	            <img class="prouct-img" 
	            	src="<c:url value="/uploads/${item.file.file_name }"/>" 
	            	onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';" alt="${item.file.file_ori_name }">
	            <div class="name">${item.post.post_title }</div>
             	<div class="d-flex justify-content-between">
		            <div class="price">	            
		            	<fmt:formatNumber value="${item.post.post_price }" type="number"/>원
		            </div>
		            <div class="wish"><i class="fa-solid fa-heart"></i> ${item.post.post_wishcount }</div>
           		</div>
	            <c:choose>
	            	<c:when test="${item.post.post_timepassed > (24 * 7) }">	      
	            		<c:set var="timepassedWeek" value="${item.post.post_timepassed div (24 * 7) }"/>      	
	            		<div class="time">
	            			<fmt:formatNumber value=" ${timepassedWeek - (timepassedWeek mod 1)}" pattern="###"/>주 전
	            		</div>
	            	</c:when>
	            	<c:when test="${item.post.post_timepassed > 24 }">	      
	            		<c:set var="timepassedDay" value="${item.post.post_timepassed div 24 }"/>      	
	            		<div class="time">
	            			<fmt:formatNumber value=" ${timepassedDay - (timepassedDay mod 1)}" pattern="###"/>일 전
	            		</div>
	            	</c:when>
	            	<c:otherwise>
			            <div class="time"> ${item.post.post_timepassed }시간 전</div>
	            	</c:otherwise>
	            </c:choose>
	        </div>    		
    	</c:forEach>        
        <!-- 추가 상품 -->
    </div>
</div>
<script>
$(document).ready(function(){
	
	$('.product-item').click(function(){
		let post_num = $(this).data('post_num')
		location.href = `<c:url value="/post/detail/\${post_num}"/>`;	
	});
});

</script>
</body>
</html>