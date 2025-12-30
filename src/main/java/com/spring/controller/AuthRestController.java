package com.spring.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.spring.dto.UserDto;
import com.spring.mapper.UserMapper;

@RestController
@RequestMapping("/api/auth")
public class AuthRestController {

    private final UserMapper userMapper;

    public AuthRestController(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    // 로그인 요청 바디용 DTO
    public static class LoginRequest {
        private String loginId;
        private String password;

        public String getLoginId() { return loginId; }
        public void setLoginId(String loginId) { this.loginId = loginId; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }

    // -----------------------------
    // POST /api/auth/login
    // -----------------------------
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req,
                                   HttpSession session) {

        if (req.getLoginId() == null || req.getPassword() == null) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", "아이디와 비밀번호를 입력해 주세요.");
            return ResponseEntity.badRequest().body(body);
        }

        UserDto user = userMapper.findByLoginIdAndPassword(
                req.getLoginId(),
                req.getPassword()
        );

        if (user == null) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return ResponseEntity.status(401).body(body);
        }

        // 세션 저장
        session.setAttribute("LOGIN_USER_ID", user.getId());
        session.setAttribute("LOGIN_USER_LOGIN_ID", user.getLoginId());
        session.setAttribute("LOGIN_USER_NAME", user.getName());

        Map<String, Object> body = new HashMap<>();
        body.put("success", true);
        body.put("loginId", user.getLoginId());
        body.put("name", user.getName());
        return ResponseEntity.ok(body);
    }

    // -----------------------------
    // POST /api/auth/logout
    // -----------------------------
    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> body = new HashMap<>();
        body.put("success", true);
        return ResponseEntity.ok(body);
    }

    // -----------------------------
    // GET /api/auth/me
    // -----------------------------
    @GetMapping("/me")
    public ResponseEntity<?> me(HttpSession session) {
        Object userId = session.getAttribute("LOGIN_USER_ID");
        if (userId == null) {
            return ResponseEntity.status(401).body("NOT LOGIN");
        }

        String loginId = (String) session.getAttribute("LOGIN_USER_LOGIN_ID");
        String name     = (String) session.getAttribute("LOGIN_USER_NAME");

        String text;
        if (name != null && !name.isEmpty()) {
            text = name + " (" + loginId + ")";
        } else {
            text = loginId;
        }

        return ResponseEntity.ok(text);
    }
}

