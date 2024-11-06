<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>충전 내역</title>
</head>
<body>
    <div class="container">
        <h2>충전 내역</h2>
        
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>충전 날짜</th>
                    <th>충전 금액</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="point" items="${pointList}">
                    <tr>
                        <td><fmt:formatDate value="${point.point_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${point.point_money}원</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <a href="<c:url value='/wallet/point'/>" class="btn btn-primary">충전하기</a>
    </div>

</body>
</html>
