<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://kit.fontawesome.com/c9d8812a57.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
<body>
<div class="container">
    <div class="header-top">
        <a class="navbar-brand" href="<c:url value="/" />">
            <img src="<c:url value="/resources/img/중고날아.svg"/>" alt="Logo" class="logo-img">
        </a>
        <form class="form-inline" action="/market/search" method="get">
            <select name="type">
                <option value="물건">물건</option>
                <option value="동네">동네</option>
            </select>
            <input class="form-control" type="text" name="query" placeholder="물건이나 동네를 검색해보세요">
            <button type="submit" id="search-button" onclick="performSearch()">
                <i class="fa fa-search"></i> 검색
            </button>
        </form>
        <a id="notice" href="/market/notice/list">
            <i class="fa-solid fa-megaphone"></i>
        </a>
        <button id="noti-btn" type="button" class="btn noti-btn">
            <i class="fa-solid fa-bell"></i>
        </button>
    </div>

    <div class="header-bottom">
        <div class="left-links">
            <button id="categoryButton" class="dropdown-btn">
                <svg stroke="currentColor" fill="currentColor" viewBox="0 0 20 20" class="text-xl" height="1em" width="1em">
                    <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"></path>
                </svg>
                카테고리
            </button>
        </div>
        
        <div class="right-links">
            <c:if test="${user == null}">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value="/signup"/>">회원가입</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value="/login"/>">로그인</a>
                </li>
            </c:if>
            <c:if test="${user != null}">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value="/chatRoom"/>">채팅</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value="/post/insert"/>">판매하기</a>
                </li>
                <c:if test="${user.member_auth eq 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value="/report/list"/>">신고 현황</a>
                    </li>
                </c:if>
                <li class="nav-item">
                    <div class="dropdown">
						<button id="profile-btn" type="button" class="profile-btn">
							<img src="<c:url value="/resources/img/none_profile_image.png"/>" alt="Profile" class="profile-img">
						</button>
						<div id="profile-dropdown" class="dropdown-content" style="display:none;">
							<div>
								<p>${user.member_nick}</p>
							</div>
							<div>
								<p>${user.member_score} M</p>
							</div>
							<div>
								<p><span id="balance">0</span>원</p>
								<a href="<c:url value='/wallet/list'/>">내역</a>
								<a href="<c:url value='/wallet/point'/>">충전</a>
							</div>
							<div class="account-section">
								<a href="<c:url value='/mypage'/>">
									<i class="fa-solid fa-user"></i>개인정보 변경
								</a>
							</div>
							<div class="account-section">
								<a href="<c:url value='/mypage/post/list'/>">
									<i class="fa-solid fa-note-sticky"></i>게시글 관리
								</a>
							</div>
							<div class="account-section">
								<a href="<c:url value='/mypage/wish/list'/>">
									<i class="fa-solid fa-heart"></i>찜목록
								</a>
							</div>
							<div class="account-section">
								<a href="<c:url value="/after/board"/>">
									<i class="fa-regular fa-pen-to-square"></i>내 리뷰
								</a>
							</div>
							<div>
								<a href="<c:url value='/logout'/>">로그아웃</a>
							</div>
						</div>
                    </div>
                </li>
            </c:if>
        </div>
    
        <div class="noti-modal" style="display:none;">
            <div class="list-group noti-list"></div>
        </div>
        
        <div id="categoryList" class="dropdown-content" style="display:none;">
            <c:forEach items="${categoryList}" var="category">
                <div>
                    <a href="${pageContext.request.contextPath}/post/list/${category.category_num}">${category.category_name}</a>
                </div>
            </c:forEach>
        </div>
        
    </div>
</div>
</body>
<script type="text/javascript">

var count = 0;
function notiCheck(){
	if(${user != null}){
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/notification/count"/>', 
			type : 'post', 
			success : function (data){	
				count = data;
				if(count != 0){
					$('#noti-btn').html('<i class="fa-solid fa-bell"></i> (' + count + ')');
				} else {
					$('#noti-btn').html('<i class="fa-solid fa-bell"></i> (' + count + ')');
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
				if(count > 0){
					$('.noti-list').html(str);
				}
			}
			
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
}

$(document).ready(function (){
	//updateHeader();  // 로그인 후 헤더를 업데이트
	notiCheck();
	
	$('#profile-dropdown').hide();
	
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

	$('#noti-btn').on('mouseenter', function() {
        if (${user != null}) {
            if (count == 0) {
                return;
            }
            notiListDisplay();
            // 알림 버튼의 위치값을 정확히 구함
            var position = $(this).offset();
            var height = $(this).outerHeight();
            
            // .noti-modal을 알림 버튼 바로 아래에 맞추어 위치 설정
            $('.noti-modal').css({
                position: 'fixed', // 화면 전체 기준으로 위치 설정
                top: position.top + height - $(window).scrollTop() + 'px', // 스크롤 위치를 고려하여 계산
                left: position.left + 'px' // 알림 버튼의 정확한 왼쪽 위치와 맞춤
            }).show();
        }
    });

    $('#noti-btn').on('mouseleave', function(e) {
        if (!$(e.relatedTarget).closest('.noti-modal').length) {
            $('.noti-modal').hide();
        }
    });

    $('.noti-modal').on('mouseenter', function() {
        $('.noti-modal').show();
    });

    $('.noti-modal').on('mouseleave', function() {
        $('.noti-modal').hide();
    });

    // 모달 외부 클릭 시 숨김 처리
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#noti-btn, .noti-modal').length) {
            $('.noti-modal').hide();
        }
    });
    $('#profile-btn').on('click', function (event) {
        $('#profile-dropdown').toggle();
        event.stopPropagation();
    });
    
    $(document).on('click', function (event) {
        if (!$(event.target).closest('#profile-dropdown, #profile-btn').length) {
            $('#profile-dropdown').hide();
        }
    });
    
    $('#categoryButton').on('click', function(event) {
        event.stopPropagation();
        $('#categoryList').toggleClass('show');
    });

    // 페이지 클릭 시 드롭다운 메뉴 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#categoryButton, #categoryList').length) {
            $('#categoryList').removeClass('show');
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
					$('.noti-modal').hide();
					return;
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

function performSearch() {
    var searchForm = document.getElementById("searchForm");
    searchForm.submit();
}



</script>
</html>