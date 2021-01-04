<%@page import="practice.member.model.MemberDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Result</title>
</head>
<%	
	// url 접근 방지
	String referer = request.getHeader("referer");
	if(referer == null){
%>
		<script>
			alert("비정상적인 접근입니다.");
			history.go(-1);
		</script>
<%	
	}
%>
<%
	// 필요 변수 선언부
	boolean idPwCh = false;
	String id = null;
	String pw = null;
	String auto = null;
	int maxAge = 60*60*24;
	// 필요 객체 선언부
	Cookie[] cs = request.getCookies();
	MemberDAO dao = MemberDAO.getInstance();
	// session이 없는 경우는 이 페이지에 접근 하지 못함.
	// cookie없이도 이 페이지에 접근하지 못함(cs==null은 페이지 직접 접근일 때만 가능)
	// cs로부터 유효data 추출
	for(Cookie c:cs){
		if(c.getName().equals("userId")){id=c.getValue();}
		if(c.getName().equals("userPw")){pw=c.getValue();}
		if(c.getName().equals("autoLogin")){auto=c.getValue();}
	}
	// 쿠키로부터 유효한 data가 있으면 idPwCh는 true
	if(id!=null || pw!=null || auto!=null){
		if(dao.loginCh(id, pw)){
			idPwCh = true;
		}
	}else{ // 쿠키에 유효한 data없으면 이전페이지에서 받아온 data로 loginCh
		id = request.getParameter("id");
		pw = request.getParameter("pw");
		auto = request.getParameter("autoLogin");
		if(dao.loginCh(id, pw)){
			idPwCh = true;
		}
	}
	
%>
<body>
<%
	if(idPwCh){	// 로그인 성공
		//쿠키 생성하기
		if(auto!=null){
			Cookie cookie1 = new Cookie("userId", id);
			Cookie cookie2 = new Cookie("userPw", pw);
			Cookie cookie3 = new Cookie("autoLogin", auto);
			cookie1.setMaxAge(maxAge);
			cookie2.setMaxAge(maxAge);
			cookie3.setMaxAge(maxAge);
			response.addCookie(cookie1);
			response.addCookie(cookie2);
			response.addCookie(cookie3);
		}
		session.setAttribute("userId", id);
		response.sendRedirect("main.jsp");
	}else{	//로그인 실패
%>
		<script type="text/javascript">
			alert("id나 pw가 일치하지 않습니다.")
			history.go(-1);
		</script>
<%
	}
%>
</body>
</html>