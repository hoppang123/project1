🧱 프로젝트 구조
project
 ├─ src/main/java/com/spring
 │   ├─ config          # Spring 환경 설정 (WebConfig, RootConfig)
 │   ├─ controller      # MVC Controller, REST API
 │   ├─ dto             # 예약·좌석·유저 정보 DTO
 │   ├─ mapper          # MyBatis Mapper Interface
 │   ├─ service         # 비즈니스 로직 (예약 생성/취소/조회)
 │   └─ util            # 기타 보조 클래스
 │
 ├─ src/main/resources
 │   ├─ mapper/*.xml    # MyBatis SQL XML
 │   └─ application.yml # DB 설정
 │
 └─ src/main/webapp
     ├─ WEB-INF/views   # JSP 파일 (UI)
     │   ├─ login.jsp
     │   ├─ reserve_movie.jsp
     │   ├─ reserve_showtime.jsp
     │   ├─ reserve_seat.jsp
     │   └─ my.jsp
     └─ index.jsp       # 메인

🧪 실행 방법
1️⃣ DB 준비

MySQL 접속 후 다음 순서 실행:

CREATE DATABASE movie DEFAULT CHARACTER SET utf8mb4;
USE movie;

-- 1) 영화 / 상영시간 / 좌석 / 예매 테이블 설치
(DDL SQL 파일 실행)

-- 2) 테스트 데이터 삽입
INSERT INTO users (login_id, password, name) VALUES ('aaa','1111','테스트유저');

2️⃣ 프로젝트 실행
mvn clean package
Run on Apache Tomcat 9.x


접속 주소:

http://192.168.0.27:8080/login

🚀 주요 기능
기능	설명	파일
로그인 / 로그아웃	세션 기반 로그인	AuthRestController, login.jsp
영화 목록 조회	등록된 영화 리스트 출력	reserve_movie.jsp
상영시간 선택	영화 선택 후 해당 영화 상영시간 출력	reserve_showtime.jsp
좌석 선택	좌석 상태 표시 + UI 선택	reserve_seat.jsp
예매 생성	선택 좌석 + 가격 계산 후 예매/저장	ReservationRestController.reserve()
예매 내역 조회	로그인한 유저의 예약 목록 표시	my.jsp
예매 취소	상태를 CANCELED 로 변경	ReservationRestController.cancel()
🧩 예매 흐름도
로그인
   ↓
영화 선택 (/reserve/movie)
   ↓ movieId
상영시간 선택 (/reserve/showtime)
   ↓ showtimeId
좌석 선택 (/reserve/seat)
   ↓ seatIds
예매 생성 (/api/reservations)
   ↓ reservationId
내 예매 내역 확인 (/my)
   ↳ 취소 가능 (/api/reservations/{id}/cancel)

🎨 UI 미리보기 (추가 예정)

아래 위치에 스크린샷 넣을 예정
(프로젝트 발표 자료에서 사용했던 화면들)

📌 메인 화면

📌 로그인 화면

📌 영화 선택 화면

📌 상영시간 선택 화면

📌 좌석 UI (행/열 정렬, 선택/예약/내 선택 상태 표시)

📌 내 예매내역 (취소 가능)

🗄️ 핵심 SQL 구조
movies(id, title, runtime_min, rating)
showtimes(id, movie_id, theater_name, screen_name, start_time, end_time, base_price)
seats(id, screen_name, seat_name, row_label, col_number)
reservations(id, user_id, showtime_id, total_price, status)
reservation_seats(reservation_id, seat_id)

📌 REST API 요약
Method	Endpoint	설명
POST	/api/auth/login	로그인
POST	/api/auth/logout	로그아웃
GET	/api/movies	영화 목록
GET	/api/movies/{id}/showtimes	상영시간 목록
GET	/api/showtimes/{id}/seats	좌석 목록
POST	/api/reservations	예매 생성
POST	/api/reservations/{id}/cancel	예매 취소
GET	/api/reservations/me	내 예약 확인
🙋 의도한 설계 포인트

REST API + JSP 조합
→ 프론트는 Fetch API로 백엔드 호출

좌석 선택 UI
→ row/col 기반으로 정렬 + 세트 선택 상태 구현

예매 취소
→ DB 삭제가 아니라 status='CANCELED' 로 관리
→ 이력 유지 + 상태 기반 표시

📝 개선 계획 (TODO)

예매 생성 시 가격 계산 UI 표시

스프링부트 전환

Vue/React 프론트 분리

⭐ 개발자 코멘트

“기능이 도는 것”을 넘어서
UI 완성 → 흐름 유지 → 발표 가능 수준까지 정리하는 작업까지 했습니다.
좌석 UI, 취소 기능, 로그인 유지 모두 실제 서비스 흐름 기준으로 설계했습니다.

👤 Made By

이름: 이종호

기간: 2025년 12월

Stack: Java / Spring MVC / MyBatis / JSP / MySQL / Tomcat
