package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.dto.MovieDto;

public interface MovieMapper {
	List<MovieDto> findAll();
	
	MovieDto findById(@Param("id") Long id);
}