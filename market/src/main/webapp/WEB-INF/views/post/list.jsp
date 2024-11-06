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

<button id="categoryButton" class="dropdown-btn">
	<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 20 20" class="text-xl" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
    	<path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"></path>
    </svg>
    카테고리
</button>
	
<div id="categoryList" class="dropdown-content" style="display:none;">
</div>
</div>

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
	$('#categoryButton').mouseenter(function() {
		var contextPath = '${pageContext.request.contextPath}';
	    $.ajax({
	    	url: contextPath + '/category',
	        type: 'GET',
	        dataType: 'json', 
	        success: function(data) {
	            
	            var html = '';
	            $.each(data, function(index, category) {
	            	html += '<div><a href="' + contextPath +'/post/list/' + category.category_num + '">' + category.category_name + '</a></div>';
	            });
	            
	            $('#categoryList').html(html);  // 생성된 HTML을 카테고리 목록에 삽입
	            $('#categoryList').toggle();  // 목록을 보여주거나 숨김
	        },
	        error: function(xhr, status, error) {
	            console.error("Error: " + error);
	        }
	    });
	});
	$('#categoryList').mouseenter(function() {
		$('#categoryList').show();  // 마우스가 목록에 있을 때 유지
	});
	
	// 카테고리 버튼 또는 목록에서 마우스를 벗어나면 목록이 사라짐
	$('#categoryButton, #categoryList').mouseleave(function() {
	    $('#categoryList').hide();  // 마우스를 벗어나면 목록이 사라짐
	});
});

</script>
</body>
</html>