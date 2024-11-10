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
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=55f22ec08aea99a6511585b99e78d0d6&libraries=services"></script>
	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
<body>
<div class="container-post">
	<h1>상품 등록</h1>
	<form id="uploadForm" action="<c:url value='/post/insert'/>" method="post" onsubmit="setPostPosition()" accept-charset="UTF-8" enctype="multipart/form-data">
		
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
		
		<!-- 거래 상태 입력 -->
		<div class="form-group">
		    <div class="btn-group" role="group" aria-label="옵션 선택">
		        <button type="button" class="btn btn-option" id="option1" onclick="selectOption(1)">판매한다</button>
		        <button type="button" class="btn btn-option" id="option2" onclick="selectOption(2)">구매한다</button>
		        <button type="button" class="btn btn-option" id="option3" onclick="selectOption(3)">무료나눔</button>
		    </div>
		    <input type="hidden" id="selectedOption" name="selectedOption" value="">
		</div>

		<!-- 상품명 입력 -->
		<div class="form-group">
			<label for="title">상품명</label>
			<input type="text" class="form-control" id="post_title" name="post_title">
		</div>
		
		<!-- 카테고리 드롭다운 -->
		<div class="form-group">
		    <label for="post_category_num">카테고리 선택</label>
		    <select class="form-control" name="post_category_num" id="post_category_num">
		        <c:forEach var="category" items="${categoryList}">
		            <option value="${category.category_num}">${category.category_name}</option>
		        </c:forEach>
		    </select>
		</div>

		<!-- 금액 입력 및 무료나눔 체크박스 -->
		<div class="form-group">
			<label for="price">금액</label>
			<div class="input-group">
				<input type="number" class="form-control" id="post_price" name="post_price" min="0" oninput="checkNumberInput(this)">
				<div class="input-group-append">
					<span class="input-group-text">원</span>
				</div>
			</div>
		</div>

		<!-- 상품 설명 -->
		<div class="form-group">
			<label for="content">상품 설명</label>
			<textarea class="form-control" id="post_content" name="post_content" rows="5" oninput="updateCharCount()" maxlength="1000"
			placeholder="- 상품명(브랜드)&#10;- 구매 시기&#10;- 사용 기간&#10;- 하자 여부&#10;* 실제 촬영한 사진과 함께 상세 정보를 입력해주세요.&#10;* 게시글 규정 위반 시 게시물 삭제 및 이용제재 처리될 수 있어요."></textarea>
			<div class="char-count">0 / 1000</div>
		</div>
		
		<!-- 흥정 여부 선택 -->
		<div id="dealCheckboxContainer" class="form-check">
		  <label class="form-check-label">
		    <input type="checkbox" class="form-check-input" id="post_deal" name="post_deal" >흥정 받기
		  </label>
		</div><br>
	
		<!-- 거래 방법 선택 -->	
		<div class="form-group">
			<label>거래 방법</label><br>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="delivery" name="transaction" value="택배거래" 
					checked="on" onclick="setPostWayNum()">
				<label class="form-check-label" for="delivery">택배거래</label>
			</div>
			<div class="form-check form-check-inline">
				<input class="form-check-input" type="checkbox" id="direct" name="transaction" value="직거래" 
					checked="on" onclick="toggleMapVisibility(); setPostWayNum()">
				<label class="form-check-label" for="direct">직거래</label>
			</div>
		</div>
		
		<!-- 지도 및 주소 입력 -->
		<div id="mapContainer">
		    <div class="map_wrap">
		        <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
		        <div class="hAddr">
		            <span class="title">지도중심기준 행정동 주소정보</span>
		            <span id="centerAddr"></span>
		        </div>
		    </div>
		    <input type="text" id="post_address" name="post_address" placeholder="여기에 클릭한 주소가 표시됩니다" style="width:100%; margin-top:10px; padding:5px;" readonly>
		</div>
		<hr>
		
		<!-- 숨겨진 필드: post_way_num -->
		<input type="hidden" id="post_way_num" name="post_way_num" value="1">
		
		<!-- 숨겨진 필드: post_position_num -->
		<input type="hidden" id="post_position_num" name="post_position_num" value="1">

		<!-- 등록 버튼 -->
		<button type="submit" class="btn btn-block" id="submitBtn" onclick="validateForm(event)">등록</button>
	</form>
</div>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 기본 중심좌표 (서울)
        level: 1 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
    infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

