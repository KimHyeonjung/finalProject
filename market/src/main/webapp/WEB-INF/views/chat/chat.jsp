<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅창</title>
    <style>
        .chat-container {
            width: 100%;
            height: 400px;
            border: 1px solid #ccc;
            padding: 10px;
            overflow-y: auto;
        }
        .message {
            padding: 5px;
            margin-bottom: 10px;
        }
        .message.self {
            text-align: right;
            background-color: #e1ffc7;
        }
        .message.other {
            text-align: left;
            background-color: #f1f1f1;
        }
        .chat-input {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
        }
    </style>
    
    <script>
    
    var targetMemberNum = "${chatDTO.targetMember.member_num}";
    console.log("송금 대상 회원 번호:", targetMemberNum);
    
	    window.onload = function() {
	        // 에러 메시지가 존재하는지 확인
	        var errorMessage = "${errorMessage}";
	        if (errorMessage) {
	            alert(errorMessage);
	        }
	
	        // 성공 메시지가 존재하는지 확인
	        var successMessage = "${successMessage}";
	        if (successMessage) {
	            alert(successMessage);
	        }
	    };
	</script>	
    
</head>
<body>
    <h2>채팅 내역</h2>
    <div class="chat-history">
        <c:forEach var="chatDTO" items="${chatDTOs}">
            <div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
                <strong>${chatDTO.getTargetMember().member_nick}</strong>: <span>${chatDTO.getChat().chat_content}</span>
                <p style="font-size: small;">[${chatDTO.getChat().chat_date}]</p>
            </div>
        </c:forEach>
    </div>

    <form action="/sendChat" method="post">
        <input type="hidden" name="chatRoomNum" value="${chatRoomNum}" />
        <textarea name="chatContent" class="chat-input" rows="3" placeholder="메시지를 입력하세요..."></textarea>
        <button type="submit">전송</button>
    </form>
    
   <form action="${pageContext.request.contextPath}/sendMoney" method="post">
	    <input type="hidden" name="chatRoomNum" value="${chatRoomNum}"/>
	    <input type="hidden" name="targetMemberNum" value="${chatDTO.getTargetMember().member_num}"/> <!-- targetMemberNum 추가 -->
	    <input type="number" name="amount" placeholder="송금할 금액" required />
	    <button type="submit" class="send-money-button">송금</button>
	</form>
    
</body>
</html>