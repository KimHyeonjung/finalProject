<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS (필요한 경우) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Summernote JS -->
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/style.css'/>">
</head>
<body>
    <div class="container-notice">
        <h1>공지사항 수정</h1>
        <form action="<c:url value='/notice/update' />" method="post">
            <!-- 공지사항 번호 (hidden) -->
            <input type="hidden" name="notice_num" value="${notice.notice_num}">

            <div class="form-group">
                <label for="title">제목:</label>
                <input type="text" class="form-control" id="title" name="notice_title" value="${notice.notice_title}" required>
            </div>

            <div class="form-group">
                <label for="content">내용:</label>
                <textarea class="form-control" id="content" name="notice_content" required>${notice.notice_content}</textarea>
            </div>

            <button type="submit" class="btn color-update">수정 완료</button>
            <a href="/market/notice/detail?notice_num=${notice.notice_num}" class="btn btn-secondary">취소</a>
        </form>
    </div>

    <script>
        $(document).ready(function() {
            $('#content').summernote({
                placeholder: '내용을 작성하세요.',
                tabsize: 2,
                height: 400
            });
        });
    </script>
</body>
</html>
