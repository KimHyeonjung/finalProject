<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<nav class="navbar navbar-expand-md bg-dark navbar-dark">
	<a class="navbar-brand" href="#">
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
		<ul class="navbar-nav" sec:authorize="isAnonymous()">
			<li class="nav-item" >
				<a class="nav-link" th:href="@{/login}">로그인</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" th:href="@{/signup}">회원가입</a>
			</li>  
		</ul>
		
		<ul class="navbar-nav" sec:authorize="isAuthenticated()">
			<li class="nav-item">
				<a class="nav-link" th:href="@{/chatRoom}">채팅</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" th:href="@{/post/insert}">글 쓰기</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" th:href="@{/mypage}">마이페이지</a>
			</li>
		</ul>
	</div>  
</nav>

<!-- Navbar links -->
<button data-toggle="collapse" type="button" data-target="#category">카테고리</button>

<div id="category" class="collapse">
	<table class="table table-striped">
		<tr th:each="item : ${category}">
			<td class="list">
				<a th:text="${item.category_name}"></a>
			</td>
		</tr>
</table>
</div>
