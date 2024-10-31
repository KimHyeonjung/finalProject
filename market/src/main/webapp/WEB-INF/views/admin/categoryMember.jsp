<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<thead>
  <tr>
    <th>신고대상</th>
    <th>신고일</th>
    <th>신고자</th>
    <th>신고내용</th>
  </tr>
</thead>
<tbody>
	<c:forEach items="${list }" var="report">
   <tr>
     <td>${report.post_member_id}(${report.post_member_nick})</td>
     <td>${report.report_date}</td>
     <td>${report.report_member_id}(${report.report_member_nick})</td>
     <td>${report.report_content}</td>
   </tr>
	</c:forEach>
</tbody>