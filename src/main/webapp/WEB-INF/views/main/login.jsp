<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>LOGIN</h1>
	<hr/>
	
	<form action="/login" method="post">
		id : <input type="text" name="username"/><br/>
		pw : <input type="text" name="password"/><br/>
		<input type="checkbox" name="remember-me"/> Remember Me<br/>
		<input type="submit" value="로그인"/>
		<sec:csrfInput/>
	</form>
</body>
</html>