package com.spring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PageController {

    /** 
     * 루트(/)로 들어오면 항상 로그인 화면으로 보냄 
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    /** 
     * 메인 메뉴 페이지 (로그인 필요)
     * /WEB-INF/views/main.jsp
     */
    @GetMapping("/main")
    public String main(HttpSession session) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        return "main";
    }

    /** 
     * 로그인 페이지 (여기는 로그인 여부와 상관없이 열어둠)
     * /WEB-INF/views/login.jsp
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /** 
     * 내 예매내역 페이지 (로그인 필요)
     * /WEB-INF/views/my.jsp
     */
    @GetMapping("/my")
    public String my(HttpSession session) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        return "my";
    }

    /** 
     * 예매 1단계: 영화 선택 (로그인 필요)
     * /WEB-INF/views/reserve_movie.jsp
     */
    @GetMapping("/reserve/movie")
    public String reserveMoviePage(HttpSession session) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        return "reserve_movie";
    }

    /** 
     * 예매 2단계: 상영시간 선택 (로그인 필요)
     * /WEB-INF/views/reserve_showtime.jsp
     */
    @GetMapping("/reserve/showtime")
    public String reserveShowtimePage(
            @RequestParam("movieId") Long movieId,
            HttpSession session) {

        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        // movieId는 JSP에서 JS로 다시 꺼내서 사용 (쿼리스트링 그대로 씀)
        return "reserve_showtime";
    }

    /** 
     * 예매 3단계: 좌석 선택 + 최종 예매 (로그인 필요)
     * /WEB-INF/views/reserve_seat.jsp
     */
    @GetMapping("/reserve/seat")
    public String reserveSeatPage(
            @RequestParam("showtimeId") Long showtimeId,
            HttpSession session) {

        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        return "reserve_seat";
    }

    /** 
     * 공통: 로그인 여부 체크
     * 세션에 LOGIN_USER_ID가 있으면 로그인된 것으로 간주
     */
    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        Object id = session.getAttribute("LOGIN_USER_ID");
        return (id != null);
    }
}
