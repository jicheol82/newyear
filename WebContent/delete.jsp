<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Delete Form</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
%>
<body>
	<br />
	<h1 align="center">delete article</h1>
	<form action="deletePro.jsp?pageNum=<%=pageNum%>" method="post">
		<input type="hidden" name="num" value="<%=num%>" />
		<table>
			<tr>
				<td>삭제를 원하시면 비밀번호를 입력하세요.</td>
			</tr>
			<tr>
				<td><input type="password" name="pw"/></td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="삭제"/>
					<input type="button" value="취소" onclick="location='main.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
	
	
</body>
</html>