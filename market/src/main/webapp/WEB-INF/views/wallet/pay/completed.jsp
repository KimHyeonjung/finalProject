<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<div class="container centered-container">
   <div class="mt-3">
	   <h1>결제가 완료되었습니다.</h1>
	</div>
	<div class="mt-5">
	   <p>주문해 주셔서 감사합니다!</p>
	</div>
	<div class="mt-5">
	   <a href="/market" id="home-link">홈으로 돌아가기</a>
	</div>
</div>
<script>
    $(document).ready(function() {
        updateHeader();
    });
</script>
</body>
</html>
