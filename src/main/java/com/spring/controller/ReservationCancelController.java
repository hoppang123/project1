package com.spring.controller;

import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.ReservationService;

@RestController
@RequestMapping("/api/reservations")
public class ReservationCancelController {

    private final ReservationService reservationService;

    public ReservationCancelController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    @PatchMapping("/{reservationId}/cancel")
    public String cancel(@PathVariable Long reservationId) {
        reservationService.cancel(reservationId);
        return "CANCELED";
    }
}
