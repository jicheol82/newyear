<%@page import="java.lang.reflect.Method"%>
<%@page import="practice.board.model.Functions"%>
<%@page import="java.util.Enumeration"%>
<%@page import="practice.board.model.BoardDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="practice.board.model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	// modify page에서 가져온 parameter값 dto객체에 저장하기
	request.setCharacterEncoding("utf-8");
	String path = request.getRealPath("files/");	//폴더명 뒤에 "/" 필요
	int max = 1024*1024*5;
	String enc = "utf-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	BoardDTO dto = new BoardDTO();
	Enumeration enu = mr.getParameterNames();
	while(enu.hasMoreElements()){
		String val = (String)enu.nextElement();
		String methodName = "set"+Functions.upperCaseFirst(val);
		try{
			Class targetClass = Class.forName("practice.board.model.BoardDTO");
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
	if(mr.getFilesystemName("attach")!=null){
		dto.setImg(mr.getFilesystemName("attach"));	
	}else{
		dto.setImg(mr.getParameter("exAttach"));
	}
	// db접속해서 수정
	BoardDAO dao = BoardDAO.getInstance();
	boolean result = dao.updateArticle(dto);
	String pageNum = request.getParameter("pageNum");
	if(result){
		response.sendRedirect("main.jsp?pageNum="+pageNum);	
	}else{
%>
		<script>
			alert("암호가 일치하지 않습니다.");
			history.go(-1);
		</script>		
<%
	}
%>
<body>

</body>
</html>