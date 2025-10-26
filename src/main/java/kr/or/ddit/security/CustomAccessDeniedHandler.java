package kr.or.ddit.security;

import java.io.IOException;
import java.security.Principal;
import java.util.Collection;
import java.util.Iterator;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.access.AccessDeniedHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
	
	// 사용자가 정의한 접근 거부 처리자
	
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		log.info("## CustomAccessDeniedHandler.handle() 실행...!");
		log.info("## AccessDeniedException info -----------------");
		
		// 
		Principal principal = request.getUserPrincipal();
		if(request.isUserInRole("ROLE_MEMBER")) {
			log.info("## 회원 권한을 가진 사용자 id : {}", principal.getName());
		}else {
			log.info("## 관리자 권한을 가진 사용자 id : {}", principal.getName());
		}
		
		log.info(accessDeniedException.getMessage());
		response.sendRedirect("/accessError");
	}

}
