<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 목록</title>
</head>
<body>

<h1>🎬 영화 목록</h1>
<p><a href="<c:url value='/'/>">🏠 홈으로</a></p>

<div id="movieArea">로딩중...</div>

<script>
fetch("<c:url value='/api/movies'/>")
  .then(r => r.json())
  .then(res => {
    // ApiResponse 쓰면 res.data, 아니면 res 자체가 리스트일 수 있음
    const movies = res.data ? res.data : res;

    if (!movies || movies.length === 0) {
      document.getElementById("movieArea").innerHTML = "<p>영화 데이터가 없습니다.</p>";
      return;
    }

    let html = `
      <table border="1" cellpadding="8">
        <thead>
          <tr>
            <th>ID</th>
            <th>제목</th>
            <th>상영시간(분)</th>
            <th>등급</th>
            <th>상영시간표</th>
          </tr>
        </thead>
        <tbody>
    `;

    movies.forEach(m => {
      html += `
        <tr>
          <td>${m.id}</td>
          <td>${m.title}</td>
          <td>${m.runtimeMin ?? ""}</td>
          <td>${m.rating ?? ""}</td>
          <td><a href="<c:url value='/movies'/>/${m.id}/showtimes">보기</a></td>
        </tr>
      `;
    });

    html += `</tbody></table>`;
    document.getElementById("movieArea").innerHTML = html;
  })
  .catch(err => {
    document.getElementById("movieArea").innerHTML = "<p>오류: " + err + "</p>";
  });
</script>

</body>
</html>
