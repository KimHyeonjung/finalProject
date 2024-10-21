<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
	<h1>포인트 : ${user.member_money}</h1>
    
    <table border="1">
        <thead>
            <tr>
                <th>이용 금액</th>
                <th>이용 날짜</th>
                <th>이용 방식 (충전 / 사용)</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="point" items="${pointList}">
                <tr>
                    <td>${point.point_money}</td>
                    <td>${point.point_date}</td>
                    <td>${point.point_type}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <a href="${pageContext.request.contextPath}/wallet/point">포인트 충전하기</a>
	
</body>
	
</html>

