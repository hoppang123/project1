<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>Movie / Showtime TEST</title>
<style>
body { font-family: Arial, sans-serif; }
.box { border: 1px solid #ddd; padding: 10px; margin: 10px 0; }
</style>
</head>
<body>

<h2>🎬 영화 / 상영시간표 API 테스트</h2>

<div class="box">
  <h3>1) 영화 목록</h3>
  <button onclick="loadMovies()">영화 불러오기</button><br><br>

  <select id="movieSelect" onchange="onMovieChange()">
    <option value="">-- 영화를 선택하세요 --</option>
  </select>
</div>

<div class="box">
  <h3>2) 상영시간표</h3>
  <button onclick="loadShowtimes()">선택한 영화의 상영시간표 불러오기</button><br><br>

  <select id="showtimeSelect">
    <option value="">-- 상영시간표를 선택하세요 --</option>
  </select>
</div>

<pre id="out"></pre>

<script>
function out(msg){
  document.getElementById('out').textContent =
    (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

// 1) 영화 목록 불러오기
async function loadMovies(){
  const res = await fetch('/api/movies');
  if(!res.ok){
    out('영화 조회 실패: ' + res.status);
    return;
  }
  const list = await res.json();
  out(list);

  const sel = document.getElementById('movieSelect');
  sel.innerHTML = '<option value="">-- 영화를 선택하세요 --</option>';

  list.forEach(m => {
    const opt = document.createElement('option');
    opt.value = m.id;
    opt.textContent = m.id + ' - ' + m.title;
    sel.appendChild(opt);
  });

  // 영화가 바뀌면 상영시간표는 초기화
  document.getElementById('showtimeSelect').innerHTML =
    '<option value="">-- 상영시간표를 선택하세요 --</option>';
}

// 영화 선택 시 자동으로 상영시간표를 불러오고 싶으면 사용
function onMovieChange(){
  loadShowtimes();
}

// 2) 선택한 영화의 상영시간표 불러오기
async function loadShowtimes(){
  const sel = document.getElementById('movieSelect');
  const movieId = sel.value;
  console.log('선택된 movieId =', movieId);

  if(!movieId){
    out('먼저 영화부터 선택하세요.');
    return;
  }

  // 템플릿 문자열 말고 문자열 연결로 확실하게
  const url = '/api/movies/' + movieId + '/showtimes';
  console.log('요청 URL =', url);

  const res = await fetch(url);
  if(!res.ok){
    out('상영시간표 조회 실패: ' + res.status);
    return;
  }

  const list = await res.json();
  out(list);

  const showSel = document.getElementById('showtimeSelect');
  showSel.innerHTML = '<option value="">-- 상영시간표를 선택하세요 --</option>';

  list.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent =
      s.id + ' | ' + s.startTime + ' ~ ' + s.endTime +
      ' | ' + (s.theaterName || '') + '/' + (s.screenName || '');
    showSel.appendChild(opt);
  });
}
</script>

</body>
</html>
