<%@page import="java.text.SimpleDateFormat"%>
<%@page import="practice.board.model.BoardDTO"%>
<%@page import="practice.board.model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>view</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<% 
	String pageNum = request.getParameter("pageNum");
	BoardDAO dao = BoardDAO.getInstance();
	BoardDTO dto = dao.callRecord(Integer.parseInt(request.getParameter("num")));
	SimpleDateFormat sdf = new SimpleDateFormat();
%>
<%-- 답글 --%>
<%-- 글 수정 --%>
<%-- 글 삭제 --%>
<body>
	<%-- 글 보여주기 --%>
	<br />
	<h1 align="center"> Article </h1>
		<%-- 숨겨서 글 속성 전송 --%>
		
		<input type="hidden" name="num" value="<%=request.getParameter("num")%>" />
		<input type="hidden" name="ref" value="<%=request.getParameter("ref")%>" />
		<input type="hidden" name="re_step" value="<%=request.getParameter("re_step")%>" />
		<input type="hidden" name="re_level" value="<%=request.getParameter("re_level")%>" />
		
		<table>
			<tr>
				<td colspan="2"><b><%=dto.getSubject() %></b></td>
			</tr>
			<tr>
				<td colspan="2"><%=dto.getContent() %></td>
			</tr>
			<tr>
				<td>posted by <a href="mail:to<%=dto.getEmail()%>"><b><%=dto.getWriter() %></b></a> at <%=sdf.format(dto.getReg()) %></td>
				<td><%=dto.getReadcount() %> viewd </td>
			</tr>
			<tr>
				<td colspan="2">
					<button onclick="location='modifyForm.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'">수정</button>
					<button onclick="location='deleteForm.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'">삭제</button>
					<button onclick="location='write.jsp?num=<%=dto.getNum()%>&ref=<%=dto.getRef()%>&re_level=<%=dto.getRe_level()%>&re_step=<%=dto.getRe_step()%>&pageNum=<%=pageNum%>'">답글</button>
					<button onclick="location='main.jsp?pageNum=<%=pageNum%>'">리스트</button>
				</td>
				
			</tr>
		</table>
</body>
</html>