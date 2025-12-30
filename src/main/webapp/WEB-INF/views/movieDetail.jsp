<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 상세 / 예매</title>
<style>
body { font-family: Arial, sans-serif; padding:20px; }
.box { border:1px solid #ddd; padding:10px; margin:10px 0; }
.row { margin:6px 0; }
.ok { color:#060; font-weight:bold; }
.bad { color:#c00; font-weight:bold; }
select, input { padding:4px; }
button { padding:6px 10px; margin-right:6px; }
.movie-title { font-size:20px; font-weight:bold; margin-bottom:8px; }
</style>
</head>
<body>

<%
    // PageController에서 넣어준 movieId
    Long movieIdObj = (Long) request.getAttribute("movieId");
    long movieId = (movieIdObj != null) ? movieIdObj.longValue() : 0L;
%>

<h1>🎬 영화 상세 / 예매</h1>

<!-- 상단 메뉴/로그인 상태 -->
<div class="box">
  <button onclick="location.href='/'">메인으로</button>
  <button onclick="location.href='/login'">로그인</button>
  <button onclick="logout()">로그아웃</button>
  <button onclick="location.href='/my'">내 예매내역</button>
  <span id="loginState" style="margin-left:10px;"></span>
</div>

<!-- 영화 정보 -->
<div class="box">
  <div class="movie-title" id="movieTitle">영화 정보 로딩 중...</div>
  <div id="movieInfo"></div>
</div>

<!-- 1) 상영시간표 선택 -->
<div class="box">
  <h3>1) 상영시간표 선택</h3>
  <div class="row">
    <select id="showtimeSelect" onchange="onShowtimeChange()">
      <option value="">-- 상영시간표를 선택하세요 --</option>
    </select>
  </div>
</div>

<!-- 2) 좌석 조회 -->
<div class="box">
  <h3>2) 좌석 선택</h3>
  <div class="row">
    <button onclick="loadSeats()">좌석 조회</button>
  </div>
  <div class="row">
    <label>좌석ID(여러 개면 콤마): </label>
    <input id="seatIdsInput" placeholder="예: 1 또는 1,2" style="width:200px;" />
  </div>
  <div class="row">
    <small>※ 좌석 API 결과에서 id를 보고 입력하면 돼.</small>
  </div>
</div>

<!-- 3) 예매 -->
<div class="box">
  <h3>3) 예매</h3>
  <div class="row">
    <button id="reserveBtn" onclick="reserve()">예매하기</button>
    <span id="reserveLockMsg" class="bad" style="margin-left:10px;"></span>
  </div>
</div>

<pre id="out"></pre>

<script>
/* JSP에서 movieId 가져오기 */
const MOVIE_ID = <%= movieId %>;

/* 로그인 상태 표시 + 예매 버튼 잠금 */
let isLoggedIn = false;

async function refreshLoginState(){
  const res = await fetch('/api/auth/me');
  const el = document.getElementById('loginState');
  const btn = document.getElementById('reserveBtn');
  const lockMsg = document.getElementById('reserveLockMsg');

  if(res.status === 200){
    isLoggedIn = true;
    const text = await res.text();
    el.innerHTML = '<span class="ok">LOGIN</span> - ' + text;

    btn.disabled = false;
    lockMsg.textContent = '';
  }else{
    isLoggedIn = false;
    el.innerHTML = '<span class="bad">NOT LOGIN</span>';
    btn.disabled = true;
    lockMsg.textContent = '로그인 후 예매할 수 있습니다.';
  }
}

async function logout(){
  await fetch('/api/auth/logout', { method:'POST' });
  await refreshLoginState();
  document.getElementById('out').textContent = '로그아웃 완료';
}

/* 공통 출력 */
function out(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

/* 0) 영화 정보 + 상영시간표 로드 */
async function loadMovieAndShowtimes(){
  // 영화 정보: /api/movies 전체 받아서 현재 movieId만 찾기
  const resMovies = await fetch('/api/movies');
  if(resMovies.ok){
    const movies = await resMovies.json();
    const movie = movies.find(m => m.id === MOVIE_ID);
    if(movie){
      document.getElementById('movieTitle').textContent = movie.title;
      document.getElementById('movieInfo').textContent =
        '영화 ID: ' + movie.id;
    }else{
      document.getElementById('movieTitle').textContent =
        '영화 정보를 찾을 수 없습니다.';
    }
  }

  // 상영시간표 불러오기
  const resShow = await fetch(`/api/movies/${MOVIE_ID}/showtimes`);
  const sel = document.getElementById('showtimeSelect');

  if(!resShow.ok){
    sel.innerHTML = '<option value="">상영시간표 조회 실패</option>';
    return;
  }

  const list = await resShow.json();
  if(list.length === 0){
    sel.innerHTML = '<option value="">상영시간표가 없습니다.</option>';
    return;
  }

  sel.innerHTML = '<option value="">-- 상영시간표를 선택하세요 --</option>';
  list.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent =
      `${s.id} | ${s.startTime} ~ ${s.endTime} | ${s.theaterName}/${s.screenName} | ${s.basePrice}원`;
    sel.appendChild(opt);
  });
}

function onShowtimeChange(){
  document.getElementById('seatIdsInput').value = '';
}

/* 좌석 조회 */
async function loadSeats(){
  const showtimeId = document.getElementById('showtimeSelect').value;
  if(!showtimeId){
    out('showtimeId를 먼저 선택하세요.');
    return;
  }

  const res = await fetch(`/api/showtimes/${showtimeId}/seats`);
  if(!res.ok){
    out('좌석 조회 실패: ' + res.status);
    return;
  }
  const list = await res.json();
  out(list);
}

/* 예매 실행 */
async function reserve(){
  await refreshLoginState();
  if(!isLoggedIn){
    alert('로그인이 필요합니다.');
    location.href = '/login';
    return;
  }

  const showtimeId = Number(document.getElementById('showtimeSelect').value);
  if(!showtimeId){
    out('showtimeId를 먼저 선택하세요.');
    return;
  }

  const seatText = document.getElementById('seatIdsInput').value.trim();
  if(!seatText){
    out('seatIds를 입력하세요. 예: 1 또는 1,2');
    return;
  }

  const seatIds = seatText.split(',')
    .map(s => s.trim())
    .filter(s => s.length > 0)
    .map(s => Number(s))
    .filter(n => !Number.isNaN(n));

  if(seatIds.length === 0){
    out('seatIds 입력이 올바르지 않습니다.');
    return;
  }

  const payload = {
    showtimeId: showtimeId,
    seatIds: seatIds
  };

  const res = await fetch('/api/reservations', {
    method:'POST',
    headers:{ 'Content-Type':'application/json' },
    body: JSON.stringify(payload)
  });

  const text = await res.text();
  if(res.ok){
    out('예매 성공: ' + text);
  }else{
    out('예매 실패: ' + res.status + '\\n' + text);
  }
}

/* 페이지 진입 시 실행 */
refreshLoginState();
loadMovieAndShowtimes();
</script>

</body>
</html>
