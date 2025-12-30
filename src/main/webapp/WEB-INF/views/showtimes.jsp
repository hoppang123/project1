<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상영시간표</title>
</head>
<body>

<h1>🕒 상영시간표</h1>

<p>
  <a href="<c:url value='/view/movies'/>">← 영화 목록</a>
</p>

<!-- movieId를 URL에서 추출해서 JS에서 사용 -->
<script>
  // 예: /project/view/movies/1/showtimes  또는 /view/movies/1/showtimes
  const path = location.pathname;
  const match = path.match(/\/view\/movies\/(\d+)\/showtimes/);
  const movieId = match ? match[1] : null;

  if (!movieId) {
    document.write("<p>movieId를 찾을 수 없습니다.</p>");
  } else {
    fetch("<c:url value='/api/movies/'/>" + movieId + "/showtimes")
      .then(r => r.json())
      .then(list => {
        if (!list || list.length === 0) {
          document.body.insertAdjacentHTML("beforeend", "<p>상영시간표가 없습니다.</p>");
          return;
        }

        let html = `
          <table border="1" cellpadding="8">
            <thead>
              <tr>
                <th>ID</th>
                <th>지점</th>
                <th>상영관</th>
                <th>시작</th>
                <th>종료</th>
                <th>가격</th>
                <th>좌석</th>
              </tr>
            </thead>
            <tbody>
        `;

        list.forEach(s => {
          html += `
            <tr>
              <td>${s.id}</td>
              <td>${s.theaterName ?? ""}</td>
              <td>${s.screenName ?? ""}</td>
              <td>${s.startTime ?? ""}</td>
              <td>${s.endTime ?? ""}</td>
              <td>${s.basePrice ?? ""}</td>
              <td>
                <a href="<c:url value='/view/showtimes/'/>${s.id}/seats">좌석보기</a>
              </td>
            </tr>
          `;
        });

        html += "</tbody></table>";
        document.body.insertAdjacentHTML("beforeend", html);
      })
      .catch(err => {
        console.error(err);
        document.body.insertAdjacentHTML("beforeend", "<p>API 호출 실패</p>");
      });
  }
</script>

</body>
</html>
