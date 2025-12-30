<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>1단계 · 영화 선택</title>
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
  display:flex;
  justify-content:space-between;
  align-items:center;
  margin-bottom:20px;
}
h1 { font-size:24px; margin:0 0 4px; }
.sub-text { font-size:13px; color:#c7c7c7; }

.btn {
  padding:6px 12px;
  border:none;
  border-radius:5px;
  cursor:pointer;
  font-weight:bold;
  font-size:13px;
}
.btn-main { background:#ff4b4b; color:#fff; }
.btn-sub  { background:#2f364a; color:#fff; }
.btn-small{ font-size:12px; padding:4px 8px; }

.movie-grid {
  display:grid;
  grid-template-columns:repeat(auto-fill, minmax(220px, 1fr));
  gap:12px;
  margin-top:14px;
}
.card {
  background:#181c30;
  border-radius:8px;
  border:1px solid #262b3e;
  padding:12px 14px;
}
.card-title {
  font-size:15px;
  font-weight:bold;
  margin-bottom:6px;
}
.card-body {
  font-size:12px;
  color:#cfd8dc;
  min-height:40px;
}
.card-footer {
  margin-top:8px;
  text-align:right;
}
.tag {
  font-size:11px;
  color:#b0bec5;
}
#out {
  margin-top:16px;
  background:#0b0f19;
  border-radius:8px;
  padding:8px;
  white-space:pre-wrap;
  font-family:Consolas, monospace;
  font-size:12px;
  max-height:180px;
  overflow-y:auto;
  border:1px solid #262b3e;
}
</style>
</head>
<body>
<div class="wrap">
  <div class="header-bar">
    <div>
      <h1>1단계 · 영화 선택</h1>
      <div class="sub-text">
        예매할 영화를 선택하세요.
      </div>
    </div>
    <div>
      <button class="btn btn-sub btn-small" onclick="location.href='/'">메인</button>
      <button class="btn btn-sub btn-small" onclick="location.href='/my'">내 예매내역</button>
    </div>
  </div>

  <button class="btn btn-main" onclick="loadMovies()">🎬 상영 영화 불러오기</button>
  <span class="tag">※ 상영 중인 영화 목록을 불러온 후, 원하는 영화를 선택합니다.</span>

  <div id="movieList" class="movie-grid"></div>

  <pre id="out"></pre>
</div>

<script>
function printOut(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

async function loadMovies(){
  const url = '/api/movies';
  const res = await fetch(url);
  const text = await res.text();
  printOut("GET " + url + "\nSTATUS=" + res.status + "\n" + text);

  if(!res.ok) return;

  let data;
  try { data = JSON.parse(text); } catch(e){ console.error(e); return; }

  renderMovies(data);
}

function renderMovies(list){
  const container = document.getElementById('movieList');
  container.innerHTML = '';

  if(!list || list.length === 0){
    container.innerHTML = '<div style="margin-top:10px;">상영 중인 영화가 없습니다.</div>';
    return;
  }

  list.forEach(m => {
    const card = document.createElement('div');
    card.className = 'card';

    const title = document.createElement('div');
    title.className = 'card-title';
    title.textContent = m.title + ' (id=' + m.id + ')';

    const body = document.createElement('div');
    body.className = 'card-body';
    body.innerHTML =
      '상영시간: ' + (m.runtimeMin || 0) + '분<br>' +
      '등급: ' + (m.rating || '-') + '<br>' +
      (m.description || '');

    const footer = document.createElement('div');
    footer.className = 'card-footer';
    const btn = document.createElement('button');
    btn.className = 'btn btn-main btn-small';
    btn.textContent = '이 영화 예매하기';
    btn.onclick = function(){
      const encTitle = encodeURIComponent(m.title);
      location.href = '/reserve/showtime?movieId=' + m.id + '&title=' + encTitle;
    };
    footer.appendChild(btn);

    card.appendChild(title);
    card.appendChild(body);
    card.appendChild(footer);
    container.appendChild(card);
  });
}
</script>
</body>
</html>
