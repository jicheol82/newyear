<%@page import="practice.board.model.BoardDTO"%>
<%@page import="practice.board.model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Modify Form</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<%
	// 글 고유번호, 페이지번호
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	// db에서 글 고유번호로 해당 글 모든 내용 받아오기
	BoardDAO dao = BoardDAO.getInstance();
	BoardDTO dto = dao.getArticle(num);
%>
<body>
	<br />
	<h1 align="center">modify article</h1>
	<form action="modifyPro.jsp?pageNum=<%=pageNum%>" method="post" enctype="multipart/form-data">
	<%--글 고유번호 숨겨서 보내기 --%>
		<input type="hidden" name="num" value="<%=num%>" />
		<table>
			<tr>
				<td> 작성자 </td>
				<td align="left"> <%=dto.getWriter()%> </td>
			</tr>
			<tr>
				<td> 제목 </td>
				<td align="left"> <%=dto.getSubject()%> </td>
			</tr>
			<tr>
				<td> E-mail </td>
				<td align="left"> <input type="text" name="email" value="<%=dto.getEmail()%>"/> </td>
			</tr>
			<tr>
				<td> 내   용 </td>
				<td> <textarea rows="20" cols="70" name="content"><%=dto.getContent()%></textarea> </td>
			</tr>
			<tr>
				<td> 첨부파일 </td>
				<td>
<%
				if(dto.getImg()!=null){
%>
					<img src="/practice/files/<%=dto.getImg()%>" /><br />
<%					
				}else{
%>
					첨부파일이 없습니다.<br />
<%					
				}
%>
				<input type="file" name="attach" />
				<input type="hidden" name="exAttach" value="<%=dto.getImg()%>"/> </td>
			</tr>
			<tr>
				<td> 비밀번호 </td>
				<td align="left"> <input type="password" name="pw"/> </td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정"/> 
					<input type="button" value="취소" onclick="location='main.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>