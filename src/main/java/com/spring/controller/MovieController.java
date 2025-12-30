package com.spring.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dto.MovieDto;
import com.spring.dto.ShowtimeDto;
import com.spring.mapper.MovieMapper;
import com.spring.mapper.ShowtimeMapper;

@RestController
public class MovieController {

    private final MovieMapper movieMapper;
    private final ShowtimeMapper showtimeMapper;

    public MovieController(MovieMapper movieMapper, ShowtimeMapper showtimeMapper) {
        this.movieMapper = movieMapper;
        this.showtimeMapper = showtimeMapper;
    }

    // 영화 목록
    @GetMapping("/api/movies")
    public List<MovieDto> movies() {
        return movieMapper.findAll();
    }

    // 단일 영화 상세 (필요 시)
    @GetMapping("/api/movies/{id}")
    public MovieDto movie(@PathVariable Long id) {
        return movieMapper.findById(id);
    }

    // ✅ 영화별 상영시간표 조회 (2단계에서 쓰는 API)
    @GetMapping("/api/movies/{movieId}/showtimes")
    public List<ShowtimeDto> showtimes(@PathVariable("movieId") Long movieId) {
        return showtimeMapper.selectShowtimesByMovieId(movieId);
    }
}
