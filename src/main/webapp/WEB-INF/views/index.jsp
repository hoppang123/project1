<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>Movie Reservation MAIN</title>
<style>
body { font-family: Arial, sans-serif; }

.box {
  border: 1px solid #ddd;
  padding: 10px;
  margin: 10px 0;
}

.row { margin: 6px 0; }

.ok  { color: #060; font-weight: bold; }
.bad { color: #c00; font-weight: bold; }

select, input { padding: 4px; }
button { padding: 6px 10px; margin-right: 6px; }

#out {
  border: 1px solid #ccc;
  padding: 8px;
  margin-top: 10px;
  white-space: pre-wrap;
  font-family: Consolas, monospace;
  font-size: 13px;
}
</style>
</head>
<body>

<h2>🎬 영화 예매 메인 화면</h2>

<!-- 상단 메뉴 / 로그인 상태 -->
<div class="box">
  <button onclick="location.href='/'">메인</button>
  <button onclick="location.href='/login'">로그인</button>
  <button onclick="logout()">로그아웃</button>
  <button onclick="location.href='/my'">내 예매내역</button>
  <span id="loginState" style="margin-left:10px;"></span>
</div>

<!-- 1) 영화 선택 -->
<div class="box">
  <h3>1) 영화 선택</h3>
  <div class="row">
    <button onclick="loadMovies()">영화 목록 불러오기</button>
  </div>
  <div class="row">
    <label>movieId:
      <select id="movieSelect" onchange="onMovieChange()">
        <option value="">-- 선택 --</option>
      </select>
    </label>
  </div>
</div>

<!-- 2) 상영시간표 선택 -->
<div class="box">
  <h3>2) 상영시간표 선택</h3>
  <div class="row">
    <button onclick="loadShowtimes()">상영시간표 불러오기</button>
  </div>
  <div class="row">
    <label>showtimeId:
      <select id="showtimeSelect" onchange="onShowtimeChange()">
        <option value="">-- 선택 --</option>
      </select>
    </label>
  </div>
</div>

<!-- 3) 좌석 조회 -->
<div class="box">
  <h3>3) 좌석 조회</h3>
  <div class="row">
    <button onclick="loadSeats()">좌석 불러오기</button>
  </div>
  <div class="row">
    <label>좌석ID(콤마로 여러 개):</label>
    <input id="seatIdsInput" placeholder="예: 1 또는 1,2,3" style="width:200px;">
  </div>
  <div class="row">
    <small>※ 좌석 API 결과에서 seatId를 보고 입력하면 돼.</small>
  </div>
</div>

<!-- 4) 예매 -->
<div class="box">
  <h3>4) 예매</h3>
  <div class="row">
    <button id="reserveBtn" onclick="reserve()">예매하기</button>
    <span id="reserveLockMsg" class="bad" style="margin-left:10px;"></span>
  </div>
</div>

<pre id="out"></pre>

<script>
/* =========================
   공통 출력 함수
   ========================= */
