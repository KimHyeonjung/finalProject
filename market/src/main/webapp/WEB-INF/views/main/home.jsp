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
    <title>home</title>
    <style>
    	* a,a:hover {
    		text-decoration: none;
    		color: inherit;
    	}
        .product-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr); /* 5개의 열 */
            gap: 20px;
            padding: 20px;
        }
        .product-item {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
            cursor: pointer;
        }
        .product-item img {
            width: 100%;
            height: auto;
            object-fit: cover;
        }
        .product-item .name {
            font-weight: bold;
            margin-top: 10px;
        }
        .product-item .price {
            color: #e74c3c;
            font-size: 18px;
            margin-top: 5px;
        }
        .product-item .time {
            color: #7f8c8d;
            font-size: 14px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h3>오늘의 상품 추천</h3>
    <div class="product-grid">
    	<c:forEach items="${list }" var="post">    		
    		<div class="product-item" data-post_num="${post.post_num}">
	            <img src="https://t4.ftcdn.net/jpg/02/51/95/53/360_F_251955356_FAQH0U1y1TZw3ZcdPGybwUkH90a3VAhb.jpg" alt="상품 이미지">
	            <div class="name">${post.post_title }</div>
	            <div class="price">	            
	            	<fmt:formatNumber value="${post.post_price }" type="number"/>원
	            </div>
	            <c:choose>
	            	<c:when test="${post.post_timepassed > 24 }">	      
	            		<c:set var="timepassed" value="${post.post_timepassed div 24 }"/>      	
	            		<div class="time">
	            			<fmt:formatNumber value="${timepassed - (timepassed mod 1)}" pattern="###"/>일 전
	            		</div>
	            	</c:when>
	            	<c:otherwise>
			            <div class="time">${post.post_timepassed }시간 전</div>
	            	</c:otherwise>
	            </c:choose>
	        </div>    		
    	</c:forEach>
        <div class="product-item">
            <img src="https://via.placeholder.com/150" alt="상품 이미지">
            <div class="name">비투비 이창섭 씨어터플러스 화보</div>
            <div class="price">10,000 원</div>
            <div class="time">16시간 전</div>
        </div>
        <div class="product-item">
            <img src="https://via.placeholder.com/150" alt="상품 이미지">
            <div class="name">라코스테 클러치백</div>
            <div class="price">79,000 원</div>
            <div class="time">9시간 전</div>
        </div>
        <div class="product-item">
            <img src="https://via.placeholder.com/150" alt="상품 이미지">
            <div class="name">벨킨 2in1 무선충전기</div>
            <div class="price">40,000 원</div>
            <div class="time">6일 전</div>
        </div>
        <div class="product-item">
            <img src="https://via.placeholder.com/150" alt="상품 이미지">
            <div class="name">데님앤서플라이 밀리터리 파카</div>
            <div class="price">140,000 원</div>
            <div class="time">16시간 전</div>
        </div>
        <div class="product-item">
            <img src="https://via.placeholder.com/150" alt="상품 이미지">
            <div class="name">맨유 23/24 FA컵 어센틱 져지</div>
            <div class="price">175,000 원</div>
            <div class="time">22시간 전</div>
        </div>
        <!-- 추가 상품 -->
    </div>
</div>
<script>
	$('.product-item').click(function(){
		let post_num = $(this).data('post_num')
		location.href = `<c:url value="/post/detail/\${post_num}"/>`;	
	});
</script>
</body>
</html>
