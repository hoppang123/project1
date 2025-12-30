package com.spring.dto;

public class SeatStatusDto {

    private Long seatId;      // 좌석 PK
    private Long showtimeId;  // 상영시간표 ID
    private Long screenId;    // 상영관 ID (seats.screen_id)
    private String seatName;  // A1, A2 이런 이름
    private String rowLabel;  // A, B, C ...
    private Integer colNumber;// 1, 2, 3 ...
    private boolean reserved; // true = 이미 예매됨

    public Long getSeatId() {
        return seatId;
    }
    public void setSeatId(Long seatId) {
        this.seatId = seatId;
    }

    public Long getShowtimeId() {
        return showtimeId;
    }
    public void setShowtimeId(Long showtimeId) {
        this.showtimeId = showtimeId;
    }

    public Long getScreenId() {
        return screenId;
    }
    public void setScreenId(Long screenId) {
        this.screenId = screenId;
    }

    public String getSeatName() {
        return seatName;
    }
    public void setSeatName(String seatName) {
        this.seatName = seatName;
    }

    public String getRowLabel() {
        return rowLabel;
    }
    public void setRowLabel(String rowLabel) {
        this.rowLabel = rowLabel;
    }

    public Integer getColNumber() {
        return colNumber;
    }
    public void setColNumber(Integer colNumber) {
        this.colNumber = colNumber;
    }

    public boolean isReserved() {
        return reserved;
    }
    public void setReserved(boolean reserved) {
        this.reserved = reserved;
    }
}
