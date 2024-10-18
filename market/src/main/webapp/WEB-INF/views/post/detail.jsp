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
.carousel-item img {
	height: 500px;
	object-fit: contain; /* 이미지 비율 유지하면서 컨테이너에 맞춤 */
}
.container-detail {
	width: 1050px;
	margin: 0 auto;
}
.carousel-item {
	text-align: center;
}
.article{
 	width: 800px;
	margin: 0 auto;
}
/* 전체 화면을 덮는 반투명 배경 */
.overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 10;
    display: none;
}
/* 신고 모달 스타일 */
.report-modal {
	margin: 10px auto;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 350px;
    padding: 20px;
    background: white;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    z-index: 20;
    text-align: center;
    display: none;
}
.list-group {margin-top: 20px;}
.list-group-item.list-group-item-action {
	cursor: pointer;
}
.btn-close {
	position: absolute; right: 10px; top: 5px;
	background: none;
    border: none;
    font-size: 35px;
    cursor: pointer;
}
.report-content-text {
	width: 100%;
	height: 80px;
	resize: none;
}
.report-content {text-align: right;}
</style>
</head>
<body>
	<div class="container-detail">
		<h1 class="hide">상세</h1>
		<section id="article-images">
			<h3 class="hide">이미지</h3>
			<div id="carousel-indicators" class="carousel slide">
				<!-- Indicators -->
				<ul class="carousel-indicators">
					<li data-target="#carousel-indicators" data-slide-to="0"
						class="active"></li>
					<li data-target="#carousel-indicators" data-slide-to="1"></li>
					<li data-target="#carousel-indicators" data-slide-to="2"></li>
					<li data-target="#carousel-indicators" data-slide-to="3"></li>
				</ul>

				<!-- The slideshow -->
				<div class="carousel-inner">
					<div class="carousel-item active">
						<img src="<c:url value="/resources/img/g1.webp"/>"
							alt="Los Angeles" width="800" height="500">
					</div>
					<div class="carousel-item">
						<img src="<c:url value="/resources/img/g2.webp"/>" alt="Chicago"
							width="800" height="500">
					</div>
					<div class="carousel-item">
						<img src="<c:url value="/resources/img/g3.webp"/>" alt="New York"
							width="800" height="500">
					</div>
					<div class="carousel-item">
						<img src="<c:url value="/resources/img/g4.webp"/>" alt="New York"
							width="800" height="500">
					</div>
				</div>

				<!-- Left and right controls -->
				<a class="carousel-control-prev" href="#carousel-indicators"
					data-slide="prev"> <i class="fas fa-chevron-left"
					style="font-size: 24px; color: black;"></i>
				</a> <a class="carousel-control-next" href="#carousel-indicators"
					data-slide="next"> <i class="fas fa-chevron-right"
					style="font-size: 24px; color: black;"></i>
				</a>
			</div>
		</section>
		<section id="article-profile" class="article">
			<h3 class="hide">프로필</h3>
			<div class="d-flex justify-content-between">
				<div style="display: flex;">
					<div id="article-profile-image">
						<img alt=${post.member_nick }
							src="<c:url value="/resources/img/none_profile_image.png"/>" />
					</div>
					<div id="article-profile-left">
						<div id="nickname">${post.member_nick }</div>
						<div id="region-name">${post.post_address }</div>
						<div id="report">신고하기</div>
					</div>
				</div>
				<div id="article-profile-right">
					<dl id="point-wrap">
						<dt>유저점수</dt>
						<dd class="text-color-04 ">
							${post.member_score } <span>점</span>
						</dd>
					</dl>
				</div>				
			</div>
		</section>
		<section id="article-description" class="article">
			<h5 property="schema:name" id="article-title"
				style="margin-top: 0px;">${post.post_title }</h5>
			<p id="article-category">
				${post.post_category_name }
				<time>
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
				</time>
			</p>
			<p property="schema:priceValidUntil" datatype="xsd:date"
				content="2026-10-07"></p>
			<p rel="schema:url" resource="https://www.daangn.com/844403235"></p>
			<p property="schema:priceCurrency" content="KRW"></p>
			<p id="article-price" property="schema:price" content="100000.0"
				style="font-size: 18px; font-weight: bold;">${post.post_price }</p>
			<div property="schema:description" id="article-detail">
				${post.post_content }</div>
			<p id="article-counts">관심 30 ∙ 채팅 85 ∙ 조회 ${post.post_view }</p>
		</section>
		<%-- <section class="article">
			<a class="btn btn-outline-dark">수정</a>
			<a href="<c:url value="/post/delete/${post.post_num }"/>" class="btn btn-outline-dark">삭제</a>
		</section> --%>
	</div>
	<div class="overlay" id="overlay"></div>
	<div class="report-modal" id="report-modal">
		<span class="btn-close" id="closeBtn">&times;</span>
		<h3>신고하기</h3>
		<div class="list-group">		
		</div>
	</div>
<script>
	$('#report').click(function(){
		
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/category"/>', 
			type : 'post',
			dataType : "json", 
			success : function (data){
				var list = data;
				var str = '';
				for(category of list){
					str += `<div class="list-group-item list-group-item-action"
							data-ca_num="\${category.report_category_num}">
							<span>\${category.report_category_name}</span>
							</div>
					`;
				}
				$('.list-group').html(str);
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
		$('#overlay').show();
		$('#report-modal').show();
	})
	
	$(document).ready(function () {
    const $overlay = $("#overlay");
    const $reportModal = $("#report-modal");
	   
	    // 닫기 버튼 클릭 시 모달을 닫기
	    $("#closeBtn").click(function () {
	        $overlay.hide();
	        $reportModal.hide();
	    });
	
	    // 오버레이 클릭 시 모달을 닫기
	    $overlay.click(function () {
	        $overlay.hide();
	        $reportModal.hide();
	    });
	});
	
	$(document).on('click','.list-group-item', function(){
		$('.report-content').remove();
		var ca_num = $(this).data('ca_num');
		var content = `
			<div class="report-content">
				<div>
					<textarea class="report-content-text" name="report_content"></textarea>
				</div>
				<div class="btn btn-dark report-btn" 
					data-ca_num="\${ca_num}" data-post_num="${post.post_num}">
					<span>신고</span>
				</div>
			</div>
			`;
		$(this).after(content);
    });
	$(document).on('click', '.report-btn', function(){
		let ca_num = $(this).data('ca_num');
		let post_num = $(this).data('post_num');
		let content = $('.report-content').find('[name=report_content]').val();
		let report = {
				report_category_num : ca_num,
				report_post_num : post_num,
				report_content : content
		}
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/post"/>', 
			type : 'post', 
			data : JSON.stringify(report), 
			contentType : "application/json; charset=utf-8",
			dataType : "json", 
			success : function (data){
				console.log(data);
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
	});
</script>
</body>
</html>
