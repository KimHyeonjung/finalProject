<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.3/dist/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
<body>
	<div class="wrapper">
		<form action="<c:url value='/signup'/>" method="post" id="form">
	     	<div class="form-field">
                <label class="label-form" for="member_id">아이디</label>
                <input type="text" class="form-control" name="member_id" id="member_id" required>
                <span id="id-check-msg" class="error"></span>
            </div>
            <div class="form-field">
                <label class="label-form" for="member_nick">닉네임</label>
                <input type="text" class="form-control" name="member_nick" id="member_nick" required>
                <span id="nick-check-msg" class="error"></span>
            </div>
            <div class="form-field">
                <label class="label-form" for="member_pw">비밀번호</label>
                <input type="password" class="form-control" name="member_pw" id="member_pw" required>
            </div>

            <div class="form-field">
                <label class="label-form" for="member_pw2">비밀번호 재확인</label>
                <input type="password" class="form-control" name="member_pw2" id="member_pw2" required>
            </div>
            <div class="form-field">
                <label class="label-form" for="member_email">이메일 주소</label>
                <input type="email" class="form-control" name="member_email" id="member_email" required>
            </div>

            <div class="form-field">
                <label class="label-form" for="member_phone">연락처</label>
                <input type="tel" class="form-control" name="member_phone" id="member_phone" required>
                <button type="button" id="send-code-btn">연락처 인증</button>
                <span id="sms-status-msg" class="error"></span>
                <span id="phone-check-msg" class="error"></span>
            </div>
            <div class="form-field hidden" id="verification-field">
                <label class="label-form" for="verification-code">인증번호 입력</label>
                <input type="text" class="form-control" id="verification-code" name="verificationCode"> 
                <span id="code-check-msg" class="error"></span>
            </div>
      
            <div class="form-field">
                <button type="submit" class="button-submit">제출하기</button>
            </div>
            
		</form>
	</div>
	<script>
	$(document).ready(function () {
		
		$.validator.addMethod("regex", function(value, element, regexpr) {
	        return regexpr.test(value);
	    }, "유효한 형식이 아닙니다.");
		
	    const idRegex = /^[a-zA-Z0-9]{6,13}$/; 
	    const nickRegex = /^[a-zA-Z가-힣0-9]{2,10}$/; 
	    let isIdAvailable = false; //중복 여부 저장
	    let isNickAvailable = false;
	    let isCodeVerified = false;
	    let isPhoneVerified = false;

	    // 아이디 입력 후 포커스를 벗어날 때 중복 검사 수행
	    $('#member_id').on('blur', function () {
	        const memberId = $(this).val().trim();

	        
	        
	        // 정규 표현식 검사
	        if (!idRegex.test(memberId)) {
	        $('#id-check-msg').text('').css('color', 'red');
	        isIdAvailable = false; // 유효하지 않은 아이디
	            return; // 서버로 요청하지 않음
	        }
	        $.ajax({
	            url: '/market/checkId',
	            type: 'GET',
	            data: { member_id: memberId },
	            success: function (response) {
	            // 서버 응답이 boolean인 경우 처리
	                if (response === true) {
	                    $('#id-check-msg').text('이미 사용 중인 아이디입니다.').css('color', 'red');
	                    isIdAvailable = false;
	                } else {
	                    $('#id-check-msg').text('사용 가능한 아이디입니다.').css('color', 'green');
	                    isIdAvailable = true;
	                }
	            },
	            error: function (xhr, status, error) {
	            $('#id-check-msg').text('중복 체크에 실패했습니다. 다시 시도해주세요.').css('color', 'red');
	                isIdAvailable = false;
	            }
	        });
	    });
		
	    $('#member_nick').on('blur', function () {
	        const memberNick = $(this).val().trim();
	        if (!nickRegex.test(memberNick)) {
	        $('#nick-check-msg').text('').css('color', 'red');
	            isNickAvailable = false;
	            return;  
	        }
	        $.ajax({
	            url: '/market/checkNick',
	            type: 'GET',
	            data: { member_nick: memberNick },
	            success: function (response) {
	                if (response === true) {
	                    $('#nick-check-msg').text('이미 사용 중인 닉네임입니다.').css('color', 'red');
	                    isNickAvailable = false;
	                } else {
	                    $('#nick-check-msg').text('사용 가능한 닉네임입니다.').css('color', 'green');
	                    isNickAvailable = true;
	                }
	            },
	            error: function (xhr, status, error) {
	                console.error("Error: ", error);
	                $('#nick-check-msg').text('중복 체크에 실패했습니다. 다시 시도해주세요.').css('color', 'red');
	                isNickAvailable = false;
	            }
	        });
	    });
	    $('#member_phone').on('blur', function() {
	        const phoneNumber = $(this).val().trim();
	        
	        if (phoneNumber === "") {
	            $('#phone-check-msg').text('').css('color', 'red');
	            $('#send-code-btn').prop('disabled', true);
	            return; 
	        }
	        $.ajax({
	            url: '/market/checkPhone',
	            type: 'GET',
	            data: { member_phone: phoneNumber },
	            success: function(response) {
	            	console.log("서버 응답: ", response);
	                if (response === true) {
	                    $('#phone-check-msg').text('이미 사용 중인 휴대폰 번호입니다.').css('color', 'red');
	                    $('#send-code-btn').prop('disabled', true);
	                } else {
	                    $('#phone-check-msg').text('사용 가능한 휴대폰 번호입니다.').css('color', 'green');
	                    $('#send-code-btn').prop('disabled', false);
	                }
	            },
	            error: function() {
	            	console.error("에러 발생: ", error);
	                $('#phone-check-msg').text('중복 체크에 실패했습니다.').css('color', 'red');
	                $('#send-code-btn').prop('disabled', true);
	            }
	        });
	    });
	    
	    $('#member_id').on('input', function () {
	        
	        isIdAvailable = false;  // 아이디 입력이 변경되면 중복 검사 결과 초기화
	    });

	    $('#member_nick').on('input', function () {
	        isNickAvailable = false;  // 닉네임 입력이 변경되면 중복 검사 결과 초기화
	    });
	    
	    let receivedCode = "";  // 서버에서 받은 인증번호 저장 변수
	    
	    // 인증번호 발송 버튼 클릭 이벤트
        $('#send-code-btn').on('click', function () {
		    const phoneNumber = $('#member_phone').val().trim();
		
		    if (!phoneNumber) {
		        $('#sms-status-msg').text('휴대폰 번호를 입력해주세요.').css('color', 'red');
		        return;
		    }
		
		    $.ajax({
		        url: '/market/api/sms/send',
		        type: 'POST',
		        data: { phoneNumber: phoneNumber },
		        success: function (response) {
		            receivedCode = response;  // 서버로부터 받은 인증번호 저장
		            $('#sms-status-msg').text('인증번호가 발송되었습니다.').css('color', 'green');
		            
		            // 인증번호 입력 필드를 보이도록 설정
		            $('#verification-field').removeClass('hidden');
		        },
		        error: function () {
		            $('#sms-status-msg').text('인증번호 발송에 실패했습니다.').css('color', 'red');
		        }
		    });
		});
		
		$('#verification-code').on('blur', function () {
            const enteredCode = $('#verification-code').val().trim();

            if (!enteredCode) {
                $('#code-check-msg').text('').css('color', 'red');
                isPhoneVerified = false;
                return;
            }

            $.ajax({
                url: '/market/api/sms/verify',
                type: 'POST',
                data: { userInputCode: enteredCode },
                success: function (isVerified) {
                    if (isVerified) {
                        $('#code-check-msg').text('인증번호가 일치합니다.').css('color', 'green');
                        isPhoneVerified = true;
                    } else {
                        $('#code-check-msg').text('인증번호가 일치하지 않습니다.').css('color', 'red');
                        isPhoneVerified = false;
                    }
                },
                error: function () {
                    $('#code-check-msg').text('인증번호 확인에 실패했습니다.').css('color', 'red');
                    isPhoneVerified = false;
                }
            });
        });
        
        // jQuery Validate와 함께 사용해 제출 버튼 제어
	    $('#form').validate({
	        rules: {
	            member_id: {
	                required: true,
	                regex: /^[a-zA-Z0-9]{6,13}$/
	            },
	            member_nick: {
	                required: true,
	                regex: /^[a-zA-Z가-힣0-9]{2,10}$/
	            },
	            member_pw: {
	                required: true,
	                regex: /^[a-zA-Z0-9!@#$]{8,15}$/
	            },
	            member_pw2: {
	                required: true,
	                equalTo: '#member_pw'
	            },
	            member_email: {
	                required: true,
	                email: true
	            },
	            member_phone: {
	                required: true,
	                digits: true
	            },
	            verificationCode: {  
	                required: true,
	                minlength: 6,  
	                maxlength: 6
	            }
	          
	            
	        },
	        messages: {
	            member_id: {
	                required: '아이디를 입력해 주세요.',
	                regex: '아이디는 영문과 숫자만 가능하며, 6~13자이어야 합니다.'
	            },
	            member_nick: {
	                required: '닉네임을 입력해 주세요.',
	                regex: '닉네임은 한글, 영문, 숫자만 가능하며, 2~10자이어야 합니다.'
	            },
	            member_pw: {
	                required: '비밀번호를 입력해 주세요.',
	                regex: '비밀번호는 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~15자이어야 합니다.'
	            },
	            member_pw2: {
	                required: '비밀번호를 다시 입력해 주세요.',
	                equalTo: '비밀번호가 일치하지 않습니다.'
	            },
	            member_email: {
	                required: '이메일을 입력해 주세요.',
	                email: '올바른 이메일 형식으로 입력해 주세요.'
	            },
	            member_phone: {
	                required: '연락처를 입력해 주세요.',
	                digits: '숫자만 입력해 주세요.'
	            },
	            verificationCode: {  // 인증번호 메시지 추가
	                required: '인증번호를 입력해 주세요.',
	                minlength: '인증번호는 6자리 입니다.',
	                maxlength: '인증번호는 6자리 입니다.'
	            }
	          
	        },
	        submitHandler: function (form) {
	            if (!isIdAvailable) {
	                $('#id-check-msg').text('아이디가 중복되었습니다. 다른 아이디를 입력해 주세요.').css('color', 'red');
	                return false;
	            }
	            if (!isNickAvailable) {
	                $('#nick-check-msg').text('닉네임이 중복되었습니다. 다른 닉네임을 사용하세요.').css('color', 'red');
	                return false;
	            }
	            if (!isPhoneVerified) {
	                $('#code-check-msg').text('연락처 인증을 완료해주세요.').css('color', 'red');
	                return false;
	            }
	            form.submit(); // 모든 유효성 검사를 통과한 경우 제출
	        }
	    });
	});
    </script>
    </body>
</html>
	        
	        