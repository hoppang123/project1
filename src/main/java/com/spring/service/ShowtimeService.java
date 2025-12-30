package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.dto.ShowtimeDto;
import com.spring.mapper.ShowtimeMapper;

@Service
public class ShowtimeService {

    private final ShowtimeMapper showtimeMapper;

    // 생성자 주입
    public ShowtimeService(ShowtimeMapper showtimeMapper) {
        this.showtimeMapper = showtimeMapper;
    }

    // 특정 영화의 상영시간표 목록 조회
    public List<ShowtimeDto> getShowtimesByMovieId(Long movieId) {
        return showtimeMapper.selectShowtimesByMovieId(movieId);
    }
}
