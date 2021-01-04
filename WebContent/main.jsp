<%@page import="practice.member.model.MemberDAO"%>
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
	
	// 1. 로그인 처리부
	Cookie[] cs = request.getCookies();
	boolean loggedin = false;	// login 상태 확인
	String picId = null;
	MemberDAO dao = MemberDAO.getInstance();
	// session이 있다면  login 되어있음
	if(session.getAttribute("userId")!=null){
		loggedin = true;
		picId = dao.getPicId(session.getAttribute("userId"));
	}else if(cs!=null){
		String id = null, pw = null, auto = null;
		for(Cookie c:cs){
			if(c.getName().equals("userId")){id=c.getValue();}
			if(c.getName().equals("userPw")){pw=c.getValue();}
			if(c.getName().equals("autoLogin")){auto=c.getValue();}
		}
		// 유효한 쿠키가 있다면 login 시도
		if(id!=null || pw!=null || auto!=null){
			response.sendRedirect("loginPro.jsp");	
		}
	}
	
%>
<%	
	// 2. 글 목록 관련 처리부
	// 변수 선언부
	int numOfList = 5;	// 한페이지에 보여줄 글 갯수
	int numOfPage = 2;	// 한번에 표시할 페이지의 겟수
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	// parameter로 null이 "null"로 넘어가는 경우 처리
	if(sel!=null || search!=null){
		if(sel.equals("null") || search.equals("null")){
			sel = null; search = null;
		}
	}
	BoardDAO bdao = BoardDAO.getInstance();
	int numOfRecords;
	if(sel!=null && search!=null){
		numOfRecords = bdao.countRecords(sel, search);	// board DB에 있는 조건에 맞는 글의 갯수
	}else{
		numOfRecords = bdao.countRecords();	// board DB에 있는 총 글의 갯수
	}
	int lastPage = numOfRecords / numOfList + (numOfRecords % numOfList > 0 ? 1 : 0);	// 총 글의 갯수/한페이지에 보여줄 글의 갯수가 나누어 떨어지지 않으면 +1
	int pageNum = request.getParameter("pageNum")!=null ? Integer.parseInt(request.getParameter("pageNum")) : 1;	// 현재 페이지의 번호(null이면 1)
	int startNum = numOfRecords - (numOfList*(pageNum-1));	// 한페이제 보여줄 시작글 번호
	int endNum = (startNum - numOfList + 1)>0 ? (startNum - numOfList + 1) : 1;	// 한페이제 보여줄 마지막글의 번호(마지막 글 번호가 음수면 1)
	int startPageNum = ((pageNum-1)/numOfPage)*numOfPage+1;	// 현재 페이지가 있는 페이지 그룹의 처음 페이지 번호
	int endPageNum = ((startPageNum + numOfPage -1)>=(lastPage)) ? (lastPage) : (startPageNum + numOfPage -1);	// 현재 페이지 번호가 마지막쪽에 위치 하지 않으면 startPageNum + numOfPage
	List records;
	if(sel!=null && search!=null){
		records = bdao.callRecords(startNum, endNum, sel, search);	// board DB에 있는 조건에 맞는 글의 갯수
	}else{
		records = bdao.callRecords(startNum, endNum);	// board DB에 있는 총 글의 갯수
	}
	// 리스트에 표시될 게시물의 시간 양식
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
%>
<body>
	<h1 align="center"><a href="main.jsp">Main</a></h1>
	<div>
		<table>
			<tr>
				<td>
					<form action="write.jsp?pageNum=<%=pageNum%>" method="post"><input type="hidden" name="loggedin" value="<%=loggedin%>"/>
					<button>글쓰기</button></form>
				</td>
<%
				if(loggedin){
%>
					<td colspan="3"><img src="/practice/pic/<%=picId%>" width="20" height="20">&nbsp;&nbsp;&nbsp;<%=session.getAttribute("userId")%>님 안녕하세요.</td>
					<td>
						<button onclick="location='logout.jsp'">Log Out</button>
						<button onclick="location='modifyAccount.jsp'">회원정보수정</button>
					</td>	
<%
				}else{
%>
					<td colspan="3"><h3>방문을 환영합니다.</h3></td>
					<td>
						<button onclick="location='login.jsp'">login</button><br />
						<button onclick="location='signup.jsp'">회원가입</button>
					</td>	
<%
				}
%>
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