<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<title>찜목록</title>
<head>
 <style>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
    }
    img {
        width: 100px;
        height: auto;
    }
    .up-button, .edit-button, .hide-button {
        padding: 5px 10px;
        background-color: #f0f0f0;
        border: 1px solid #ccc;
        cursor: pointer;
    }
    .page-number {
        text-align: center;
        margin-top: 10px;
    }
    .page-number span {
        padding: 5px 10px;
        background-color: #ff5252;
        color: white;
        border-radius: 3px;
    }
    .type-selected {
    	color: red;
    }
    .btn-func {
    	margin-top: 5px; 
    	border: 1px solid black; border-radius: 2px;
    	cursor: pointer;
    }
</style>
</head>
<body>
<div class="container">
	<h2>내 상점관리 ${list.size()}</h2>
    <form action="<c:url value="/mypage/post/list"/>" id="form">
	    <div>
	    	<input type="hidden" name="type" value="${pm.cri.type}">
	    	<input type="hidden" name="page" value="${pm.cri.page}">
	        <input type="text" name="search" value="${pm.cri.search}" placeholder="상품명을 입력해주세요."/>
	        <button id="btn-search" type="submit"><i class="fa-solid fa-magnifying-glass"></i>검색</button>
	        <select id="perPageSelect" name="perPageNum">
	            <option value="10" <c:if test="${pm.cri.perPageNum == 10}">selected</c:if>>10개씩</option>
	            <option value="20" <c:if test="${pm.cri.perPageNum == 20}">selected</c:if>>20개씩</option>
	            <option value="50" <c:if test="${pm.cri.perPageNum == 50}">selected</c:if>>50개씩</option>
	        </select>
	        <button id="btn-all" class="<c:if test="${pm.cri.type == '' }">type-selected</c:if>">전체</button>
	        <button id="btn-selling" class="<c:if test="${pm.cri.type == 'selling' }">type-selected</c:if>">판매중</button>
	        <button id="btn-buying" class="<c:if test="${pm.cri.type == 'buying' }">type-selected</c:if>">구매중</button>
	        <button id="btn-reserved" class="<c:if test="${pm.cri.type == 'reserved' }">type-selected</c:if>">예약중</button>
	        <button id="btn-soldout" class="<c:if test="${pm.cri.type == 'soldout' }">type-selected</c:if>">거래완료</button>
	        <button id="btn-forfree" class="<c:if test="${pm.cri.type == 'forfree' }">type-selected</c:if>">무료나눔</button>
	    </div>
    </form>
    <table>
        <thead>
            <tr>
                <th>사진</th>
                <th>거래상태</th>
                <th>상품명</th>
                <th>가격</th>
                <th>찜</th>
                <th>등록일</th>
                <th>기능</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach items="${list }"	var="post">
            <tr>
                <td>
	                <a href="<c:url value="/post/detail/${post.post_num}"/>">
		                <img class="thumbnail" data-post_num="${post.post_num}"
			                src="<c:url value="/resources/img/none_image.jpg"/>" 
			                onerror="this.onerror=null; this.src='<c:url value="/resources/img/none_image.jpg"/>';"
			                alt="none" />
	                </a>
	            </td>
                <td>
                    <select class="state" data-post_num="${post.post_num}">
                    	<c:choose>
	                    	<c:when test="${post.post_position_num == 1}">
	                    		<option value="1" <c:if test="${post.post_position_num == 1}">selected</c:if>>판매중</option>
		                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
		                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
	                    	</c:when>
	                    	<c:when test="${post.post_position_num == 2}">
		                        <option value="2" <c:if test="${post.post_position_num == 2}">selected</c:if>>구매중</option>
		                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
		                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
	                    	</c:when>
	                    	<c:when test="${post.post_position_num == 3}">
		                        <option value="3" <c:if test="${post.post_position_num == 3}">selected</c:if>>무료나눔</option>
		                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
		                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<option value="1" <c:if test="${post.post_position_num == 1}">selected</c:if>>판매중</option>
	                    		<option value="2" <c:if test="${post.post_position_num == 2}">selected</c:if>>구매중</option>
	                    		<option value="3" <c:if test="${post.post_position_num == 3}">selected</c:if>>무료나눔</option>
		                        <option value="4" <c:if test="${post.post_position_num == 4}">selected</c:if>>예약중</option>
		                        <option value="5" <c:if test="${post.post_position_num == 5}">selected</c:if>>거래완료</option>
	                    	</c:otherwise>
						</c:choose>
                    </select>
                </td>
                <td><a href="<c:url value="/post/detail/${post.post_num}"/>">${post.post_title}</a></td>
                <td>${post.post_price}</td>
                <td>${post.post_view}</td>
                <td>
                	<fmt:formatDate value="${post.post_refresh}" pattern="yyy-MM-dd hh:mm"/>
                	
                </td>
                <td>
                    <div class="btn-func refresh" data-post_num="${post.post_num}">끌올</div>
                    <div class="btn-func edit" data-post_num="${post.post_num}">수정</div>
                    <div class="btn-func delete" data-post_num="${post.post_num}">삭제</div>
                </td>
            </tr>
		</c:forEach>
        </tbody>
    </table>
    
    <!-- 모달 창 -->
    <div id="chatRoomModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: white; padding: 20px; border: 1px solid black; z-index: 1000;">
        <h2>채팅방 선택</h2>
        <ul id="chatRoomList" style="list-style: none; padding: 0; margin: 10px 0; max-height: 200px; overflow-y: auto; border: 1px solid #ccc;"></ul>
        <button onclick="completeTransaction()">거래 완료</button>
        <button onclick="closeChatRoomModal()">닫기</button>
    </div>

    <!-- 배경 오버레이 -->
    <div id="modalOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 999;"></div>
    
    <div class="page-number">
        <ul class="pagination justify-content-center">
        	<c:if test="${pm.prev}">
			    <li class="page-item"><a class="page-link" id="pn-prev" href="javascript:void(0);">이전</a></li>
        	</c:if>
        	<c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">   
       			<c:choose>
					<c:when test="${pm.cri.page eq i }">
						<c:set var="active" value="active" />
					</c:when>
					<c:otherwise>
						<c:set var="active" value="" />
					</c:otherwise>
				</c:choose>    		
			    <li class="page-item ${active}"><a class="page-link" href="javascript:void(0);"
			    	data-page="${i}">${i}</a></li>
        	</c:forEach>
		    <c:if test="${pm.next}">
			    <li class="page-item"><a class="page-link" id="pn-next" href="javascript:void(0);">다음</a></li>
		    </c:if>
		  </ul>
    </div>
    
