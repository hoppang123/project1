package com.spring.mapper;

import org.apache.ibatis.annotations.Param;

public interface ReservationCancelMapper {
	Long findShowtimeIdByReservationId(@Param("reservationId") Long reservationId);

    int updateReservationStatusToCanceled(@Param("reservationId") Long reservationId);

    int deleteReservationSeats(@Param("reservationId") Long reservationId);
}
