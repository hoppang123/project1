<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>3단계 · 좌석 선택</title>

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
h1 { font-size: 24px; margin-bottom: 8px; }
.sub-text { font-size: 13px; color: #c7c7c7; }

.btn {
  padding: 6px 12px; border: none;
  border-radius: 5px; cursor: pointer;
  font-weight: bold; font-size: 13px;
}
.btn-main { background: #ff4b4b; color:#fff; }
.btn-sub  { background: #2f364a; color:#fff; }
.btn-small{ font-size:12px; padding:4px 8px; }

/* ===== 좌석 영역 ===== */
#seatArea {
  margin-top: 25px;
  padding: 16px 12px 12px;
  background: #181c30;
  border-radius: 8px;
}

/* SCREEN 바 */
.screen-bar {
  text-align:center;
  font-weight:bold;
  margin-bottom: 12px;
  padding: 6px 0;
  border-radius: 6px;
  background: linear-gradient(to right, #22283b, #202437);
  letter-spacing: 2px;
}

/* 좌석 한 줄 */
.seat-row {
  display: flex;
  align-items: center;
  margin-bottom: 6px;
}

/* A, B, C 행 레이블 */
.seat-row-label {
  width: 24px;
  text-align: center;
  font-size: 13px;
  color: #c7c7c7;
}

/* 행 안의 좌석 버튼 컨테이너 */
.seat-row-buttons {
  flex: 1;
}

/* 좌석 버튼 기본 */
.seat-btn {
  margin:2px 4px;
  min-width: 36px;
  padding:6px 0;
  border:1px solid #2e3245;
  background:#1b2133;
  color:#fff;
  border-radius:4px;
  cursor:pointer;
  font-size: 12px;
  transition: all .12s ease-out;
}

/* hover 효과 */
.seat-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 6px rgba(0,0,0,.4);
}

/* 선택된 좌석 */
.seat-btn.active {
  background:#ff4b4b;
  border-color:#ff4b4b;
}

/* 이미 예약된 좌석 */
.seat-btn.reserved {
  background:#4b4f63;
  border-color:#3d4153;
  color:#aaaaaa;
  cursor:not-allowed;
  text-decoration: line-through;
}
.seat-btn.reserved:hover {
  transform:none;
  box-shadow:none;
}

/* 요약 박스 */
.summary-box {
  margin-top:14px;
  padding:10px;
  background:#181c30;
  border-radius:6px;
  font-size:14px;
}
.summary-label {
  color:#b0bec5;
}

/* 디버깅 출력 */
#out {
  margin-top:16px;
  background:#0b0f19;
  border-radius:8px;
  padding:8px;
  white-space:pre-wrap;
  font-family:Consolas, monospace;
  font-size:12px;
  max-height:260px;
  overflow-y:auto;
  border:1px solid #262b3e;
}
</style>
</head>
<body>

<div class="wrap">

  <h1>3단계 · 좌석 선택</h1>
  <div class="sub-text" id="movieInfo">
    상영 ID=? 의 좌석을 선택합니다.
  </div>

  <div style="margin-top:15px;">
    <button class="btn btn-sub btn-small" onclick="location.href='/'">메인</button>
    <button class="btn btn-sub btn-small" onclick="history.back()">이전 단계</button>
    <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
  </div>

  <div id="seatArea">
    <div class="screen-bar">SCREEN</div>
    <div id="seatContainer">
      <!-- 좌석 버튼들이 JS로 렌더링됨 -->
    </div>
  </div>

  <div class="summary-box">
    <span class="summary-label">선택 좌석:</span>
    <span id="summarySeat">없음</span>
    &nbsp; | &nbsp;
    <span class="summary-label">인원:</span>
    <span id="summaryPeople">0명</span>
    &nbsp; | &nbsp;
    <span class="summary-label">예상 금액:</span>
    <span id="summaryPrice">0원</span>
  </div>

  <button class="btn btn-main" style="margin-top:10px;" onclick="doReserve()">예매하기</button>

  <pre id="out"></pre>

</div>


<script>
// =========================
//  쿼리스트링에서 showtimeId
// =========================
const params = new URLSearchParams(location.search);
const showtimeId = params.get('showtimeId');

// =========================
// 선택 좌석: 숫자 Set + id→이름 매핑
// =========================
const selectedSeatIds = new Set();
const seatIdToNameMap = {};   // { 1: "A1", 2: "A2", ... }

// =========================
// 디버그 출력
// =========================
function printOut(msg){
  const out = document.getElementById('out');
  if (!out) return;
  out.textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

// =========================
// header 표시
// =========================
(function initHeader(){
  const el = document.getElementById('movieInfo');
  if (showtimeId) {
    el.textContent = '상영 ID=' + showtimeId + ' 의 좌석을 선택합니다.';
  } else {
    el.textContent = '상영 정보가 없습니다.';
  }
})();


// =========================
// 좌석 토글 선택
// =========================
function toggleSeat(seatId, seatName, btn){
  const idNum = Number(seatId);
  if (!idNum || Number.isNaN(idNum)) {
    console.error("seatId가 숫자가 아닙니다:", seatId);
    return;
  }

  if (btn.classList.contains('reserved')) {
    // 이미 예약된 좌석은 무시
    return;
  }

  if (selectedSeatIds.has(idNum)) {
    selectedSeatIds.delete(idNum);
    btn.classList.remove('active');
  } else {
    selectedSeatIds.add(idNum);
    btn.classList.add('active');
  }
  updateSummary();
}


// =========================
// 요약 갱신
// =========================
function updateSummary(){
  const seatIdsArr = Array.from(selectedSeatIds);

  // 좌석 이름 배열로 변환 (A1, B2...)
  const seatNames = seatIdsArr
    .map(id => seatIdToNameMap[id])
    .filter(n => !!n);

  const seatText = seatNames.join(', ');
  const count = seatIdsArr.length;

  document.getElementById('summarySeat').textContent = seatText || '없음';
  document.getElementById('summaryPeople').textContent = count + '명';
  // 금액계산은 Service에서 처리 → 여기선 0원 고정
  document.getElementById('summaryPrice').textContent = '0원';
}


// =========================
// 좌석 목록 불러오기
// =========================
async function loadSeats(){
  if (!showtimeId) {
    printOut('showtimeId가 없습니다.');
    return;
  }

  const url = '/api/showtimes/' + showtimeId + '/seats';
  const res = await fetch(url);
  const text = await res.text();
  printOut("GET " + url + "\nSTATUS=" + res.status + "\n" + text);

  if (!res.ok) return;

  let data;
  try {
    data = JSON.parse(text);
  } catch(e) {
    console.error(e);
    return;
  }

  renderSeats(data);
}


// =========================
// 좌석 버튼 렌더링
// - seat.seatId, seat.seatName, seat.reserved 사용
// - A, B, C 행별로 묶어서 표시
// =========================
function renderSeats(list){
  const container = document.getElementById('seatContainer');
  container.innerHTML = '';

  if (!list || list.length === 0) {
    container.textContent = '좌석 정보가 없습니다.';
    return;
  }

  // id → 이름 매핑 저장
  list.forEach(seat => {
    seatIdToNameMap[seat.seatId] = seat.seatName;
  });

  // 행(row)별로 그룹화
  const rows = {};   // { 'A': [seat, seat, ...], 'B': [...] }
  list.forEach(seat => {
    const name = seat.seatName || '';
    // rowLabel 컬럼이 있으면 우선 사용, 없으면 seatName 첫 글자
    const rowKey = (seat.rowLabel && seat.rowLabel.trim() !== '')
                     ? seat.rowLabel
                     : (name.length > 0 ? name.charAt(0) : '?');
    if (!rows[rowKey]) rows[rowKey] = [];
    rows[rowKey].push(seat);
  });

  // 행 이름 정렬 (A, B, C ...)
  const rowKeys = Object.keys(rows).sort();

  rowKeys.forEach(rowKey => {
    const seatsInRow = rows[rowKey];

    // 같은 행 안에서 열 번호 순으로 정렬 (A1, A2, A3…)
    seatsInRow.sort((a, b) => {
      const n1 = parseInt((a.seatName || '').substring(1)) || 0;
      const n2 = parseInt((b.seatName || '').substring(1)) || 0;
      return n1 - n2;
    });

    const rowDiv = document.createElement('div');
    rowDiv.className = 'seat-row';

    const labelDiv = document.createElement('div');
    labelDiv.className = 'seat-row-label';
    labelDiv.textContent = rowKey;
    rowDiv.appendChild(labelDiv);

    const btnContainer = document.createElement('div');
    btnContainer.className = 'seat-row-buttons';

    seatsInRow.forEach(seat => {
      const btn = document.createElement('button');
      btn.textContent = seat.seatName;
      btn.className = 'seat-btn';
      if (seat.reserved) {
        btn.classList.add('reserved');
        btn.disabled = true;
      }
      btn.onclick = function(){
        toggleSeat(seat.seatId, seat.seatName, btn);
      };
      btnContainer.appendChild(btn);
    });

    rowDiv.appendChild(btnContainer);
    container.appendChild(rowDiv);
  });
}


// =========================
// ** 예매하기 **
// =========================
async function doReserve(){
  if (!showtimeId) {
    alert("상영 ID가 없습니다.");
    return;
  }

  const seatIdsArr = Array.from(selectedSeatIds);
  if (seatIdsArr.length === 0) {
    alert("좌석을 하나 이상 선택하세요.");
    return;
  }

  const body = {
    showtimeId: Number(showtimeId),
    seatIds: seatIdsArr
  };

  printOut({ requestBody: body });

  const url = "/api/reservations";
  const res = await fetch(url, {
    method:'POST',
    headers:{ 'Content-Type':'application/json' },
    body: JSON.stringify(body)
  });

  const text = await res.text();
  printOut("POST " + url + "\nSTATUS=" + res.status + "\n" + text);

  let json=null;
  try { json = JSON.parse(text); } catch(e){}

  if (res.ok && json && json.success) {
    alert("예매 완료! 예약번호: " + json.reservationId);
    location.href = "/my";
  } else {
    const msg = (json && json.message)
      ? json.message
      : "알 수 없는 오류가 발생했습니다.\n(HTTP 코드: " + res.status + ")";
    alert("예매 실패: " + msg);
  }
}


// =========================
// 페이지 로드시 좌석 로딩
// =========================
loadSeats();
</script>

</body>
</html>
