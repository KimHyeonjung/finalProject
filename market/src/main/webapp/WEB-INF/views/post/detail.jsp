<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
.carousel-item img {
	height: 500px;
	object-fit: contain; /* 이미지 비율 유지하면서 컨테이너에 맞춤 */
}
.container-detail {
	width: 900px;
	margin: 0 auto;
}
.carousel-item {
	text-align: center;
}
.article{
 	width: 700px;
	margin: 0 auto;
}
#article-profile-image img {
	width: 80px; height: 80px;
	border-radius: 40px;
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
.click {
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
			<div id="carousel-indicators" class="carousel slide" data-ride="false">
				<!-- Indicators -->
				<ul class="carousel-indicators"> 
					<c:if test="${fileList.size() != 0 }">
						<c:forEach begin="0" end="${fileList.size() - 1}" var="i" varStatus="status">
							<li data-target="#carousel-indicators" data-slide-to="${i}"
								class="<c:if test="${status.first}">active</c:if>"></li>
						</c:forEach>
					</c:if>
					<c:if test="${fileList.size() == 0 }">
						<li data-target="#carousel-indicators" data-slide-to="0"
								class="active"></li>
					</c:if>
				</ul>
				<!-- The slideshow -->
				<div class="carousel-inner">
						<c:if test="${fileList.size() != 0 }">
							<c:forEach items="${fileList}" var="file" varStatus="status">
								<div class="carousel-item <c:if test="${status.first}">active</c:if>"> 
									<img src="<c:url value="/uploads/${file.file_name}"/>"
										onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';"
										alt="${file.file_ori_name}" width="700" height="500"> 
								</div>
							</c:forEach>
						</c:if>
					<c:if test="${fileList.size() == 0 }">
						<div class="carousel-item active"> 
							<img src="<c:url value="/resources/img/none_image.jpg"/>"
								alt="none" width="700" height="500"> 
						</div>
					</c:if>
				</div>
				<!-- Left and right controls -->
				<a class="carousel-control-prev" href="#carousel-indicators"
					data-slide="prev"> <i class="fas fa-chevron-left"
					style="font-size: 24px; color: black;"></i>
				</a> 
				<a class="carousel-control-next" href="#carousel-indicators"
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
						<c:if test="${profile != null}">
							<img alt="${profile.file_ori_name}"
								src="<c:url value="/uploads/${profile.file_name}"/>" />
						</c:if>
						<c:if test="${profile == null}">
							<img alt="none"
								src="<c:url value="/resources/img/none_profile_image.png"/>" />
						</c:if>
					</div>
					<div id="article-profile-left">
						<div id="nickname">${post.member_nick }</div>
						<div id="region-name">${post.post_address }</div>
						<div id="btn-group">
							<c:choose>
								<c:when test="${user ne null}">
									<c:if test="${user.member_num ne post.post_member_num }">
										<div class="btn btn-outline-success <c:if test="${wish.wish_member_num == user.member_num}">active</c:if>" 
											id="wish" data-post_num="${post.post_num}">찜하기</div>
										<div class="btn btn-outline-danger <c:if test="${report.report_member_num == user.member_num}">active</c:if>" 
											id="report" data-post_num="${post.post_num}">신고하기</div>
										<div class="btn btn-warning" id="chat" data-post_num="${post.post_num}">채팅</div>
										<div class="dropdown dropright">
										    <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
												흥정하기
										    </button>
										    <div class="dropdown-menu" style="padding: 4px;">
										      <span class="dropdown-item discount" data-price="1000">
										      	<fmt:formatNumber value="-1000" type="number"/><span>원</span></span>
										      <span class="dropdown-item discount" data-price="5000">
										      	<fmt:formatNumber value="-5000" type="number"/><span>원</span></span>
										      <span class="dropdown-item discount" data-price="10000">
										     	 <fmt:formatNumber value="-10000" type="number"/><span>원</span></span>
										      <div class="dropdown-divider"></div>
										      <span class="dropdown-item" style="padding: 4px 5px;">										      	
										      	<input type="text" value="${post.post_price }"
										      		id="input-discount" style="width: 120px; margin-right: 5px;">
										      	<button type="button" class="btn btn-outline-dark" id="propose">제안</button>
										      </span>
										    </div>
										</div>
									</c:if>
									<c:if test="${user.member_num eq post.post_member_num }">
										<div>
											<a class="btn btn-outline-info" href="<c:url value="/mypage/post/list"/>">내 상점 관리</a>
										</div>
									</c:if>
								</c:when>								
								<c:otherwise>
									<div class="btn btn-dark" 
										id="wish">찜하기</div>
									<div class="btn btn-dark" 
										id="report">신고하기</div>
									<div class="btn btn-dark" 
										id="chat">채팅</div>
								</c:otherwise>
							</c:choose>
						</div>
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
			<h5 id="article-title"
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
			
			<p id="article-price" style="font-size: 18px; font-weight: bold;">
				${post.post_price }</p>
			<div id="article-detail">
				${post.post_content }</div>
			<p id="article-counts">
				관심 ${post.post_wishcount} ∙ 채팅 85 ∙ 조회 ${post.post_view}</p>
		</section>
	</div>
	<div class="overlay" id="overlay"></div>
	<div class="report-modal" id="report-modal">
		<span class="btn-close" id="closeBtn">&times;</span>
		<h3>신고하기</h3>
		<div class="list-group">		
		</div>
	</div>
<script>
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
	    $('#test-btn').click(function(){
	    	var userId = 'qweqwe';
	    	var message = '테스트메세지야';
	    	$.ajax({
				async : true, //비동기 : true(비동기), false(동기)
				url : '<c:url value="/notification/notify-user"/>', 
				type : 'post',
				data : {userId : userId, message : message},
				success : function (data){
					console.log(data);
				}, 
				error : function(jqXHR, textStatus, errorThrown){
				}
			});
	    });
	});
	//로그인 상태 체크
	function checkLogin(){
		return '${user.member_id}' != '';
	}
	function alertLogin(){
		if(checkLogin()){
			return false;
		}
		if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?')){
			location.href="<c:url value="/login"/>";
		}
		return true;
	}
	//신고하기 클릭
	var res = false;
	$(document).on('click','#report',function(){
		if(alertLogin()){
			return;
		}
		let post_num = $(this).data('post_num');
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/category"/>', 
			type : 'post',
			data : {post_num : post_num},
			dataType : "json", 
			success : function (data){
				res = data.res;
				if(res){
					alert('이미 신고한 게시글입니다.');
					return;
				}
				var list = data.list;
				var str = '';
				for(category of list){
					str += `<div class="list-group-item list-group-item-action click"
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
		if(res){
			return;
		}
		$('#overlay').show();
		$('#report-modal').show();
	})
	
	//신고항목 클릭
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
	//신고버튼 클릭
	$(document).on('click', '.report-btn', function(){		
		if(confirm('정말 신고합니까?')){			
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
				success : function (data){
					if(data == 1){
						alert('신고 완료');
						$('#report').addClass('active');
					}
					else if(data == 2){
						alert('이미 신고한 게시글입니다.');
					}else {
						alert('신고 실패');
					}					
				}, 
				error : function(jqXHR, textStatus, errorThrown){
				}
			});
		$("#overlay").hide();
	    $("#report-modal").hide();
		}
	});
	//찜하기 클릭
	$(document).on('click', '#wish', function(){	
		if(alertLogin()){
			return;
		}
		let post_num = $(this).data("post_num");
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/post/wish"/>', 
			type : 'post', 
			data : {post_num : post_num}, 
			success : function (data){	
				if(data){
					$('#wish').addClass('active');
				}else{
					$('#wish').removeClass('active');
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	});
	// 드롭다운 클릭 시 닫히지 않도록 기본 동작 취소
    $(document).on('click', '.dropdown-menu', function (e) {
      e.stopPropagation(); // 클릭 이벤트 전파 막기
    });
	// 흥정하기
	$(document).on('click', '.discount', function (){
		let discount = +$('#input-discount').val() - +$(this).data('price');
		//var formattedDc = discount.toLocaleString();
		if(discount < 0 ){
			discount = 0;
		}
		$('#input-discount').val(discount);
	});
	$(document).on('click', '#input-discount', function (){
		if($(this).val() == 0){
			$('#input-discount').val('');
		}
	});
	// 제안
	$(document).on('click', '#propose', function () {
		let proposePrice = +$('#input-discount').val();
		let post_num = +${post.post_num};
		let member_num = +${post.post_member_num};
		let obj = {
				post_num : post_num,
				member_num : member_num,
				proposePrice : proposePrice
		}
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/post/propose"/>', 
			type : 'post', 
			data : JSON.stringify(obj), 
			contentType : "application/json; charSet=utf-8",
			success : function (data){	
				if(data){
					$('.dropdown-toggle').click();
					/* location.href = `<c:url value="/채팅룸"/>`; */
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){				
				console.log(jqXHR);
			}
		});	
		alert(1);
	});
	
</script>
</body>
</html>