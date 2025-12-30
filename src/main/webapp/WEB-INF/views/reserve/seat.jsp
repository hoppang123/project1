<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>영화 예매 3단계 - 좌석 선택</title>

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
.showtime-info {
  font-size: 13px;
  margin-top: 4px;
}

/* 좌석 그리드 */
.screen-label {
  text-align: center;
  font-size: 13px;
  margin-bottom: 8px;
  color: #ccc;
}
.seat-grid {
  display: inline-block;
  padding: 10px 12px;
  background: #10141f;
  border-radius: 8px;
  border: 1px solid #262b3e;
}
.seat-row {
  display: flex;
  align-items: center;
  margin-bottom: 4px;
}
.seat-row-label {
  width: 18px;
  font-size: 12px;
  text-align: right;
  margin-right: 4px;
  color: #ccc;
}
.seat {
  width: 24px;
  height: 24px;
  margin: 2px;
  border-radius: 4px;
  font-size: 11px;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  background: #2f364a;
  color: #f5f5f5;
}
.seat.reserved {
  background: #b71c1c;
  cursor: not-allowed;
  opacity: 0.7;
}
.seat.selected {
  background: #ff9800;
  color: #000;
}
.seat-empty {
  width: 24px;
  height: 24px;
  margin: 2px;
}

