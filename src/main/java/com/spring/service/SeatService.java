package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.dto.SeatStatusDto;
import com.spring.mapper.SeatMapper;

@Service
public class SeatService {

    private final SeatMapper seatMapper;

    public SeatService(SeatMapper seatMapper) {
        this.seatMapper = seatMapper;
    }

    public List<SeatStatusDto> getSeatStatus(Long showtimeId) {
        return seatMapper.selectSeatStatusByShowtimeId(showtimeId);
    }
}
