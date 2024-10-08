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
			<img src="bird.jpg" alt="Logo" style="width:40px;">
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<form class="form-inline" action="/action_page.php">
			<select>
				<option>물건</option>
				<option>동네</option>
			</select>
			<input class="form-control mr-sm-2" type="text" placeholder="물건이나 동네를 검색해보세요">
		</form>
		
		<div class="collapse navbar-collapse d-flex " id="collapsibleNavbar">
			<ul class="navbar-nav">
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
						<a class="nav-link" href="<c:url value="/post/insert"/>">글 쓰기</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/mypage"/>">마이페이지</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<c:url value="/logout"/>">로그아웃</a>
					</li>
			    </c:if>
			</ul>
		</div>  
	</nav>

	<!-- Navbar links -->
	<button data-toggle="collapse" type="button" data-target="#category">카테고리</button>
	
	<div id="category" class="collapse">
		<c:forEach items="${category}" var="category">
			<a href="<c:url value="/post/list/${category.category_num}"/>">${category.category_name}</a>
		</c:forEach>
	</div>
</body>
</html>