/* 설명 / 선택정보 */
.seat-legend {
  margin-top: 8px;
  font-size: 12px;
}
.seat-legend span {
  display: inline-flex;
  align-items: center;
  margin-right: 10px;
}
.seat-legend-box {
  width: 16px;
  height: 16px;
  border-radius: 4px;
  margin-right: 4px;
}
.box-free { background:#2f364a; }
.box-reserved { background:#b71c1c; }
.box-selected { background:#ff9800; }

.select-summary {
  font-size: 13px;
  margin-top: 6px;
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
</style>
</head>
<body>

<div class="wrap">

  <!-- 상단 -->
  <div class="header-bar">
    <div>
      <div class="step-label">영화 예매 3단계 ▸ 좌석 선택 / 예매</div>
      <h1>좌석을 선택해 주세요.</h1>
    </div>
    <div>
      <button class="btn btn-sub btn-small" onclick="location.href='/'">메인</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/reserve/movie'">1단계: 영화 선택</button>
      <button class="btn btn-sub btn-small" onclick="goBackShowtime()">2단계: 상영시간 선택</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
    </div>
  </div>

  <!-- 영화 + 상영시간 정보 -->
  <div class="card">
    <div class="card-header">선택한 영화 / 상영정보</div>
    <div class="card-body" id="infoArea">
      정보를 불러오는 중입니다...
    </div>
  </div>

  <!-- 좌석 선택 -->
  <div class="card">
    <div class="card-header">좌석 선택</div>
    <div class="card-body">
      <div class="screen-label">스크린 방향</div>
      <div id="seatGridWrapper">
        좌석 정보를 불러오는 중입니다...
      </div>

      <div class="seat-legend">
        <span><div class="seat-legend-box box-free"></div>예약 가능</span>
        <span><div class="seat-legend-box box-reserved"></div>이미 예매됨</span>
        <span><div class="seat-legend-box box-selected"></div>선택한 좌석</span>
      </div>

      <div class="select-summary" id="selectSummary">
        선택한 좌석: 없음
      </div>
    </div>
  </div>

  <!-- 예매 버튼 -->
  <div class="card">
    <div class="card-header">예매 진행</div>
    <div class="card-body">
      <button id="reserveBtn" class="btn btn-main" onclick="reserve()">예매하기</button>
      <span id="reserveLockMsg" class="tag-bad" style="margin-left:10px;"></span>
    </div>
  </div>

  <!-- 디버그 -->
  <pre id="out"></pre>
</div>

<script>
/* ==========================
   공통 출력
   ========================== */
function printOut(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

/* ==========================
   전역 상태
   ========================== */
let movieId = null;
let showtimeId = null;
let basePrice = 0;
let seatData = [];          // /api/showtimes/{showtimeId}/seats 결과
let selectedSeatIds = [];   // 사용자가 선택한 seatId 목록
let isLoggedIn = false;

/* ==========================
   로그인 상태 체크
   ========================== */
async function refreshLoginState(){
  const res = await fetch('/api/auth/me');
  const btn = document.getElementById('reserveBtn');
  const lockMsg = document.getElementById('reserveLockMsg');

  if(res.status === 200){
    isLoggedIn = true;
    btn.disabled = false;
    lockMsg.textContent = '';
  }else{
    isLoggedIn = false;
    btn.disabled = true;
    lockMsg.textContent = '로그인 후 예매할 수 있습니다.';
  }
}

/* ==========================
   초기화
   ========================== */
window.addEventListener('load', init);

async function init(){
  const params = new URLSearchParams(window.location.search);
  movieId = params.get('movieId');
  showtimeId = params.get('showtimeId');

  await refreshLoginState();

  if(!movieId || !showtimeId){
    document.getElementById('infoArea').innerHTML =
      '필수 정보(movieId, showtimeId)가 없습니다.<br>' +
      '1단계 화면에서 다시 예매를 시작해 주세요.';
    document.getElementById('seatGridWrapper').textContent =
      'movieId/showtimeId가 없어 좌석 정보를 불러올 수 없습니다.';
    document.getElementById('reserveBtn').disabled = true;
    return;
  }

  await loadInfo();
  await loadSeats();
}

/* ==========================
   영화 + 상영시간 정보 로드
   (기존 API 그대로 활용)
   ========================== */
async function loadInfo(){
  try {
    // 1) 영화 정보
    const movieRes = await fetch(`/api/movies/${movieId}`);
    if(!movieRes.ok){
      const t = await movieRes.text();
      document.getElementById('infoArea').textContent =
        '영화 정보를 불러오지 못했습니다.';
      printOut('GET /api/movies/' + movieId + '\\nSTATUS=' + movieRes.status + '\\n' + t);
      return;
    }
    const movie = await movieRes.json();

    // 2) 상영시간표 리스트에서 showtimeId에 해당하는 1건 찾기
    const stRes = await fetch(`/api/movies/${movieId}/showtimes`);
    if(!stRes.ok){
      const t = await stRes.text();
      document.getElementById('infoArea').textContent =
        '상영시간 정보를 불러오지 못했습니다.';
      printOut('GET /api/movies/' + movieId + '/showtimes\\nSTATUS=' + stRes.status + '\\n' + t);
      return;
    }
    const stList = await stRes.json();
    const st = stList.find(x => String(x.id) === String(showtimeId));

    if(!st){
      document.getElementById('infoArea').textContent =
        '해당 showtimeId에 대한 상영 정보를 찾을 수 없습니다.';
      printOut('showtimeId=' + showtimeId + ' 에 해당하는 상영정보 없음');
      return;
    }

    basePrice = st.basePrice || 0;

    const html =
      '<div class="movie-title">' + movie.title + ' (id=' + movie.id + ')</div>' +
      '<div class="movie-sub">' +
        '<span class="badge">상영시간 ' + movie.runtimeMin + '분</span>' +
        '<span class="badge">등급 ' + movie.rating + '</span>' +
      '</div>' +
      '<div class="showtime-info" style="margin-top:8px;">' +
        '상영일시: ' + st.startTime + ' ~ ' + st.endTime + '<br>' +
        '상영관: ' + st.theaterName + ' / ' + st.screenName + '<br>' +
        '기본 요금: ' + basePrice + '원' +
      '</div>';

    document.getElementById('infoArea').innerHTML = html;
  } catch(e){
    document.getElementById('infoArea').textContent =
      '정보를 불러오는 중 오류가 발생했습니다.';
    printOut(e);
  }
}

/* ==========================
   좌석 정보 로드
   GET /api/showtimes/{showtimeId}/seats
   ========================== */
async function loadSeats(){
  const wrapper = document.getElementById('seatGridWrapper');
  wrapper.textContent = '좌석 정보를 불러오는 중입니다...';

  const url = `/api/showtimes/${showtimeId}/seats`;
  const res = await fetch(url);
  if(!res.ok){
    const t = await res.text();
    wrapper.textContent = '좌석 조회에 실패했습니다.';
    printOut('GET ' + url + '\\nSTATUS=' + res.status + '\\n' + t);
    return;
  }

  seatData = await res.json();
  printOut(seatData);

  if(!seatData || seatData.length === 0){
    wrapper.textContent = '등록된 좌석 정보가 없습니다.';
    return;
  }

  renderSeatGrid();
}

/* ==========================
   좌석 그리드 렌더링
   ========================== */
function renderSeatGrid(){
  const wrapper = document.getElementById('seatGridWrapper');
  wrapper.innerHTML = '';

  // rowLabel 기준으로 그룹핑
  const rowsMap = {};  // { 'A': [seat,...], 'B': [seat,...] }
  seatData.forEach(s => {
    const row = s.rowLabel || '';
    if(!rowsMap[row]) rowsMap[row] = [];
    rowsMap[row].push(s);
  });

  // 행 순서 정렬 (A,B,C,...)
  const rowLabels = Object.keys(rowsMap).sort();

  const grid = document.createElement('div');
  grid.className = 'seat-grid';

  rowLabels.forEach(row => {
    const seats = rowsMap[row].slice().sort((a, b) => (a.colNumber || 0) - (b.colNumber || 0));

    const rowDiv = document.createElement('div');
    rowDiv.className = 'seat-row';

    const labelDiv = document.createElement('div');
    labelDiv.className = 'seat-row-label';
    labelDiv.textContent = row;
    rowDiv.appendChild(labelDiv);

    seats.forEach(s => {
      const seatDiv = document.createElement('div');
      seatDiv.className = 'seat';
      seatDiv.textContent = s.colNumber;
      seatDiv.dataset.seatId = s.seatId;

      if(s.reserved){
        seatDiv.classList.add('reserved');
      }else{
        seatDiv.addEventListener('click', onSeatClick);
      }
      rowDiv.appendChild(seatDiv);
    });

    grid.appendChild(rowDiv);
  });

  wrapper.appendChild(grid);
}

/* ==========================
   좌석 클릭 처리
   ========================== */
function onSeatClick(e){
  const seatDiv = e.currentTarget;
  const seatId = Number(seatDiv.dataset.seatId);

  const idx = selectedSeatIds.indexOf(seatId);
  if(idx === -1){
    selectedSeatIds.push(seatId);
    seatDiv.classList.add('selected');
  }else{
    selectedSeatIds.splice(idx, 1);
    seatDiv.classList.remove('selected');
  }

  updateSelectSummary();
}

/* ==========================
   선택 요약 / 금액 표시
   ========================== */
function updateSelectSummary(){
  const summaryEl = document.getElementById('selectSummary');
  if(selectedSeatIds.length === 0){
    summaryEl.textContent = '선택한 좌석: 없음';
    return;
  }

  const total = basePrice * selectedSeatIds.length;
  summaryEl.textContent =
    '선택한 좌석 seatId: ' + selectedSeatIds.join(', ') +
    ' / 인원: ' + selectedSeatIds.length + '명' +
    ' / 예상 금액: ' + total + '원';
}

/* ==========================
   예매하기
   POST /api/reservations
   ========================== */
async function reserve(){
  await refreshLoginState();
  if(!isLoggedIn){
    alert('로그인이 필요합니다.');
    location.href = '/login';
    return;
  }

  if(!showtimeId){
    alert('showtimeId가 없습니다.');
    return;
  }

  if(selectedSeatIds.length === 0){
    alert('좌석을 한 개 이상 선택해 주세요.');
    return;
  }

  const payload = {
    showtimeId: Number(showtimeId),
    seatIds: selectedSeatIds
  };

  const url = '/api/reservations';
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type':'application/json' },
    body: JSON.stringify(payload)
  });

  const text = await res.text();
  if(res.ok){
    alert('예매가 완료되었습니다. 예약 ID: ' + text);
    printOut('POST ' + url + '\\nSTATUS=' + res.status + '\\n예약 ID: ' + text);
    // 예매 완료 후 내 예매내역으로 이동 (원하면 유지)
    location.href = '/my';
  }else{
    alert('예매에 실패했습니다. 상세 내용은 아래 로그를 확인하세요.');
    printOut('POST ' + url + '\\nSTATUS=' + res.status + '\\n' + text);
  }
}

/* ==========================
   2단계 페이지로 돌아가기
   ========================== */
function goBackShowtime(){
  if(!movieId) {
    location.href = '/reserve/movie';
    return;
  }
  location.href = '/reserve/showtime?movieId=' + movieId;
}
</script>

</body>
</html>