// HTML5의 Geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도

        var locPosition = new kakao.maps.LatLng(lat, lon); // 접속 위치를 LatLng 객체로 변환

        // Geocoder를 이용해 현재 위치 좌표에 대한 법정동 상세 주소 정보를 검색합니다
        searchDetailAddrFromCoords(locPosition, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;

                var content = '<div class="bAddr">' +
                                '<span class="title">현재 위치</span><br>' + 
                                detailAddr + 
                            '</div>';

                // 마커와 인포윈도우를 표시합니다
                displayMarker(locPosition, content, detailAddr);
            } else {
                var content = '<div class="bAddr">현재 위치 정보를 찾을 수 없습니다.</div>';
                displayMarker(locPosition, content, "");
            }
        });
    });
} else { 
    var locPosition = new kakao.maps.LatLng(37.566826, 126.9786567), // 기본 좌표 (서울)
        message = '<div class="bAddr">Geolocation을 사용할 수 없습니다.</div>'; 
    displayMarker(locPosition, message, "");
}
    
//지도 타입 전환 버튼 생성
var mapTypeControl = new kakao.maps.MapTypeControl();
map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

// 지도 확대/축소 버튼 생성
var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

// 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, content, address) {
    marker.setPosition(locPosition);
    marker.setMap(map);

    infowindow.setContent(content);
    infowindow.open(map, marker);

    map.setCenter(locPosition); // 지도 중심을 접속 위치로 설정

    // 입력창에 주소를 입력합니다
    document.getElementById('post_address').value = address;
}

// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
            
            var content = '<div class="bAddr">' +
                            '<span class="title">직거래 위치</span><br>' + 
                            detailAddr + 
                        '</div>';

            // 마커를 클릭한 위치에 표시합니다 
            marker.setPosition(mouseEvent.latLng);
            marker.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            infowindow.setContent(content);
            infowindow.open(map, marker);

            // 입력창에 클릭한 좌표의 주소를 입력합니다
            document.getElementById('post_address').value = detailAddr;
        }   
    });
});

