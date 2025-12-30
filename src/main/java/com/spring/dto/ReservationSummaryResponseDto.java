package com.spring.dto;

import java.util.Date;
import java.util.List;

public class ReservationSummaryResponseDto {

    // 예약 ID
    private Long reservationId;

    // 영화 제목
    private String movieTitle;

    // 상영 시작/끝 시간
    private Date startTime;
    private Date endTime;

    // 극장 / 상영관 이름
    private String theaterName;
    private String screenName;

    // 총 금액
    private Integer totalPrice;

    // 상태 (CONFIRMED / CANCELED)
    private String status;

    // 좌석 코드 목록 (예: ["A1","A2"])
    private List<String> seatCodes;

    public Long getReservationId() {
        return reservationId;
    }

    public void setReservationId(Long reservationId) {
        this.reservationId = reservationId;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getTheaterName() {
        return theaterName;
    }

    public void setTheaterName(String theaterName) {
        this.theaterName = theaterName;
    }

    public String getScreenName() {
        return screenName;
    }

    public void setScreenName(String screenName) {
        this.screenName = screenName;
    }

    public Integer getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Integer totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<String> getSeatCodes() {
        return seatCodes;
    }

    public void setSeatCodes(List<String> seatCodes) {
        this.seatCodes = seatCodes;
    }
}
