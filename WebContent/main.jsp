<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="practice.board.model.BoardDAO"%>
<%@page import="practice.board.model.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>main</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<%
	// 변수 선언부
	int numOfList = 10;
	int numOfPage = 5;
	BoardDAO dao = BoardDAO.getInstance();
	List records = dao.callAllRecords(); //실제 게시글 수 보다 1개 더 많음(총 개시글 수가 last에 추가됨)
	int numOfRecords = (int)records.remove(records.size()-1);	// records 마지막에 있는 총 게시글 수를 빼온다.
	
	// 리스트에 표시될 게시물의 시간 양식
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
%>
<body>
	<h1 align="center">Main</h1>
	<div>
		<table>
			<tr><td colspan="5" align="right">로그인/회원가입<br />로그아웃/내계정 </td></tr>
			<tr>
				<td>글번호</td><td>작성자</td><td>제목</td><td>조회수</td><td>작성일</td>
			</tr>
<%
			if(numOfRecords>0){
				// iterator를 이용하여 records에서 객체 꺼내오기
				for(Iterator<BoardDTO> itr = records.iterator();itr.hasNext();numOfRecords--){
					BoardDTO dto = itr.next();
%>				
					<tr>
						<td><%=numOfRecords%></td>
						<td><%=dto.getWriter()%></td>
						<td><%=dto.getSubject()%></td>
						<td><%=dto.getReadcount()%></td>
						<td><%=sdf.format(dto.getReg())%></td>
					</tr>
<%				
				}
			}else{
%>
				<tr><td colspan="5" align="center">등록된 글이 없습니다. </td></tr>
<%
			}
%>
		</table>
	</div>
</body>
</html>