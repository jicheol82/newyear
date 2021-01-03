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
	int numOfList = 5;	// 한페이지에 보여줄 글 갯수
	int numOfPage = 2;	// 한번에 표시할 페이지의 겟수
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	BoardDAO dao = BoardDAO.getInstance();
	int numOfRecords;
	if(sel!=null && search!=null){
		numOfRecords = dao.countRecords(sel, search);	// board DB에 있는 조건에 맞는 글의 갯수
	}else{
		numOfRecords = dao.countRecords();	// board DB에 있는 총 글의 갯수
	}
	int lastPage = numOfRecords / numOfList + (numOfRecords % numOfList > 0 ? 1 : 0);	// 총 글의 갯수/한페이지에 보여줄 글의 갯수가 나누어 떨어지지 않으면 +1
	int pageNum = request.getParameter("pageNum")!=null ? Integer.parseInt(request.getParameter("pageNum")) : 1;	// 현재 페이지의 번호(null이면 1)
	int startNum = numOfRecords - (numOfList*(pageNum-1));	// 한페이제 보여줄 시작글 번호
	int endNum = (startNum - numOfList + 1)>0 ? (startNum - numOfList + 1) : 1;	// 한페이제 보여줄 마지막글의 번호(마지막 글 번호가 음수면 1)
	int startPageNum = ((pageNum-1)/numOfPage)*numOfPage+1;	// 현재 페이지가 있는 페이지 그룹의 처음 페이지 번호
	int endPageNum = ((startPageNum + numOfPage -1)>=(lastPage)) ? (lastPage) : (startPageNum + numOfPage -1);	// 현재 페이지 번호가 마지막쪽에 위치 하지 않으면 startPageNum + numOfPage
	List records;
	if(sel!=null && search!=null){
		records = dao.callRecords(startNum, endNum, sel, search);	// board DB에 있는 조건에 맞는 글의 갯수
	}else{
		records = dao.callRecords(startNum, endNum);	// board DB에 있는 총 글의 갯수
	}
	
	// 리스트에 표시될 게시물의 시간 양식
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
%>
<body>
	<h1 align="center"><a href="main.jsp">Main</a></h1>
	<div>
		<table>
			<tr>
				<td><button onclick="location='write.jsp'">글쓰기</button></td>
				<td colspan="4" align="right">로그인/회원가입<br />로그아웃/내계정 </td>
			</tr>
			<tr>
				<td>글번호</td><td>작성자</td><td>제목</td><td>조회수</td><td>작성일</td>
			</tr>
<%
			if(numOfRecords>0){	// board내에 게시글이 있는경우
				// iterator를 이용하여 records에서 객체 꺼내오기
				for(Iterator<BoardDTO> itr = records.iterator();itr.hasNext();startNum--){
					BoardDTO dto = itr.next();
%>				
					<tr>
						<td><%=startNum%></td>
						<td><a href="mailto:<%=dto.getEmail()%>"><%=dto.getWriter()%></a></td>
						<td align="left"><a href="view.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>" >
<%							
							int wid = Integer.parseInt(dto.getRe_level());
							if(wid>0){
%>
							<img src="img/tabImg.PNG" width="<%=wid*8%>" />
							<img src="img/replyImg.png" width="10" />
<%
							}
%>
						<%=dto.getSubject()%>
						</a></td>
						<td><%=dto.getReadcount()%></td>
						<td><%=sdf.format(dto.getReg())%></td>
					</tr>
<%				
				}
			}else{	// board내에 게시글이 없는 경우
%>
				<tr><td colspan="5" align="center">등록된 글이 없습니다. </td></tr>
<%
			}
%>
		</table>
	</div>
	<br />
	<div align="center">
		<%-- 페이지 표시 --%>
<%
		if(startPageNum>numOfPage){	//맨 처음쪽에 위치하지 않을때
%>				
			<a href="main.jsp?pageNum=1" class="pageNums"> 처음</a>
			<a href="main.jsp?pageNum=<%=startPageNum-numOfPage%>" class="pageNums"> 이전</a>			
<%				
		}
%>
<%
		for(int i=startPageNum; i<=endPageNum; i++){
%>
			<a href="main.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>" class="pageNums">&nbsp; <%=i %> &nbsp;</a>
<%
		}
%>
<%
		if((startPageNum + numOfPage -1) < lastPage){	// 맨 마지막에 위치하지 않을때
%>
			<a href="main.jsp?pageNum=<%=startPageNum+numOfPage%>" class="pageNums"> 다음</a>
			<a href="main.jsp?pageNum=<%=lastPage%>" class="pageNums"> 마지막</a>	
<%
		}
%>
		<%-- 작성자/내용 검색 --%>
		<form action="main.jsp">
			<select name="sel">
				<option value="null">선택하세요</option>
				<option value="writer">작성자</option>
				<option value="content">내용</option>
			</select>
			<input type="text" name="search" />
			<input type="submit" value="검색" />
		</form>
	</div>
</body>
</html>