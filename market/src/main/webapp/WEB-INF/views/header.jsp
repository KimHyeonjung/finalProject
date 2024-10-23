<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>    
<html>
<head>
	<meta charset="UTF-8">
<style type="text/css">
	.close:hover {color: red;}
	.list-group-item.list-group-item-action {
		padding: 4px 10px;
	}
	.modal-header, .modal-body {
		padding: 4px 10px;
	}
	.list-group.noti-list {
		margin-top: 0;
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
				<%-- <c:if test="${user == null}"> --%>
				    <li class="nav-item">
						<a class="nav-link" href="<c:url value="/signup"/>">회원가입</a>
				    </li>
				    <li class="nav-item">
						<a class="nav-link" href="<c:url value="/login"/>">로그인</a>
				    </li>
			    <%-- </c:if> --%>
			    <%-- <c:if test="${user != null}"> --%>
			    	<li class="nav-item">
						<a class="nav-link" href="<c:url value="/chatRoom"/>">채팅</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/post/insert"/>">판매하기</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/logout"/>">로그아웃</a>
					</li>
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
						<button id="noti-btn" type="button" class="btn btn-dark" data-toggle="modal" data-target="#notiList">
						  <i class="fa-regular fa-bell"></i>알림
						</button>
					</li>
			    <%-- </c:if> --%>
			</ul>
		</div>  
	</nav>

	<div id="demo" class="collapse" style="position: relative; bottom: 10%; left: 80%; background-color: grey;">
	
		<div>
			<p>닉네임</p>
			<a href="<c:url value="/mypage"/>">개인정보 변경</a>
			<a href="#">알림</a>
			<p>온도</p>
		</div>
		<div>
			<p>포인트</p>
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
	
	<!-- The Modal -->
  <div class="modal fade" id="notiListModal">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h6 class="modal-title" style="font-weight: bold;">새로운 알림이 있습니다.</h6>
          <button type="button" class="close" data-dismiss="modal">×</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          	<div class="list-group noti-list">
			  <a href="#" class="list-group-item list-group-item-action">First item</a>
			</div>
        </div>
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
					$('#noti-btn').html('<i style="color: yellow;" class="fa-solid fa-bell"></i>알림(' + count + ')');
				} else {
					$('#noti-btn').html('<i class="fa-regular fa-bell"></i>알림(' + count + ')');
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
			var str = '';
			notiCheck();				
			if(count != 0) {
				for(item of list){
					str += `
					<div class="list-group-item list-group-item-action d-flex justify-content-between">
						<a href='<c:url value="/post/detail/\${item.notification_post_num}"/>' >
							\${item.notification_message}	
						</a>
						<button type="button" class="close checked"
							data-num="\${item.notification_num}"
						><i class="fa-solid fa-check"></i></button>
					</div>
					`;
				}
				$('.noti-list').html(str);
				$('#notiListModal').modal();
			}
			
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
}
	
$(document).ready(function (){
	notiCheck();
	
	$('#noti-btn').click(function(){
		notiListDisplay();	
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
</script>
</html>