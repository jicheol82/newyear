<%@page import="practice.member.model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>아이디 중복확인</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head>
<%
	String id = request.getParameter("id");
	// db접속해서 id던져주고 해당 id가 db에 존재하는지 검사
	MemberDAO dao = MemberDAO.getInstance();
	boolean result = dao.confirmId(id);
	if(result){%>
		<body>
			<h3>아이디 중복확인</h3>
			<table>
				<tr>
					<td><%=id %>는 이미 사용중입니다.</td>
				</tr>
			</table>
		<form action="confirmId.jsp" method="post">
			<table>
				<tr>
					<td>
						다른 아이디를 입력하세요<br/>
						<input type="text" name="id"/>
						<input type="submit" value="ID중복확인"/>
					</td>
				</tr>
			</table>
		</form>
		</body>
		
<%	}else{%>
		<body>
			<h3>아이디 중복확인</h3>
			<table>
				<tr>
					<td><%=id %>는 사용하실 수 있습니다.<br/>
						<input type="button" value="닫기" onclick="setId()"/>
					</td>
				</tr>
			</table>
			<script>
				function setId(){
					//팝업을 열어준 원래 페이지의 id란에 지금 체크한 id값 넣어주기
					opener.document.inputForm.id.value="<%=id%>";
					// 팝업창 닫기
					self.close();
				}
			</script>
		</body>
<%}%>

</html>