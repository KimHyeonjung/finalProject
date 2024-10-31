<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>    
<html>
<head>
	<meta charset="UTF-8">
	<!-- 폰트어썸 -->
	<script src="https://kit.fontawesome.com/c9d8812a57.js"	crossorigin="anonymous"></script>
<style type="text/css">
	.close:hover {color: red;}
	.list-group-item.list-group-item-action {
		padding: 4px 10px;
	}	
	.list-group.noti-list {
		margin-top: 0;
	}
	.noti-modal {
            position: absolute;
            width: auto;
            padding: 10px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            display: none;
            z-index: 1001;
        }
</style>
</head>
<body>
	<nav class="navbar navbar-expand-md bg-dark navbar-dark">
		<a class="navbar-brand" href="<c:url value="/"/>">
			<img src="<c:url value="/resources/img/logo.PNG"/>" alt="Logo" style="width:40px;">
		</a>
		<form class="form-inline" action="/action_page.php">
			<select>
				<option>물건</option>
				<option>동네</option>
			</select>
			<input class="form-control mr-sm-2" type="text" placeholder="물건이나 동네를 검색해보세요">
		</form>
		
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
			
		</button>
		
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
				<c:if test="${user == null}">
				    <li class="nav-item">
						<a class="nav-link" href="<c:url value="/signup"/>">회원가입</a>
				    </li>
				    <li class="nav-item">
						<a class="nav-link" href="<c:url value="/login"/>">로그인</a>
				    </li>
			    </c:if> 
			    <%-- <c:if test="${user != null}">  --%>
			    	<li class="nav-item">
						<a class="nav-link" href="<c:url value="/chatRoom"/>">채팅</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/post/insert"/>">판매하기</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/logout"/>">로그아웃</a>
					</li>
					<%-- <c:if test="${user.member_auth eq 'ADMIN'}"> --%>
						<li class="nav-item">
							<a class="nav-link" href="<c:url value="/report/list"/>">신고 현황</a>
						</li>
					<%-- </c:if> --%>
					<li class="nav-item">
						<div class="dropdown">
							<button data-toggle="collapse" data-target="#demo">
								<img src="<c:url value="/resources/img/none_profile_image.png"/>" alt="Logo" style="width:40px;">	
							</button>
						</div>
					</li>
					<li class="nav-item">
						<span class="nav-link" id="profile_nick">[${user.member_nick}]</span>
					</li>
					<li>
						<!-- Button to Open the Modal -->
						<button id="noti-btn" type="button" class="btn btn-dark">
						  <i class="fa-solid fa-bell"></i>알림
						</button>
					</li>
			    <%-- </c:if> --%>
			</ul>
		</div>  
	</nav>

	<div id="demo" class="collapse" style="position: relative; bottom: 10%; left: 80%; background-color: grey;">
	
		<div>
			<p>${user.member_nick}</p>
			<a href="<c:url value="/mypage"/>">개인정보 변경</a>
			<p>온도</p>
		</div>
		<div>
			<p><span id="balance">0</span>원</p>
			<a href="<c:url value="/wallet/list"/>">내역</a>
			<a href="<c:url value="/wallet/point"/>">충전</a>
		</div>
		<div>
			<a href="<c:url value="/mypage/post/list"/>">게시글 관리</a>
			<a href="<c:url value="/mypage/wish/list"/>">찜목록</a>
		</div>
		<div>
			<a href="#">주소록</a>
			<a href="#">거래 내역</a>
		</div>
		<a href="<c:url value="/logout"/>">로그아웃</a>
	</div>
	
	
	<div class="noti-modal">
		<div class="list-group noti-list">
			
		</div>
	</div>
</body>
<script type="text/javascript">

