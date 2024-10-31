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
        
        .dropdown-content {
		  display: none;
		  position: absolute;
		  background-color: white;
		  min-width: 160px;
		  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
		  z-index: 1;
		}
		
		.dropdown-content a {
		  color: black;
		  padding: 12px 16px;
		  text-decoration: none;
		  display: block;
		}
		
		.dropdown-content a:hover {
		  background-color: #f1f1f1;
		}
		
		.dropdown-btn {
		  background-color: #343a40;
		  color: white;
		  padding: 10px;
		  width: 160px;
		  font-size: 16px;
		  border: none;
		  cursor: pointer;
		  display: flex;            
		  align-items: center;      
		  justify-content: center;
		}
		
		.dropdown-btn:hover {
		  background-color: #3d444b;
		}
		.dropdown-btn svg {
		  margin-right: 8px; 
		  vertical-align: middle; 
		}
    </style>
</head>
<body>

<button id="categoryButton" class="dropdown-btn">
	<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 20 20" class="text-xl" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
    	<path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"></path>
    </svg>
    카테고리
</button>
	
<div id="categoryList" class="dropdown-content" style="display:none;">
    <c:forEach items="${categoryList}" var="category">
    	<div>
        	<a href="${pageContext.request.contextPath}/post/list/${category.category_num}">${category.category_name}</a>
        </div>
    </c:forEach>
</div>


<div class="container">
    <h3 class="mt-3">오늘의 상품 추천</h3>
    <div class="product-grid">
    	<c:forEach items="${list }" var="post">    		
    		<div class="product-item" data-post_num="${post.post_num}">
	            <img class="prouct-img" 
	            	src="https://t4.ftcdn.net/jpg/02/51/95/53/360_F_251955356_FAQH0U1y1TZw3ZcdPGybwUkH90a3VAhb.jpg" 
	            	onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';" alt="상품 이미지">
	            <div class="name">${post.post_title }</div>
             	<div class="d-flex justify-content-between">
		            <div class="price">	            
		            	<fmt:formatNumber value="${post.post_price }" type="number"/>원
		            </div>
		            <div class="wish"><i class="fa-solid fa-heart"></i> ${post.post_wishcount }</div>
           		</div>
	            <c:choose>
	            	<c:when test="${post.post_timepassed > (24 * 7) }">	      
	            		<c:set var="timepassedWeek" value="${post.post_timepassed div (24 * 7) }"/>      	
	            		<div class="time">
	            			<fmt:formatNumber value=" ${timepassedWeek - (timepassedWeek mod 1)}" pattern="###"/>주 전
	            		</div>
	            	</c:when>
	            	<c:when test="${post.post_timepassed > 24 }">	      
	            		<c:set var="timepassedDay" value="${post.post_timepassed div 24 }"/>      	
	            		<div class="time">
	            			<fmt:formatNumber value=" ${timepassedDay - (timepassedDay mod 1)}" pattern="###"/>일 전
	            		</div>
	            	</c:when>
	            	<c:otherwise>
			            <div class="time"> ${post.post_timepassed }시간 전</div>
	            	</c:otherwise>
	            </c:choose>
	        </div>    		
    	</c:forEach>        
        <!-- 추가 상품 -->
    </div>
</div>
<script>
$(document).ready(function(){
	// 썸네일 불러오기
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