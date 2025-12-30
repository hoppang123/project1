<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>영화 예매 2단계 - 상영시간 선택</title>

<style>
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
  margin-bottom: 8px;
}
h2 {
  font-size: 20px;
}
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.step-label {
  font-size: 13px;
  color: #ccc;
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
.card-body {
  font-size: 14px;
}
.badge {
  display: inline-block;
  padding: 2px 6px;
  border-radius: 4px;
  background: #2f364a;
  font-size: 11px;
  margin-right: 4px;
}
.tag-ok { color: #4caf50; font-weight: bold; }
.tag-bad { color: #ff5252; font-weight: bold; }

.movie-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 4px;
}
.movie-sub {
  font-size: 13px;
  color: #ccc;
}

/* 상영시간 카드 목록 */
.showtime-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 10px;
}
.showtime-card {
  background: #1d2238;
  border-radius: 8px;
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.showtime-main {
  margin-bottom: 6px;
}
.showtime-time {
  font-weight: bold;
  margin-bottom: 4px;
}
.showtime-place {
  font-size: 13px;
  color: #ccc;
}
.showtime-price {
  font-size: 13px;
  margin-top: 2px;
}

/* 디버그 출력 */
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

#errorMsg {
  color: #ff7676;
  font-size: 13px;
  margin-top: 4px;
}
</style>
</head>
<body>

<div class="wrap">

  <!-- 상단 영역 -->
  <div class="header-bar">
    <div>
      <div class="step-label">영화 예매 2단계 ▸ 상영시간 선택</div>
      <h1>상영시간을 선택해 주세요.</h1>
    </div>
    <div>
      <button class="btn btn-sub btn-small" onclick="location.href='/'">메인</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/reserve/movie'">1단계: 영화 다시 선택</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
    </div>
  </div>

  <!-- 선택된 영화 정보 -->
  <div class="card">
    <div class="card-header">선택한 영화 정보</div>
    <div class="card-body">
      <div id="movieInfo">
        영화 정보를 불러오는 중입니다...
      </div>
      <div id="errorMsg"></div>
    </div>
  </div>

  <!-- 상영시간표 목록 -->
  <div class="card">
    <div class="card-header">
      상영시간표
      <button class="btn btn-sub btn-small" style="margin-left:6px;" onclick="loadShowtimes()">새로고침</button>
    </div>
    <div class="card-body">
      <div id="showtimeEmptyMsg" style="font-size:13px; color:#ccc;">
        상영시간표를 불러오는 중입니다...
      </div>
      <div id="showtimeList" class="showtime-list"></div>
    </div>
  </div>

  <!-- 디버그 영역 -->
  <pre id="out"></pre>
</div>

<script>
/* ============================
   공통 출력
   ============================ */
function printOut(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

/* ============================
   전역 변수
   ============================ */
let movieId = null;

/* ============================
   초기화
   ============================ */
window.addEventListener('load', init);

function init(){
  const params = new URLSearchParams(window.location.search);
  movieId = params.get('movieId');

  if(!movieId){
    document.getElementById('movieInfo').textContent =
      'movieId가 없습니다. 1단계 화면에서 영화를 다시 선택해 주세요.';
    document.getElementById('errorMsg').textContent =
      'URL 예) /reserve/showtime?movieId=1';
    document.getElementById('showtimeEmptyMsg').textContent =
      'movieId가 없어서 상영시간표를 조회할 수 없습니다.';
    return;
  }

  loadMovieDetail();
  loadShowtimes();
}

/* ============================
   영화 상세 정보
   GET /api/movies/{movieId}
   ============================ */
async function loadMovieDetail(){
  const url = `/api/movies/${movieId}`;
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    document.getElementById('movieInfo').textContent =
      '영화 정보를 불러오는 데 실패했습니다.';
    document.getElementById('errorMsg').textContent =
      'GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text;
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
    return;
  }

  const m = await res.json();
  const infoHtml =
    '<div class="movie-title">' + m.title + ' (id=' + m.id + ')</div>' +
    '<div class="movie-sub">' +
      '<span class="badge">상영시간 ' + m.runtimeMin  + '분</span>' +
      '<span class="badge">등급 ' + m.rating + '</span>' +
    '</div>' +
    '<div style="margin-top:6px; font-size:13px;">' + (m.description || '') + '</div>';

  document.getElementById('movieInfo').innerHTML = infoHtml;
  document.getElementById('errorMsg').textContent = '';
}

/* ============================
   상영시간표 목록
   GET /api/movies/{movieId}/showtimes
   ============================ */
async function loadShowtimes(){
  if(!movieId){
    return;
  }

  const url = `/api/movies/${movieId}/showtimes`;
  const res = await fetch(url);

  const emptyMsgEl = document.getElementById('showtimeEmptyMsg');
  const listEl  = document.getElementById('showtimeList');

  if(!res.ok){
    const text = await res.text();
    emptyMsgEl.textContent = '상영시간표 조회에 실패했습니다.';
    listEl.innerHTML = '';
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
    return;
  }

  const data = await res.json();
  printOut(data);

  if(!data || data.length === 0){
    emptyMsgEl.textContent = '등록된 상영시간표가 없습니다.';
    listEl.innerHTML = '';
    return;
  }

  emptyMsgEl.textContent = '';
  listEl.innerHTML = '';

  data.forEach(s => {
    const card = document.createElement('div');
    card.className = 'showtime-card';

    const main = document.createElement('div');
    main.className = 'showtime-main';

    const time = document.createElement('div');
    time.className = 'showtime-time';
    time.textContent = `${s.startTime} ~ ${s.endTime}`;

    const place = document.createElement('div');
    place.className = 'showtime-place';
    place.textContent = `${s.theaterName} / ${s.screenName}`;

    const price = document.createElement('div');
    price.className = 'showtime-price';
    price.textContent = `기본 요금: ${s.basePrice}원`;

    main.appendChild(time);
    main.appendChild(place);
    main.appendChild(price);

    const btnWrap = document.createElement('div');
    const btn = document.createElement('button');
    btn.className = 'btn btn-main';
    btn.textContent = '이 상영 회차 예매하기';

    // 👉 3단계(좌석 선택 화면)으로 이동
    //    다음 턴에서 /reserve/seat 페이지를 만들 거야.
    btn.onclick = function(){
      location.href = `/reserve/seat?movieId=${movieId}&showtimeId=${s.id}`;
    };

    btnWrap.appendChild(btn);

    card.appendChild(main);
    card.appendChild(btnWrap);

    listEl.appendChild(card);
  });
}
</script>

</body>
</html>
