package kr.or.ddit.util;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

// @ConfigurationProperties 어노테이션은 .properties 파일 내 구성된 프로퍼티값을 가져와 사용할 수 있도록 해줍니다.
// 인수 "kr.or.ddit.jwt"로 시작하는 프로퍼티의 값을 가져와 해당 필드와 일치하는 항목에 값을 매핑시켜준다.
@Data
@Component
@ConfigurationProperties("kr.or.ddit.jwt")	// 자바 클래스에 프로퍼티값을 가져와서 사용하는 어노테이션
public class JwtProperties {
	// 제공자 (kr.or.ddit.jwt.issuer > issuer)
	private String issuer;
	// 시크릿 키 (kr.or.ddit.jwt.secret_key > secretKey)
	private String secretKey;
}
