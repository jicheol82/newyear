<%@page import="practice.member.model.MemberDTO"%>
<%@page import="practice.member.model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Modify</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
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
	<script>
	// 유효성 검사
	// 유효성 검사
		function check(){
			//id와 pwassword 유효성 검사 정규식
			var RegExp = /^[a-zA-Z0-9]{4,12}$/; 
	        //이메일 유효성검사
	        var e_RegExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
			var inputs = document.inputForm;
			// 필수기입란 기입했는지
			if(inputs.pw.value != inputs.pwCh.value){
				alert("pw가 일치하지 않습니다.");
				return false;
			}else if(!RegExp.test(inputs.pw.value)){
				alert("비밀번호는 영어 대소문자 와 숫자만 이용하세요.");
				return false;
			}else if(!e_RegExp.test(inputs.email.value)){
				alert("유효하지 않은 email주소입니다.");
				return false;
			}
		}
	</script>
<%
	// 세션에서 받은 id로 회원정보 가져오기
	String id = (String)session.getAttribute("userId");
	MemberDAO dao = MemberDAO.getInstance();
	MemberDTO dto = dao.getIdInfo(id);
%>
<body>
<form action="modifyAccountPro.jsp" name="inputForm" method="post" enctype="multipart/form-data" onsubmit="return check()" >
		<table>
			<tr>
				<td>아이디</td>
				<td><%=dto.getId() %><input type="hidden" name="id" value="<%=dto.getId()%>"/></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pw" value="<%=dto.getPw()%>"/></td>
			</tr>
			<tr>
				<td>비밀번호확인</td>
				<td><input type="password" name="pwCh" value="<%=dto.getPw()%>"/></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><%=dto.getName() %></td>
			</tr>
			<tr>
				<td>생년월일</td>
				<td><input type="date" name="birth" value="<%=dto.getBirth()%>"/></td>
			</tr>
			<tr>
				<td>E-mail</td>
				<td><input type="text" name="email" value="<%=dto.getEmail()%>"/></td>
			</tr>
			<tr>
				<td>내사진</td>
				<td>
<%
					if(dto.getPic()!=null){
%>
						<img src="/practice/pic/<%=dto.getPic()%>" /><br />
<%					
					}else{
%>
						<img src="/practice/pic/default.jpg" /><br />
<%						
					}
%>
					<input type="file" name="picId" />
					<input type="hidden" name="exPicId" value="<%=dto.getPic()%>"/>
					
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="변경" />
					<input type="reset" value="재작성" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="Main으로" onclick="location='main.jsp'"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="탈퇴하기" onclick="location='resign.jsp'"/>
				</td>
			</tr>
		</table>
	</form>	
</body>
</html>