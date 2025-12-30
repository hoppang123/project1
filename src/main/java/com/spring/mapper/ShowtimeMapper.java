package com.spring.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.spring.dto.ShowtimeDto;

public interface ShowtimeMapper {

    List<ShowtimeDto> selectShowtimesByMovieId(@Param("movieId") Long movieId);

}
