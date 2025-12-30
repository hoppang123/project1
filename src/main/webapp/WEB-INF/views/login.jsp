<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Movie Reservation - Login</title>
<style>
body {
  margin:0;
  padding:0;
  font-family: Arial, sans-serif;
  background:#10141f;
  color:#f5f5f5;
}
.wrap {
  max-width:400px;
  margin:80px auto;
  padding:30px 24px;
  background:#141829;
  border-radius:10px;
  box-shadow:0 10px 30px rgba(0,0,0,0.6);
}
h1 { font-size:22px; margin-bottom:20px; }
label { display:block; margin:10px 0 4px; }
input[type="text"], input[type="password"] {
  width:100%;
  padding:8px;
  border-radius:4px;
  border:1px solid #434b61;
  background:#10141f;
  color:#f5f5f5;
}
input:focus {
  outline:none;
  border-color:#ff4b4b;
}
.btn {
  width:100%;
  margin-top:18px;
  padding:8px 0;
  border:none;
  border-radius:5px;
  background:#ff4b4b;
  color:#fff;
  font-weight:bold;
  cursor:pointer;
}
.msg {
  margin-top:10px;
  font-size:13px;
  min-height:18px;
}
.msg-error { color:#ff7676; }
.msg-ok    { color:#4caf50; }
.small {
  font-size:12px;
  margin-top:10px;
  color:#bbb;
}
</style>
</head>
<body>

<div class="wrap">
  <h1>🎬 영화 예매 로그인</h1>

  <label for="loginId">아이디</label>
  <input type="text" id="loginId" />

  <label for="password">비밀번호</label>
  <input type="password" id="password" />

  <button class="btn" onclick="doLogin()">로그인</button>

  <div id="msg" class="msg"></div>

  <div class="small">
    * 테스트용 계정 예시: <b>testuser / 1234</b><br>
    * 로그인 성공 시 메인 메뉴로 이동합니다.
  </div>
</div>

<script>
async function doLogin(){
  const loginId  = document.getElementById('loginId').value.trim();
  const password = document.getElementById('password').value.trim();
  const msgEl    = document.getElementById('msg');

  if(!loginId || !password){
    msgEl.textContent = '아이디와 비밀번호를 모두 입력하세요.';
    msgEl.className = 'msg msg-error';
    return;
  }

  const res = await fetch('/api/auth/login', {
    method:'POST',
    headers:{ 'Content-Type':'application/json' },
    body: JSON.stringify({ loginId, password })
  });

  const text = await res.text();

  if(res.ok){
    msgEl.textContent = '로그인 성공! 메인으로 이동합니다...';
    msgEl.className = 'msg msg-ok';
    setTimeout(() => location.href = '/main', 500);
  } else {
    msgEl.textContent = '로그인 실패: ' + text;
    msgEl.className = 'msg msg-error';
  }
}
</script>

</body>
</html>
