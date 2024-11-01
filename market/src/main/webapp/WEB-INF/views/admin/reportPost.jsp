<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<select id="postReportList">
	<option value="0" hidden>카테고리별 분류</option>
	<c:forEach items="${rcList }" var="category">
		<option value="${category.report_category_num }">${category.report_category_name}</option>			
	</c:forEach>
</select>
<table class="table table-hover">
   	<thead>
      <tr>
        <th>제목</th>
        <th>작성일</th>
        <th>작성자</th>
        <th>가장 많이 받은 신고 항목</th>
        <th>신고 받은 횟수</th>  
        <th>기능</th>      
      </tr>
    </thead>
    <tbody>
   		<c:forEach items="${list }" var="post">
		   <tr class="link post-link" data-post_num="${post.post_num }">
		     <td>
		     	<a href="<c:url value="/post/detail/${post.post_num }"/>">${post.post_title}</a>				        
		     </td>
		     <td>${post.post_date}</td>
		     <td>${post.member_id}(${post.member_nick})</td>
		     <td>${post.mostCategory}(${post.categoryCount})</td>
		     <td>${post.reportCount}</td>
		     <td>
		     	<c:if test="${post.post_state_num == 1 }">
			     	<button class="hide-button" type="button" data-post_num="${post.post_num }">숨김</button>
			     	<button class="use-button" type="button" data-post_num="${post.post_num }" disabled>사용</button>
		     	</c:if>
		     	<c:if test="${post.post_state_num == 2 }">
			     	<button class="hide-button" type="button" data-post_num="${post.post_num }" disabled>숨김</button>
			     	<button class="use-button" type="button" data-post_num="${post.post_num }" >사용</button>
		     	</c:if>
		     	<c:if test="${post.post_state_num == 3 }">
		     		<span style="color: red;">삭제된 게시물</span>
		     	</c:if>
		     </td>
		   </tr>
		</c:forEach>
  </tbody>
</table>
<script>
$(document).on('change', '#postReportList', function(){
	let category_num = $(this).val();
	$.ajax({
		async : false, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/list/post"/>', 
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
$('.post-link').click(function(event){
	let post_num = $(this).data('post_num');
	location.href = `<c:url value="/report/detail/post/\${post_num}"/>`
	event.stopPropagation();
});
$('.hide-button').click(function(event){
	let post_num = $(this).data('post_num');	
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/post/hide"/>', 
		type : 'post', 
		data : {post_num : post_num}, 
		success : function (data){	
			console.log(data);
			if(data){
				alert('게시물을 숨김 상태로 전환함');
				$('#btn-post').click();
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
	event.stopPropagation();
});
$('.use-button').click(function(event){
	let post_num = $(this).data('post_num');	
	$.ajax({
		async : true, //비동기 : true(비동기), false(동기)
		url : '<c:url value="/report/post/use"/>', 
		type : 'post', 
		data : {post_num : post_num}, 
		success : function (data){	
			console.log(data);
			if(data){
				alert('게시물을 사용 상태로 전환함');
				$('#btn-post').click();
			}
		}, 
		error : function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR);
		}
	});
	event.stopPropagation();
});
</script>