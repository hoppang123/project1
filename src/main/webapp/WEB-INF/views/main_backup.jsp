<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>Movie Reservation - 메인</title>

<style>
<div class="card">
  <div class="card-header">메뉴</div>
  <div style="display:flex; gap:10px; flex-wrap:wrap;">
    <button class="btn btn-main" onclick="location.href='/reserve/movie'">
      🎟 영화 예매하기
    </button>
    <button class="btn btn-sub" onclick="location.href='/my'">
      📃 내 예매내역 보기
    </button>
    <button class="btn btn-sub" onclick="loadMovies()">
      🎞 상영 영화 목록 보기
    </button>
  </div>
</div>



body {
  font-family: Arial, sans-serif;
  background: #10141f;
  color: #f5f5f5;
  margin: 0;
  padding: 0;
}
.wrap {
  max-width: 960px;
  margin: 20px auto 40px;
  padding: 20px;
  background: #141829;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.6);
}
h1, h2, h3 {
  margin: 0 0 10px;
}
h1 {
  font-size: 26px;
  margin-bottom: 20px;
}
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  font-size: 13px;
}
.btn-small {
  font-size: 12px;
  padding: 4px 8px;
}
.btn-main {
  background: #ff4b4b;
  color: #fff;
}
.btn-sub {
  background: #2f364a;
  color: #fff;
}
.btn-main:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.tag-ok {
  color: #4caf50;
  font-weight: bold;
}
.tag-bad {
  color: #ff5252;
  font-weight: bold;
}
.card {
  background: #181c30;
  border-radius: 8px;
  padding: 12px 14px;
  margin-bottom: 12px;
}
.card-header {
  font-weight: bold;
  margin-bottom: 8px;
}
select, input {
  padding: 5px 8px;
  border-radius: 4px;
  border: 1px solid #434b61;
  background: #10141f;
  color: #f5f5f5;
}
select:focus, input:focus {
  outline: none;
  border-color: #ff4b4b;
}
#seatIdsInput {
  width: 240px;
}
#out {
  background: #0b0f19;
  border-radius: 8px;
  padding: 8px;
  margin-top: 12px;
  white-space: pre-wrap;
  font-family: Consolas, monospace;
  font-size: 12px;
  max-height: 260px;
  overflow-y: auto;
  border: 1px solid #262b3e;
}

/* 좌석 영역(그리드처럼 보여 주기용) */
#seatHint {
  font-size: 12px;
  color: #ccc;
}
</style>
</head>
<body>

<div class="wrap">

  <!-- 상단 영역 -->
  <div class="header-bar">
    <div>
      <h1>🎬 영화 예매 메인</h1>
      <div id="loginState"></div>
    </div>
    <div>
      <button class="btn btn-sub btn-small" onclick="location.href='/'">API TEST</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/login'">로그인</button>
      <button class="btn btn-sub btn-small" onclick="logout()">로그아웃</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
    </div>
  </div>

  <!-- 1) 영화 선택 -->
  <div class="card">
    <div class="card-header">1) 영화 선택</div>
    <div style="margin-bottom:6px;">
      <button class="btn btn-sub" onclick="loadMovies()">영화 목록 새로고침</button>
    </div>
    <div>
      <label>movieId:
        <select id="movieSelect" onchange="onMovieChange()">
          <option value="">-- 영화를 선택하세요 --</option>
        </select>
      </label>
    </div>
  </div>

  <!-- 2) 상영시간표 선택 -->
  <div class="card">
    <div class="card-header">2) 상영시간표 선택</div>
    <div style="margin-bottom:6px;">
      <button class="btn btn-sub" onclick="loadShowtimes()">상영시간표 불러오기</button>
    </div>
    <div>
      <label>showtimeId:
        <select id="showtimeSelect" onchange="onShowtimeChange()">
          <option value="">-- 상영시간표를 선택하세요 --</option>
        </select>
      </label>
    </div>
  </div>

  <!-- 3) 좌석 조회 -->
  <div class="card">
    <div class="card-header">3) 좌석 확인</div>
    <div style="margin-bottom:6px;">
      <button class="btn btn-sub" onclick="loadSeats()">좌석 불러오기</button>
    </div>
    <div style="margin-bottom:4px;">
      <label>좌석 ID(콤마로 여러 개): </label>
      <input id="seatIdsInput" placeholder="예: 1 또는 1,2,3">
    </div>
    <div id="seatHint">
      좌석 API 결과에서 <b>seatId</b>를 보고 입력하면 됩니다.
    </div>
  </div>

  <!-- 4) 예매 -->
  <div class="card">
    <div class="card-header">4) 예매</div>
    <div>
      <button id="reserveBtn" class="btn btn-main" onclick="reserve()">예매하기</button>
      <span id="reserveLockMsg" class="tag-bad" style="margin-left:10px;"></span>
    </div>
  </div>

  <!-- 결과 -->
  <pre id="out"></pre>
