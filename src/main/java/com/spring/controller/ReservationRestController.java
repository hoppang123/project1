package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.spring.dto.ReservationRequestDto;
import com.spring.dto.ReservationSummaryResponseDto;
import com.spring.service.ReservationService;

@RestController
@RequestMapping("/api")
public class ReservationRestController {

    private final ReservationService reservationService;

    public ReservationRestController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    /* -----------------------------------------------------
       1) 예매 생성
       ----------------------------------------------------- */
    @PostMapping("/reservations")
    public ResponseEntity<?> reserve(
            @RequestBody ReservationRequestDto req,
            HttpSession session) {

        Long userId = getLoginUserId(session);
        if (userId == null) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);

            // 디버그용으로 세션ID도 같이 내려줌 (나중에 필요 없으면 지워도 됨)
            String sid = (session != null ? session.getId() : "null");
            body.put("message", "로그인이 필요합니다. (세션ID=" + sid + ")");
            return ResponseEntity.status(401).body(body);
        }

        try {
            Long reservationId = reservationService.reserve(userId, req);

            Map<String, Object> body = new HashMap<>();
            body.put("success", true);
            body.put("reservationId", reservationId);
            return ResponseEntity.ok(body);

        } catch (IllegalStateException e) {
            // 우리가 의도적으로 던지는 오류 (좌석 중복, 잘못된 showtime 등)
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(body);

        } catch (Exception e) {
            // 진짜 서버 내부 오류 (SQL 오류 등)
            e.printStackTrace(); // 콘솔에 전체 스택 출력

            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", "EXCEPTION: " + e.getClass().getName() + " / " + e.getMessage());
            return ResponseEntity.status(500).body(body);
        }
    }

    /* -----------------------------------------------------
       2) 예매 취소
       ----------------------------------------------------- */
    @PostMapping("/reservations/{reservationId}/cancel")
    public ResponseEntity<?> cancel(
            @PathVariable Long reservationId,
            HttpSession session) {

        Long userId = getLoginUserId(session);
        if (userId == null) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            String sid = (session != null ? session.getId() : "null");
            body.put("message", "로그인이 필요합니다. (세션ID=" + sid + ")");
            return ResponseEntity.status(401).body(body);
        }

        try {
            reservationService.cancel(reservationId);

            Map<String, Object> body = new HashMap<>();
            body.put("success", true);
            return ResponseEntity.ok(body);

        } catch (IllegalStateException e) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(body);

        } catch (Exception e) {
            e.printStackTrace();

            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", "서버 내부 오류: " + e.getMessage());
            return ResponseEntity.status(500).body(body);
        }
    }

    /* -----------------------------------------------------
       3) (테스트용) userId=1 고정 조회
       ----------------------------------------------------- */
    @GetMapping("/test/reservations")
    public ResponseEntity<?> testReservations() {
        Long userId = 1L;
        List<ReservationSummaryResponseDto> list =
                reservationService.findSummaryByUser(userId);
        return ResponseEntity.ok(list);
    }

    /* -----------------------------------------------------
       4) 내 예매 내역 조회 (my.jsp에서 사용)
       ----------------------------------------------------- */
    @GetMapping("/reservations/me")
    public ResponseEntity<?> myReservations(HttpSession session) {

        Long userId = getLoginUserId(session);
        Map<String, Object> body = new HashMap<>();

        if (userId == null) {
            String sid = (session != null ? session.getId() : "null");
            body.put("success", false);
            body.put("message", "로그인이 필요합니다. (세션ID=" + sid + ")");
            return ResponseEntity.status(401).body(body);
        }

        List<ReservationSummaryResponseDto> list =
                reservationService.findSummaryByUser(userId);

        body.put("success", true);
        body.put("data", list);
        return ResponseEntity.ok(body);
    }

    /* -----------------------------------------------------
       세션에서 로그인 유저 ID 꺼내기
       ----------------------------------------------------- */
    private Long getLoginUserId(HttpSession session) {
        if (session == null) return null;

        Object obj = session.getAttribute("LOGIN_USER_ID");
        if (obj instanceof Number) {
            return ((Number) obj).longValue();
        }

        // 혹시 옛날 코드에서 LOGIN_USER 객체로 들고 있는 경우 방어용
        Object userObj = session.getAttribute("LOGIN_USER");
        if (userObj != null) {
            try {
                java.lang.reflect.Method m =
                        userObj.getClass().getMethod("getId");
                Object idVal = m.invoke(userObj);
                if (idVal instanceof Number) {
                    return ((Number) idVal).longValue();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }
}
