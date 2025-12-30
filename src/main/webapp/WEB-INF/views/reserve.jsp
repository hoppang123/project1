<%@ page contentType="text/html; charset=UTF-8"%>
<!doctype html>
<html>
<head><meta charset="UTF-8"></head>
<body>

<h2>좌석 선택</h2>

<input id="seatIds" placeholder="예: 1,2">
<button onclick="reserve()">예매하기</button>

<pre id="out"></pre>

<script>
const showtimeId = location.pathname.split('/').pop();

async function reserve(){
  const seatIds = document.getElementById('seatIds').value
    .split(',').map(s=>Number(s.trim()));

  const res = await fetch('/api/reservations',{
    method:'POST',
    headers:{'Content-Type':'application/json'},
    body: JSON.stringify({ showtimeId, seatIds })
  });

  document.getElementById('out').innerText =
    res.ok ? '예매 성공!' : '예매 실패';
}
</script>

</body>
</html>
