<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=55f22ec08aea99a6511585b99e78d0d6&libraries=services"></script>
<style>
.carousel-item img {
	height: 500px;
	object-fit: cover; /* 이미지 비율 유지하면서 컨테이너에 맞춤 */
}
.container-detail {
	position: relative;
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
/* 화면 전체를 덮는 흐림 효과 */
.blind {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5); /* 어두운 흐림 효과 */
    backdrop-filter: blur(5px); /* 흐리게 처리 */
    display: none; /* 기본적으로 숨김 처리 */
    z-index: 9999;
    justify-content: center;
    align-items: center;
}
/* 중앙 텍스트 스타일 */
.blind-text {
    color: white;
    font-size: 2em;
    text-align: center;
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
	height: 160px;
	resize: none;
}
.report-content {text-align: right;}
.map_wrap {position:relative;width:100%;height:350px;}
.title {font-weight:bold;display:block;}
.hAddr {position:absolute;left:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
#centerAddr {display:block;margin-top:2px;font-weight: normal;}
.bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
</style>
</head>
<body>
	<div class="container-detail">
		<h1 class="hide">상세</h1>
		<section id="article-images">
			<h3 class="hide">이미지</h3>
			<div id="carousel-indicators" class="carousel slide" data-interval="false">
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
										alt="${file.file_ori_name}" width="500" height="500"> 
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
										<div class="btn btn-warning" id="chat" data-post_num="${post.post_num}">채팅방</div>
										<c:if test="${post.post_deal eq true }">
											<div class="dropdown dropright">
											    <button type="button" data-toggle="dropdown" id="dropdown-btn"
											    	class="btn btn-outline-primary dropdown-toggle <c:if test="${haggle}">active</c:if>" >
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
									</c:if>
									<c:if test="${user.member_num eq post.post_member_num }">
										<div>
											<select class="state" data-post_num="${post.post_num}">
												<c:choose>
							                    	<c:when test="${post.post_position_num == 1}">
							                    		<option value="1" <c:if test="${post.post_position_num == 1}">selected</c:if>>판매중</option>
								                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
								                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
							                    	</c:when>
							                    	<c:when test="${post.post_position_num == 2}">
								                        <option value="2" <c:if test="${post.post_position_num == 2}">selected</c:if>>구매중</option>
								                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
								                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
							                    	</c:when>
							                    	<c:when test="${post.post_position_num == 3}">
								                        <option value="3" <c:if test="${post.post_position_num == 3}">selected</c:if>>무료나눔</option>
								                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
								                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
							                    	</c:when>
							                    	<c:otherwise>
							                    		<option value="1" <c:if test="${post.post_position_num == 1}">selected</c:if>>판매중</option>
							                    		<option value="2" <c:if test="${post.post_position_num == 2}">selected</c:if>>구매중</option>
							                    		<option value="3" <c:if test="${post.post_position_num == 3}">selected</c:if>>무료나눔</option>
								                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
								                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
							                    	</c:otherwise>
												</c:choose>
						                    </select>
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
										id="chat">채팅신청</div>
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
			<!-- 지도 및 주소 입력 -->
			<input type="hidden" value="${post.post_way_num }" id="post_way_num">
			<div id="mapContainer">
			    <div class="map_wrap">
			        <div id="map" style="display:block;width:100%;height:100%;position:relative;overflow:hidden;"></div>
			        <div class="hAddr">
			            <span class="title">지도중심기준 행정동 주소정보</span>
			            <span id="centerAddr"></span>
			        </div>
			    </div>
			    <input type="text" id="post_address" name="post_address" value="${post.post_address }"
			    	placeholder="여기에 주소가 표시됩니다" style="width:100%; margin-top:10px; padding:5px;" readonly>
			</div>
		</section>
		<!-- 블라인드 처리 -->
		<div class="blind" id="blind">
			<div class="blind-text">신고 누적으로 블라인드 처리된 게시물입니다.</div>
		</div>
	</div>
	<!-- modal -->
	<div class="overlay" id="overlay"></div>
	<div class="report-modal" id="report-modal">
		<span class="btn-close" id="closeBtn">&times;</span>
		<h3>신고하기</h3>
		<div class="list-group">		
		</div>
	</div>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = {
    center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 기본 중심좌표 (서울)
    level: 1 // 지도의 확대 레벨
};  

//지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

//주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

//HTML5의 Geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
	navigator.geolocation.getCurrentPosition(function(position) {
		const address = document.getElementById("post_address").value;
		const mapContainerDiv = document.getElementById('mapContainer');
		let post_way_num = document.getElementById('post_way_num').value;
		if(post_way_num == 1){
			mapContainerDiv.style.display = 'none';
		}else {
			if(address != ''){
		    	// 입력한 주소로 좌표 변환 요청
		   		geocoder.addressSearch(address, function(result, status) {
		        	if (status === kakao.maps.services.Status.OK) {
		                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		                var content = '<div class="bAddr">' +
					                    '<span class="title">직거래 위치</span><br>' + 
					                    address + 
					                '</div>';
		
		                // 지도에 마커 생성
		                marker.setPosition(coords);
					    marker.setMap(map);
		
		                // 해당 좌표로 지도 중심 이동
		                map.setCenter(coords);
					
					    // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
					    infowindow.setContent(content);
					    infowindow.open(map, marker);
		            } else {
		                alert("주소를 찾을 수 없습니다.");
		            }
		        }); 	
			}       
		}
	});
} else { 
var locPosition = new kakao.maps.LatLng(37.566826, 126.9786567), // 기본 좌표 (서울)
    message = '<div class="bAddr">Geolocation을 사용할 수 없습니다.</div>'; 
displayMarker(locPosition, message, "");
}

