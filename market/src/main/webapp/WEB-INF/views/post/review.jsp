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
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style>
		.btn-option {
	        border: 1px solid #007bff; /* 기본 파란색 테두리 */
	        background-color: white; /* 기본 흰색 배경 */
	        color: black; /* 기본 검은색 글자 */
	    }
	    
	    
        .radio-group {
            display: flex;
            justify-content: space-around;
            align-items: center;
            margin-top: 20px;
        }
        .radio-group label {
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
        }
        
		.radio-group input[type="radio"] {
	        transform: scale(1.5); /* 라디오 버튼 크기 조정 */
	        margin-bottom: 5px; /* 텍스트와 라디오 버튼 사이 여백 */
	    }
	</style>
</head>
<body>
<div class="container mt-4">
	<h1>거래 리뷰</h1>
	<hr>
	<form action="<c:url value='/post/review'/>" method="post" onsubmit="setPostPosition()" accept-charset="UTF-8" enctype="multipart/form-data">
		<!-- 거래 형태 입력 -->
		<div class="form-group">
		    <div class="btn-group" role="group" aria-label="옵션 선택">
		        <button type="button" class="btn btn-option" id="option1" onclick="selectOption(1)">직거래</button>
		        <button type="button" class="btn btn-option" id="option2" onclick="selectOption(2)">택배거래</button>
		    </div>
		    <input type="hidden" id="selectedOption" name="selectedOption" value="">
		</div>
		<br>
		
		<!-- 숨겨진 필드: after_review_avg -->
		<input type="hidden" id="after_review_sum" name="after_review_sum" value="1.5">
		
		<div class="container">
		    <label style="font-weight: bold;">가격 평가</label>
		    <div class="radio-group">
		        <label>
		            <input type="radio" name="after_review1" value="-1">
		            <span class="text-muted">별로예요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review1" value="0.5" checked="checked">
		            <span class="text-muted">보통이에요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review1" value="1">
		            <span class="text-muted">좋아요</span>
		        </label>
				<label>
		            <input type="radio" name="after_review1" value="2">
		            <span class="text-muted">매우 좋아요</span>
		        </label>
		    </div>
		</div>
		
		<!-- 매너 평가 라디오 그룹 -->
		<div class="container">
		    <label style="font-weight: bold;">매너 평가</label>
		    <div class="radio-group">
		        <label>
		            <input type="radio" name="after_review2" value="-1">
		            <span class="text-muted">별로예요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review2" value="0.5" checked="checked">
		            <span class="text-muted">보통이에요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review2" value="1">
		            <span class="text-muted">좋아요</span>
		        </label>
				<label>
		            <input type="radio" name="after_review2" value="2">
		            <span class="text-muted">매우 좋아요</span>
		        </label>
		    </div>
		</div>

		<!-- 시간 또는 배송 평가 라디오 그룹 -->
		<div class="container">
		    <label id="after_review3Label" style="font-weight: bold;">시간 평가</label>
		    <div class="radio-group">
		        <label>
		            <input type="radio" name="after_review3" value="-1">
		            <span class="text-muted">별로예요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review3" value="0.5" checked="checked">
		            <span class="text-muted">보통이에요</span>
		        </label>
		        <label>
		            <input type="radio" name="after_review3" value="1">
		            <span class="text-muted">좋아요</span>
		        </label>
				<label>
		            <input type="radio" name="after_review3" value="2">
		            <span class="text-muted">매우 좋아요</span>
		        </label>
		    </div>
		</div>
		<br>
		
		<!-- 상품 설명 -->
		<div class="form-group">
			<label for="content" style="font-weight: bold;">소중한 후기를 더 자세히 적어주세요.</label>
			<textarea class="form-control" id="after_message" name="after_message" rows="5" oninput="updateCharCount()" maxlength="200"
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
	
	// after_review1, after_review2, after_review3의 합계를 계산하여 after_review_sum에 설정
	function updateReviewSum() {
	    const review1 = parseFloat(document.querySelector('input[name="after_review1"]:checked').value) || 0;
	    const review2 = parseFloat(document.querySelector('input[name="after_review2"]:checked').value) || 0;
	    const review3 = parseFloat(document.querySelector('input[name="after_review3"]:checked').value) || 0;
	    
	    const sum = review1 + review2 + review3;
	    document.getElementById('after_review_sum').value = sum;
	}

	// 각 라디오 버튼의 클릭 이벤트에 updateReviewSum 함수 연결
	document.querySelectorAll('input[name="after_review1"], input[name="after_review2"], input[name="after_review3"]').forEach(radio => {
	    radio.addEventListener('click', updateReviewSum);
	});
</script>
</body>
</html>