package kr.or.ddit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import lombok.extern.slf4j.Slf4j;

@Configuration
@EnableWebSocketMessageBroker
@Slf4j
public class ChattingConfig implements WebSocketMessageBrokerConfigurer{

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		// TODO Auto-generated method stub
		config.enableSimpleBroker("/sub");
		config.setApplicationDestinationPrefixes("/pub");
	}
	
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		// TODO Auto-generated method stub
		registry.addEndpoint("/ws-stomp")
		.addInterceptors(new org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor())
        .setAllowedOriginPatterns("http://localhost:8060", "http://localhost:8080", "http://localhost:3000") // 개발용 허용 도메인 명시
        .withSockJS();
		log.info("✅ STOMP 엔드포인트 등록 완료: /ws-stomp");
	}
	
}