//지도 타입 전환 버튼 생성
var mapTypeControl = new kakao.maps.MapTypeControl();
map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

//지도 확대/축소 버튼 생성
var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

//주소 검색 함수
function searchDetailAddrFromCoords(coords, callback) {
// 좌표로 법정동 상세 주소 정보를 요청합니다
geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}
$(document).ready(function(){
	
});
</script>		
<script>
$(document).ready(function () {
	const $overlay = $("#overlay");
	const $reportModal = $("#report-modal");
	//신고 횟수 초과시 블라인드
	let post_report = ${post.post_report};
	if(post_report > 3){
		document.getElementById("blind").style.display = "flex";
	}
	
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
		url : '<c:url value="/report/category/post"/>', 
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
//$(document).on('click', '#dropdown-btn', function (){
$('#dropdown-btn').click(function(e){
	let haggle = ${haggle};
	if(haggle){
		alert('이미 흥정한 상품입니다.');
		e.stopPropagation();
	}
});
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
				alert('판매자에게 가격제안을 보냈습니다.');
				$('.dropdown-toggle').addClass('active');
				/* location.href = `<c:url value="/채팅룸"/>`; */
			} else {
				alert('더 이상 흥정을 할 수 없습니다.');
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){				
			console.log(jqXHR);
		}
	});	
});
	//채팅신청
	$(document).on('click', '#chat', function() {
		if (alertLogin()) {
			return;
		}

		let post_num = +${post.post_num};
		let member_num = +${post.post_member_num};
		let obj = {
				post_num : post_num,
				member_num : member_num,
		}

		$.ajax({
			async: true,
			url: '<c:url value="/post/chat"/>',  // 채팅 요청 URL
			type: 'post',
			data: JSON.stringify(obj),  // JSON 형태로 데이터 전달
			contentType: "application/json; charSet=utf-8",
			success: function (data) {
				console.log(data);
				if (data.success) {
					// 채팅방 생성 또는 존재 -> 해당 채팅창으로 이동
					console.log(${data.chatRoomNum});
					location.href = `<c:url value="/chat"/>?chatRoomNum=\${data.chatRoomNum}`;
				} else {
					alert("채팅 신청에 실패했습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR);
			}
		});
	});
	
// 거래 상태 변경
$(document).on('change','.state', function(){
	var state = $(this).val();
	var post_num = $(this).data('post_num');
	$(this).find('option').show();
	console.log(state);
	if(state == '1'){
		$(this).find('option[value="2"]').hide();
		$(this).find('option[value="3"]').hide();
	}
	if(state == '2'){
		$(this).find('option[value="1"]').hide();
		$(this).find('option[value="3"]').hide();
	}
	if(state == '3'){
		$(this).find('option[value="1"]').hide();
		$(this).find('option[value="2"]').hide();
	}
	$(this).find('option[value="' + state + '"]').hide();
	let obj = {
			post_num : post_num,
			post_position_num : state
	}
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/mypage/post/state"/>', 
		type : 'post', 
		data : JSON.stringify(obj), 
		contentType : "application/json; charset=utf-8",
		success : function (data){
		}, 
		error : function(jqXHR, textStatus, errorThrown){
		}
	});
});
</script>
</body>
</html>