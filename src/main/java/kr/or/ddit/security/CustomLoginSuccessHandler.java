package kr.or.ddit.security;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	private RequestCache requestCache = new HttpSessionRequestCache();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		log.info("## CustomLoginSuccessHandler.onAuthenticationSuccess() 실행...!");
		User user = (User) authentication.getPrincipal();
		
		CustomUser custom = (CustomUser) authentication.getPrincipal();
		EmpVO emp = custom.getMember();
		
		HttpSession session = request.getSession();
		session.setAttribute("empVO", emp);
		
		// 시큐리티 활성화된 사용자인지 체크
		if(user.isEnabled()) {
			log.info("## username : {}", user.getUsername());	// 인증된 사용자 아이디
			log.info("## password : {}", user.getPassword());	// 인증된 사용자 비밀번호
			Collection<GrantedAuthority> grantedAuthority = user.getAuthorities();
		 	Iterator<GrantedAuthority> ite_authority = grantedAuthority.iterator();
		 	while(ite_authority.hasNext()) {
		 		GrantedAuthority authority = ite_authority.next();
		 		log.info("## auth : {}", authority.getAuthority());	// 인증된 사용자 권한
		 	}
		}
		
		// SPRING_SECURITY_EXCEPTION으로 등록된 에러 정보를 삭제
		clearAuthenticationAttribute(request);
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		String targetUrl = "/main/dashboard";	// 기본 default target은 root
		// 그냥 무조건 메인에 대시보드로 보냄
//		if(savedRequest != null) {
//			targetUrl = savedRequest.getRedirectUrl();
//		}
		
		log.info("## Login Success target URL : " + targetUrl);
		response.sendRedirect(targetUrl);
	}

	private void clearAuthenticationAttribute(HttpServletRequest request) {
		// session 정보가 존재한다면 현재 session을 반환하고 존재하지 않으면 null을 반환합니다.
		HttpSession session = request.getSession(false);
		if(session == null) {
			return;
		}
		
		// SPRING_SECURITY_LAST_EXCEPTION 값
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

}
