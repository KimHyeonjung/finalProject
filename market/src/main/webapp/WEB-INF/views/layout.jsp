<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Website</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <header>
        <tiles:insertAttribute name="header" />
    </header>

    <main>
        <tiles:insertAttribute name="content" />
    </main>

    <footer>
        <tiles:insertAttribute name="footer" />
    </footer>
<script type="text/javascript">
$(document).ready(function(){
	
	if(${user != null}){
		var userId = `${user.member_id}`; // 현재 로그인한 사용자의 ID
		var eventSource = new EventSource('<c:url value="/notification/subscribe/' + userId + '"/>');
		// 서버로부터 알림을 받았을 때 실행되는 이벤트 핸들러
		eventSource.onmessage = function(event) {
		    var notification = event.data;
		    alert("알림: " + notification); // 실시간 알림 표시
		};
		
		// 서버와 연결이 끊겼을 때
		eventSource.onerror = function(event) {
		    console.log("연결이 끊어졌습니다.");
		};
	}
});
</script>
</body>
</html>