<%@page import="practice.board.model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete Pro</title>
</head>
<%
	request.setCharacterEncoding("utf-8");

	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	String pw = request.getParameter("pw");
	
	//dao 통해서 삭제
	BoardDAO dao = BoardDAO.getInstance();
	if(dao.deleteArticle(num, pw)){
		response.sendRedirect("main.jsp?pageNum="+pageNum);
	}else{
%>		
	<script>
		alert("비밀번호가 틀렸습니다.");
		history.go(-1);
	</script>

<%	
	}
%>
<body>

</body>
</html>