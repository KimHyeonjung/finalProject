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
	object-fit: cover; /* 이미지 비율 유지하면서 컨테이너에 맞춤 */
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
						<div>
							<a href="<c:url value="/post/report"/>">신고하기</a>
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
			<h5 property="schema:name" id="article-title"
				style="margin-top: 0px;">${post.post_title }</h5>
			<p id="article-category">
				${post.post_category_name }
				<time>${post.beforeTime } 시간 전 </time>
			</p>
			<p property="schema:priceValidUntil" datatype="xsd:date"
				content="2026-10-07"></p>
			<p rel="schema:url" resource="https://www.daangn.com/844403235"></p>
			<p property="schema:priceCurrency" content="KRW"></p>
			<p id="article-price" property="schema:price" content="100000.0"
				style="font-size: 18px; font-weight: bold;">100,000원</p>
			<div property="schema:description" id="article-detail">
				${post.post_content }</div>
			<p id="article-counts">관심 30 ∙ 채팅 85 ∙ 조회 ${post.post_view }</p>
		</section>
		<%-- <section class="article">
			<a class="btn btn-outline-dark">수정</a>
			<a href="<c:url value="/post/delete/{${post.post_num }}"/>" class="btn btn-outline-dark">삭제</a>
		</section> --%>
	</div>
</body>
</html>