</div>	
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {	
	
	// 썸네일 불러오기
	$('.thumbnail').each(function (){
		var post_num = $(this).data('post_num');
		var thumbnail = $(this);
		// 선택된 거래상태 항목 안보이게
		var state = $(this).closest('tr').find('.state');
		if(state.data('post_num') == post_num){
			state.find('option[selected]').hide();
		}
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/mypage/post/thumbnail"/>', 
			type : 'post', 
			data : {post_num : post_num}, 
			success : function (data){
				if(data.file_name != null){
					var str = `<c:url value="/uploads/\${data.file_name}"/>`;
					$(thumbnail).attr('src', str);
					$(thumbnail).attr('alt', data.file_ori_name);
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
	});
    
 	// 표시 개수 선택
	$('#perPageSelect').change(function(){
		var perPageNum = $(this).val();
		if(perPageNum){
			location.href = `<c:url value="/mypage/post/list?perPageNum=\${perPageNum}"/>`
		}
	});
	// 전체 선택
	$('#btn-all').click(function(){
		$('[name=type]').val('');
		$('#form').submit();
	});
	// 판매중
	$('#btn-selling').click(function(){
		$('[name=type]').val('selling');
		$('#form').submit();
	});
	// 구매중
	$('#btn-buying').click(function(){
		$('[name=type]').val('buying');
		$('#form').submit();
	});
	// 예약중
	$('#btn-reserved').click(function(){
		$('[name=type]').val('reserved');
		$('#form').submit();
	});
	// 거래완료
	$('#btn-soldout').click(function(){
		$('[name=type]').val('soldout');
		$('#form').submit();
	});  
	// 무료나눔
	$('#btn-forfree').click(function(){
		$('[name=type]').val('forfree');
		$('#form').submit();
	});  
	
	// 페이지 네이션
	$('.page-link').click(function(){
		var page = $(this).data('page');
		$('[name=page]').val(page);
		$('#form').submit();
	});
	$('#pn-prev').click(function(){
		var page = ${pm.startPage} - 1;
		$('[name=page]').val(page);
		$('#form').submit();
	});
	$('#pn-next').click(function(){
		var page = ${pm.endPage} + 1;
		$('[name=page]').val(page);
		$('#form').submit();
	});
	//끌올
	$('.btn-func.refresh').click(function(){
		var renewal = false;
		var post_num = $(this).data('post_num');
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/mypage/refresh/check"/>', 
			type : 'post', 
			data : {post_num : post_num}, 
			success : function (data){
				if(data == -1){
					alert('더 이상 끌올을 할 수 없습니다.');
				} else if(data == -2){
					renewal = true;					
				} else {
					alert(data + '일 후에 가능합니다.');
				}
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
		if(renewal){
			if(confirm('끌어 올립니까?')){			
				$.ajax({
					async : true, //비동기 : true(비동기), false(동기)
					url : '<c:url value="/mypage/post/refresh"/>', 
					type : 'post', 
					data : {post_num : post_num}, 
					success : function (data){
						if(data){
							alert('끌올 성공.');
						}else {
							alert('끌올 실패');
						}
						location.reload();
					}, 
					error : function(jqXHR, textStatus, errorThrown){
					}
				});
			}		
		}
	});
	//삭제
	$('.btn-func.delete').click(function(){
		if(confirm('정말 삭제하시겠습니까?')){
			var post_num = $(this).data('post_num');
			$.ajax({
				async : true, //비동기 : true(비동기), false(동기)
				url : '<c:url value="/mypage/post/delete"/>', 
				type : 'post', 
				data : {post_num : post_num}, 
				success : function (data){
					if(data){
						alert('삭제하였습니다.');
					}else {
						alert('삭제하지 못했어요');
					}
					location.reload();
				}, 
				error : function(jqXHR, textStatus, errorThrown){
				}
			});
		}		
	});
	
});
// 거래 상태 변경
$(document).on('change','.state', function(){
	var state = $(this).val();
	var post_num = $(this).data('post_num');
	var memberNum = ${sessionScope.memberNum};
	$(this).find('option').show();
	console.log(state);
	if(state == '1'){
		$(this).find('option[value="2"]').hide();
		$(this).find('option[value="3"]').hide();
	}
	if(state == '2'){
		$(this).find('option[value="1"]').hide();
		$(this).find('option[value="3"]').hide();
	}
	if(state == '3'){
		$(this).find('option[value="1"]').hide();
		$(this).find('option[value="2"]').hide();
	}
	if(state == '5'){
		openChatRoomModal();
	}
	$(this).find('option[value="' + state + '"]').hide();
	let obj = {
			post_num : post_num,
			post_position_num : state
	}
	// 거래 상태 업데이트 요청
	$.ajax({
	    async: true,
	    url: '<c:url value="/mypage/post/state"/>', 
	    type: 'post', 
	    data: JSON.stringify(obj), 
	    contentType: "application/json; charset=utf-8",
	    success: function(data) {
	        alert("거래 상태가 업데이트되었습니다.");
	    },
	    error: function(jqXHR, textStatus, errorThrown) {
	        alert("거래 상태 업데이트 실패:", textStatus, errorThrown);
	    }
	});
    
	// 모달 열기 함수
    function openChatRoomModal() {
        document.getElementById('chatRoomModal').style.display = 'block';
        document.getElementById('modalOverlay').style.display = 'block';
        loadChatRooms();
    }

    // 채팅방 목록 불러오기
    function loadChatRooms() {
        fetch('/market/mypage/chatRooms')
            .then(response => response.json())
            .then(data => {
                console.log("서버에서 받은 데이터:", data);  // 데이터를 콘솔에 출력하여 확인
                const chatRoomList = document.getElementById('chatRoomList');
                chatRoomList.innerHTML = '';  // 기존 목록 초기화

                if (data.length === 0) {
                    chatRoomList.innerHTML = '<li>채팅방이 없습니다.</li>';
                    return;
                }

                data.forEach(room => {
                    console.log("각 room 데이터:", room);  // 각 room 객체를 확인
                    const listItem = document.createElement('li');
                    
                    // 데이터 접근 수정
                    const chatRoomId = room.chatRoom ? room.chatRoom.chatRoom_num : "No Chat Room ID";
                    const targetMemberId = room.targetMember ? room.targetMember.member_id : "No ID";
                    
                    listItem.textContent = targetMemberId;
                    listItem.setAttribute('data-room-id', chatRoomId);
                    listItem.style.cursor = 'pointer';
                    listItem.style.padding = '8px';
                    listItem.style.borderBottom = '1px solid #ddd';
                    listItem.onclick = () => selectChatRoom(chatRoomId);
                    chatRoomList.appendChild(listItem);
                });
            })
            .catch(error => console.error('채팅방 리스트 불러오기 오류:', error));
	}
});

// 선택된 채팅방 ID 저장
let selectedChatRoomId = null;

function selectChatRoom(chatRoomId) {
    selectedChatRoomId = chatRoomId;
    console.log("선택된 채팅방 ID:", chatRoomId);  // chatRoomId가 올바른지 확인
    alert('선택된 채팅방 ID: ' + chatRoomId);
}

function completeTransaction() {
    if (selectedChatRoomId) {
        fetch('/market/mypage/completeTransaction', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ chatRoomNum: selectedChatRoomId }) // JSON 형식으로 데이터 전송
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error("거래 완료 요청이 실패했습니다.");
            }
        })
        .then(result => {
            alert('거래 완료: ' + result.message);
            closeChatRoomModal();
            location.reload(); // 새로고침으로 UI 업데이트
        })
        .catch(error => {
            console.error('거래 완료 오류:', error);
            alert('거래 완료 중 오류가 발생했습니다. 다시 시도해 주세요.');
        });
    } else {
        alert('채팅방을 선택해주세요.');
    }
}


function closeChatRoomModal() {
    document.getElementById('chatRoomModal').style.display = 'none';
    document.getElementById('modalOverlay').style.display = 'none';
}
    

	
</script>
</body>
</html>