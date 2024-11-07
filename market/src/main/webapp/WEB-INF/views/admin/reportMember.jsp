<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<select id="memberReportList">
<option hidden>카테고리별 분류</option>
<c:forEach items="${rcList }" var="category">
	<option value="${category.report_category_num }">${category.report_category_name}</option>			
</c:forEach>
</select>
<table class="table table-hover">
   	<thead>
      <tr>
        <th>신고대상</th>
        <th>회원 상태</th>
        <th>회원 점수</th>
        <th>가장 많이 받은 신고 항목</th>
        <th><span>신고 받은 횟수</span>
        	<c:if test="${order eq 'count_asc' }">
        		<i id="sortRMCount" class="fas fa-sort-up"></i>
        	</c:if>
        	<c:if test="${order eq 'count_desc' }">
        		<i id="sortRMCount" class="fas fa-sort-down"></i>
        	</c:if>
        	<c:if test="${order ne 'count_desc' && order ne 'count_asc'}">
        		<i id="sortRMCount" class="fas fa-sort"></i>
        	</c:if>
        </th> 
        <th>기능</th> 
      </tr>
    </thead>
    <tbody>
    	<c:forEach items="${list }" var="user">
      <tr class="link member-link" data-member_num="${user.report_member_num2}">
        <td>${user.member_id}(${user.member_nick})</td>
        <td>${user.member_state}</td>
        <td>${user.member_score}</td>
        <td>${user.mostCategory}</td>
        <td>${user.categoryCount}</td>
        <td>
        	<c:if test="${user.member_state eq '사용'}">
		     	<button class="suspend-button" type="button" data-member_num="${user.report_member_num2 }">정지</button>
		     	<button class="use-button" type="button" data-member_num="${user.report_member_num2 }" disabled>사용</button>
	     	</c:if>
	     	<c:if test="${user.member_state eq '정지'}">
		     	<button class="suspend-button" type="button" data-member_num="${user.report_member_num2 }" disabled>정지</button>
		     	<button class="use-button" type="button" data-member_num="${user.report_member_num2 }" >사용</button>
	     	</c:if>
	     	<c:if test="${user.member_state eq '휴면' }">
	     		<span style="color: red;">휴면 계정</span>
	     	</c:if>
        </td>
      </tr>
   	</c:forEach>
   </tbody>
</table>
<script>
$('#sortRMCount').click(function(){
	if(sortOrder != 'count_asc' && sortOrder != 'count_desc'){
		sortOrder = 'count_asc';
	}else if(sortOrder == 'count_asc'){
		sortOrder = 'count_desc';
	}else if(sortOrder == 'count_desc')	{
		sortOrder = 'count_asc';
	}
	$('#btn-user').click();
});
$(document).on('change', '#memberReportList', function(){
	let category_num = $(this).val();
	if(category_num == 0){
		location.href = `<c:url value="/report/list"/>`;
		$('#btn-user').click();
	}
	$.ajax({
		async : false, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/list/member"/>', 
		type : 'post', 
		data : {category_num : category_num}, 
		success : function (data){	
			$('#table-report').find('table').html(data);
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});	
});
$('.member-link').click(function(event){
	let member_num = $(this).data('member_num');
	location.href = `<c:url value="/report/detail/member/\${member_num}"/>`
});
$('.suspend-button').click(function(event){
	let member_num = $(this).data('member_num');	
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/member/suspend"/>', 
		type : 'post', 
		data : {member_num : member_num}, 
		success : function (data){	
			console.log(data);
			if(data){
				alert('계정을 정지 상태로 전환함');
				$('#btn-user').click();
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
	event.stopPropagation();
});
$('.use-button').click(function(event){
	let member_num = $(this).data('member_num');	
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/member/use"/>', 
		type : 'post', 
		data : {member_num : member_num}, 
		success : function (data){	
			console.log(data);
			if(data){
				alert('계정을 사용 상태로 전환함');
				$('#btn-user').click();
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
	event.stopPropagation();
});
</script>