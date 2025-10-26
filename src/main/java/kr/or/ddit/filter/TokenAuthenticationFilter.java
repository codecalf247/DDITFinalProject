package kr.or.ddit.filter;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.util.TokenProvider;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TokenAuthenticationFilter extends OncePerRequestFilter {

	private TokenProvider tokenProvider;
	
	private final static String HEADER_AUTHORIZATION = "Authorization";
	private final static String TOKEN_PREFFIX = "Bearer ";

	public TokenAuthenticationFilter(TokenProvider tokenProvider) {
		this.tokenProvider = tokenProvider;
	}
	
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		log.info("# TokenAuthenticationFilter:doFilterInternal->Msg : Filter execution...!");
		String authorizationHeader = request.getHeader(HEADER_AUTHORIZATION);
		String token = getAccessToken(authorizationHeader);
		
		if(token != null && tokenProvider.validToken(token)) {
			log.info("# TokenAuthenticationFilter:doFilterInternal->Msg :This is a valid token");
			log.info("# TokenAuthenticationFilter:doFilterInternal->Token : " + token);
			
			Authentication authentication = tokenProvider.getAuthentication(token);
			SecurityContextHolder.getContext().setAuthentication(authentication);
		}
		filterChain.doFilter(request, response);
	}

	private String getAccessToken(String authorizationHeader) {
		if(authorizationHeader != null && authorizationHeader.startsWith(TOKEN_PREFFIX)) {
			return authorizationHeader.substring(TOKEN_PREFFIX.length());
		}
		return null;
	}

}