function printOut(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

/* =========================
   로그인 상태 / 로그아웃
   ========================= */
let isLoggedIn = false;

async function refreshLoginState(){
  const res = await fetch('/api/auth/me');
  const el  = document.getElementById('loginState');
  const btn = document.getElementById('reserveBtn');
  const lockMsg = document.getElementById('reserveLockMsg');

  if(res.status === 200){
    isLoggedIn = true;
    const text = await res.text();   // "userId=1, loginId=aaa" 같은 문자열이라고 가정
    el.innerHTML = '<span class="ok">LOGIN</span> - ' + text;

    btn.disabled = false;
    lockMsg.textContent = '';
  } else {
    isLoggedIn = false;
    el.innerHTML = '<span class="bad">NOT LOGIN</span>';
    btn.disabled = true;
    lockMsg.textContent = '로그인 후 예매할 수 있습니다.';
  }
}

async function logout(){
  await fetch('/api/auth/logout', { method:'POST' });
  await refreshLoginState();
  printOut('로그아웃 완료');
}

/* =========================
   1) 영화 목록
   ========================= */
async function loadMovies(){
  const url = '/api/movies';
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    printOut('GET ' + url + '\nSTATUS=' + res.status + '\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);

  const sel = document.getElementById('movieSelect');
  sel.innerHTML = '<option value="">-- 선택 --</option>';

  data.forEach(m => {
    const opt = document.createElement('option');
    opt.value = m.id;                       // id 저장
    opt.textContent = m.id + ' - ' + m.title;
    sel.appendChild(opt);
  });

  // 영화 바뀌면 하위 선택 초기화
  document.getElementById('showtimeSelect').innerHTML =
    '<option value="">-- 선택 --</option>';
  document.getElementById('seatIdsInput').value = '';
}

function onMovieChange(){
  // 필요하면 영화 선택 시 자동으로 상영시간표 로딩
  // loadShowtimes();
}

/* =========================
   2) 상영시간표
   ========================= */
async function loadShowtimes(){
  const movieId = document.getElementById('movieSelect').value;

  if(!movieId){
    printOut(
      'movieId를 먼저 선택하세요. (영화 목록 불러오기 → 영화 선택)\n' +
      '현재 movieId 값: "' + movieId + '"'
    );
    return;
  }

  const url = `/api/movies/${movieId}/showtimes`;
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    printOut('GET ' + url + '\nSTATUS=' + res.status + '\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);

  const sel = document.getElementById('showtimeSelect');
  sel.innerHTML = '<option value="">-- 선택 --</option>';

  data.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent =
      s.id + ' | ' + s.startTime + ' ~ ' + s.endTime + ' | ' +
      s.theaterName + '/' + s.screenName + ' | ' + s.basePrice + '원';
    sel.appendChild(opt);
  });

  document.getElementById('seatIdsInput').value = '';
}

function onShowtimeChange(){
  document.getElementById('seatIdsInput').value = '';
}

/* =========================
   3) 좌석 조회
   ========================= */
async function loadSeats(){
  const showtimeId = document.getElementById('showtimeSelect').value;

  if(!showtimeId){
    printOut('showtimeId를 먼저 선택하세요.');
    return;
  }

  const url = `/api/showtimes/${showtimeId}/seats`;
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    printOut('GET ' + url + '\nSTATUS=' + res.status + '\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);
}

/* =========================
   4) 예매
   ========================= */
async function reserve(){
  // 예매 직전에 세션 다시 확인
  await refreshLoginState();
  if(!isLoggedIn){
    alert('로그인이 필요합니다.');
    location.href = '/login';
    return;
  }

  const showtimeId = document.getElementById('showtimeSelect').value;
  if(!showtimeId){
    printOut('showtimeId를 먼저 선택하세요.');
    return;
  }

  let seatText = document.getElementById('seatIdsInput').value.trim();
  if(!seatText){
    // 입력이 없으면 prompt로 받아 볼 수도 있음
    seatText = prompt('예매할 좌석 id들을 입력하세요 (예: 1 또는 1,2,3)');
    if(!seatText){
      printOut('예매가 취소되었습니다.');
      return;
    }
  }

  const seatIds = seatText
    .split(',')
    .map(s => s.trim())
    .filter(s => s.length > 0)
    .map(s => Number(s))
    .filter(n => !Number.isNaN(n));

  if(seatIds.length === 0){
    printOut('좌석 id 입력이 올바르지 않습니다.');
    return;
  }

  const payload = {
    showtimeId: Number(showtimeId),
    seatIds: seatIds
  };

  const url = '/api/reservations';
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type':'application/json' },
    body: JSON.stringify(payload)
  });

  const text = await res.text();
  if(res.ok){
    printOut('POST ' + url + '\nSTATUS=' + res.status + '\n예약 ID: ' + text);
  } else {
    printOut('POST ' + url + '\nSTATUS=' + res.status + '\n' + text);
  }
}

/* 처음 들어올 때 로그인 상태부터 체크 */
refreshLoginState();
</script>

</body>
</html>
