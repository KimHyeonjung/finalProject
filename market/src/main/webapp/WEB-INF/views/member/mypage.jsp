<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<style type="text/css">
.profile img {
	width: 200px;
	height: 200px;
	border-radius: 100px;
}
</style>
</head>
<body>
<div class="container">
	<form action="<c:url value="/mypage"/>" method="post" id="form">
		<div class="form-group profile">
			<c:if test="${user.file_name ne null }">
				<img id="mypage-preview" src="<c:url value="/uploads/${user.file_name }"/>" alt="${user.file_ori_name }" style="width:200px;">
			</c:if>
			<c:if test="${user.file_name eq null }">
				<img id="mypage-preview" src="<c:url value="/resources/img/none_profile_image.png"/>" alt="none" style="width:200px;">
			</c:if>
			<div class="form-group">
				<input type="file" class="form-control" id="member_file" name="member_file" accept="image/*">
			</div>
			<div class="d-flex justify-content-left">
				<div class="btn btn-dark m-auto" id="profile-change">프로필 사진 변경</div>
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
			<label class="form-control">${user.member_phone}</label>
		</div>
		<div class="d-flex justify-content-left">
			<div class="btn btn-dark m-auto" data-toggle="modal" data-target="#modal_phone">연락처 변경</div>
		</div>
		
		<button type="button" onclick="location.href='/market'" class="btn btn-outline-success col-12">나가기</button>
		
		<button type="button" class="btn btn-outline-error col-12" id="delete">회원 탈퇴</button>
		
	</form>
</div>
	
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
	                <form id="phoneForm" method="post">
                        <div class="form-group">
                            <label for="member_phone">새 연락처:</label>
                            <input type="tel" class="form-control" id="member_phone" required>
                        </div>
                        <button type="button" id="smsVerifyBtn" class="btn btn-secondary mt-2">인증 요청</button>
                        
                        <!-- 인증 코드 입력 필드 -->
                        <div class="form-group mt-3" id="verification-field">
                            <label for="verification_code">인증 코드:</label>
                            <input type="text" class="form-control" id="verification_code" required>
                            <span id="code-check-msg" class="text-danger"></span>
                        </div>
                    </form>
	            </div>
	
	            <!-- Modal footer -->
	            <div class="modal-footer">
	                <button type="button" id="submitPhoneBtn" class="btn btn-primary" disabled>확인</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="location.href='/market/mypage'">취소</button>
	            </div>
	        </div>
	    </div>
	</div>

	<script>
	const preview = document.getElementById("mypage-preview");
	const previewImage = preview.src;
	let file = null;
	$(document).ready(function(){
		$('#profile-change').click(function(){
			if(file == null){
				alert('선택된 파일이 없습니다.');
				return;
			}
			const formData = new FormData();
			formData.append('file', file);
			$.ajax({
				async : true,
		        url: '<c:url value="/mypage/updateprofile"/>',
		        method: 'post',
		        data: formData,
		        contentType: false,  // 서버로 전송 시 `multipart/form-data`가 자동 설정되도록
		   	    processData: false,  // jQuery가 데이터를 자동으로 처리하지 않도록 설정 
		        success: function(data) {
		            console.log(data);
		            // 서버에서 문자열을 반환한다고 가정
		            if (data === 'UPDATE_PROFILE') {
		                alert("프로필 사진이 성공적으로 변경되었습니다.");
		                window.location.href = '/market/mypage'; // 페이지 이동
		            } else {
		                errorMessageElement.textContent = "프로필 변경 실패: " + data;
		                errorMessageElement.classList.remove("d-none");
		            }
		        },
		        error: function(xhr, status, error) {
		            console.log('Eroor : ' + error);
		        }
		    });
		});
		$('#member_file').change(function(e){
			file = e.target.files[0];
			// 파일 선택 취소시 
	 	 	if (!file || file.length === 0) {
	 	 		preview.src = previewImage;
		        return; 
		    } 	    
		    
			 // 미리보기 생성
	 	 	const reader = new FileReader();
		    reader.onload = () => {
		        preview.src = reader.result;
		    }
		    reader.readAsDataURL(file);
		}); 

	});
	
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
    $(document).ready(function() {
        let isVerified = false;
        
        // 인증 요청 버튼 클릭 시
        $('#smsVerifyBtn').click(function () {
            const newPhone = $('#member_phone').val();
            const phonePattern = /^(010)(\d{4})(\d{4})$/;

            if (!phonePattern.test(newPhone)) {
                alert('올바른 연락처 형식으로 입력하세요.');
                return;
            }

            $.ajax({
                method: 'POST',
                url: '/market/api/sms/send',
                data: { phoneNumber: newPhone },
                success: function (response) {
                    alert('인증 코드가 발송되었습니다. 인증 코드를 입력하세요.');
                    $('#verification_code').prop('disabled', false);
                    $('#submitPhoneBtn').prop('disabled', true); // 확인 버튼 비활성화
                },
                error: function () {
                    $('#code-check-msg').text('인증 코드 발송에 실패했습니다.').css('color', 'red');
                }
            });
        });

        // 인증 코드 입력 확인
        $('#verification_code').on('input', function () {
            const enteredCode = $(this).val();

            if (enteredCode.length === 6) {
                $.ajax({
                    method: 'POST',
                    url: '/market/api/sms/verify',
                    data: { userInputCode: enteredCode },
                    success: function (isValid) {
                        if (isValid) {
                            $('#code-check-msg').text('인증 성공! 연락처를 변경할 수 있습니다.').css('color', 'green');
                            $('#submitPhoneBtn').prop('disabled', false); // 확인 버튼 활성화
                            isVerified = true;
                        } else {
                            $('#code-check-msg').text('잘못된 인증 코드입니다. 다시 입력해주세요.').css('color', 'red');
                            $('#submitPhoneBtn').prop('disabled', true);
                            isVerified = false;
                        }
                    },
                    error: function () {
                        $('#code-check-msg').text('서버 오류가 발생했습니다.').css('color', 'red');
                    }
                });
            } else {
                $('#code-check-msg').text('');
            }
        });

        // 확인 버튼 클릭 시 연락처 업데이트
        $('#submitPhoneBtn').click(function () {
            if (!isVerified) {
                $('#code-check-msg').text('연락처 인증을 완료해주세요.').css('color', 'red');
                return;
            }

            const newPhone = $('#member_phone').val();

            $.ajax({
                method: 'POST',
                url: '/market/updatephone',
                data: { member_phone: newPhone },
                success: function (response) {
                    if (response === '/market/mypage') {
                        alert('연락처가 성공적으로 변경되었습니다.');
                        window.location.href = '/market/mypage';
                    } else {
                        $('#code-check-msg').text('연락처 변경에 실패했습니다: ' + response).css('color', 'red');
                    }
                },
                error: function () {
                    $('#code-check-msg').text('서버 오류가 발생했습니다.').css('color', 'red');
                }
            });
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
	
    </script>
</body>
</html>