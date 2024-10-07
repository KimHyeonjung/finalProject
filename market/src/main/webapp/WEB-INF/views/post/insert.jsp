<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 등록</title>
	<!-- Bootstrap CDN -->
	<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
	<style>
		.textarea {
			height: 400px;
		}
		.image-upload {
			width: 100px;
			height: 100px;
			border: 2px dashed #ccc;
			display: flex;
			align-items: center;
			justify-content: center;
			cursor: pointer;
		}
		.image-upload input {
			display: none;
		}
		.char-count {
			font-size: 0.9rem;
			color: #999;
		}
		.btn-selected {
			background-color: #007bff;
			color: white;
		}
		.image-preview {
            display: inline-block;
            position: relative;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        .image-preview img {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        .image-preview .remove-btn {
            position: absolute;
            top: 0;
            right: 0;
            background-color: rgba(255, 255, 255, 0.7);
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        /* 증감버튼 숨기기 */
   		input[type="number"]::-webkit-inner-spin-button, 
    	input[type="number"]::-webkit-outer-spin-button { 
        	-webkit-appearance: none; 
        	margin: 0; 
    	}

    	input[type="number"] {
        	-moz-appearance: textfield;
    	}
	</style>
</head>
<body>
<div class="container mt-4">
	<h1>상품 등록</h1>
	<form action="<c:url value='/post/insert/${co_num}'/>" method="post" enctype="multipart/form-data">
		
		<!-- 사진 첨부 -->
		<div class="form-group">
		    <label>사진 첨부 (최대 10장)</label>
		    <div class="image-upload" onclick="document.getElementById('fileInput').click();">
		        <span>사진 추가</span>
		        <input type="file" id="fileInput" name="fileList" multiple accept="image/*" style="display: none;" onchange="handleFiles(this.files)">
		    </div>
		    <div id="previewContainer" style="display: flex; flex-wrap: wrap; margin-top: 10px;"></div>
		    <small id="fileCount" class="form-text text-muted">0/10 사진 선택됨</small>
		</div>

		<!-- 상품명 입력 -->
		<div class="form-group">
			<label for="po_title">상품명</label>
			<input type="text" class="form-control" id="po_title" name="po_title" required>
		</div>

		<!-- 카테고리 드롭다운 -->
		<div class="form-group">
			<label for="category">카테고리</label>
			<select class="form-control" id="category" name="category" onchange="categoryChange()" required>
				<option value="">선택하세요</option>
				<option value="패션">패션</option>
				<option value="리빙">리빙</option>
				<option value="모바일/태블릿">모바일/태블릿</option>
				<option value="가전제품">가전제품</option>
				<option value="스포츠">스포츠</option>
				<option value="도서/음반">도서/음반</option>
				<option value="반려동물">반려동물</option>
				<option value="유아/완구">유아/완구</option>
				<option value="공구/산업용품">공구/산업용품</option>
				<option value="취미용품">취미용품</option>
				<option value="여행">여행</option>
				<option value="중고차">중고차</option>
				<option value="나눔">나눔</option>
				<option value="삽니다">삽니다</option>
			</select>
		</div>

		<!-- 금액 입력 및 무료나눔 체크박스 -->
		<div class="form-group">
			<label for="price">금액</label>
			<div class="input-group">
				<input type="number" class="form-control" id="price" name="price" min="0" required>
				<div class="input-group-append">
					<span class="input-group-text">원</span>
				</div>
			</div>
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="freeCheckbox" name="free" onclick="toggleFree()">
				<label class="form-check-label" for="freeCheckbox">무료나눔</label>
			</div>
		</div>

		<!-- 상품 설명 -->
		<div class="form-group">
			<label for="po_content">상품 설명</label>
			<textarea class="form-control" id="po_content" name="po_content" rows="5" oninput="updateCharCount()" maxlength="1000" required 
			placeholder="- 상품명(브랜드)&#10;- 구매 시기&#10;- 사용 기간&#10;- 하자 여부&#10;* 실제 촬영한 사진과 함께 상세 정보를 입력해주세요.&#10;* 게시글 규정 위반 시 게시물 삭제 및 이용제재 처리될 수 있어요."></textarea>
			<div class="char-count">0 / 1000</div>
		</div>

		<!-- 거래 방법 선택 -->
		<div class="form-group">
			<label>거래 방법</label><br>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="delivery" name="transaction" value="택배거래">
				<label class="form-check-label" for="delivery">택배거래</label>
			</div>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="direct" name="transaction" value="직거래" onclick="toggleAddressInput()">
				<label class="form-check-label" for="direct">직거래</label>
			</div>
		</div>
		
		<!-- 주소 입력란 (초기에는 숨김) -->
		<div class="form-group" id="addressContainer" style="display: none;">
		    <label for="address">직거래 주소</label><br>
		    <input type="text" id="sample4_postcode" placeholder="우편번호">
			<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
			<input type="text" id="sample4_roadAddress" placeholder="도로명주소" style="width: 300px">
			<input type="text" id="sample4_jibunAddress" placeholder="지번주소" style="width: 300px"><br>
			<span id="guide" style="color:#999;display:none"></span>
			<input type="text" id="sample4_detailAddress" placeholder="상세주소" style="width: 250px">
			<input type="text" id="sample4_extraAddress" placeholder="참고항목" style="width: 250px">
		</div>

		<!-- 등록 버튼 -->
		<button type="submit" class="btn btn-primary btn-block" id="submitBtn" disabled>등록</button>
	</form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	// 카테고리 변경 시 무료나눔 자동 선택
	function categoryChange() {
		var category = document.getElementById('category').value;
		if (category === '나눔') {
			document.getElementById('freeCheckbox').checked = true;
			toggleFree();
		}
	}
	
    // 숫자 이외의 문자를 입력하지 않도록 처리
    function validateNumberInput(input) {
        // 입력된 값이 숫자가 아니면 빈 문자열로 변환
        input.value = input.value.replace(/[^0-9]/g, '');
    }

	// 무료나눔 체크박스 클릭 시 가격 변경
	function toggleFree() {
		var freeCheckbox = document.getElementById('freeCheckbox');
		var priceInput = document.getElementById('price');
		if (freeCheckbox.checked) {
			priceInput.value = 0;
			priceInput.setAttribute('readonly', 'readonly');
		} else {
			priceInput.removeAttribute('readonly');
		}
	}

	// 상품 설명 글자 수 업데이트
	function updateCharCount() {
		var content = document.getElementById('po_content').value;
		document.querySelector('.char-count').innerText = content.length + " / 1000";
	}

	// 상품 상태 선택
	function selectCondition(condition) {
		document.getElementById('condition').value = condition;
		document.getElementById('usedBtn').classList.remove('btn-selected');
		document.getElementById('newBtn').classList.remove('btn-selected');
		if (condition === '중고') {
			document.getElementById('usedBtn').classList.add('btn-selected');
		} else {
			document.getElementById('newBtn').classList.add('btn-selected');
		}
	}
	
	// 직거래 체크박스 선택 시 주소 입력란 표시/숨김
	function toggleAddressInput() {
	    var directCheckbox = document.getElementById('direct');
	    var addressContainer = document.getElementById('addressContainer');

	    if (directCheckbox.checked) {
	        addressContainer.style.display = 'block'; // 체크되면 주소 입력란 표시
	    } else {
	        addressContainer.style.display = 'none'; // 체크 해제되면 주소 입력란 숨김
	    }
	}
	
	// 거래 방법 선택
	function checkTransactionMethod() {
		const deliveryChecked = document.getElementById('delivery').checked;
		const directChecked = document.getElementById('direct').checked;
		return deliveryChecked || directChecked;
	}

	// 폼 요소 모두가 선택되었는지 확인하는 함수
	function checkFormCompletion() {
		const conditionSelected = document.getElementById('condition').value !== ""; // 상품 상태 선택 여부 확인
		const transactionMethodSelected = checkTransactionMethod(); // 거래 방법 체크박스 선택 여부 확인
		
		// 조건이 모두 충족되면 등록 버튼 활성화, 그렇지 않으면 비활성화
		document.getElementById('submitBtn').disabled = !(conditionSelected && transactionMethodSelected);
	}

	// 거래 방법 체크박스에 change 이벤트 리스너 추가
	document.getElementById('delivery').addEventListener('change', checkFormCompletion);
	document.getElementById('direct').addEventListener('change', checkFormCompletion);

	
	
    let selectedFiles = [];

    // 파일 처리 함수
    function handleFiles(files) {
        var previewContainer = document.getElementById('previewContainer');
        var fileCountDisplay = document.getElementById('fileCount');
        
        // 새로 선택된 파일을 배열로 변환
        let newFiles = Array.from(files);
        
        // 기존 파일과 합쳐서 10장까지만 허용
        if (selectedFiles.length + newFiles.length > 10) {
            alert('최대 10장까지 업로드할 수 있습니다.');
            return;
        }

        // 선택한 파일들을 selectedFiles 배열에 추가
        selectedFiles = selectedFiles.concat(newFiles);

        // 미리보기 컨테이너 초기화
        previewContainer.innerHTML = '';

        // 파일을 순회하면서 미리보기 생성
        selectedFiles.forEach((file, index) => {
            let reader = new FileReader();
            reader.onload = function(e) {
                let imgWrapper = document.createElement('div');
                imgWrapper.style.position = 'relative';
                imgWrapper.style.display = 'inline-block';
                imgWrapper.style.marginRight = '10px';
                imgWrapper.style.marginBottom = '10px';

                let img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '100px';
                img.style.height = '100px';
                img.style.objectFit = 'cover';

                // 삭제 버튼 생성
                let removeBtn = document.createElement('button');
                removeBtn.textContent = '삭제';
                removeBtn.style.position = 'absolute';
                removeBtn.style.top = '5px';
                removeBtn.style.right = '5px';
                removeBtn.style.backgroundColor = 'red';
                removeBtn.style.color = 'white';
                removeBtn.style.border = 'none';
                removeBtn.style.borderRadius = '3px';
                removeBtn.style.cursor = 'pointer';

                // 삭제 버튼 클릭 시 파일 삭제 처리
                removeBtn.onclick = function() {
                    removeFile(index);
                };

                imgWrapper.appendChild(img);
                imgWrapper.appendChild(removeBtn);
                previewContainer.appendChild(imgWrapper);
            };

            reader.readAsDataURL(file);
        });

        // 파일 개수 업데이트
        fileCountDisplay.textContent = selectedFiles.length + '/10 사진 선택됨';
    }

    // 파일 삭제 함수
    function removeFile(index) {
        selectedFiles.splice(index, 1);  // 선택된 파일 배열에서 해당 파일 제거
        updatePreview();  // 미리보기 업데이트
    }

    // 미리보기 업데이트 함수
    function updatePreview() {
        var previewContainer = document.getElementById('previewContainer');
        var fileCountDisplay = document.getElementById('fileCount');
        
        previewContainer.innerHTML = '';  // 미리보기 컨테이너 초기화

        // 파일을 순회하면서 미리보기 다시 생성
        selectedFiles.forEach((file, index) => {
            let reader = new FileReader();
            reader.onload = function(e) {
                let imgWrapper = document.createElement('div');
                imgWrapper.style.position = 'relative';
                imgWrapper.style.display = 'inline-block';
                imgWrapper.style.marginRight = '10px';
                imgWrapper.style.marginBottom = '10px';

                let img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '100px';
                img.style.height = '100px';
                img.style.objectFit = 'cover';

                // 삭제 버튼 생성
                let removeBtn = document.createElement('button');
                removeBtn.textContent = '삭제';
                removeBtn.style.position = 'absolute';
                removeBtn.style.top = '5px';
                removeBtn.style.right = '5px';
                removeBtn.style.backgroundColor = 'red';
                removeBtn.style.color = 'white';
                removeBtn.style.border = 'none';
                removeBtn.style.borderRadius = '3px';
                removeBtn.style.cursor = 'pointer';

                // 삭제 버튼 클릭 시 파일 삭제 처리
                removeBtn.onclick = function() {
                    removeFile(index);
                };

                imgWrapper.appendChild(img);
                imgWrapper.appendChild(removeBtn);
                previewContainer.appendChild(imgWrapper);
            };

            reader.readAsDataURL(file);
        });

        // 파일 개수 업데이트
        fileCountDisplay.textContent = selectedFiles.length + '/10 사진 선택됨';
    }
    
   
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
</script>
</body>
</html>