</div>

<script>
/* =====================================
   공통 출력
   ===================================== */
function printOut(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

/* =====================================
   로그인 상태 / 로그아웃
   ===================================== */
let isLoggedIn = false;

async function refreshLoginState(){
  const res = await fetch('/api/auth/me');
  const el  = document.getElementById('loginState');
  const btn = document.getElementById('reserveBtn');
  const lockMsg = document.getElementById('reserveLockMsg');

  if(res.status === 200){
    isLoggedIn = true;
    const text = await res.text();
    el.innerHTML = '<span class="tag-ok">LOGIN</span> - ' + text;
    btn.disabled = false;
    lockMsg.textContent = '';
  } else {
    isLoggedIn = false;
    el.innerHTML = '<span class="tag-bad">NOT LOGIN</span>';
    btn.disabled = true;
    lockMsg.textContent = '로그인 후 예매할 수 있습니다.';
  }
}

async function logout(){
  await fetch('/api/auth/logout', { method:'POST' });
  await refreshLoginState();
  printOut('로그아웃 완료');
}

/* =====================================
   1) 영화 목록
   ===================================== */
async function loadMovies(){
  const url = '/api/movies';
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);

  const sel = document.getElementById('movieSelect');
  sel.innerHTML = '<option value="">-- 선택 --</option>';

  data.forEach(m => {
    const opt = document.createElement('option');
    opt.value = m.id;
    opt.textContent = m.title + ' (id=' + m.id + ')';
    sel.appendChild(opt);
  });

  document.getElementById('showtimeSelect').innerHTML =
    '<option value="">-- 선택 --</option>';
  document.getElementById('seatIdsInput').value = '';
}

function onMovieChange(){
  // 필요하면 영화 선택 시 상영시간표 자동 불러오기
  // loadShowtimes();
}

/* =====================================
   2) 상영시간표
   ===================================== */
async function loadShowtimes(){
  const movieId = document.getElementById('movieSelect').value;

  if(!movieId){
    printOut('movieId를 먼저 선택하세요.');
    return;
  }

  const url = `/api/movies/${movieId}/showtimes`;
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
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
      s.startTime + ' | ' + s.theaterName + '/' + s.screenName +
      ' | ' + s.basePrice + '원';
    sel.appendChild(opt);
  });

  document.getElementById('seatIdsInput').value = '';
}

function onShowtimeChange(){
  document.getElementById('seatIdsInput').value = '';
}

/* =====================================
   3) 좌석 조회
   ===================================== */
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
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);
}

/* =====================================
   4) 예매
   ===================================== */
async function reserve(){
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
    seatText = prompt('예매할 좌석 id(콤마 구분)를 입력하세요. 예: 1 또는 1,2,3');
    if(!seatText){
      printOut('예매 취소됨.');
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
    printOut('POST ' + url + '\\nSTATUS=' + res.status + '\\n예약 ID: ' + text);
  } else {
    printOut('POST ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
  }
}

/* 초기 진입 시 로그인 상태 체크 */
refreshLoginState();
</script>

</body>
</html>
