<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>거래 리뷰</title>
	<!-- Bootstrap CDN -->
	<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
	<style>
		.btn-option {
	        border: 1px solid #007bff; /* 기본 파란색 테두리 */
	        background-color: white; /* 기본 흰색 배경 */
	        color: black; /* 기본 검은색 글자 */
	    }
	    
	    [type="radio"] {
		  width: 30px;
		  height: 30px;
		  marign-right: 100px;
		  margin-bottom: 15px;
		}
	</style>
</head>
<body>
<div class="container mt-4">
	<h1>거래 리뷰</h1>
	<hr>
	<form action="<c:url value='/post/review'/>" method="review" onsubmit="setPostPosition()" accept-charset="UTF-8" enctype="multipart/form-data">
		<!-- 거래 형태 입력 -->
		<div class="form-group">
		    <div class="btn-group" role="group" aria-label="옵션 선택">
		        <button type="button" class="btn btn-option" id="option1" onclick="selectOption(1)">직거래</button>
		        <button type="button" class="btn btn-option" id="option2" onclick="selectOption(2)">택배거래</button>
		    </div>
		    <input type="hidden" id="selectedOption" name="selectedOption" value="">
		</div>
		
		<!-- 		<div class="form-check">
			<input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>
			<label class="form-check-label" for="radio1" style="margin-right: 50px"></label>
			<input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>
		 	<label class="form-check-label" for="radio1" style="margin-right: 50px"></label>
		 	<input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>
		 	<label class="form-check-label" for="radio1"></label>
		</div> -->
		
		<!-- 슬라이더들 추가 -->
		<div class="form-group">
		    <label for="slider1" style="font-weight: bold;">가격 평가</label>
		    <input type="range" class="custom-range" id="after_review1" name="slider1" min="1" max="3" step="1" onchange="showSliderValue('slider1', 'slider1Value')">
		    <p id="slider1Value">보통이에요</p>
		</div>
		<div class="form-group">
		    <label for="slider2" style="font-weight: bold;">매너 평가</label>
		    <input type="range" class="custom-range" id="after_review2" name="slider2" min="1" max="3" step="1" onchange="showSliderValue('slider2', 'slider2Value')">
		    <p id="slider2Value">보통이에요</p>
		</div>
		<div class="form-group">
		    <label id="slider3Label" for="slider3" style="font-weight: bold;">시간 평가</label>
		    <input type="range" class="custom-range" id="after_review3" name="slider3" min="1" max="3" step="1" onchange="showSliderValue('slider3', 'slider3Value')">
		    <p id="slider3Value">보통이에요</p>
		</div>
		
		<!-- 상품 설명 -->
		<div class="form-group">
			<label for="content" style="font-weight: bold;">소중한 후기를 더 자세히 적어주세요.</label>
			<textarea class="form-control" id="post_content" name="post_content" rows="5" oninput="updateCharCount()" maxlength="200"
			placeholder="남겨주신 후기는 더 나은 중고거래 환경을 만드는데 보탬이 돼요. (선택사항)"></textarea>
			<div class="char-count">0 / 200</div>
		</div>
		
		<hr>
		
		<!-- 등록 버튼 -->
		<button type="submit" class="btn btn-primary btn-block" id="submitBtn" onclick="validateForm(event)">등록</button>
	</form>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
 	// 페이지 로드 시 기본 옵션 선택
    window.onload = function() {
        setDefaultOption(); // "판매한다" 버튼 선택
    };
	
    // 페이지 로드 시 기본 옵션 선택
    function setDefaultOption() {
        selectOption(1); // "판매한다" 버튼 선택
    }
	
    // 옵션 선택 함수
	function selectOption(option) {
	    document.querySelectorAll('.btn-option').forEach(btn => {
	        btn.style.backgroundColor = 'white';
	        btn.style.color = 'black';
	    });
	
	    const selectedBtn = document.getElementById('option' + option);
	    selectedBtn.style.backgroundColor = '#007bff';
	    selectedBtn.style.color = 'white';
	
	    document.getElementById('selectedOption').value = option;
	
	    // 거래 형태에 따른 after_review3 라벨 변경
	    const after_review3Label = document.getElementById('after_review3Label');
	    if (option === 1) {
	        after_review3Label.innerText = '시간 평가';
	    } else if (option === 2) {
	        after_review3Label.innerText = '배송 및 포장';
	    }
	}
    
	// 슬라이더 값에 따라 텍스트 업데이트
	function showSliderValue(sliderId, displayId) {
	    const value = document.getElementById(sliderId).value;
	    let text;
	    switch (value) {
	        case '1':
	            text = '별로에요';
	            break;
	        case '2':
	            text = '보통이에요';
	            break;
	        case '3':
	            text = '좋아요';
	            break;
	    }
	    document.getElementById(displayId).innerText = text;
	}
	
	// 상품 설명 글자 수 업데이트
	function updateCharCount() {
		var content = document.getElementById('post_content').value;
		document.querySelector('.char-count').innerText = content.length + " / 200";
	}
</script>
</body>
</html>