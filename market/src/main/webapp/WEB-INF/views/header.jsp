<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>    
<html>
<head>
	<meta charset="UTF-8">
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
						<button id="notification" type="button" class="btn btn-dark" data-toggle="modal" data-target="#notiList">
						  🔔알림
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
	

</body>
<script type="text/javascript">
function notiCheck(notification_read){
	if(${user != null}){
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/mypage/notification"/>', 
			type : 'post', 
			data : {notification_read : notification_read},
			dataType : 'json',
			success : function (data){	
				var count = data.count;
				var list = data.list;
				var str = '';
				$('#notification').text('🔔알림(' + count + ')');
				if(count != 0){
					$('#notification').removeClass('btn-dark');
					$('#notification').addClass('btn-danger');
				} else {
					$('#notification').removeClass('btn-danger');
					$('#notification').addClass('btn-dark');
				}
				if(list == null || list.length == 0){					
					return;
				}else {
					str += `
						<div class="modal fade" id="notiList">
					    <div class="modal-dialog">
					      <div class="modal-content">
					        
				        <!-- Modal body -->
				        <div class="modal-body">
					        <div class="list-group">
					`;
					for(noti of list){
						str +=`
							  <a href="<c:url value="/post/detail/\${noti.notification_post_num}"/>" 
							  	class="list-group-item list-group-item-action">
							  	\${noti.notification_message}							  	
							  </a>
								
						`;
					}
					str += `
							</div>
				        </div>
			       `;
					$('#notification').html(str);
					$("#notiList").modal();
				}
				
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	}
}	
	
$(document).ready(function (){
	let notification_read = false;
	notiCheck(notification_read);
	$('#notification').click(function(){
		notification_read = true;
		notiCheck(notification_read);
	});
});
</script>
</html>