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
                <button type="submit" class="button-submit">로그인</button>
            </div>

            <div class="form-field">
                <p>계정이 없으신가요? <a href="<c:url value='/signup'/>">회원가입</a></p>
            </div>
		</form>
	</div>
</body>
</html>
