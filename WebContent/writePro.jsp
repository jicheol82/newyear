<%@page import="practice.board.model.BoardDTO"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="practice.board.model.Functions"%>
<%@page import="java.util.Enumeration"%>
<%@page import="practice.board.model.BoardDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write Pro</title>
</head>
<%
	request.setCharacterEncoding("utf-8");
	// write에서 넘어온 정보를 dto에 받는다
	// dao.insertArticle(dto) 글 db에 등록
	// 그런데 파일이 있으면 앞에 form에서 enctype="multipart/form-data"를 써야하고
	// 이걸 쓰면 javabean은 못쓴다고 했음.
	// 역시 사용할 수 없음. 에러는 발생하지 않으나 null이 됨
	// 글은 어떻게 넘기지?
	// 아래 블로그에 잘나와 있음
	// https://gunbin91.github.io/jsp/2019/05/28/jsp_11_file.html
	
	// MultipartRequest 객체 만들기 전 매개변수 선언
	String path = request.getRealPath("files");
	int max = 1024*1024*5;
	String enc = "utf-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	// MultipartRequest 객체 생성
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	// form에서 받아온 정보(작성자, 글내용 등등) BoardDAO 객체에 저장하기
	BoardDTO dto = new BoardDTO();
	// dto에는 하나씩 다 넣어야 하나? 
	// ! java.lang.reflet api 사용
	// ! 아래코드가 javabean처럼 사용됨
	// MultipartRequest객체에서 Enumeration형의 parameter name 가져오기
	Enumeration enu = mr.getParameterNames();
	// parameter name을 이용하여 dao에 value 넣기
	while(enu.hasMoreElements()){
		String val = (String)enu.nextElement();
		//System.out.println(val);
		// Functions의 upperCaseFirst메서드를 이용하여 dao에 사용할 메서드명 생성
		String methodName = "set"+Functions.upperCaseFirst(val);
		//System.out.println(methodName);
		try{
			// java.lang.Class의 forName()메서드를 통해 클래스 찾기
			Class targetClass = Class.forName("practice.board.model.BoardDTO");
			// java.lang.reflect.Method의 getDeclaredMethods()를 이용하여 targetClass의 메소드를 찾음
			Method methods[] = targetClass.getDeclaredMethods();
			for(int i=0;i<methods.length;i++){
				// 가져온 메서드 이름 findMethod에 선언
				String findMethod = methods[i].getName();
				// 이름이 methodName인 method를 method[]에서 찾기
				if(findMethod.equals(methodName)){
					try{
						methods[i].invoke(dto, mr.getParameter(val));
					}catch(Exception e){e.printStackTrace();}
					finally{
						break;
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	/* MultipartRequest객체에서 name과 value의 확인
	for(int i=0; i<paraNameList.size(); i++){
		System.out.println(paraNameList.get(i)+" : "+paraValueList.get(i));
	}
	*/
	//dao.uploadContent(dao);
%>
<%-- 
<jsp:useBean id="dto" class="practice.board.model.BoardDTO"/>
<jsp:setProperty property="*" name="dto"/>
	<h3>writer : <%=dto.getWriter()%></h3>
	<h3>subject : <%=dto.getSubject()%></h3>
	<h3>content : <%=dto.getContent()%></h3>
	<h3>img : <%=dto.getImg()%></h3>
--%>
<body>
</body>
</html>