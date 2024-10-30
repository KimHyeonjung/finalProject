<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
#table-user {
	display: none;
}
.link {cursor: pointer;}
</style>
</head>
<body>
	<div class="container">
		<h2 class="report-title mt-3">게시물 신고 내역</h2>
		<button type="button" class="btn btn-outline-dark" id="btn-post">게시물</button>
		<button type="button" class="btn btn-outline-dark" id="btn-user">유저</button>
		<div id="table-report">
			
		</div>
	</div>
<script>
$(document).ready(function(){
	$('#btn-post').click(function(){
		$('.report-title').text('게시물 신고 내역');
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/postList"/>', 
			type : 'post', 
			success : function (data){	
				$('#table-report').html(data);
			}, 
			error : function(jqXHR, textStatus, errorThrown){
				console.log(jqXHR);
			}
		});	
	});
	$('#btn-post').click();
	$('#btn-user').click(function(){
		$('.report-title').text('유저 신고 내역');
		$.ajax({
			async : false, //비동기 : true(비동기), false(동기)
			url : '<c:url value="/report/memberList"/>', 
			type : 'post', 
			success : function (data){	
				$('#table-report').html(data);
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