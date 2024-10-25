<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
	<h1>포인트 : ${point}</h1>
    
    <form action="/market/wallet/point" method="post">
	    <!-- 결제 금액 -->
	    <label for="point_money">충전 금액:</label>
	    <input type="number" id="point_money" name="point_money" min="1000" required><br><br>
	    
	    <input type="radio" id="kakao" name="paymentMethod" value="kakaopay" required>
        <label for="kakao">카카오페이</label><br>

        <input type="radio" id="toss" name="paymentMethod" value="tosspay" required>
        <label for="toss">토스페이</label><br>
    
	    <input type="submit" value="결제하기">
	</form>
	
</body>

</html>

