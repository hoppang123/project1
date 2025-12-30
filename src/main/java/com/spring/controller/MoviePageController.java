package com.spring.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.dto.MovieDto;
import com.spring.mapper.MovieMapper;

@Controller
public class MoviePageController {

    private final MovieMapper movieMapper;

    public MoviePageController(MovieMapper movieMapper) {
        this.movieMapper = movieMapper;
    }

    @GetMapping("/movies")
    public String movies(Model model) {
        List<MovieDto> list = movieMapper.findAll();
        model.addAttribute("movies", list);
        return "movies"; // /WEB-INF/views/movies.jsp
    }
}
