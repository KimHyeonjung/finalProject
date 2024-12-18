<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
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
            <div class="checkbox-and-links">
                <div class="left">
                    <input type="checkbox" name="autoLogin" value="Y"> 로그인 유지
                </div>
                <div class="right">
                   <a href="<c:url value='/findId'/>">아이디 찾기</a>
                   <a href="<c:url value='/findPassword'/>">비밀번호 찾기</a>
                </div>
            </div>

            <div class="form-field">
                <button type="submit" class="button-submit">로그인</button>
            </div>
			
		</form>
		<a id="kakao-login-btn" href="javascript:loginWithKakao()">
		  <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="222"
		    alt="카카오 로그인 버튼" />
		</a>
            <div class="account-text">
            	<p>계정이 없으신가요? <a href="<c:url value='/signup'/>">회원가입</a></p>
        	</div>
       	<c:if test="${not empty message}">
            <script type="text/javascript">
                alert('${message.msg}');
            </script>
        </c:if>
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