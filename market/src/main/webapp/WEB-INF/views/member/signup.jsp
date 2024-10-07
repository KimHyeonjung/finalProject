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
            </div>
            <div class="form-field">
                <label class="label-form" for="member_nick">닉네임</label>
                <input type="text" class="form-control" name="member_nick" id="member_nick" required>
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
	  jQuery(function() {
		  $.validator.addMethod("regex", function(value, element, regexpr) {          
              return regexpr.test(value);
          }, "유효한 형식이 아닙니다.");
		  
          const myForm = $('#form');
          myForm.validate({
              rules: {                    // 유효성 검사 규칙
                  member_id: {             // 아이디 필드
                      required: true,     // 필수 입력
                      regex: /^[a-zA-Z0-9]{6,13}$/     
                  },
                  member_nick: {             // 닉네임 필드
                      required: true,     // 필수 입력
                      regex: /^[a-zA-Z가-힣0-9]{2,10}$/     
                  },
                  member_pw: {             // 비밀번호 필드
                      required: true,     // 필수 입력
                      regex: /^[a-zA-Z0-9!@#$]{8,15}$/   
                  },
                  member_pw2: {     // 비밀번호 재확인 필드
                      required: true,     // 필수 입력
                      equalTo: '#member_pw'   // 비밀번호 필드와 동일한 값을 가지도록
                  },
                  member_email: {                // 이메일 필드
                      required: true,     // 필수 입력
                      email: true         // 이메일 형식 검증
                  },
                  member_phone: {                  // 연락처 필드
                      required: true,     // 필수 입력
                      digits: true        // 숫자 형태로만 입력 가능하도록 설정
                  },
                  chk_agree: {            // 약관 동의 체크박스
                      required: true      // 필수 체크
                  }
              },
              messages: {                 // 오류값 발생시 출력할 메시지 수동 지정
                  member_id: {
                      required: '필수 입력 항목입니다.',
                      regex: '아이디는 영문과 숫자만 가능하며, 6~13자이어야 합니다.'
                  },
                  member_nick: {
                      required: '필수 입력 항목입니다.',
                      regex: '닉네임은 한글, 영문, 숫자만 가능하며, 2~10자이어야 합니다.'
                  },
                  member_pw: {
                      required: '필수 입력 항목입니다.',
                      regex: '비밀번호는 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~15자이어야 합니다.'
                  },
                  member_pw2: {
                      required: '필수 입력 항목입니다.',
                      equalTo: '동일한 비밀번호를 입력해 주세요.'
                  },
                  member_email: {
                      required: '필수 입력 항목입니다.',
                      email: '올바른 이메일 형식으로 입력하세요.'
                  },
                  member_phone: {
                      required: '필수 입력 항목입니다.',
                      digits: '반드시 숫자만 입력하세요.'
                  },
                  chk_agree: {
                      required: '필수 체크 항목입니다.'
                  }
              }
          });
      });
    </script>
</body>
</html>
