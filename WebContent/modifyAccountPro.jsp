<%@page import="java.lang.reflect.Method"%>
<%@page import="practice.board.model.Functions"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="practice.member.model.MemberDAO"%>
<%@page import="practice.member.model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<% request.setCharacterEncoding("utf-8"); %>
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
	// modify page에서 가져온 parameter값 dto객체에 저장하기
	request.setCharacterEncoding("utf-8");
	String path = request.getRealPath("pic/");	//폴더명 뒤에 "/" 필요
	int max = 1024*1024*5;
	String enc = "utf-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	MemberDTO dto = new MemberDTO();
	Enumeration enu = mr.getParameterNames();
	while(enu.hasMoreElements()){
		String val = (String)enu.nextElement();
		String methodName = "set"+Functions.upperCaseFirst(val);
		try{
			Class targetClass = Class.forName("practice.member.model.MemberDTO");
			Method methods[] = targetClass.getDeclaredMethods();
			for(int i=0;i<methods.length;i++){
				String findMethod = methods[i].getName();
				if(findMethod.equals(methodName)){
					try{
						methods[i].invoke(dto, mr.getParameter(val));
					}catch(Exception e){e.printStackTrace();}
					finally{break;}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	// 첨부파일은 getParameter로 안가져와짐
	if(mr.getFilesystemName("picId")!=null){
		dto.setPic(mr.getFilesystemName("picId"));	
	}else{
		dto.setPic(mr.getParameter("exPicId"));
	}
	// db접속해서 수정
	MemberDAO dao = MemberDAO.getInstance();
	if(dao.modifyAccount(dto)){
%>
		<script>
			alert("회원정보를 변경하였습니다.");
			window.location='main.jsp';
		</script>
<%	
	}else{
%>
		<script>
			alert("회원정보변경에 실패하였습니다.");
			window.location='main.jsp';
		</script>
<%	
	}
%>
<body>

</body>
</html>
</html>