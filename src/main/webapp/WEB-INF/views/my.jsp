<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>내 예매내역</title>
<style>
  body{font-family:Arial,sans-serif;background:#10141f;color:#f5f5f5;margin:0}
  .wrap{max-width:1100px;margin:20px auto 40px;padding:20px;background:#141829;border-radius:10px;box-shadow:0 10px 30px rgba(0,0,0,0.6)}
  h1{margin:0 0 8px;font-size:26px}
  .sub{color:#c7c7c7;font-size:13px}
  .btn{padding:6px 12px;border:none;border-radius:6px;cursor:pointer;font-weight:bold;font-size:13px}
  .btn-main{background:#ff4b4b;color:#fff}
  .btn-sub{background:#2f364a;color:#fff}
  .btn-sm{padding:4px 8px;font-size:12px}
  .toolbar{display:flex;gap:8px;margin-top:12px}
  table{width:100%;border-collapse:collapse;margin-top:14px;background:#181c30;border-radius:8px;overflow:hidden}
  thead th{background:#20263c;padding:10px;border-bottom:1px solid #2a2f45;text-align:left;font-size:13px}
  tbody td{padding:10px;border-bottom:1px solid #2a2f45;font-size:13px}
  .tag{padding:2px 8px;border-radius:999px;font-size:12px}
  .tag-ok{background:#1f4d2e;color:#b8f3c6}
  .tag-cancel{background:#4d1f1f;color:#ffc1c1}
  .empty{padding:16px;color:#c7c7c7}
  #out{margin-top:12px;background:#0b0f19;border:1px solid #262b3e;border-radius:8px;
       padding:8px;white-space:pre-wrap;font-family:Consolas,monospace;font-size:12px;
       max-height:220px;overflow:auto}
</style>
</head>
<body>
<div class="wrap">
  <h1>내 예매내역</h1>
  <div class="sub">로그인한 계정으로 예매한 내역을 확인하고, 필요하면 취소할 수 있습니다.</div>

  <div class="toolbar">
    <button class="btn btn-main btn-sm" onclick="loadMyReservations()">내 예매내역 새로고침</button>
    <span style="font-size:12px;color:#9aa4b2">※ 로그인 상태에서만 조회 가능합니다.</span>
    <div style="flex:1"></div>
    <button class="btn btn-sub btn-sm" onclick="location.href='/'">메인</button>
    <button class="btn btn-sub btn-sm" onclick="location.href='/reserve/movie'">영화 예매하기</button>
    <button class="btn btn-sub btn-sm" onclick="location.href='/login'">로그인</button>
    <button class="btn btn-sub btn-sm" onclick="doLogout()">로그아웃</button>
  </div>

  <table>
    <thead>
      <tr>
        <th style="width:90px">예약ID</th>
        <th style="width:200px">영화 제목</th>
        <th style="width:230px">상영 시간</th>
        <th style="width:140px">상영관</th>
        <th style="width:160px">좌석</th>
        <th style="width:110px">총 금액</th>
        <th style="width:100px">상태</th>
        <th style="width:90px">취소</th>
      </tr>
    </thead>
    <tbody id="rows">
      <tr><td colspan="8" class="empty">예매내역을 불러오지 못했습니다.</td></tr>
    </tbody>
  </table>

  <pre id="out"></pre>
</div>

<script>
function printOut(msg){
  var el = document.getElementById('out');
  el.textContent = (typeof msg === 'string') ? msg : JSON.stringify(msg, null, 2);
}

function fmt(ms){
  var d  = new Date(ms);
  var y  = d.getFullYear();
  var m  = String(d.getMonth()+1).padStart(2,'0');
  var dd = String(d.getDate()).padStart(2,'0');
  var hh = String(d.getHours()).padStart(2,'0');
  var mm = String(d.getMinutes()).padStart(2,'0');
  return y + '-' + m + '-' + dd + ' ' + hh + ':' + mm;
}

async function doLogout(){
  try{
    var res = await fetch('/api/auth/logout', {method:'POST'});
    if(res.ok){ location.href='/login'; }
  }catch(e){}
}

function escapeHtml(s){
  return String(s).replace(/[&<>"']/g, function(m){
    return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]);
  });
}

/** 예매내역 조회 */
async function loadMyReservations(){
  var url = '/api/reservations/me';
  var res = await fetch(url);
  var text = await res.text();
  printOut('GET ' + url + '\nSTATUS=' + res.status + '\n' + text);

  var tbody = document.getElementById('rows');

  if(!res.ok){
    tbody.innerHTML = '<tr><td colspan="8" class="empty">로그인이 필요하거나 서버 오류가 발생했습니다.</td></tr>';
    return;
  }

  var json;
  try{ json = JSON.parse(text); }catch(e){
    tbody.innerHTML = '<tr><td colspan="8" class="empty">응답 파싱 오류</td></tr>';
    return;
  }

  if(!json.success){
    tbody.innerHTML = '<tr><td colspan="8" class="empty">' + (json.message || '조회 실패') + '</td></tr>';
    return;
  }

  var list = json.data || [];
  if(list.length === 0){
    tbody.innerHTML = '<tr><td colspan="8" class="empty">예매 내역이 없습니다.</td></tr>';
    return;
  }

  tbody.innerHTML = '';

  list.forEach(function(item){
    var tr = document.createElement('tr');

    var seatText = '';
    if (Array.isArray(item.seatCodes)) {
      seatText = item.seatCodes.join(', ');
    }

    var statusClass = (item.status === 'CONFIRMED') ? 'tag-ok' : 'tag-cancel';

    var html  = '';
    html += '<td>' + item.reservationId + '</td>';
    html += '<td>' + escapeHtml(item.movieTitle || '') + '</td>';
    html += '<td>' + fmt(item.startTime) + ' ~ ' + fmt(item.endTime) + '</td>';
    html += '<td>' + escapeHtml(item.theaterName || '') + ' / ' + escapeHtml(item.screenName || '') + '</td>';
    html += '<td>' + escapeHtml(seatText) + '</td>';
    html += '<td>' + (item.totalPrice || 0).toLocaleString() + '원</td>';
    html += '<td><span class="tag ' + statusClass + '">' + escapeHtml(item.status || '') + '</span></td>';

    if (item.status === 'CONFIRMED') {
      html += '<td><button class="btn btn-main btn-sm" onclick="cancelReservation(' + item.reservationId + ')">취소</button></td>';
    } else {
      html += '<td><button class="btn btn-sm" disabled>완료</button></td>';
    }

    tr.innerHTML = html;
    tbody.appendChild(tr);
  });
}

/** 예매 취소 */
async function cancelReservation(reservationId){
  if(!confirm('예약 ' + reservationId + '을(를) 취소할까요?')) return;

  var url = '/api/reservations/' + reservationId + '/cancel';
  var res = await fetch(url, {method:'POST'});
  var text = await res.text();
  printOut('POST ' + url + '\nSTATUS=' + res.status + '\n' + text);

  var json = null;
  try{ json = JSON.parse(text); }catch(e){}

  if(res.ok && json && json.success){
    alert('취소되었습니다.');
    loadMyReservations();
  }else{
    alert('취소 실패: ' + (json && json.message ? json.message : 'HTTP ' + res.status));
  }
}

// 페이지 들어오면 자동 조회
loadMyReservations();
</script>
</body>
</html>
