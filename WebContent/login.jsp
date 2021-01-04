<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<%
	Cookie[] cs = request.getCookies();
	boolean loggedin = false;	// login 상태 확인
	// session이 있다면  login 되어있음
	if(session.getAttribute("userId")!=null){
		loggedin = true;
	}else if(cs!=null){
		String id = null, pw = null, auto = null;
		for(Cookie c:cs){
			if(c.getName().equals("userId")){id=c.getValue();}
			if(c.getName().equals("userPw")){pw=c.getValue();}
			if(c.getName().equals("autoLogin")){auto=c.getValue();}
		}
		// 유효한 쿠키가 있다면 log 시도
		if(id!=null || pw!=null || auto!=null){
			response.sendRedirect("loginPro.jsp");	
		}
	}
%>
<body>
<%
	if(loggedin){
%>
		<script type="text/javascript">
			alert("이미 로그인 상태입니다.")
			window.location="main.jsp";
		</script>
<%
	}else{
%>
		<form action="loginPro.jsp" method="post" onclick="">
				<table>
					<tr>
						<td>아이디</td>
						<td><input type="text" name="id" /></td>
						<td rowspan="2">
							<input type="submit" value="로그인"/><br />
							<label><input type="checkbox" name="autoLogin" value="1">자동로그인</label>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="pw" /></td>
					
					</tr>
					<tr>
						<td colspan="3">
							<input type="button" value="아이디찾기" onclick="location='findId.jsp'"/>
							<input type="button" value="비밀번호찾기" onclick="location='findPw.jsp'"/>
							<input type="button" value="메인으로" onclick="location='main.jsp'"/>
							<!-- <button onclick="location='main.jsp'">메인으로</button> 버튼으로 하면 submit되어 버림-->
						</td>
					</tr>
				</table>
			</form>
<%
	}
%>
<br/>
<div align="center">
	<img src="img/beach.jpg" width="800"/>
</div>
</body>
</html>