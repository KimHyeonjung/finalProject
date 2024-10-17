<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<title>찜목록</title>
<head>
<!-- 폰트어썸 -->
<script src="https://kit.fontawesome.com/c9d8812a57.js"
	crossorigin="anonymous"></script>
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
    </style>
</head>
<body>
<div class="container">
	<h2>내 상점관리 ${list.size()}</h2>
    <form action="<c:url value="/mypage/post/list"/>" id="form">
	    <div>
	    	<input type="hidden" name="type">
	    	<input type="hidden" name="page">
	        <input type="text" name="search" value="${cri.search }" placeholder="상품명을 입력해주세요."/>
	        <button id="btn-search" type="submit">검색</button>
	        <select id="perPageSelect" name="perPageNum">
	            <option value="2" <c:if test="${cri.perPageNum == 2}">selected</c:if>>10개씩</option>
	            <option value="3" <c:if test="${cri.perPageNum == 3}">selected</c:if>>20개씩</option>
	            <option value="4" <c:if test="${cri.perPageNum == 4}">selected</c:if>>50개씩</option>
	        </select>
	        <button id="btn-all" class="<c:if test="${cri.type == '' }">type-selected</c:if>">전체</button>
	        <button id="btn-selling" class="<c:if test="${cri.type == 'selling' }">type-selected</c:if>">판매중</button>
	        <button id="btn-reserved" class="<c:if test="${cri.type == 'reserved' }">type-selected</c:if>">예약중</button>
	        <button id="btn-soldout" class="<c:if test="${cri.type == 'soldout' }">type-selected</c:if>">거래완료</button>
	    </div>
    </form>
    <table>
        <thead>
            <tr>
                <th>사진</th>
                <th>판매상태</th>
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
                <td><img src="<c:url value="/post/detail/${post.post_num}"/>" alt="카피바라" /></td>
                <td>
                    <select class="state" data-post_num="${post.post_num}">
                        <option value="1" <c:if test="${post.post_position_num == 1}">selected</c:if>>판매중</option>
                        <option value="2" <c:if test="${post.post_position_num == 2}">selected</c:if>>예약중</option>
                        <option value="3" <c:if test="${post.post_position_num == 3}">selected</c:if>>거래완료</option>
                    </select>
                </td>
                <td><a href="<c:url value="/post/detail/${post.post_num}"/>">${post.post_title}</a></td>
                <td>${post.post_price}</td>
                <td>${post.post_view}</td>
                <td>${post.post_date}</td>
                <td>
                    <div class="refresh">끌올</div>
                    <div class="edit">수정</div>
                    <div class="delete">삭제</div>
                </td>
            </tr>
		</c:forEach>
        </tbody>
    </table>
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
<script>
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
	// 선택된 거래상태 항목 안보이게
	$(document).ready(function() {		
	    $('.state').each(function (){
	    	$(this).find('option[selected]').hide();
	    });	    
	    
    });
	// 거래 상태 변경
	$(document).on('change','.state', function(){
		let state = $(this).val();
		let post_num = $(this).data('post_num');
		$(this).find('option').show();
		$(this).find('option[value="' + state + '"]').hide();
		let obj = {
				post_num : post_num,
				post_position_num : state
		}
		$.ajax({
			async : true, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/mypage/post/state"/>', 
			type : 'post', 
			data : JSON.stringify(obj), 
			contentType : "application/json; charset=utf-8",
			success : function (data){
			}, 
			error : function(jqXHR, textStatus, errorThrown){
			}
		});
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
</script>
</body>
</html>
