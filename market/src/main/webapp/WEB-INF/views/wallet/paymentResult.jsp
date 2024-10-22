<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>

	<!-- 결제 성공 여부에 따라 메시지 표시 -->
	<c:choose>
	    <c:when test="${not empty point.point_num}">
	        <!-- 결제가 성공한 경우 -->
	        <h3>결제가 성공했습니다!</h3>
	        <p>결제 타입: 포인트 충전</p>
	        <p>금액: ${point.point_money}원</p>
	        <p>결제일: ${point.point_date}</p>
	    </c:when>
	    <c:otherwise>
	        <!-- 결제 실패한 경우 -->
	        <h3>결제가 실패했습니다.</h3>
	        <p>잠시 후 다시 시도해주세요.</p>
	    </c:otherwise>
	</c:choose>
	
	<a href="${pageContext.request.contextPath}/home">홈으로 돌아가기</a>

</body>
</html>
