package kr.or.ddit.config;

import java.util.concurrent.Executor;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
// WebMvcConfigurer : Spring MVC 설정을 커스터마이징 할 수 있게 해주는 인터페이스
	
	// spring MVC의 CORS 매핑 추가 메서드 
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") 			// 1. 애플리케이션의 모든 URL 패턴에 CORS 설정을 적용합니다.
                .allowedOriginPatterns("*") // 2. 모든 출처(도메인)에서의 요청을 허용합니다.
                .allowedMethods("*") 		// 3. 모든 HTTP 메서드(GET, POST, PUT, DELETE 등)를 허용합니다.
                .allowedHeaders("*") 		// 4. 모든 요청 헤더를 허용합니다.
                .allowCredentials(false); 	// 5. 자격 증명(쿠키, 인증 헤더 등)은 허용하지 않습니다.
    }
    
    public Executor mvcTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);       // 기본 스레드 수
        executor.setMaxPoolSize(50);        // 최대 스레드 수
        executor.setQueueCapacity(100);     // 대기 큐 크기
        executor.setThreadNamePrefix("mvc-async-");
        executor.initialize();
        return executor;
    }
    
}