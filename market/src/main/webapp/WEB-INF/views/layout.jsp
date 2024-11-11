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
$(document).ready(function() {
	if(${user != null}){
	    var socket = new WebSocket("ws://192.168.30.194:8080" + "<c:url value="/ws/notify"/>");
	
	    socket.onmessage = function(event) {
	        var notification = event.data;
	        if(notification === 'notification') {
	        	notiCheck();
	        	sessionReload();
	        	location.reload();
	        }
	    };
	
	    socket.onopen = function() {
	        console.log("WebSocket connection established");
	    };
	
	    socket.onclose = function() {
	        console.log("WebSocket connection closed");
	    };
	}
});
function sessionReload(){
	$.ajax({
	    url: "<c:url value='/session/reload'/>", // 데이터를 가져올 URL을 설정하세요.
	    type: "post", // GET 또는 POST로 요청 타입을 설정하세요.
	    success: function(data) {
	    },
	    error: function(xhr, status, error) {
	        console.error("데이터를 가져오는 중 오류 발생:", error); // 오류 로그
	    }
	});
}
</script>
</body>
</html>