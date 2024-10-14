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
			<img src="" alt="Logo" style="width:40px;">
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
						<a class="nav-link" href="<c:url value="/post/insert"/>">글 쓰기</a>
					</li>
					<li class="nav-item">
						<div class="dropdown">
							<button data-toggle="collapse" data-target="#demo">
								<img src="bird.jpg" alt="Logo" style="width:40px;">	
							</button>
						</div>
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
			<a href="#">내역</a>
			<a href="#">충전</a>
		</div>
		<div>
			<a href="#">게시글 관리</a>
			<a href="#">찜목록</a>
		</div>
		<div>
			<a href="#">주소록</a>
			<a href="#">거래 내역</a>
		</div>
		<a href="<c:url value="/logout"/>">로그아웃</a>
	</div>

	<button data-toggle="collapse" type="button" data-target="#category">카테고리</button>
	
	<div id="category" class="collapse">
		<c:forEach items="${category}" var="category">
			<a href="<c:url value="/post/list/${category.category_num}"/>">${category.category_name}</a>
		</c:forEach>
	</div>
	
</body>
</html>