package kr.or.ddit.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.filter.TokenAuthenticationFilter;
import kr.or.ddit.security.CustomAccessDeniedHandler;
import kr.or.ddit.security.CustomLoginFailureHandler;
import kr.or.ddit.security.CustomLoginSuccessHandler;
import kr.or.ddit.security.CustomUserDetailsService;
import kr.or.ddit.util.TokenProvider;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService customUserDetailsService;
    
//	@Autowired
//	private TokenProvider tokenProvider;
	
	private static final String[] PASS_URL = {
			"/",
			"/login",
			"/error",
			"/.well-known/**",
			"/accessError",
			"/api/**",
			"/meetings/**",
			"/rag/**",
	};

	@Bean
	public WebSecurityCustomizer cofigure() {
		return (web) -> web.ignoring()
				// 정적 리소스 요청부 모두를 우회할 수 있도록 요청 경로 설정
				.requestMatchers(PathRequest.toStaticResources().atCommonLocations())
				.requestMatchers("/resources/**");
		
		// 해당 Bean 안에서도 정적 리소스 말고도 시큐리티를 우회하여 페이지를 실행할 여러 요청 경로를 설정할 수도 있습니다.
		// 그렇지만 보통 정적 리소스로만 한정 지어서 필터 체인을 우회할 수 있도록 설정합니다.
		// 그외 요청에 대해서는 아래 필터체인을 통해 모든 요청을 허용할 수 있는 permitAll()을 설정하여 우회할 수 있도록 합니다.
	}
	
	// JWT 토큰 방식의 필터체인 구성
//	@Order(1)
//	@Bean
//	protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//		http.csrf((csrf) -> csrf.disable());
//		http.formLogin((login) -> login.disable());
//		http.httpBasic((basic) -> basic.disable());
//		http.headers((config) -> config.frameOptions((fOpt) -> fOpt.sameOrigin()));
//		http.sessionManagement(
//				(management) -> management.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
//		);
//		
//		http.addFilterBefore(new TokenAuthenticationFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class);
//		http.securityMatcher("/api/react/**")
//			.authorizeHttpRequests(
//			(authorize) ->
//				// forward는 모두 접근 가능
//				authorize
//						.requestMatchers("/api/react/checkId.do",
//										 "/api/react/signup.do",
//										 "/api/react/signin.do",
//										 "/api/react/notice/list"
//						).permitAll()
//						.anyRequest().authenticated()
//		);
//		
//		return http.build();
//	}
	
	// 세션 기반의 필터체인 등록
	@Order(2)
	@Bean
	public SecurityFilterChain filterChain2(HttpSecurity http) throws Exception {
		http.csrf((csrf) -> csrf.disable());
		http.securityMatcher("/**")
				.authorizeHttpRequests(authorize -> 
						authorize.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
						
								.requestMatchers(PASS_URL).permitAll()
								.anyRequest().authenticated()
				);
		http.exceptionHandling((exception) -> exception.accessDeniedHandler(new CustomAccessDeniedHandler()));
		http.httpBasic((hbasic) -> hbasic.disable());
		http.formLogin(
				(login) -> login.loginPage("/login")
								//.loginProcessingUrl("/login")
								.successHandler(new CustomLoginSuccessHandler())
								.failureHandler(new CustomLoginFailureHandler())
		);
		http.logout(
				(logout) -> logout.logoutUrl("/logout")
									.invalidateHttpSession(true)
									.logoutSuccessUrl("/login")
									.deleteCookies("JSSESION_ID", "remember-me")
		);
		return http.build();
	}
	
    @Bean
    protected AuthenticationManager authenticationManager(
    		HttpSecurity http, BCryptPasswordEncoder bCryptPasswordEncoder,
    		UserDetailsService userDetailsService) {
    	// 인증 제공자 인증 처리
    	DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
    	// # userDetailService()
    	// - 사용자 정보를 가져올 서비스를 설정한다. 이때, 설정하는 클래스는 UserDetailsService를 상속받는 클래스여야 한다.
    	// # passwordEncoder()
    	// - 비밀번호 암호화하기 위한 인코더를 설정한다.
    	authProvider.setUserDetailsService(customUserDetailsService);
    	authProvider.setPasswordEncoder(bCryptPasswordEncoder);
    	return new ProviderManager(authProvider);
    }
	
	@Bean
	protected PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
}
