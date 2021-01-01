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
	// 글은 어떻게 넘기지?
%>
<body>

</body>
</html>