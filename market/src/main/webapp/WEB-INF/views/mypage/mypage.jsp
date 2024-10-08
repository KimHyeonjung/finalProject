<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
	<div>
		<p>이미지 변경하기</p>
	</div>
	
	<form action="<c:url value="/mypage"/>" method="post" id="form">
		<div class="form-group">
			<img src="member image" alt="member image" style="width:200px;">
				<div class="form-group">
					<label>이미지 수정하기</label>
					<input type="file" class="form-control" name="fileList">
				</div>
			<label class="label-form" for="member_id">${user.member_id}</label>
			<label class="label-form" for="member_nick">${user.member_nick}</label>
		</div>
		<div class="form-group">
			<label for="pw">비밀번호:</label>
			<input type="password" class="form-control" id="pw" name="me_pw">
		</div>
		<div class="form-group">
			<label for="pw2">새 비밀번호:</label>
			<input type="password" class="form-control" id="pw2" name="me_pw2">
		</div>
		<div class="form-group">
			<label for="pw2">새 비밀번호 확인:</label>
			<input type="password" class="form-control" id="pw2" name="me_pw2">
		</div>
		<div class="form-group">
			<label for="email">이메일 주소:</label>
			<input type="text" class="form-control" id="email" name="me_email" value="${user.me_email}">
		</div>
		<div class="form-group">
			<label for="email">새 이메일 주소:</label>
			<input type="text" class="form-control" id="email" name="me_email" value="${user.me_email}">
		</div>
		<div class="form-group">
			<label for="email">휴대폰 번호:</label>
			<input type="text" class="form-control" id="email" name="me_email" value="${user.me_email}">
		</div>
		<div class="form-group">
			<label for="email">새 휴대폰 번호:</label>
			<input type="text" class="form-control" id="email" name="me_email" value="${user.me_email}">
		</div>
		
		<button type="submit" class="btn btn-outline-success col-12">회원 정보 수정</button>
		
		<div class="form-group">
			<button type="submit" class="btn btn-outline-success col-12">회원 탈퇴</button>
		</div>
		
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
		
	</form>
	
	<script>
	  jQuery(function() {
		  $.validator.addMethod("regex", function(value, element, regexpr) {          
              return regexpr.test(value);
          }, "유효한 형식이 아닙니다.");
		  
          const myForm = $('#form');
          myForm.validate({
              rules: {                    // 유효성 검사 규칙
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
              },
              messages: {                 // 오류값 발생시 출력할 메시지 수동 지정
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
              }
          });
      });
    </script>
</body>
</html>