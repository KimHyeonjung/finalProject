<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<title>찜목록</title>
<head>
<!-- 폰트어썸 -->
<script src="https://kit.fontawesome.com/c9d8812a57.js"
	crossorigin="anonymous"></script>
<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
}

.container-product {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    max-width: 1200px;
    margin: 20px auto;
}

.product {
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    display: flex;
    padding: 10px;
    position: relative;
    cursor: pointer;
}

.product img {
    width: 150px;
    height: 150px;
    object-fit: cover;
    margin-right: 15px;
    border-radius: 8px;
}

.product-info {
    flex: 1;
    margin-right: 50px;
}

.product-info h2 {
    font-size: 18px;
    margin-bottom: 5px;    
}

.product-info .price {
    font-weight: bold;
    margin-bottom: 5px;
}

.product-info .time, .product-info .location {
    font-size: 14px;
    color: gray;
}

.select {
	width: 40px; height: 40px;
    position: absolute;
    top: 10px;
    right: 10px;
}
.location {
	position: absolute;
	bottom: -5px;
}

</style>
</head>
<body>
	<div class="container">		
		<h2>찜 목록</h2>
		<div class="container-product">		
			<c:forEach items="${list }" var="post"> 
				<div class="product">
		            <img class="product-click" src="https://via.placeholder.com/150" alt="뉴에라 스카잔"
		            	 data-post_num="${post.post_num}">
		            <div class="product-info product-click" data-post_num="${post.post_num}">		            	
		                <h2>${post.post_title }</h2> 
		                <p class="price"><fmt:formatNumber value="${post.post_price }" type="number"/>원</p>
		                <p class="time">
							<c:choose>
				            	<c:when test="${post.post_timepassed > 24 }">	      
				            		<c:set var="timepassed" value="${post.post_timepassed div 24 }"/>      	
				            			<fmt:formatNumber value="${timepassed - (timepassed mod 1)}" pattern="###"/>일 전
				            	</c:when>
				            	<c:otherwise>
						            ${post.post_timepassed }시간 전
				            	</c:otherwise>
				            </c:choose>
						</p>
						<hr class="mt-5">
		                <p class="location">
		                	<c:choose>
		                		<c:when test="${post.post_address eq null}">
		                			위치 없음
		                		</c:when>
		                		<c:otherwise>
				                	${post.post_address}
		                		</c:otherwise>
		                	</c:choose>
		                </p>
		            </div>	
		            <input type="checkbox" class="select">	            
	            </div>
		              		    		
	    	</c:forEach>    
		</div>
	</div>
<script>
	$('.product-click').click(function(){
		let post_num = $(this).data('post_num');
		location.href = `<c:url value="/post/detail/\${post_num}"/>`;
	});
</script>
</body>
</html>
