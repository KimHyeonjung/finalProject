<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<div class="container">
		<h1 class="hide">상세</h1>
            <section id="article-images">
                <h3 class="hide">이미지</h3>
                <div id="image-slider">
                    <div class="slider-wrap">
                        <div class="slider" data-article-id="844403235">
                            <a href="/images?image_index=0&amp;object_id=844403235&amp;object_type=Article">
                                <div>
                                    <div class="image-wrap" data-image-id="-818925824" data-image-index="1">
                                        <img data-lazy="https://img.kr.gcp-karroter.net/origin/article/202410/40d06ad779333afaca47cd14493351fd03b4fb5f9db9513dae324e3c4a7836c4_0.webp?f=webp&amp;q=95&amp;s=1440x1440&amp;t=inside" class="portrait" alt='에어팟 맥스의 디지털기기 모종동 1' src="https://dnvefa72aowie.cloudfront.net/origin/category/202306/2c0811ac0c0f491039082d246cd41de636d58cd6e54368a0b012c386645d7c66.png"/>
                                    </div>
                                </div>
                            </a>                           
                        </div>
                    </div>
                </div>
            </section>
            <section id="article-profile">                
                    <h3 class="hide">프로필</h3>
                    <div class="d-flex justify-content-between">
                        <div style="display: flex;">
                            <div id="article-profile-image">
                                <img alt="닉네임" src="https://d1unjqcospf8gs.cloudfront.net/assets/users/default_profile_80-c649f052a34ebc4eee35048815d8e4f73061bf74552558bb70e07133f25524f9.png"/>
                            </div>
                            <div id="article-profile-left">
                                <div id="nickname">닉네임</div>
                                <div id="region-name">${post.post_address }</div>
                            </div>
                        </div>
                        <div id="article-profile-right">
                            <dl id="temperature-wrap">
                                <dt>매너점수</dt>
                                <dd class="text-color-04 ">
                                    37.9  <span>점</span>
                                </dd>
                            </dl>
                            
                        </div>
                    </div>                
            </section>
            <section id="article-description">
                <h1 property="schema:name" id="article-title" style="margin-top:0px;">${post.post_title }</h1>
                <p id="article-category">
                	
                	
                    디지털기기 ∙         <time>  시간 전  </time>
                </p>
                <p property="schema:priceValidUntil" datatype="xsd:date" content="2026-10-07"></p>
                <p rel="schema:url" resource="https://www.daangn.com/844403235"></p>
                <p property="schema:priceCurrency" content="KRW"></p>
                <p id="article-price" property="schema:price" content="100000.0" style="font-size:18px; font-weight:bold;">100,000원
       			 </p>
                <div property="schema:description" id="article-detail">
                	${post.post_content }
                </div>
                <p id="article-counts">관심 30 ∙
            채팅 85
           ∙
          조회 1061
        </p>
            </section>
		
	</div>
</body>
</html>
