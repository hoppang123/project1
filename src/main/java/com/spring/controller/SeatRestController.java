package com.spring.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dto.SeatStatusDto;
import com.spring.service.SeatService;

@RestController
public class SeatRestController {

    private final SeatService seatService;

    public SeatRestController(SeatService seatService) {
        this.seatService = seatService;
    }

    @GetMapping("/api/showtimes/{showtimeId}/seats")
    public ResponseEntity<List<SeatStatusDto>> getSeats(
            @PathVariable("showtimeId") Long showtimeId) {

        List<SeatStatusDto> list = seatService.getSeatStatus(showtimeId);
        return ResponseEntity.ok(list);
    }
}
