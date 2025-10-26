package kr.or.ddit.config;

import java.time.Duration;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig {
    
	// RestTemplate : Spring 에서 제공하는 HTTP 클라이언트 (REST API를 호출할 때 쓰는 도구)
	@Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
    	
    	return builder
                // Cloudinary 서버가 응답이 없을 때 무한정 기다리는 것을 방지하기 위해 타임아웃을 설정합니다.
                .setConnectTimeout(Duration.ofSeconds(5)) // 연결 타임아웃 5초
                .setReadTimeout(Duration.ofSeconds(5))    // 데이터 읽기 타임아웃 5초
                .build();
    }
}