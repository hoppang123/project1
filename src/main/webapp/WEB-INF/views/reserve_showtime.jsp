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
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
h1 {
  font-size: 24px;
  margin: 0 0 4px;
}
.sub-text {
  font-size: 13px;
  color: #c7c7c7;
}
.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  font-size: 13px;
}
.btn-main {
  background: #ff4b4b;
  color: #fff;
}
.btn-sub {
  background: #2f364a;
  color: #fff;
}
.btn-small {
  font-size: 12px;
  padding: 4px 8px;
}
.card {
  background: #181c30;
  border-radius: 8px;
  padding: 12px 14px;
  border: 1px solid #262b3e;
  margin-bottom: 10px;
}
.card-title {
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 4px;
}
.card-body {
  font-size: 12px;
  color: #cfd8dc;
}
.card-footer {
  text-align: right;
  margin-top: 6px;
}
#showtimeList {
  margin-top: 12px;
}
</style>
</head>
<body>

<div class="wrap">
  <div class="header-bar">
    <div>
      <h1>2단계 · 상영시간 선택</h1>
      <div class="sub-text" id="movieTitleText">
        현재 선택한 영화: (알 수 없음)
      </div>
    </div>
    <div>
      <button class="btn btn-sub btn-small" onclick="location.href='/'">메인</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/reserve/movie'">1단계: 영화 선택으로</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
    </div>
  </div>

  <button class="btn btn-main" onclick="loadShowtimes()">🎬 상영시간 불러오기</button>

  <div id="showtimeList">
    <!-- 상영시간 카드가 JS로 채워짐 -->
  </div>
</div>

<script>
// 쿼리스트링에서 movieId, title 읽기
const params = new URLSearchParams(location.search);
const movieId = params.get('movieId');
const movieTitle = params.get('title') || '';

// 화면에 영화 제목 표시
(function initHeader(){
  const el = document.getElementById('movieTitleText');
  if(movieId){
    el.textContent = '현재 선택한 영화: ' + decodeURIComponent(movieTitle) +
      ' (id=' + movieId + ') 의 상영시간을 선택하세요.';
  } else {
    el.textContent = '영화 정보가 없습니다. 1단계에서 다시 선택해 주세요.';
  }
})();

// 상영시간 목록 불러오기
async function loadShowtimes(){
  if(!movieId){
    alert('movieId가 없습니다. 1단계에서 영화를 다시 선택해 주세요.');
    return;
  }

  const url = '/api/movies/' + movieId + '/showtimes';
  const res = await fetch(url);

  if(!res.ok){
    const text = await res.text();
    alert('상영시간 로딩 실패\nSTATUS=' + res.status + '\n' + text);
    return;
  }

  const data = await res.json();
  // console.log(data); // 필요하면 개발자도구에서 확인
  renderShowtimes(data);
}

// 상영시간 카드 렌더링
function renderShowtimes(list){
  const container = document.getElementById('showtimeList');
  container.innerHTML = '';

  if(!list || list.length === 0){
    container.innerHTML = '<div style="margin-top:10px;">상영시간 정보가 없습니다.</div>';
    return;
  }

  list.forEach(s => {
    const card = document.createElement('div');
    card.className = 'card';

    const title = document.createElement('div');
    title.className = 'card-title';
    title.textContent = '상영ID: ' + s.id;

    const body = document.createElement('div');
    body.className = 'card-body';
    body.innerHTML =
      '시간: ' + (s.startTime || '') + ' ~ ' + (s.endTime || '') + '<br>' +
      '지점/관: ' + (s.theaterName || '') + ' / ' + (s.screenName || '') + '<br>' +
      '기본 가격: ' +
      (s.basePrice != null ? Number(s.basePrice).toLocaleString() : 0) + '원';

    const footer = document.createElement('div');
    footer.className = 'card-footer';

    const btn = document.createElement('button');
    btn.className = 'btn btn-main btn-small';
    btn.textContent = '이 상영 선택';
    btn.onclick = function(){
      goSeatStep(s.id);
    };

    footer.appendChild(btn);
    card.appendChild(title);
    card.appendChild(body);
    card.appendChild(footer);

    container.appendChild(card);
  });
}

// 3단계(좌석 선택)으로 이동
function goSeatStep(showtimeId){
  if(!showtimeId) {
    alert('showtimeId가 없습니다.');
    return;
  }
  location.href = '/reserve/seat?showtimeId=' + showtimeId;
}

// 필요하면 자동 호출
// loadShowtimes();
</script>

</body>
</html>
