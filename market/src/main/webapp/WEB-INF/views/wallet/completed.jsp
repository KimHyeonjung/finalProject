<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
   <h1>결제가 완료되었습니다.</h1>
   <p>주문해 주셔서 감사합니다!</p>
   <a href="/market">홈으로 돌아가기</a>
   
   <script>
    $(document).ready(function() {
        updateHeader();
    });
</script>
</body>
</html>
