package com.spring.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dto.ReservationHistoryDto;
import com.spring.dto.ReservationRequestDto;
import com.spring.dto.ReservationSummaryDto;
import com.spring.dto.ReservationSummaryResponseDto;
import com.spring.mapper.ReservationMapper;

@Service
public class ReservationService {

    private final ReservationMapper reservationMapper;

    public ReservationService(ReservationMapper reservationMapper) {
        this.reservationMapper = reservationMapper;
    }

    // ==============================
    // 1) 유저 예매 요약 조회
    //    (좌석 코드까지 묶어서 반환)
    // ==============================
    public List<ReservationSummaryResponseDto> findSummaryByUser(Long userId) {
        // 요약 정보들 (좌석 제외)
        List<ReservationSummaryDto> summaries =
                reservationMapper.findReservationSummariesByUserId(userId);

        List<ReservationSummaryResponseDto> result = new ArrayList<>();

        for (ReservationSummaryDto s : summaries) {
            ReservationSummaryResponseDto dto = new ReservationSummaryResponseDto();
            dto.setReservationId(s.getReservationId());
            dto.setMovieTitle(s.getMovieTitle());
            dto.setStartTime(s.getStartTime());
            dto.setEndTime(s.getEndTime());
            dto.setTheaterName(s.getTheaterName());
            dto.setScreenName(s.getScreenName());
            dto.setTotalPrice(s.getTotalPrice());
            dto.setStatus(s.getStatus());

            // 예약 ID로 좌석 코드들 조회해서 세팅
            dto.setSeatCodes(
                    reservationMapper.findSeatCodesByReservationId(s.getReservationId())
            );

            result.add(dto);
        }

        return result;
    }

    // ==============================
    // 2) 예매 생성
    // ==============================
    @Transactional
    public Long reserve(Long userId, ReservationRequestDto req) {

        if (req == null || req.getSeatIds() == null || req.getSeatIds().isEmpty()) {
            throw new IllegalStateException("좌석이 선택되지 않았습니다.");
        }
        if (req.getShowtimeId() == null) {
            throw new IllegalStateException("상영 정보가 없습니다.");
        }

        Long showtimeId = req.getShowtimeId();

        // 2-1) 좌석 중복 체크
        int cnt = reservationMapper.countReservedSeats(showtimeId, req.getSeatIds());
        if (cnt > 0) {
            throw new IllegalStateException("이미 예약된 좌석이 포함되어 있습니다.");
        }

        // 2-2) 기본 가격 조회
        Integer basePrice = reservationMapper.findBasePrice(showtimeId);
        if (basePrice == null) {
            throw new IllegalStateException("존재하지 않는 상영시간표(showtimeId)입니다.");
        }

        // 2-3) 총 금액 계산
        int totalPrice = basePrice * req.getSeatIds().size();

        // 2-4) 예약 헤더 생성
        reservationMapper.insertReservation(userId, showtimeId, totalPrice);

        // 2-5) 방금 생성된 예약 ID 조회
        Long reservationId = reservationMapper.findLastReservationId();
        if (reservationId == null) {
            throw new IllegalStateException("예약 번호를 가져오지 못했습니다.");
        }

        // 2-6) 예약-좌석 연결 (좌석당 price = basePrice 로 저장)
        for (Long seatId : req.getSeatIds()) {
            reservationMapper.insertReservationSeat(
                    reservationId,
                    seatId,
                    showtimeId,
                    basePrice
            );
        }

        return reservationId;
    }

    // ==============================
    // 3) 예매 취소
    // ==============================
    @Transactional
    public void cancel(Long reservationId) {
        int updated = reservationMapper.cancelReservation(reservationId);
        if (updated == 0) {
            throw new IllegalStateException("이미 취소되었거나 존재하지 않는 예약입니다.");
        }
    }

    // ==============================
    // 4) (옵션) 상세 내역
    // ==============================
    public List<ReservationHistoryDto> findByUser(Long userId) {
        return reservationMapper.findReservationsByUserId(userId);
    }
}
