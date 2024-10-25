<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>home</title>
    <script src="https://kit.fontawesome.com/c9d8812a57.js"
	crossorigin="anonymous"></script>
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
            text-align: left;
            cursor: pointer;
            padding: 0 0;
        }
        .product-item img {
            width: 100%;
            height: auto;
            object-fit: cover;
        }
        .product-item .name {
            color: #7f8c8d;
            font-size: 14px;
            margin-top: 10px;
            margin-left: 10px;
        }
        .product-item .price {
            color: #1B1B1B;
            font-weight: bold;
            font-size: 16px;
            margin-top: 10px;
            margin-left: 10px;
        }
        .product-item .time, .wish {
            color: #7f8c8d;
            font-size: 11px;
            margin-top: 10px;
            margin-right: 10px;
            text-align: right;
        }
        .product-item .time { margin-top: 0px; margin-bottom: 10px; }
    </style>
</head>
<body>

    <div class="container">
        <h3>${category.category_name}</h3>
        <div class="product-grid">
            <c:forEach items="${postList}" var="post">    		
                <div class="product-item" data-post_num="${post.post_num}">
                    <img class="product-img" src="https://t4.ftcdn.net/jpg/02/51/95/53/360_F_251955356_FAQH0U1y1TZw3ZcdPGybwUkH90a3VAhb.jpg" alt="상품 이미지">
                    <div class="name">${post.post_title}</div>
                    <div class="d-flex justify-content-between">
                        <div class="price">
                            <fmt:formatNumber value="${post.post_price}" type="number"/>원
                        </div>
                        <div class="wish"><i class="fa-solid fa-heart"></i> ${post.post_wishcount}</div>
                    </div>
                    <c:choose>
                        <c:when test="${post.post_timepassed > (24 * 7)}">
                            <c:set var="timepassedWeek" value="${post.post_timepassed div (24 * 7)}"/>
                            <div class="time">
                                <fmt:formatNumber value="${timepassedWeek - (timepassedWeek mod 1)}" pattern="###"/>주 전
                            </div>
                        </c:when>
                        <c:when test="${post.post_timepassed > 24}">
                            <c:set var="timepassedDay" value="${post.post_timepassed div 24}"/>
                            <div class="time">
                                <fmt:formatNumber value="${timepassedDay - (timepassedDay mod 1)}" pattern="###"/>일 전
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="time">${post.post_timepassed}시간 전</div>
                        </c:otherwise>
                    </c:choose>
                </div>    		
            </c:forEach>
        </div>
    </div>
    
    <c:if test="${postList.size() == 0}">
        <p>해당 카테고리에 게시글이 없습니다.</p>
    </c:if>
</body>
<script>
$(document).ready(function(){
	$('.product-item').each(function (){
		var post_num = $(this).data('post_num');
		var thumbnail = $(this).children().first();
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/mypage/post/thumbnail"/>', 
			type : 'post', 
			data : {post_num : post_num}, 
			success : function (data){			
				if(data.file_name != null){
					var str = `<c:url value="/uploads/\${data.file_name}"/>`;
					$(thumbnail).attr('src', str);
					$(thumbnail).attr('alt', data.file_ori_name);
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
	});
	$('.product-item').click(function(){
		let post_num = $(this).data('post_num')
		location.href = `<c:url value="/post/detail/\${post_num}"/>`;	
	});
});
</script>
</html>
