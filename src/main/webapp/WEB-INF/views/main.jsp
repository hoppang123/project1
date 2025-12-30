<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 예매 시스템 - 메인</title>
<style>
body {
  margin:0;
  padding:0;
  font-family:Arial, sans-serif;
  background:#10141f;
  color:#f5f5f5;
}
.wrap {
  max-width:960px;
  margin:40px auto;
  padding:24px 20px 30px;
  background:#141829;
  border-radius:10px;
  box-shadow:0 10px 30px rgba(0,0,0,0.6);
}
.header {
  display:flex;
  justify-content:space-between;
  align-items:center;
}
.title {
  font-size:26px;
  font-weight:bold;
}
.subtitle {
  font-size:13px;
  color:#c7c7c7;
  margin-top:4px;
}
.menu {
  margin-top:24px;
  display:flex;
  gap:10px;
  flex-wrap:wrap;
}
.btn {
  padding:10px 18px;
  border:none;
  border-radius:6px;
  cursor:pointer;
  font-weight:bold;
  font-size:14px;
}
.btn-main { background:#ff4b4b; color:#fff; }
.btn-sub  { background:#2f364a; color:#fff; }
.badge-login {
  font-size:13px;
  padding:4px 8px;
  border-radius:4px;
  background:#1f2937;
}
</style>
</head>
<body>

<div class="wrap">
  <div class="header">
    <div>
      <div class="title">🎬 영화 예매 시스템</div>
      <div class="subtitle">영화 선택 → 상영시간 선택 → 좌석 선택까지 한 번에!</div>
    </div>
    <div id="loginStatus" class="badge-login">
      로그인 상태: 확인 중...
    </div>
  </div>

  <div class="menu">
    <button class="btn btn-main" onclick="location.href='/reserve/movie'">🎟 영화 예매하기</button>
    <button class="btn btn-sub" onclick="location.href='/my'">📂 내 예매내역 보기</button>
    <button class="btn btn-sub" onclick="location.href='/reserve/movie'">🎥 상영 영화 보기</button>
    <button class="btn btn-sub" onclick="location.href='/login'">🔐 로그인</button>
    <button class="btn btn-sub" onclick="logout()">🔓 로그아웃</button>
  </div>
</div>

<script>
async function refreshLoginStatus(){
  const el = document.getElementById('loginStatus');
  try {
    const res = await fetch('/api/auth/me');
    if(res.ok){
      const text = await res.text();
      el.textContent = 'LOGIN - ' + text;
      el.style.color = '#4caf50';
    } else {
      el.textContent = 'LOGOUT';
      el.style.color = '#ff7676';
    }
  } catch(e){
    el.textContent = '상태 확인 실패';
  }
}
async function logout(){
  await fetch('/api/auth/logout',{method:'POST'});
  alert('로그아웃 되었습니다.');
  refreshLoginStatus();
}
refreshLoginStatus();
</script>
</body>
</html>
