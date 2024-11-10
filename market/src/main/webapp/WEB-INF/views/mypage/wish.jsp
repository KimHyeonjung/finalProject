<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<title>찜목록</title>
<head>
</head>
<body>
	<div class="container-wish">				
		<h2>찜 목록 ${list.size()}</h2>
		<div class="d-flex justify-content-between">
			<ul class="nav">
				<li class="nav-item">
					<span class="nav-link">
						<input type="checkbox" class="select-all" id="select-all">
						<label for="select-all" style="cursor: pointer;">전체선택</label>						
					</span>
				</li>
				<li class="nav-item">
					<span class="nav-link" id="select-delete">선택삭제</span>
				</li>
			</ul>
			<ul class="nav">
				<li class="nav-item">
					<a class="nav-link" href="<c:url value="/mypage/wish/list/view"/>">인기순/</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value="/mypage/wish/list/date"/>">등록순/</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value="/mypage/wish/list/low"/>">저가순/</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value="/mypage/wish/list/hight"/>">고가순</a>
				</li>
			</ul>
		</div>
		<div class="container-product">		
			<c:forEach items="${list }" var="post"> 
				<div class="product">
		            <img class="product-click thumbnail" src="<c:url value="/resources/img/none_image.jpg"/>" 
		            	onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';"alt="none"
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
		            <input type="checkbox" class="select" name="products" value="${post.post_num}">	            
	            </div>
	    	</c:forEach>    
		</div>
	</div>
<script>
$(function(){
	// 썸네일 불러오기
	$('.thumbnail').each(function (){
		var post_num = $(this).data('post_num');
		var thumbnail = $(this);
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
	
	
	$('.product-click').click(function(){
		let post_num = $(this).data('post_num');
		location.href = `<c:url value="/post/detail/\${post_num}"/>`;
	});	
	
	//전체 선택
	$('#select-all').change(function(){
		$('.select').prop('checked', this.checked);
	});
	//개별 체크박스 상태가 변경될 때 전체 선택 체크박스 업데이트
	$('.select').change(function(){
		const allChecked = $('.select').length === $('.select:checked').length;
		$('#select-all').prop('checked', allChecked);
	})
	//선택 삭제
	$('#select-delete').click(function(){
		if(confirm('삭제하시겠습니까?')){
			// 선택된 체크박스들의 값을 배열로 수집
			let selectProducts = [];
			$('input[name=products]:checked').each(function(){
				selectProducts.push($(this).val());
			});
			$.ajax({
				async : false, //비동기 : true(비동기), false(동기)
				url : '<c:url value="/mypage/wish/delete"/>', 
				type : 'post', 
				data : JSON.stringify({post_nums : selectProducts}), 
				contentType : "application/json; charset=utf-8",
				success : function (data){
					console.log(data);				
				}, 
				error : function(jqXHR, textStatus, errorThrown){

				}
			});
			window.location.reload();
		}
	});
});
	
	
</script>
</body>
</html>