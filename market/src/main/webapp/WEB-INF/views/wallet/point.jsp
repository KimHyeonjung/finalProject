<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>카카오페이 결제 페이지</title>
   <!-- jQuery 라이브러리 추가 -->
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
   <h1>카카오페이 결제 페이지</h1>
   <form id="paymentForm">
       <label for="totalPrice">충전 금액:</label>
       <input type="number" id="totalPrice" name="totalPrice" required><br><br>
       <button type="button" id="btn-pay-ready">결제하기</button>
   </form>
   <script type="text/javascript">
       $(function() {
           $("#btn-pay-ready").click(function(e) {
               let data = {
                   name: '중고날아',
                   totalPrice: parseInt($('#totalPrice').val())
               };
               $.ajax({
                   type: 'POST',
                   url: '/market/wallet/pay/ready',
                   data: JSON.stringify(data),
                   contentType: 'application/json',
                   success: function(response) {
                       location.href = response.next_redirect_pc_url;
                   },
                   error: function(error) {
                       alert("결제 준비에 실패했습니다.");
                       console.error(error);
                   }
               });
           });
       });
   </script>
</body>
</html>
