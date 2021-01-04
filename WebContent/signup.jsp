<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Sign Up</title>
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
		function check(){
			//id와 pwassword 유효성 검사 정규식
			var RegExp = /^[a-zA-Z0-9]{4,12}$/; 
	        //이메일 유효성검사
	        var e_RegExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
			var inputs = document.inputForm;
			// 필수기입란 기입했는지
			if(!inputs.id.value){
				alert("아이디 입력하세요.");
				return false;
			}else if(inputs.pw.value != inputs.pwCh.value){
				alert("pw가 일치하지 않습니다.");
				return false;
			}else if(!RegExp.test(inputs.id.value)){
				alert("아이디는 영어 대소문자 와 숫자만 이용하세요.");
				return false;
			}else if(!RegExp.test(inputs.pw.value)){
				alert("비밀번호는 영어 대소문자 와 숫자만 이용하세요.");
				return false;
			}else if(!e_RegExp.test(inputs.email.value)){
				alert("유효하지 않은 email주소입니다.");
				return false;
			}
		}
		// id중복확인함수
		function openConfirmId(inputForm){	// this.form 
			// form 태그안에 id입력란에 작성한 값을 꺼내서 db연결해 검사
			console.log(inputForm.id.value);	//폼태그안에 name속성이 id인 태그의 값 출력
			if(inputForm.id.value==""){	// id란에 입력했는지 검사
				alert("아이디를 입력하세요");	
				return;	//아래 코드 실행하지 않고 이 함수 종료
			}
			// 팝업띄워서 id확인결과 보기
			// 팝업띄울 주소를 작성 > id란에 입력한 값을 get 방식 파라미터로 같이 전송.
			var url = "confirmId.jsp?id="+inputForm.id.value;
			open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=300, height=200");
			
		}
	</script>

<body>
	<form action="signupPro.jsp" name="inputForm" method="post" enctype="multipart/form-data" onsubmit="return check()">
		<table>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id"/></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="button" value="아이디 중복 확인" onclick="openConfirmId(this.form)" /></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pw" /></td>
			</tr>
			<tr>
				<td>비밀번호확인</td>
				<td><input type="password" name="pwCh" /></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" name="name" /></td>
			</tr>
			<tr>
				<td>생년월일</td>
				<td><input type="date" name="birth" /></td>
			</tr>
			<tr>
				<td>E-mail</td>
				<td><input type="text" name="email" /></td>
			</tr>
			<tr>
				<td>내사진</td>
				<td><input type="file" name="myPic" /></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="가입" />
					<input type="reset" value="다시작성" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="Main으로" onclick="location='main.jsp'"/>
				</td>
			</tr>
		</table>
	</form>	
</body>
</html>