package com.spring.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.mapper.ReservationCancelMapper;

@Service
public class ReservationCancelService {

    private final ReservationCancelMapper mapper;

    public ReservationCancelService(ReservationCancelMapper mapper) {
        this.mapper = mapper;
    }

    @Transactional
    public boolean cancel(Long reservationId) {
        // 1) 상태를 CANCELED로 변경 (이미 취소된 경우 0)
        int updated = mapper.updateReservationStatusToCanceled(reservationId);
        if (updated != 1) {
            return false;
        }

        // 2) 좌석 풀기(예매 좌석 삭제)
        mapper.deleteReservationSeats(reservationId);
        return true;
    }
}