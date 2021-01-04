<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	}else{
		//로그아웃시 쿠키도 삭제
		Cookie[] cs = request.getCookies();
		if(cs != null){
			for(Cookie c:cs){
				if(c.getName().equals("userId") || c.getName().equals("userPw") || c.getName().equals("autoLogin")){
					c.setMaxAge(0);
					response.addCookie(c);
				}
			}
		}
		session.invalidate();
		response.sendRedirect("main.jsp");		
	}
%>
<body>

</body>
</html>