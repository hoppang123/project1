package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/view")
public class ViewController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/movies")
    public String movies() {
        return "movies";
    }

    @GetMapping("/reservations")
    public String reservations() {
        return "reservations";
    }

    @GetMapping("/movies/{movieId}/showtimes")
    public String showtimes(@PathVariable long movieId) {
        return "showtimes";
    }

    @GetMapping("/showtimes/{showtimeId}/seats")
    public String seats(@PathVariable long showtimeId) {
        return "seats";
    }
}
