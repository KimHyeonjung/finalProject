<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<!-- The Modal -->
<div class="modal" id="Modal">
	<div class="modal-dialog">
    	<div class="modal-content">

			<div class="modal-header">
				<h4 class="modal-title">비밀번호 변경</h4>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
		
			<div class="modal-body">
				<form action="<c:url value="/updatepw"/>" method="post" id="form">
					<div class="form-group">
						<label for="oldpw">기존 비밀번호:</label> 
						<input type="password" class="form-control" id="oldpw" name="oldpw">
					</div>
					<div class="form-group">
						<label for="newpw">새 비밀번호:</label> 
						<input type="password" class="form-control" id="newpw" name="newpw">
					</div>
					<div class="form-group">
						<label for="newpw2">새 비밀번호 확인:</label> 
						<input type="password" class="form-control" id="newpw2" name="newpw2">
					</div>
					<button type="submit" class="col-12 btn-submit btn">수정</button>
				</form>
			</div>
		</div>
	</div>
</div>

