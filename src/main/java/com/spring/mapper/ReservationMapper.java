package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.dto.ReservationHistoryDto;
import com.spring.dto.ReservationSummaryDto;

public interface ReservationMapper {

    // 1) 좌석 중복 체크
    int countReservedSeats(
        @Param("showtimeId") Long showtimeId,
        @Param("seatIds") List<Long> seatIds
    );

    // 2) 상영 기본 가격 조회
    Integer findBasePrice(@Param("showtimeId") Long showtimeId);

    // 3) 예약 헤더 insert
    void insertReservation(
        @Param("userId") Long userId,
        @Param("showtimeId") Long showtimeId,
        @Param("totalPrice") int totalPrice
    );

    // 4) 방금 insert 된 예약 ID 조회
    Long findLastReservationId();

    // 5) 예약-좌석 insert (좌석당 price 포함)
    void insertReservationSeat(
        @Param("reservationId") Long reservationId,
        @Param("seatId") Long seatId,
        @Param("showtimeId") Long showtimeId,
        @Param("price") int price
    );

    // 6) 예매 취소
    int cancelReservation(@Param("reservationId") Long reservationId);

    // 7) 상세 내역 (히스토리)
    List<ReservationHistoryDto> findReservationsByUserId(
        @Param("userId") Long userId
    );

    // 8) 예매 요약 (좌석 제외)
    List<ReservationSummaryDto> findReservationSummariesByUserId(
        @Param("userId") Long userId
    );

    // 9) 예매 1건의 좌석 코드들
    List<String> findSeatCodesByReservationId(
        @Param("reservationId") Long reservationId
    );
}
