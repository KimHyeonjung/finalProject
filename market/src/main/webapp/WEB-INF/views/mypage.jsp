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
		
		<div class="d-flex justify-content-center">
			<div class="btn btn-dark m-auto" data-toggle="modal" data-target="#modal">비밀번호 변경</div>
		</div>
		
		<div class="form-group">
			<label for="email">이메일 주소:</label>
			<label class="form-control" for="email">${user.member_email}</label>
		</div>
		<div class="form-group">
			<label class="label-form" for="member_email">새 이메일 주소:</label>
			<input type="email" class="form-control" name="member_email" id="member_email">
		</div>
		<div class="form-group">
			<label for="phone">연락처</label>
			<label class="form-control" for="phone">${user.member_phone}</label>
		</div>
		<div class="form-group">
			<label class="label-form" for="member_phone">새 연락처:</label>
			<input type="tel" class="form-control" name="member_phone" id="member_phone">
		</div>
		
		<button type="button" id="click">확인용</button>
		
		<button type="submit" class="btn btn-outline-success col-12" id="update">회원 정보 수정</button>
		
		<button type="button" class="btn btn-outline-error col-12" id="delete">회원 탈퇴</button>
		
	</form>
	
	<!-- The Modal -->
	<div class="modal" id="modal">
	    <div class="modal-dialog">
	        <div class="modal-content">
	
	            <!-- Modal Header -->
	            <div class="modal-header">
	                <h5 class="modal-title" id="passwordModalLabel">비밀번호 변경</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">&times;</button>
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
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
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
	    const formData = new FormData(document.getElementById("passwordForm"));
	    
	    event.preventDefault(); // 기본 제출 방지
	    
	    fetch('/market/updatepw', {
	        method: 'POST',
	        body: formData
	    })
	    .then(response => response.json())
	    .then(data => {
	        if (data.success) {
	            // 비밀번호 변경 성공 시 처리
	            alert("비밀번호가 성공적으로 변경되었습니다.");
	            // 모달 닫기
	            $('#modal').modal('hide');
	        } else {
	            // 비밀번호 변경 실패 시 처리
	            errorMessageElement.textContent = data.message;
	            errorMessageElement.classList.remove("d-none");
	        }
	    })
	    .catch(error => {
	        console.error('Error:', error);
	        errorMessageElement.textContent = "서버 오류가 발생했습니다.";
	        errorMessageElement.classList.remove("d-none");
	    });
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
	
	jQuery(function() {
		  $.validator.addMethod("regex", function(value, element, regexpr) {          
            return regexpr.test(value);
        }, "유효한 형식이 아닙니다.");
		  
        const myForm = $('#form');
        myForm.validate({
            rules: {                    // 유효성 검사 규칙
                member_email: {                // 이메일 필드
                    email: true         // 이메일 형식 검증
                },
                member_phone: {                  // 연락처 필드
                    digits: true        // 숫자 형태로만 입력 가능하도록 설정
                },
            },
            messages: {                 // 오류값 발생시 출력할 메시지 수동 지정
                member_email: {
                    email: '올바른 이메일 형식으로 입력하세요.'
                },
                member_phone: {
                    digits: '반드시 숫자만 입력하세요.'
                },
            }
        });
    });
	
    </script>
</body>
</html>