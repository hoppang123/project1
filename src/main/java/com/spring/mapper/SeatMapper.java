package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.dto.SeatStatusDto;

public interface SeatMapper {

    // showtimeId 기준으로 좌석 + 예매여부 조회
	List<SeatStatusDto> selectSeatStatusByShowtimeId(
	        @Param("showtimeId") Long showtimeId
	    );
}
