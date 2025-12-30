<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 선택</title>
</head>
<body>

<h1>💺 좌석 선택</h1>

<p>
  <a href="javascript:history.back()">← 뒤로</a>
</p>

<div id="info"></div>
<hr/>

<div id="seatArea">좌석 불러오는 중...</div>

<hr/>
<h3>✅ 선택한 좌석</h3>
<div id="selected">없음</div>

<hr/>
<h3>🎫 예매</h3>

<p>
  userId:
  <input type="number" id="userId" value="1" />
</p>

<button id="reserveBtn">예매하기</button>

<div id="result" style="margin-top:15px;"></div>

<script>
  // URL에서 showtimeId 추출: /view/showtimes/11/seats
  const path = location.pathname;
  const match = path.match(/\/view\/showtimes\/(\d+)\/seats/);
  const showtimeId = match ? match[1] : null;

  const seatArea = document.getElementById("seatArea");
  const selectedDiv = document.getElementById("selected");
  const resultDiv = document.getElementById("result");
  const infoDiv = document.getElementById("info");

  let selectedSeatIds = [];
  let selectedSeatCodes = [];

  if (!showtimeId) {
    seatArea.innerHTML = "<p>showtimeId를 찾을 수 없습니다.</p>";
  } else {
    infoDiv.innerHTML = "<p><b>상영 ID:</b> " + showtimeId + "</p>";

    // 1) 좌석 조회 API 호출
    fetch("<c:url value='/api/showtimes/'/>" + showtimeId + "/seats")
      .then(r => r.json())
      .then(list => {
        if (!list || list.length === 0) {
          seatArea.innerHTML = "<p>좌석 데이터가 없습니다.</p>";
          return;
        }

        // seatStatusDto 예시 필드 가정:
        // { seatId, seatCode, status } 또는 { id, seatCode, reserved }
        // 너 프로젝트 dto에 맞게 아래에서 읽는 키만 맞춰주면 됨.
        let html = "<form id='seatForm'><table border='1' cellpadding='8'><tr><th>선택</th><th>좌석</th><th>상태</th></tr>";

        list.forEach(s => {
          const seatId = (s.seatId ?? s.id);          // 둘 중 있는 거 사용
          const seatCode = (s.seatCode ?? s.code);    // 둘 중 있는 거 사용

          // status 판단 (프로젝트에 맞게)
          const status = (s.status ?? (s.reserved ? "RESERVED" : "AVAILABLE"));
          const reserved = (status === "RESERVED" || status === "CANCELED_RESERVED"); // 혹시 값 다르면 조정

          html += `
            <tr>
              <td>
                <input type="checkbox"
                       data-id="${seatId}"
                       data-code="${seatCode}"
                       ${reserved ? "disabled" : ""}/>
              </td>
              <td>${seatCode}</td>
              <td>${reserved ? "예약됨" : "가능"}</td>
            </tr>
          `;
        });

        html += "</table></form>";
        seatArea.innerHTML = html;

        // 체크 변경 이벤트
        document.querySelectorAll("#seatForm input[type=checkbox]").forEach(cb => {
          cb.addEventListener("change", () => {
            const id = Number(cb.getAttribute("data-id"));
            const code = cb.getAttribute("data-code");

            if (cb.checked) {
              selectedSeatIds.push(id);
              selectedSeatCodes.push(code);
            } else {
              selectedSeatIds = selectedSeatIds.filter(x => x !== id);
              selectedSeatCodes = selectedSeatCodes.filter(x => x !== code);
            }

            selectedDiv.innerText = selectedSeatCodes.length ? selectedSeatCodes.join(", ") : "없음";
          });
        });

      })
      .catch(err => {
        console.error(err);
        seatArea.innerHTML = "<p>좌석 API 호출 실패</p>";
      });
  }

  // 2) 예매 POST
  document.getElementById("reserveBtn").addEventListener("click", () => {
    resultDiv.innerHTML = "";

    const userId = Number(document.getElementById("userId").value);

    if (!showtimeId) {
      resultDiv.innerHTML = "<p>showtimeId가 없습니다.</p>";
      return;
    }
    if (!userId) {
      resultDiv.innerHTML = "<p>userId를 입력하세요.</p>";
      return;
    }
    if (selectedSeatIds.length === 0) {
      resultDiv.innerHTML = "<p>좌석을 1개 이상 선택하세요.</p>";
      return;
    }

    const payload = {
      userId: userId,
      showtimeId: Number(showtimeId),
      seatIds: selectedSeatIds
    };

    fetch("<c:url value='/api/reservations'/>", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
    .then(async r => {
      const text = await r.text();
      // 서버가 ApiResponse JSON을 줄 수도 있고, 단순 문자열을 줄 수도 있어서 방어
      try {
        return { ok: r.ok, json: JSON.parse(text) };
      } catch (e) {
        return { ok: r.ok, raw: text };
      }
    })
    .then(res => {
      if (res.json) {
        if (res.json.success) {
          resultDiv.innerHTML = "<p>✅ 예매 성공! reservationId = <b>" + res.json.data + "</b></p>";
        } else {
          resultDiv.innerHTML = "<p>❌ 실패: " + (res.json.message ?? "오류") + "</p>";
        }
      } else {
        // raw 응답
        resultDiv.innerHTML = "<p>응답: " + (res.raw ?? "") + "</p>";
      }
    })
    .catch(err => {
      console.error(err);
      resultDiv.innerHTML = "<p>❌ 예매 요청 실패</p>";
    });
  });
</script>

</body>
</html>
