<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<style type="text/css">
		*, *::before, *::after {
		    box-sizing: border-box;
		}
		
		html, body {
		    margin: 0;
		    padding: 0;
		}
		
		body {
		    font-family: 'Pretendard', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
		    font-size: 100%;
		}
		
		.wrapper {
		    max-width: 480px;
		    margin: 100px auto;
		    padding: 0 20px;
		}
		
		.form-field {
		    display: flex;
		    flex-wrap: wrap;
		    margin-bottom: 30px;
		    align-items: center;
		}
		
		.form-field .label-form {
		    font-weight: 600;
		    color: #000;
		    margin-bottom: 8px;
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
		    outline: 0;
		}
		
		.form-control:focus {
		    color: #333;
		    border-color: #333;
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
		    cursor: pointer;
		}
		
		.button-submit:hover {
		    background-color: #000;
		}
	</style>
</head>
<body>
	<div class="wrapper">
		<form action="<c:url value='/login'/>" method="post" id="login-form">
	     	<div class="form-field">
                <label class="label-form" for="member_id">아이디</label>
                <input type="text" class="form-control" name="member_id" id="member_id" required>
            </div>
            <div class="form-field">
                <label class="label-form" for="member_pw">비밀번호</label>
                <input type="password" class="form-control" name="member_pw" id="member_pw" required>
            </div>
              <div class="form-field">
                <input type="checkbox" name="autoLogin" value="Y">자동 로그인
            </div>

            <div class="form-field">
                <button type="submit" class="button-submit">로그인</button>
            </div>
			
		</form>
		<a id="kakao-login-btn" href="javascript:loginWithKakao()">
		  <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="222"
		    alt="카카오 로그인 버튼" />
		</a>
            <div class="form-field">
                <p>계정이 없으신가요? <a href="<c:url value='/signup'/>">회원가입</a></p>
            </div>
        <!--카카오 스크립트 -->
		<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
		<script type="text/javascript">
			Kakao.init('55f22ec08aea99a6511585b99e78d0d6'); // 사용하려는 앱의 JavaScript 키 입력
			function loginWithKakao() {
				Kakao.Auth.login({
		      success: function (authObj) {
		    	  console.log('카카오 로그인 성공:', authObj);
		         Kakao.Auth.setAccessToken(authObj.access_token); // access토큰값 저장
							
		         getInfo();
		      },
		      fail: function (err) {
		          console.log(err);
		      }
		    });
		  }
			function getInfo() {
		    Kakao.API.request({
		      url: '/v2/user/me',
		      success: function (res) {
		        // 이메일, 프로필
		        var id = res.id;
		        var email = res.kakao_account.email;
		        var sns = "kakao";
		        if(!checkMember(sns, id)){
		        	if(confirm("회원이 아닙니다. 가입하시겠습니까?")){
		        		signupSns(sns, id, email);
		        	}else{
		        		return;
		        	}
		        }
		        snsLogin(sns, id);
		       	location.href = '<c:url value="/"/>';

		      },
		      fail: function (error) {
		          alert('카카오 로그인에 실패했습니다. 관리자에게 문의하세요.' + JSON.stringify(error));
		      }
		    });
		  }
		  function checkMember(sns, id){
			  
			  var res;
			  $.ajax({
					async : false,
					url : `<c:url value="/sns"/>/\${sns}/check/id`, 
					type : 'post', 
					data : {id}, 
					success : function (data){
						res = data;
					}, 
					error : function(jqXHR, textStatus, errorThrown){

					}
				});
			  return res;
		  }
		  function signupSns(sns, id, email){
			  $.ajax({
					async : false,
					url : `<c:url value="/sns"/>/\${sns}/signup`, 
					type : 'post', 
					data : {id, email}, 
					success : function (data){
						
					}, 
					error : function(jqXHR, textStatus, errorThrown){
						
					}
				});
		  }
		  function snsLogin(sns, id){
			  $.ajax({
					async : false,
					url : `<c:url value="/sns"/>/\${sns}/login`, 
					type : 'post', 
					data : {id}, 
					success : function (data){
						if(data){
							alert("로그인 되었습니다.");
						}
					}, 
					error : function(jqXHR, textStatus, errorThrown){
						
					}
				});
		  }
		</script>
		
	
	</div>
</body>
</html>