var count = 0;
function notiCheck(){
	if(${user != null}){
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/notification/count"/>', 
			type : 'post', 
			success : function (data){	
				count = data;
				if(count != 0){
					$('#noti-btn').html('<i style="color: yellow;" class="fa-solid fa-bell"></i>알림(' + count + ')');
				} else {
					$('#noti-btn').html('<i class="fa-solid fa-bell"></i>알림(' + count + ')');
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	}
}
function notiListDisplay(){
	$.ajax({
		async : false, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/notification/list"/>', 
		type : 'post', 
		success : function (data){	
			var list = data.list;
			console.log(list);
			var str = '';
			notiCheck();				
			if(count != 0) {
				for(item of list){
					var fileName
					if(item.file != null){
						fileName = item.file.file_name;
						fileOriName = item.file.file_ori_name;
						str += `
							<img src="<c:url value="/uploads/\${fileName}"/>" 
							onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';"
							width="70" height="70" alt="\${fileOriName}"/>
						`;
					} else {
						str += `
							<img src="<c:url value="/resources/img/none_image.jpg"/>" 
							onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';"
							width="70" height="70" alt="none"/>
						`;
					}
					str += `<div class="list-group-item list-group-item-action d-flex justify-content-between">
							<a href=`;
					if (item.notification.notification_type_num == 1) {
						str += `'<c:url value="/post/detail/\${item.notification.notification_post_num}"/>'`;
					} else if (item.notification.notification_type_num == 4) {
						str += `'<c:url value="/chat?chatRoomNum=\${item.notification.notification_chatRoom_num}"/>'`;
					}
					
					str += `>
						\${item.notification.notification_message}	
						</a>
						<button type="button" class="close checked"
							data-num="\${item.notification.notification_num}"
						><i class="fa-solid fa-check"></i></button>
					</div>
					`;
				}
				$('.noti-list').html(str);
			}
			
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
}

$(document).ready(function (){
	updateHeader();  // 로그인 후 헤더를 업데이트
	notiCheck();

    $('#noti-btn').on('mouseenter', function(){
    	if(${user != null}){
    		if(count == 0){
    			return;
    		}
	    	notiListDisplay();
	        // 클릭한 요소의 위치값을 구함
	        var position = $(this).offset();
	        var height = $(this).outerHeight();
	        var width = $(this).outerWidth();
	        var modalWidth = $('.noti-modal').outerWidth();
			
	        // 모달을 클릭한 버튼 바로 아래에 위치시키고 보여줌
	        $('.noti-modal').css({
	            top: position.top + height,
	            left: position.left - ((modalWidth - width) / 2)
	        }).show();
    	}
    });

    $('#noti-btn').on('mouseleave', function(e) {
    	if (!$(e.relatedTarget).closest('.noti-modal').length) {
   	    	$('.noti-modal').hide();
        }
    	
    });
    $('.noti-modal').on('mouseenter', function(){
    	$('.noti-modal').show();
    });
    $('.noti-modal').on('mouseleave', function(){
    	$('.noti-modal').hide();
    });
    
    // 모달 닫기 예시: 모달 외부 클릭시 숨김 처리
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#noti-btn, .noti-modal').length) {
        	$('.noti-modal').hide();
        }
    });
});
$(document).on('click', '.close.checked', function(){
	var notification_num = $(this).data('num');
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/notification/checked"/>', 
		type : 'post', 
		data : {notification_num : notification_num},
		success : function (data){
			if(data){
				
				notiListDisplay();
				if(count == 0){
					$('#notiListModal').modal("hide");
				}
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
});

function updateHeader() {
    $.ajax({
        url: '/market/wallet/balance', // 잔액을 가져오는 API 엔드포인트
        type: 'GET',
        success: function(response) {
            console.log("Total Money from server: " + response.totalMoney); // 서버 응답 확인
            $('#balance').text(response.totalMoney); // 헤더에서 잔액을 표시하는 요소의 ID 사용
        },
        error: function(error) {
            console.error("헤더 업데이트 중 오류 발생:", error);
        }
    });
}

</script>
</html>