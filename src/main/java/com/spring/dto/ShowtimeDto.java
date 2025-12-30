package com.spring.dto;

public class ShowtimeDto {
    private Long id;
    private Long movieId;
    private Long screenId;
    private String startTime;   // '2025-12-28 19:00' 같은 문자열
    private String endTime;
    private Integer basePrice;

    private String theaterName; // 지점 이름
    private String screenName;  // 상영관 이름

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public Long getMovieId() {
        return movieId;
    }
    public void setMovieId(Long movieId) {
        this.movieId = movieId;
    }

    public Long getScreenId() {
        return screenId;
    }
    public void setScreenId(Long screenId) {
        this.screenId = screenId;
    }

    public String getStartTime() {
        return startTime;
    }
    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }
    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Integer getBasePrice() {
        return basePrice;
    }
    public void setBasePrice(Integer basePrice) {
        this.basePrice = basePrice;
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
}
