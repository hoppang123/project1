package com.spring.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request,
	                         HttpServletResponse response,
	                         Object handler) throws Exception {

		 System.out.println(">>> LoginInterceptor hit: " + request.getRequestURI());
		
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("loginUser") == null) {
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        response.setContentType("application/json;charset=UTF-8");
	        response.getWriter().write(
	            "{\"success\":false,\"message\":\"로그인이 필요합니다.\"}"
	        );
	        return false;
	    }
	    return true;
	}
}