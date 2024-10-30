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
        <th>신고 받은 횟수</th> 
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
        <td><button>정지</button></td>
      </tr>
   	</c:forEach>
   </tbody>
</table>
<script>
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
$(document).on('click','.member-link',function(){
	let member_num = $(this).data('member_num');
	location.href = `<c:url value="/report/detail/member/\${member_num}"/>`
});

</script>