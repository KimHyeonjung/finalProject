<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.3/dist/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js"></script>
	<style type="text/css">
		*, *::before, *::after {
		    box-sizing: border-box
		}
		
		html, body {
		    margin: 0;
		    padding: 0
		}
		
		body {
		    font-family: 'Pretendard', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
		    font-size: 100%
		}
		
		.wrapper {
		    max-width: 480px;
		    margin: 100px auto;
		    padding: 0 20px
		}
		
		.form-field {
		    display: flex;
		    flex-wrap: wrap;
		    margin-bottom: 30px;
		    align-items: center
		}
		
		.form-field .label-form {
		    font-weight: 600;
		    color: #000;
		    margin-bottom: 8px
		}
		
		.form-control {
		    display: block;
		    width: 100%;
		    height: 48px;
		    padding: 6px 16px;
		    font-family: inherit;
		    font-size: 15px;
		    color: #666;
		    border: 1px solid #ced4da;
		    border-radius: 6px;
		    outline: 0
		}
		
		.form-control:focus {
		    color: #333;
		    border-color: #333
		}
		
		.button-submit {
		    display: block;
		    width: 100%;
		    height: 56px;
		    font-family: inherit;
		    font-size: 17px;
		    font-weight: 600;
		    color: #fff;
		    text-align: center;
		    padding: 0;
		    border: 0;
		    border-radius: 6px;
		    background-color: #333;
		    outline: 0;
		    cursor: pointer
		}
		
		.button-submit:hover {
		    background-color: #000
		}
		
		.error {
		    display: block;
		    color: #f00;
		    border-color: #f00
		}
		
		input:not([type=checkbox]) + label {
		    display: block;
		    margin-top: 6px
		}
	</style>
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
            </div>

            <div class="form-field">
                <input type="checkbox" name="chk_agree" id="chk_agree" required>
                <label for="chk_agree">약관에 동의합니다</label>
            </div>

            <div class="form-field">
                <button type="submit" class="button-submit">제출하기</button>
            </div>
		</form>
	</div>
	<script>
	$(document).ready(function () {
	    const idRegex = /^[a-zA-Z0-9]{6,13}$/; 
	    const nickRegex = /^[a-zA-Z가-힣0-9]{2,10}$/; 
	    let isIdAvailable = false; //중복 여부 저장
	    let isNickAvailable = false;

	    // 아이디 입력 후 포커스를 벗어날 때 중복 검사 수행
	    $('#member_id').on('blur', function () {
	        const memberId = $(this).val().trim();

	        // 정규 표현식 검사
	        if (!idRegex.test(memberId)) {
	            $('#id-check-msg').text('아이디는 6~13자의 영문과 숫자만 가능합니다.').css('color', 'red');
	            isIdAvailable = false; // 유효하지 않은 아이디
	            return; // 서버로 요청하지 않음
	        }

	        // 유효한 형식일 경우에만 서버에 Ajax 요청
	        $.ajax({
	            url: '/market/checkId',
	            type: 'GET',
	            data: { member_id: memberId },
	            success: function (response) {
	                console.log("Ajax Response:", response);

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
	                console.error("Error: ", error);
	                $('#id-check-msg').text('중복 체크에 실패했습니다. 다시 시도해주세요.').css('color', 'red');
	                isIdAvailable = false;
	            }
	        });
	    });
		
	    $('#member_nick').on('blur', function () {
	        const memberNick = $(this).val().trim();

	        if (!nickRegex.test(memberNick)) {
	            $('#nick-check-msg').text('닉네임은 2~10자의 한글, 영문, 숫자만 가능합니다.').css('color', 'red');
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
	    
	    // 폼 제출 시 아이디 중복 여부 최종 확인
	    $('#form').on('submit', function (e) {
	        if (!isIdAvailable) { // 아이디가 중복되거나 유효하지 않은 경우
	            e.preventDefault(); // 폼 제출 중단
	            $('#id-check-msg').text('아이디가 중복되었습니다. 다른 아이디를 사용하세요.').css('color', 'red');
	        }
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
	            chk_agree: {
	                required: true
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
	            chk_agree: {
	                required: '약관에 동의해 주세요.'
	            }
	        },
	        submitHandler: function (form) {
	            if (!isIdAvailable) {
	                $('#id-check-msg').text('아이디가 중복되었습니다. 다른 아이디를 입력해 주세요.').css('color', 'red');
	                return false;
	            }
	            form.submit(); // 모든 유효성 검사를 통과한 경우 제출
	        }
	    });
	});
    </script>
</body>
</html>