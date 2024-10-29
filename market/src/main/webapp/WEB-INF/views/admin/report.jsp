<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
#table-post, #table-user {
	display: none;
}
.link {cursor: pointer;}
</style>
</head>
<body>
	<div class="container">
		<h2 class="report-title mt-3">게시글 신고 현황</h2>
		<button type="button" class="btn btn-outline-dark" id="btn-post">게시물</button>
		<button type="button" class="btn btn-outline-dark" id="btn-user">유저</button>
		<div id="table-post">
			<select id="postReportList">
				<c:forEach items="${rcp }" var="category">
					<option value="${category.report_category_num }">${category.report_category_name}</option>			
				</c:forEach>
			</select>
			<table class="table table-hover">
		    	<thead>
			      <tr>
			        <th>제목</th>
			        <th>날짜</th>
			        <th>작성자</th>
			        <th>게시글 신고 횟수</th>        
			      </tr>
			    </thead>
			    <tbody>
			    	<c:forEach items="${postList }" var="post">
				      <tr class="link post-link" data-post_num="${post.report_post_num }">
				        <td>${post.post_title}</td>
				        <td>${post.post_date}</td>
				        <td>${post.member_id}(${post.member_nick})</td>
				        <td>${post.post_report}</td>
				      </tr>
			    	</c:forEach>
			    </tbody>
		  	</table>
		</div>
		<div id="table-user">
			<select id="memberReportList">
				<c:forEach items="${rcm }" var="category">
					<option value="${category.report_category_num }">${category.report_category_name}</option>			
				</c:forEach>
			</select>
			<table class="table table-hover">
		    	<thead>
			      <tr>
			        <th>신고받은 회원</th>
			        <th>회원 상태</th>
			        <th>회원 점수</th>
			        <th>신고 횟수</th> 
			      </tr>
			    </thead>
			    <tbody>
			    	<c:forEach items="${userList }" var="user">
				      <tr class="link member-link" data-member_num="member_report_num2">
				        <td>${user.member_id}(${user.member_nick})</td>
				        <td>${user.member_state}</td>
				        <td>${user.member_score}</td>
				        <td>${user.member_report}</td>
				      </tr>
			    	</c:forEach>
			    </tbody>
		  	</table>
		</div>
	</div>
<script>
$(document).ready(function(){
	
	$('#btn-post').click(function(){
		$('.report-title').text('게시물 신고 내역');
		$('[id^=table]').hide();
		$('#table-post').show();
	});
	$('#btn-user').click(function(){
		$('.report-title').text('유저 신고 내역');
		$('[id^=table]').hide();
		$('#table-user').show();
	});
	
	$('.post-link').click(function(){
		let post_num = $(this).data('post_num');
		location.href = `<c:url value="/report/detail/post/\${post_num}"/>`
	});
	$('.member-link').click(function(){
		let member_num = $(this).data('member_num');
		location.href = `<c:url value="/report/detail/member/\${member_num}"/>`
	});
	
	$('#postReportList').on('focus', function() {
        $(this).prop('selectedIndex', -1); // 기본 선택 해제
    });
	$('#memberReportList').on('focus', function() {
        $(this).prop('selectedIndex', -1); // 기본 선택 해제
    });
	$('#postReportList').change(function(){
		let category_num = $(this).val();
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/list/post"/>', 
			type : 'post', 
			data : {category_num : category_num}, 
			success : function (data){	
				$('#table-post').find('table').html(data);
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	});
	$('#memberReportList').change(function(){
		let category_num = $(this).val();
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/list/member"/>', 
			type : 'post', 
			data : {category_num : category_num}, 
			success : function (data){	
				$('#table-user').find('table').html(data);
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	});
});
</script>
</body>
</html>