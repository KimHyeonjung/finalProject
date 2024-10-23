<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<link href="<c:url value="/resources/summernote/"/>summernote.min.css" rel="stylesheet">
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
    	
    	.map_wrap {position:relative;width:100%;height:350px;}
    	.hAddr {position:absolute;left:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
	    #centerAddr {display:block;margin-top:2px;font-weight: normal;}
	    .bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
	    
 	    
		.form-check-radio {
		  display: flex;
		  justify-content: center; /* 라디오 버튼을 페이지 가운데로 정렬 */
		  gap: 80px; /* 각 라디오 버튼 항목 사이의 간격을 50px로 설정 */
		  align-items: center; /* 라디오 버튼과 텍스트를 세로 중앙 정렬 */
		  margin-top: 20px; /* 상단 여백 추가 */
		}
		
		.radio-item {
		  display: flex;
		  align-items: center; /* 라디오 버튼과 라벨을 세로 중앙 정렬 */
		  gap: 5px; /* 라디오 버튼과 텍스트 사이의 간격 */
		}
		
		.radio-large {
		  width: 20px; /* 라디오 버튼 크기 */
		  height: 20px;
		  margin: 0; /* 버튼의 여백 제거 */
		  padding: 0; /* 버튼의 패딩 제거 */
		}
		
		.form-check-label-radio {
		  font-size: 18px; /* 라벨의 텍스트 크기 */
		  line-height: 30px; /* 라디오 버튼과 텍스트의 높이를 맞춤 */
		  margin-left: 25px; /* 버튼과 라벨 사이의 간격을 맞추기 */
		}
		
		
	</style>
</head>
<body>
<div class="container mt-4">
	<h1>상품 등록</h1>
	<form action="<c:url value='/post/insert'/>" method="post" onsubmit="setPostPosition()" accept-charset="UTF-8" enctype="multipart/form-data">
		
		<!-- 판매 유형 -->
<!-- 		<div class="form-check-radio">
		  <div class="radio-item">
		    <input type="radio" class="form-check-input radio-large" id="radio1" name="optradio" value="sell" checked>
		    <label class="form-check-label-radio" for="radio1">팝니다</label>
		  </div>
		  
		  <div class="radio-item">
		    <input type="radio" class="form-check-input radio-large" id="radio2" name="optradio" value="buy">
		    <label class="form-check-label-radio" for="radio2">삽니다</label>
		  </div>
		  
		  <div class="radio-item">
		    <input type="radio" class="form-check-input radio-large" id="radio3" name="optradio" value="donate">
		    <label class="form-check-label-radio" for="radio3">무료나눔</label>
		  </div>
		</div> -->
		
		
		
	    <div class="btn-group">
	        <button type="button" class="btn-radio">팝니다</button> 
	        <button type="button" class="btn-radio">삽니다</button> 
	        <button type="button" class="btn-radio">무료나눔</button> 
	    </div>
		
		
		
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
			<label for="title">상품명</label>
			<input type="text" class="form-control" id="post_title" name="post_title" required>
		</div>
		
		<!-- 카테고리 드롭다운 -->
		<div class="form-group">
		    <label for="post_category_num">카테고리 선택:</label>
		    <select class="form-control" name="post_category_num" id="post_category_num" required>
		        <c:forEach var="category" items="${categoryList}">
		            <option value="${category.category_num}">${category.category_name}</option>
		        </c:forEach>
		    </select>
		</div>

		<!-- 금액 입력 및 무료나눔 체크박스 -->
		<div class="form-group">
			<label for="price">금액</label>
			<div class="input-group">
				<input type="number" class="form-control" id="post_price" name="post_price" min="0" required>
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
			<label for="content">상품 설명</label>
			<textarea class="form-control" id="post_content" name="post_content" rows="5" oninput="updateCharCount()" maxlength="1000" required 
			placeholder="- 상품명(브랜드)&#10;- 구매 시기&#10;- 사용 기간&#10;- 하자 여부&#10;* 실제 촬영한 사진과 함께 상세 정보를 입력해주세요.&#10;* 게시글 규정 위반 시 게시물 삭제 및 이용제재 처리될 수 있어요."></textarea>
			<div class="char-count">0 / 1000</div>
		</div>
		
		<!-- 흥정 여부 선택 -->
		<div class="form-check">
		  <label class="form-check-label">
		    <input type="checkbox" class="form-check-input" id="post_deal" name="post_deal" >흥정 받기
		  </label>
		</div><br>
	
		<!-- 거래 방법 선택 -->	
		<div class="form-group">
			<label>거래 방법</label><br>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="delivery" name="transaction" value="택배거래" onclick="setPostWayNum()">
				<label class="form-check-label" for="delivery">택배거래</label>
			</div>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="direct" name="transaction" value="직거래" onclick="setPostWayNum();">
				<label class="form-check-label" for="direct">직거래</label>
			</div>
		</div>
		
		<!-- 숨겨진 필드: post_way_num -->
		<input type="hidden" id="post_way_num" name="post_way_num" value="0">
		
		
		
		<!-- 주소 입력란 (초기에는 숨김) -->
		<!-- 카카오 지도 API 추가 -->
		<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=55f22ec08aea99a6511585b99e78d0d6"></script>
		
		<!-- 지도와 주소 입력 관련 섹션 -->
		<div class="map_wrap">
		    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
		    <div class="hAddr">
		        <span class="title">지도중심기준 행정동 주소정보</span>
		        <span id="centerAddr"></span>
		    </div>
		</div>
		
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=발급받은 APP KEY를 사용하세요&libraries=services"></script>
		<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = {
		        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
		        level: 1 // 지도의 확대 레벨
		    };  
		
		// 지도를 생성합니다    
		var map = new kakao.maps.Map(mapContainer, mapOption); 
		
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();
		
		var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
		    infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다
		
		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		
		// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
		    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
		        if (status === kakao.maps.services.Status.OK) {
		            var detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
		            detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
		            
		            var content = '<div class="bAddr">' +
		                            '<span class="title">법정동 주소정보</span>' + 
		                            detailAddr + 
		                        '</div>';
		
		            // 마커를 클릭한 위치에 표시합니다 
		            marker.setPosition(mouseEvent.latLng);
		            marker.setMap(map);
		
		            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
		            infowindow.setContent(content);
		            infowindow.open(map, marker);
		        }   
		    });
		});
		
		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
		    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		});
		
		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
		}
		
		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}
		
		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');
		
		        for(var i = 0; i < result.length; i++) {
		            // 행정동의 region_type 값은 'H' 이므로
		            if (result[i].region_type === 'H') {
		                infoDiv.innerHTML = result[i].address_name;
		                break;
		            }
		        }
		    }    
		}
		</script>
		
		<!-- 숨겨진 필드: post_position_num -->
		<input type="hidden" id="post_position_num" name="post_position_num" value="1">

		<!-- 등록 버튼 -->
		<button type="submit" class="btn btn-primary btn-block" id="submitBtn" disabled>등록</button>
	</form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	// 카테고리 변경 시 무료나눔 자동 선택
	function categoryChange() {
		var category = document.getElementById('post_category').value;
		if (category === '무료나눔') {
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
		var priceInput = document.getElementById('post_price');
		
		if (freeCheckbox.checked) {
			priceInput.value = 0;
			priceInput.setAttribute('readonly', 'readonly');
		} else {
			priceInput.removeAttribute('readonly');
		}
	}

	// 상품 설명 글자 수 업데이트
	function updateCharCount() {
		var content = document.getElementById('post_content').value;
		document.querySelector('.char-count').innerText = content.length + " / 1000";
	}
	
    // 주소 필드 초기화
    function clearAddressFields() {
        document.getElementById('sample4_postcode').value = '';
        document.getElementById('sample4_roadAddress').value = '';
        document.getElementById('sample4_jibunAddress').value = '';
        document.getElementById('sample4_detailAddress').value = '';
        document.getElementById('sample4_extraAddress').value = '';
    }
	
	// 거래 방법 선택 여부 확인
	function checkTransactionMethod() {
		const deliveryChecked = document.getElementById('delivery').checked;
		const directChecked = document.getElementById('direct').checked;
		return deliveryChecked || directChecked;
	}
	
    // 폼 완료 상태 확인
    function checkFormCompletion() {
        const transactionMethodSelected = checkTransactionMethod();
        const directChecked = document.getElementById('direct').checked;

        // 직거래가 선택된 경우에는 주소 입력 여부까지 확인
        const formValid = transactionMethodSelected && (!directChecked || isAddressFilled());

        // 조건이 모두 충족되면 등록 버튼 활성화, 그렇지 않으면 비활성화
        document.getElementById('submitBtn').disabled = !formValid;
    }

    // 거래 방법 체크박스와 주소 필드에 change 이벤트 리스너 추가
    document.getElementById('delivery').addEventListener('change', checkFormCompletion);
    document.getElementById('direct').addEventListener('change', checkFormCompletion);
    document.getElementById('sample4_postcode').addEventListener('input', checkFormCompletion);
    document.getElementById('sample4_roadAddress').addEventListener('input', checkFormCompletion);
    document.getElementById('sample4_jibunAddress').addEventListener('input', checkFormCompletion);
    document.getElementById('sample4_detailAddress').addEventListener('input', checkFormCompletion);
	
	
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
        updateFileInput();  // file input 갱신

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
        updateFileInput();  // file input 갱신
    }
    
    function updateFileInput() {
        // 새로운 데이터로 FileList를 업데이트하기 위해 DataTransfer 객체 사용
        let dataTransfer = new DataTransfer();
        selectedFiles.forEach(file => {
            dataTransfer.items.add(file);
        });
        document.getElementById('fileInput').files = dataTransfer.files;  // file input 업데이트
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
    
	function setPostPosition() {
		const category = document.getElementById('post_category').value;
		const positionInput = document.getElementById('post_position_num');

		if (category === '삽니다') {
			positionInput.value = '2';
		} else if (category === '무료나눔') {
			positionInput.value = '3';
		} else {
			positionInput.value = '1';
		}
	}
	
	// 거래 방법 선택에 따라 post_way_num 값 설정
	function setPostWayNum() {
	    const deliveryChecked = document.getElementById('delivery').checked;
	    const directChecked = document.getElementById('direct').checked;
	    const postWayInput = document.getElementById('post_way_num');
	    
        var addressContainer = document.getElementById('addressContainer');
        
        
        var map = document.getElementById('map');

        if (directChecked.checked) {
            map.style.display = 'block'; // 체크되면 주소 입력란 표시
        } else {
            map.style.display = 'none'; // 체크 해제되면 주소 입력란 숨김
            clearAddressFields(); // 체크 해제 시 주소 필드 초기화
        }
	    
	    if (deliveryChecked && directChecked) {
	        postWayInput.value = '3'; // 택배거래와 직거래 둘 다 선택됨
	        //document.getElementById('post_way_num').value = 3; // 택배거래 방식
	    } else if (deliveryChecked) {
	        postWayInput.value = '1'; // 택배거래만 선택됨
	        //document.getElementById('post_way_num').value = 1; // 택배거래 방식
	    } else if (directChecked) {
	        postWayInput.value = '2'; // 직거래만 선택됨
	        //document.getElementById('post_way_num').value = 2; // 택배거래 방식
	    }

	    checkFormCompletion(); // 폼의 완료 상태 재검증
	}
	
	function panTo() {
	    // 이동할 위도 경도 위치를 생성합니다 
	    var moveLatLon = new kakao.maps.LatLng(33.450580, 126.574942);
	    
	    // 지도 중심을 부드럽게 이동시킵니다
	    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
	    map.panTo(moveLatLon);            
	}      
</script>
</body>
</html>