// 주소 검색 함수
function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}
</script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	// 숫자 이외의 문자를 입력하지 않도록 처리
    function checkNumberInput(input) {
        // 숫자가 아닌 값은 빈 문자열로 대체합니다.
        input.value = input.value.replace(/[^0-9]/g, '');
    }

	// 상품 설명 글자 수 업데이트
	function updateCharCount() {
		var content = document.getElementById('post_content').value;
		document.querySelector('.char-count').innerText = content.length + " / 1000";
	}
	
	// 거래 방법 선택에 따라 post_way_num 값 설정
	function setPostWayNum() {
	    const deliveryChecked = document.getElementById('delivery').checked;
	    const directChecked = document.getElementById('direct').checked;
	    const postWayInput = document.getElementById('post_way_num');
	    
	    const mapContainer = document.getElementById('mapContainer');
	    
	    if (deliveryChecked && directChecked) {
	        postWayInput.value = '3'; // 택배거래와 직거래 둘 다 선택됨
	    } else if (deliveryChecked) {
	        postWayInput.value = '1'; // 택배거래만 선택됨
	    } else if (directChecked) {
	        postWayInput.value = '2'; // 직거래만 선택됨
	    } else {
	        postWayInput.value = '';  // 아무 것도 선택되지 않음
	    }
	    
	    //checkFormCompletion(); // 거래 방식 선택 시 폼 완료 상태 확인
	}
	
    // 직거래 체크박스 선택 시 지도 및 주소 입력창 보이게
	function toggleMapVisibility() {
        const directChecked = document.getElementById('direct').checked;
        const mapContainer = document.getElementById('mapContainer');
        const addressInput = document.getElementById('post_address');
        
        if (directChecked) {
            mapContainer.style.display = 'block'; // 직거래 체크 시 지도와 주소 입력창 보이기
            
            setTimeout(function() {
                map.relayout(); // 지도가 보이게 된 후 다시 그리기
            }, 100); // 약간의 지연 후 호출 (비동기 처리 문제 방지)
        } else {
            mapContainer.style.display = 'none';  // 체크 해제 시 숨기기
            addressInput.value = '';  // 주소 입력창 값 초기화
        }
    }
	// 선택된 파일 정보를 저장할 전역 변수
	var savedFiles = [];
	const previewContainer = document.getElementById('previewContainer');
    const fileCount = document.getElementById('fileCount');
    var selectedCount
	// 이미지 파일 미리보기 처리
	function handleFiles(files) {
	    const maxFiles = 10;
		
	 	// 파일 선택 여부 확인
 	    if (!files || files.length === 0) {
 	    	displayPreviews(savedFiles);
	        return; // 선택된 파일이 없으면 기존 미리보기를 유지하고 함수 종료
	    } 
 		// 새로 선택된 파일 정보 저장
	 	const newFiles = Array.from(files);
 	   	savedFiles = savedFiles.concat(newFiles);
 	   	
 	   	selectedCount = savedFiles.length;
	    
 		// 파일 개수가 10개를 초과할 경우 경고
	    if (selectedCount > maxFiles) {
	        alert("최대 10장까지 이미지를 업로드할 수 있습니다.");
	        document.getElementById('fileInput').value = ''; // 파일 입력 초기화
	        savedFiles = savedFiles.filter(item => !newFiles.includes(item)); //초과 선택했던 파일들 제거
	        return;
	    }
	    
		 // 새로운 파일들로 미리보기 생성
 	    displayPreviews(savedFiles);
	
	    // 파일 개수 업데이트
	    fileCount.innerText = selectedCount + "/10 사진 선택됨";
	}
 	// 미리보기 생성 함수
	function displayPreviews(files) {
		// 미리보기 컨테이너 초기화
	    previewContainer.innerHTML = '';
		// 각 파일을 Promise로 처리하여 onload 이벤트 순서를 보장
	    const readFilePromises = files.map((file, index) => {
	        return new Promise((resolve) => {
	            const reader = new FileReader();
	            reader.onload = function (e) {
	                resolve({ src: e.target.result, index: index });
	            };
	            reader.readAsDataURL(file);
	        });
	    });
		// 모든 파일이 읽힌 후 순서대로 미리보기 생성
	    Promise.all(readFilePromises).then((results) => {
	        results.forEach(({ src, index }) => {
	            const previewDiv = document.createElement('div');
	            previewDiv.classList.add('image-preview');
	            const closeButton = document.createElement('button');
	            closeButton.innerHTML = '&times;'; // × 표시
	            closeButton.type = 'button';
	            closeButton.dataset.index = index;
	            closeButton.classList.add('close-button'); // CSS 클래스 추가
	            const imgElement = document.createElement('img');
	            imgElement.src = src;
	            imgElement.dataset.index = index; // 파일 순서를 유지할 데이터 속성 추가
	            previewDiv.appendChild(imgElement);
	            previewDiv.appendChild(closeButton);
	            previewContainer.appendChild(previewDiv);
	        });
	    });	       
	}
	//미리보기 x삭제버튼 클릭시
	$(document).on('click', '.close-button', function(){
		let index = $(this).data('index');
		if(index >= 0){ // 새로 추가된거
			savedFiles.splice(index, 1);
			$(this).parent().remove();
			selectedCount = savedFiles.length;
		    fileCount.innerText = selectedCount + "/10 사진 선택됨";
		}		
	});
	// 등록버튼 클릭
	$('#uploadForm').submit(function(e){
		e.preventDefault();
	 	const formData = new FormData(this);
		// savedFiles 배열에 있는 파일들을 formData에 추가
		savedFiles.forEach(file => {
			console.log(file.name);
		  formData.append("files", file); // "files"는 컨트롤러에서 받을 파라미터 이름
		}); 
       $.ajax({
	   		async : true, //비동기 : true(비동기), false(동기)
	   		url : '<c:url value="/post/insert"/>', 
	   		type : 'post',
	   		data : formData,
	   		contentType: false,  // 서버로 전송 시 `multipart/form-data`가 자동 설정되도록
	   	    processData: false,  // jQuery가 데이터를 자동으로 처리하지 않도록 설정 
	   		success : function (data){
	   			console.log("Upload success:", data);
	   			let str = data;
	   			let result = str.split("::")[0];
	   			let post_num = str.split("::")[1];
	   			if(result == 'REGISTRATION_POST'){
	   				location.href = `<c:url value="/post/detail/\${post_num}"/>`;
	   			}else {
	   				alert('상품 등록에 실패하였습니다.');
	   			}
	   		}, 
	   		error : function(jqXHR, textStatus, errorThrown){
	   			console.error("Upload failed:", error);
	   		}
	   	});
		
	});
	
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
	    var priceInput = document.getElementById('post_price');
	
	    // 모든 버튼을 기본 상태로 되돌림
	    document.querySelectorAll('.btn-option').forEach(btn => {
	        btn.style.backgroundColor = 'white';
	        btn.style.color = 'black';
	    });
	
	    // 선택된 버튼의 스타일 변경
	    const selectedBtn = document.getElementById('option' + option);
	    selectedBtn.style.backgroundColor = '#7590bd'; // 파란색 배경
	    selectedBtn.style.color = 'white'; // 하얀색 글자
	
	    // 숨겨진 필드에 선택된 값 저장
	    document.getElementById('selectedOption').value = option;
	
	    // post_position_num 값 변경
	    let postPositionNum;
	    switch (option) {
	        case 1:
	            postPositionNum = 1; // 판매한다
	            priceInput.removeAttribute('readonly');
	            break;
	        case 2:
	            postPositionNum = 2; // 구매한다
	            priceInput.removeAttribute('readonly');
	            break;
	        case 3:
	            postPositionNum = 3; // 무료나눔
	            priceInput.value = 0;
	            priceInput.setAttribute('readonly', 'readonly');
	            break;
	    }
	    
	    // 스타일 변경 후 toggleDealCheckbox 호출
	    // 무료나눔이나 구매한다가 아닌 경우에만 흥정 체크박스를 활성화
	    toggleDealCheckbox(option === 1); // 판매한다일 때만 흥정 체크박스 활성화
	    
	    document.getElementById('post_position_num').value = postPositionNum;
	}
    
    // 흥정 받기 체크박스를 활성화/비활성화하는 함수 (비활성화 시 숨김 처리)
	function toggleDealCheckbox(enable) {	
	    const dealCheckbox = document.getElementById('post_deal');
	    const dealCheckboxContainer = document.getElementById('dealCheckboxContainer');
	
	    if (enable) {
	        dealCheckboxContainer.style.display = 'block'; // 체크박스 보이기
	    } else {
	        dealCheckbox.checked = false;  // 체크 해제
	        dealCheckboxContainer.style.display = 'none';  // 체크박스 숨기기
	    }
	}
    
	// 주소 입력창 값을 null로 설정
    function setPostPosition() {
        const directChecked = document.getElementById('direct').checked;
        const addressInput = document.getElementById('post_address');

        // 직거래 체크박스가 해제된 경우
        if (!directChecked) {
            addressInput.value = null;  // 주소 입력창 값을 null로 설정
        }
    }
	
	
	// 필수 필드 검증 함수
	function validateForm(event) {
		const title = document.getElementById("post_title").value.trim();
		const price = document.getElementById("post_price").value.trim();
		const content = document.getElementById("post_content").value.trim();
		const address = document.getElementById("post_address").value.trim();
		
		// 거래 방법 체크 확인
        const transactionCheckboxes = document.querySelectorAll('input[name="transaction"]');
        const isTransactionSelected = Array.from(transactionCheckboxes).some(checkbox => checkbox.checked);
        const directChecked = document.getElementById('direct').checked;
        
        // 파일 첨부 확인
        const fileInput = document.getElementById("fileInput");
        const filesAttached = selectedCount > 0;
        setPostWayNum();
		if (!title && !price && !content) {
			alert("상품명, 금액, 상품 설명을 모두 입력해주세요.");
			event.preventDefault(); // 폼 제출 중단
		} else if (!title) {
			alert("상품명을 입력해주세요.");
			event.preventDefault(); // 폼 제출 중단
		} else if (!price) {
			alert("금액을 입력해주세요.");
			event.preventDefault(); // 폼 제출 중단
		} else if (!content) {
			alert("상품 설명을 입력해주세요.");
			event.preventDefault(); // 폼 제출 중단
		}else if (!isTransactionSelected) {
	            alert("거래 방법을 선택해주세요.");
	            event.preventDefault(); // 폼 제출 중단
	            return;
	    } else if (directChecked && !address) {
            alert("직거래 주소를 선택해주세요.");
            event.preventDefault(); // 폼 제출 중단
            return;
    	} else {
	        if (!filesAttached) {
	            alert("최소한 하나의 사진을 첨부해주세요.");
	            event.preventDefault(); // 폼 제출 중단
	            return;
	        }
	    }
	
	}
</script>
</body>
</html>