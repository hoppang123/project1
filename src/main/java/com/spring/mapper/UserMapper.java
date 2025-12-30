package com.spring.mapper;

import org.apache.ibatis.annotations.Param;
import com.spring.dto.UserDto;

public interface UserMapper {

    UserDto findByLoginIdAndPassword(
        @Param("loginId") String loginId,
        @Param("password") String password
    );
}
