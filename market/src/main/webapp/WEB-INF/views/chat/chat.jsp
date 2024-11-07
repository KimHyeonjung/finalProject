<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Chat Window</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
<body>
<div class="container">
	<!-- 게시물 정보 표시 영역 -->
	<div class="post-info" 
	     style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; background-color: #f9f9f9; cursor: pointer;" 
	     onclick="window.location.href='<c:url value='/post/detail/${post.post_num}' />'">
		<!-- 게시물 프로필 이미지 (썸네일) -->
		<%-- <img src="${post.post_thumbnail}" alt="게시물 이미지" style="width: 100px; height: 100px; object-fit: cover; margin-right: 15px; display: inline-block;"> --%>
		
		<!-- 게시물 제목 및 가격 -->
		<div style="display: inline-block; vertical-align: top;">
			<h3>${post.post_title}</h3> <!-- 게시물 제목 -->
			<p><strong>가격:</strong> ${post.post_price}원</p> <!-- 게시물 가격 -->
		</div>
	</div>
	
	<button type="button" onclick="window.location.href='<c:url value='/after/review/${post.post_num}' />'">후기 작성</button>
	
	
	<!-- 채팅 내용 표시 영역 -->
	<div id="chat-history">
		<c:forEach var="chatDTO" items="${chatDTOs}">
			<div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
				<strong>${chatDTO.getTargetMember().member_nick}</strong>: 
				<span>${chatDTO.getChat().chat_content}</span>
				<p style="font-size: small;">[${chatDTO.getChat().chat_date}]</p>
			</div>
		</c:forEach>
	</div>
	
	<!-- 메시지 입력창 -->
	<input type="text" id="message" placeholder="메시지를 입력하세요." style="width: 80%;" onkeypress="checkEnter(event)">
    <!-- 메시지 전송 버튼 -->
	<button onclick="sendMessage()">Send</button>
	
	<!-- 송금 요청 버튼 -->
	<button onclick="openModal()">송금</button>
	
	<!-- 송금 모달 -->
	<div id="sendMoneyModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border: 1px solid #ccc; z-index: 1000;">
	    <form id="sendMoneyForm" onsubmit="event.preventDefault(); sendMoney();">
	        <input type="hidden" id="chatRoomNum" name="chatRoomNum" value="${chatRoomNum}"/>
	        <input type="number" id="amount" name="amount" placeholder="송금할 금액" required />
	        <button type="submit" class="send-money-button">송금</button>
	        <button type="button" onclick="closeModal()">닫기</button>
	    </form>
	</div>
	
	<!-- 모달 배경 -->
	<div id="modalBackground" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;"></div>
	
	</div>	
	
	<script>
		//let websocket = new WebSocket("http://localhost:8080/market/chat/echo.do?chatRoomNum=${chatRoomNum}&member_nick=${member.member_nick}");
		let websocket = new WebSocket("http://localhost:8080/market/ws/notify?chatRoomNum=${chatRoomNum}&member_nick=${member.member_nick}");
		websocket.onopen = function(evt) {
			console.log("open websocket");
			//websocket.send(JSON.stringify({ type: "join", chatRoomNum: ${chatRoomNum} }));
			onOpen(evt)
		};
		websocket.onmessage = function(evt) {
			onMessage(evt)
		};
		websocket.onerror = function(evt) {
			onError(evt)
		};

		// WebSocket 연결
		function onOpen(evt) {
			writeToScreen("WebSocket 연결!");
			doSend($("#message").val());
		}
		
		// 메시지 수신
		function onMessage(evt) {
			writeToScreen("메시지 수신 : " + evt.data);
			
			//location.reload(true);
			
			$("#chat-history").load(window.location.href + " #chat-history");
			
			 // 새로운 메시지를 수신할 때마다 채팅 내역을 갱신
		    //refreshChatHistory();
			
			/* const message = JSON.parse(evt.data); // 서버로부터 받은 데이터를 JSON으로 파싱
	        const chatArea = document.querySelector(".chat-history");
	        
	        // 상대방이 보낸 메시지를 화면에 출력
	        const messageElement = document.createElement("div");
	        messageElement.classList.add("message-container", "their-message");

	        messageElement.innerHTML = `
	        	<div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
				<strong>\${message.member_nick}</strong>: 
				<span>\${message.chatVO.chat_content}</span>
				<p style="font-size: small;">[\${message.chatVO.chat_date}]</p>
			</div>
	        `;
			console.log(chatArea);
	        chatArea.appendChild(messageElement);
	        chatArea.scrollTop = chatArea.scrollHeight; */
		}
		
		// 에러 발생
		function onError(evt) {
			writeToScreen("에러 : " + evt.data);
		}

		function doSend(message) {
			writeToScreen("메시지 송신 : " + message);
			websocket.send(message);
		}

		function writeToScreen(message) {
			$("#outputDiv").append("<p>" + message + "</p>");
		}

		function sendMessage() {
			const content = document.getElementById("message").value;
			if (content === "") {
                return;
            }
			
			const message = {
				//type : "chat",			
				chat_member_num : '${member.member_num}', // 세션 또는 전역 변수에서 사용자 ID 가져옴
				chat_chatRoom_num : '${chatRoomNum}',
				chat_content : content,
			};
			// WebSocket을 통해 메시지 전송
		    websocket.send(JSON.stringify(message));

		    // 메시지 입력 필드 초기화
		    document.getElementById("message").value = '';
		    
			//알림
			let member_num = ${member.member_num};
			let chatRoom_num = ${chatRoomNum};
			let obj = {
					member_num : member_num,
					chatRoom_num : chatRoom_num,
					content : content
			}
			console.log(obj)
			$.ajax({
				async : true, //비동기 : true(비동기), false(동기)
				url : '<c:url value="/chat/notification"/>', 
				type : 'post', 
				data : JSON.stringify(obj), 
				contentType : "application/json; charSet=utf-8",
				success : function (data){	
					if(data){
						console.log("채팅 알람 전송");
					}
				}, 
				error : function(jqXHR, textStatus, errorThrown){
					console.log(jqXHR);
				}
			});	
		}
		
		function refreshChatHistory() {
            $.ajax({
                url: '/market/chat/loadChatHistory',
                type: 'GET',
                data: {
                    chatRoomNum: '${chatRoomNum}' // 현재 채팅방 번호 전송
                },
                success: function(response) {
                    // 채팅 기록 부분만 업데이트
                    $('#chat-history').html(response);
                },
                error: function(error) {
                    console.log("채팅 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }
		
		function checkEnter(event) {
            if (event.keyCode === 13) { // Enter 키가 눌렸을 때
                event.preventDefault(); // 기본 동작 방지
                sendMessage(); // 메시지 전송
            }
        }
		
		/* 
		function checkEnter(event) {
            if (event.key === "Enter") { // Enter 키가 눌렸을 때
                event.preventDefault(); // 기본 동작 방지
                sendMessage(); // 메시지 전송
            }
        }
		 */
		 
	    window.onload = function() {
			// 에러 메시지가 존재하는지 확인
			var errorMessage = "<c:out value='${errorMessage}' />";
			if (errorMessage) {
				alert(errorMessage);
			}
	
			// 성공 메시지가 존재하는지 확인
			var successMessage = "<c:out value='${successMessage}' />";
			if (successMessage) {
				alert(successMessage);
			
			}
		};
		
		function openModal() {
	        document.getElementById("sendMoneyModal").style.display = 'block';
	        document.getElementById("modalBackground").style.display = 'block';
	    }

	    function closeModal() {
	        document.getElementById("sendMoneyModal").style.display = 'none';
	        document.getElementById("modalBackground").style.display = 'none';
	    }

	    function sendMoney() {
	        var amount = document.getElementById('amount').value;
	        var chatRoomNum = document.getElementById('chatRoomNum').value;

	        if (amount <= 0) {
	            alert("금액은 0보다 커야 합니다.");
	            return;
	        }

	        if (amount < 100) {
	            alert('송금할 금액은 최소 100원이어야 합니다.');
	            return;
	        }

	        var data = {
	            amount: amount,
	            chatRoomNum: chatRoomNum
	        };

	        $.ajax({
	            type: 'POST',
	            url: '/market/wallet/sendMoney',
	            data: JSON.stringify(data),
	            contentType: 'application/json',
	            success: function(response) {
	                alert(response.message); // 메시지 표시
	                if (response.redirectUrl) {
	                    window.location.href = response.redirectUrl; // 리다이렉트 URL로 이동
	                } else {
	                    // 송금자와 수신자 번호를 서버 응답에서 가져옴
	                    var senderMemberNum = response.senderMemberNum;
	                    var targetMemberNum = response.targetMemberNum;

	                    // 송금 알림 전송
	                    sendTransferNotification(senderMemberNum, targetMemberNum, amount, chatRoomNum);

	                    closeModal(); // 모달 닫기
	                    updateHeader(); // 헤더 업데이트
	                    window.location.href = '/market/chat?chatRoomNum=' + chatRoomNum; // 기존 URL로 리다이렉트
	                }
	            },
	            error: function(xhr) {
	                var response = xhr.responseJSON || {};
	                var errorMessage = response.message || "송금 중 오류가 발생했습니다.";
	                alert(errorMessage); // 오류 메시지 표시

	                if (xhr.status === 400 && errorMessage.includes("잔액이 부족합니다.")) {
	                    // 잔액 부족 시 포인트 충전 페이지로 리다이렉트
	                    if (confirm("잔액이 부족합니다. 포인트를 충전하시겠습니까?")) {
	                        window.location.href = '/market/wallet/point'; // 포인트 충전 URL
	                    }
	                }
	            }
	        });
	    }
	    
	    function sendTransferNotification(senderMemberNum, targetMemberNum, amount, chatRoomNum) {
	        let content = `${senderMemberNum}님이 ${amount}원을 송금했습니다.`; // 알림 내용

	        let notificationObj = {
	            member_num: targetMemberNum, // 수신자 회원 번호
	            chatRoom_num: chatRoomNum, // 채팅방 번호
	            content: content // 알림 내용
	        };

	        console.log(notificationObj);

	        $.ajax({
	            async: true, // 비동기 : true(비동기), false(동기)
	            url: '/chat/notification',
	            type: 'post',
	            data: JSON.stringify(notificationObj),
	            contentType: "application/json; charSet=utf-8",
	            success: function(data) {
	                if (data) {
	                    console.log("송금 알람 전송");
	                }
	            },
	            error: function(jqXHR, textStatus, errorThrown) {
	                console.log(jqXHR);
	            }
	        });
	    }
	    
	    function updateHeader() {
	        $.ajax({
	            url: '/market/wallet/balance', // 잔액을 가져오는 API 엔드포인트
	            type: 'GET',
	            success: function(response) {
	                console.log("Total Money from server: " + response.totalMoney); // 서버 응답 확인
	                $('#balance').text(response.totalMoney); // 잔액을 표시하는 요소에 텍스트 추가
	            },
	            error: function(error) {
	                console.error("헤더 업데이트 중 오류 발생:", error);
	            }
	        });
	    }
	    
	</script>
</body>
</html>