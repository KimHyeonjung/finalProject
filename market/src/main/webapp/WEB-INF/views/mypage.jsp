<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
	<link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
	
</head>
<body>
	<form action="<c:url value="/mypage"/>" method="post" id="form">
		<div class="form-group">
			<img src="member image" alt="member image" style="width:200px;">
				<div class="form-group">
					<input type="file" class="form-control" id="member_file" name="member_file">
				</div>
			<label class="label-form" for="member_id">${user.member_id}</label>
			<label class="label-form" for="member_nick">${user.member_nick}</label>
		</div>
		
		<div class="d-flex justify-content-left">
			<div class="btn btn-dark m-auto" data-toggle="modal" data-target="#modal">비밀번호 변경</div>
		</div>
		
		<div class="form-group">
			<label for="email">이메일 주소:</label>
			<label class="form-control" for="email">${user.member_email}</label>
		</div>
		<div class="d-flex justify-content-left">
			<div class="btn btn-dark m-auto" data-toggle="modal" data-target="#modal_email">이메일 변경</div>
		</div>
		<div class="form-group">
			<label for="phone">연락처</label>
			<label class="form-control" for="phone">${user.member_phone}</label>
		</div>
		<div class="d-flex justify-content-left">
			<div class="btn btn-dark m-auto" data-toggle="modal" data-target="#modal_phone">연락처 변경</div>
		</div>
		
		<button type="button" onclick="location.href='/market'" class="btn btn-outline-success col-12">나가기</button>
		
		<button type="button" class="btn btn-outline-error col-12" id="delete">회원 탈퇴</button>
		
	</form>
	
	<!-- The Modal -->
	<div class="modal" id="modal">
	    <div class="modal-dialog">
	        <div class="modal-content">
	
	            <!-- Modal Header -->
	            <div class="modal-header">
	                <h5 class="modal-title" id="passwordModalLabel">비밀번호 변경</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="location.href='/market/mypage'">&times;</button>
	            </div>
	
	            <!-- Modal body -->
	            <div class="modal-body">
	                <form id="passwordForm" method="post" action="<c:url value="/updatepw"/>">
	                    <div id="error-message" class="alert alert-danger d-none"></div> <!-- 오류 메시지 표시 -->
	                    <div class="form-group">
	                        <label for="member_pw">기존 비밀번호:</label>
	                        <input type="password" class="form-control" id="member_pw" name="member_pw" required>
	                    </div>
	                    <div class="form-group">
	                        <label for="new_member_pw">새로운 비밀번호:</label>
	                        <input type="password" class="form-control" id="new_member_pw" name="new_member_pw" required>
	                    </div>
	                    <div class="form-group">
	                        <label for="new_member_pw2">새로운 비밀번호 확인:</label>
	                        <input type="password" class="form-control" id="new_member_pw2" name="new_member_pw2" required>
	                    </div>
	                </form>
	            </div>
	
	            <!-- Modal footer -->
	            <div class="modal-footer">
	                <button type="button" id="submitBtn" class="btn btn-primary">확인</button>
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="location.href='/market/mypage'">취소</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- The Modal -->
	<div class="modal" id="modal_email">
	    <div class="modal-dialog">
	        <div class="modal-content">
	
	            <!-- Modal Header -->
	            <div class="modal-header">
	                <h5 class="modal-title" id="emailModalLabel">이메일 변경</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="location.href='/market/mypage'">&times;</button>
	            </div>
	
	            <!-- Modal body -->
	            <div class="modal-body">
	                <form id="passwordForm" method="post" action="<c:url value="/updateemail"/>">
	                    <div id="error-message" class="alert alert-danger d-none"></div> <!-- 오류 메시지 표시 -->
	                    <div class="form-group">
	                        <label for="member_email">새 이메일 주소 : </label>
	                        <input type="email" class="form-control" name="member_email" id="member_email" required>
	                    </div>
	                </form>
	            </div>
	
	            <!-- Modal footer -->
	            <div class="modal-footer">
	                <button type="button" id="submitEmailBtn" class="btn btn-primary">확인</button>
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="location.href='/market/mypage'">취소</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- The Modal -->
	<div class="modal" id="modal_phone">
	    <div class="modal-dialog">
	        <div class="modal-content">
	
	            <!-- Modal Header -->
	            <div class="modal-header">
	                <h5 class="modal-title" id="phoneModalLabel">연락처 변경</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="location.href='/market/mypage'">&times;</button>
	            </div>
	
	            <!-- Modal body -->
	            <div class="modal-body">
	                <form id="passwordForm" method="post" action="<c:url value="/updatephone"/>">
	                    <div id="error-message" class="alert alert-danger d-none"></div> <!-- 오류 메시지 표시 -->
	                    <div class="form-group">
	                        <label for="member_phone">새 연락처 : </label>
	                       	<input type="tel" class="form-control" name="member_phone" id="member_phone">
	                    </div>
	                </form>
	            </div>
	
	            <!-- Modal footer -->
	            <div class="modal-footer">
	                <button type="button" id="submitPhoneBtn" class="btn btn-primary">확인</button>
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="location.href='/market/mypage'">취소</button>
	            </div>
	        </div>
	    </div>
	</div>

	<script>
	
	document.getElementById("submitBtn").addEventListener("click", function() {
	    // 입력값 가져오기
	    const oldPassword = document.getElementById("member_pw").value;
	    const newPassword = document.getElementById("new_member_pw").value;
	    const newPasswordConfirm = document.getElementById("new_member_pw2").value;
	    
	    // 오류 메시지 초기화
	    const errorMessageElement = document.getElementById("error-message");
	    errorMessageElement.classList.add("d-none");
	    errorMessageElement.textContent = "";

	    // 비밀번호 검증
	    const passwordPattern = /^[a-zA-Z0-9!@#$]{8,15}$/;

	    if (!passwordPattern.test(newPassword)) {
	        errorMessageElement.textContent = "비밀번호는 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~15자이어야 합니다.";
	        errorMessageElement.classList.remove("d-none");
	        return;
	    }

	    if (newPassword !== newPasswordConfirm) {
	        errorMessageElement.textContent = "확인 비밀번호가 일치하지 않습니다.";
	        errorMessageElement.classList.remove("d-none");
	        return;
	    }

	    // 폼 데이터 전송
	    // const formData = new FormData(document.getElementById("passwordForm"));
	    
	    const formData = new FormData();
	    
	    formData.append("member_pw", oldPassword);
	    formData.append("new_member_pw", newPassword);
	    formData.append("new_member_pw2", newPasswordConfirm);
	    
	    console.log(formData);
	    
	    event.preventDefault(); // 기본 제출 방지
	    
	    $.ajax({
	        method: 'post',
	        url: '/market/updatepw',
	        data: {
	            member_pw: oldPassword,
	            new_member_pw: newPassword,
	            new_member_pw2: newPasswordConfirm
	        },
	        success: function(data) {
	            console.log(data);
	            // 서버에서 문자열을 반환한다고 가정
	            if (data === '/market/mypage') {
	                alert("비밀번호가 성공적으로 변경되었습니다.");
	                window.location.href = '/market/mypage'; // 페이지 이동
	            } else {
	                errorMessageElement.textContent = "비밀번호 변경 실패: " + data;
	                errorMessageElement.classList.remove("d-none");
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log('Eroor : ' + error);
	            errorMessageElement.textContent = "서버 오류가 발생했습니다.";
	            errorMessageElement.classList.remove("d-none");
	        }
	    })
	});

/* 	   	var params = new URLSearchParams();
	    
	    params.append('member_pw', oldPassword);
	    params.append('new_member_pw', newPassword);
	    params.append('new_member_pw2', newPasswordConfirm);
	    
	    fetch('/market/updatepw', {
	        method: 'POST',
	        headers: {
	          'Content-Type': 'application/x-www-form-urlencoded'
	        },
	        body: params.toString()
	    }) */
	
    document.getElementById("submitEmailBtn").addEventListener("click", function() {
	    // 입력값 가져오기
	    const newEmail = document.getElementById("member_email").value;
	    
	    // 오류 메시지 초기화
	    const errorMessageElement = document.getElementById("error-message");
	    errorMessageElement.classList.add("d-none");
	    errorMessageElement.textContent = "";

	    // 비밀번호 검증
	   	const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

	    if (!emailPattern.test(newEmail)) {
	        errorMessageElement.textContent = "올바른 이메일 형식으로 입력하세요.";
	        errorMessageElement.classList.remove("d-none");
	        return;
	    }

	    const formData = new FormData();
	    
	    formData.append("member_email", newEmail);
	    
	    console.log(formData);
	    
	    event.preventDefault(); // 기본 제출 방지
	    
	    $.ajax({
	        method: 'post',
	        url: '/market/updateemail',
	        data: {
	        	member_email: newEmail
	        },
	        success: function(data) {
	            console.log(data);
	            // 서버에서 문자열을 반환한다고 가정
	            if (data === '/market/mypage') {
	                alert("이메일이 성공적으로 변경되었습니다.");
	                window.location.href = '/market/mypage'; // 페이지 이동
	            } else {
	                errorMessageElement.textContent = "이메일 변경 실패: " + data;
	                errorMessageElement.classList.remove("d-none");
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log('Eroor : ' + error);
	            errorMessageElement.textContent = "서버 오류가 발생했습니다.";
	            errorMessageElement.classList.remove("d-none");
	        }
	    })
	});   
	    
    document.getElementById("submitPhoneBtn").addEventListener("click", function() {
	    // 입력값 가져오기
	    const newPhone = document.getElementById("member_phone").value;
	    
	    // 오류 메시지 초기화
	    const errorMessageElement = document.getElementById("error-message");
	    errorMessageElement.classList.add("d-none");
	    errorMessageElement.textContent = "";

	    // 비밀번호 검증
	   	const phonePattern = /^^(010)(\d{4})(\d{4})$/;

	    if (!phonePattern.test(newPhone)) {
	        errorMessageElement.textContent = "반드시 숫자만 입력하세요.";
	        errorMessageElement.classList.remove("d-none");
	        return;
	    }

	    const formData = new FormData();
	    
	    formData.append("member_phone", newPhone);
	    
	    console.log(formData);
	    
	    event.preventDefault(); // 기본 제출 방지
	    
	    $.ajax({
	        method: 'post',
	        url: '/market/updatephone',
	        data: {
	        	member_phone: newPhone
	        },
	        success: function(data) {
	            console.log(data);
	            // 서버에서 문자열을 반환한다고 가정
	            if (data === '/market/mypage') {
	                alert("연락처가 성공적으로 변경되었습니다.");
	                window.location.href = '/market/mypage'; // 페이지 이동
	            } else {
	                errorMessageElement.textContent = "연락처 변경 실패: " + data;
	                errorMessageElement.classList.remove("d-none");
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log('Eroor : ' + error);
	            errorMessageElement.textContent = "서버 오류가 발생했습니다.";
	            errorMessageElement.classList.remove("d-none");
	        }
	    })
	});   
	    
	    
	$(document).ready(function() {
	    $('#delete').on('click', function() {
	        if (confirm('정말로 회원 탈퇴를 하시겠습니까?')) {
	            $.ajax({
	                url: '/market/delete', // 서버에서 처리할 URL
	                type: 'POST', // 요청 방식
	                data: {
	                    member_id: 'user.member_id' // 서버에서 사용할 현재 회원 ID
	                },
	                success: function(response) {
	                    // 회원 탈퇴 성공 시 페이지 이동
	                    window.location.href = '/market'; // 이동할 페이지 URL
	                },
	                error: function(xhr, status, error) {
	                    // 에러 처리
	                    alert('회원 탈퇴에 실패했습니다: ' + error);
	                }
	            });
	        }
	    });
	});
	
    </script>
</body>
</html>