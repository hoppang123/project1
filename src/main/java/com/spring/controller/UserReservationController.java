package com.spring.controller;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.spring.dto.ReservationSummaryResponseDto;
import com.spring.service.ReservationService;

@RestController
@RequestMapping("/api/users")
public class UserReservationController {

    private final ReservationService reservationService;

    public UserReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    @GetMapping("/{userId}/reservations")
    public List<ReservationSummaryResponseDto> reservations(@PathVariable Long userId) {
        return reservationService.findSummaryByUser(userId);
    }
}
