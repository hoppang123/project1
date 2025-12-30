<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Movie Reservation</title>
</head>
<body>

<h1>🎬 영화 예매 시스템</h1>

<ul>
  <li><a href="<c:url value='/movies'/>">영화 목록</a></li>
  <li><a href="<c:url value='/login'/>">로그인</a></li>
  <li><a href="<c:url value='/reservations'/>">내 예매</a></li>
</ul>

</body>
</html>
