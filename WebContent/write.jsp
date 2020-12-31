<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="../css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<br />
	<h1 align="center"> Write Article </h1>
	<form action="writePro.jsp?pageNum=<%=pageNum%>" method="post">
		<%-- 숨겨서 글 속성 전송 --%>
		<input type="hidden" name="num" value="<%=num %>" />
		<input type="hidden" name="ref" value="<%=ref %>" />
		<input type="hidden" name="re_step" value="<%=re_step %>" />
		<input type="hidden" name="re_level" value="<%=re_level %>" />
		<table>
			<tr>
				<td> 작성자 </td>
				<td align="left"> <input type="text" name="writer"/> </td>
			</tr>
			<tr>
				<td> 제목 </td>
				<td align="left"> <input type="text" name="subject"/> </td>
			</tr>
			<tr>
				<td> E-mail </td>
				<td align="left"> <input type="text" name="email"/> </td>
			</tr>
			<tr>
				<td> 내   용 </td>
				<td> <textarea rows="20" cols="70" name = "content"></textarea> </td>
			</tr>
			<tr>
				<td> 비밀번호 </td>
				<td align="left"> <input type="password" name="pw"/> </td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="저장"/> 
					<input type="reset" value="재작성"/>
					<input type="button" value="리스트 보기" onclick="location='list.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>