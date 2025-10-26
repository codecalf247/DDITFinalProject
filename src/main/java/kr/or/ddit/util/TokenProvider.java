package kr.or.ddit.util;

import java.time.Duration;
import java.util.Date;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.or.ddit.security.CustomUserDetailsService;
import kr.or.ddit.vo.BlogMemberVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

// TokenProvider 객체는 JWT 토큰을 생성하고 생성된 토큰을 검증, 인증 객체 생성 등 JWT 기능을 활용할 수 있는 Provider 객체입니다.
@Slf4j
@Component
public class TokenProvider {

	// application.properties에 설정된 issuer와 secretKey를 활용할 수 있도록 Properties 객체 선언
	@Autowired
	private JwtProperties jwtProperties;
	
	// 인증 객체를 생성 하기 위한 UserDetailsService 객체 선언
	@Autowired
	private CustomUserDetailsService userDetailsService;
	
	public String generateToken(BlogMemberVO memberVO, Duration expiredAt) {
		Date now = new Date();
		// 토큰 생성 시, 현재 시간 + 설정 시간을 더한 기간으로 토큰을 생성한다.
		return makeToken(new Date(now.getTime() + expiredAt.toMillis()), memberVO);
	}

	/*
	 * 1. JWT 토큰 생성 메소드
	 * - 토큰을 생성하는 메소드
	 * - 인자는 만료시간, 유저 정보를 받는다.
	 * - 해당 메소드는 set 계열의 메소드를 통해 여러 값을 지정합니다.
	 * 	 헤더는 typ(타입), 내용은 iss(발급자), iat(발급일시), ext(만료일시), sub(토큰 제목), 클레임에는 유저no,id,auth를 지정한다.
	 *   토큰을 만들 때는 프로퍼티스 파일에 선언해둔 비밀키와 함께 HS256 방식으로 암호화한다.
	 */
	private String makeToken(Date expiration, BlogMemberVO memberVO) {
		Date now = new Date();
		return Jwts.builder()
					.setHeaderParam(Header.TYPE, Header.JWT_TYPE)	// 헤더 설정
					// 공용 payload 설정
					.setIssuer(jwtProperties.getIssuer())
					.setIssuedAt(now)					// 내용 iat : 현재 시간
					.setExpiration(expiration)			// 내용 exp : expiry 멤버 변수 값
					.setSubject(memberVO.getMemId())	// 내용 sub : 유저 사용자 아이디
					// 개인 설정
					.claim("no", memberVO.getMemNo())	// 클레임 no : 유저 No
					.claim("id", memberVO.getMemId())	// 클레임 id : 유저 id
					.claim("auth", memberVO.getAuthList())	// 클레임 auth : 유저 권한
					// 서명 : 비밀키와 함께 해시값을 HS256 방식으로 암호화한다.
					.signWith(SignatureAlgorithm.HS256, jwtProperties.getSecretKey().getBytes())
					.compact();
	}
	
	/*
	 * 2. JWT 토큰 유효성 검증 메소드
	 * - 토큰이 유효한지 검증하는 메소드이다.
	 * - 프로퍼티스 파일에 선언한 비밀키와 함께 토큰 복호화를 진행한다.
	 *   만약 복호화 과정에서 에러가 발생하면 유효하지 않은 토큰이므로 false를 반환하고 아무 에러도 발생하지 않으면 true를 반환한다.
	 */
	public boolean validToken(String token) {
		Jws<Claims> parseToken = null;
		try {
			parseToken = Jwts.parser().setSigningKey(jwtProperties.getSecretKey().getBytes())
					.parseClaimsJws(token);
		}catch(Exception e) {
			return false;
		}
		
		log.info("# 토큰 만료 기간 : " + parseToken.getBody().getExpiration());
		Date exp = parseToken.getBody().getExpiration();
		
		// 만료기한과 오늘 날짜를 비교한다.
		// 만료기한이 오늘 날짜를 기준으로 전인지를 비교
		// 만료기한이 현재 날짜보다 전이면 만료 (true - > false)
		// 만료기한이 현재 날짜보다 후이면 유효 (false - > true)
		return !exp.before(new Date());
	}
	
	/*
	 * 3. 토큰 기반으로 인증 정보를 가져오는 메소드
	 * - 토큰을 받아 인증 정보를 담은 객체 Authentication을 반환하는 메소드입니다.
	 * - 프로퍼티스 파일에 저장한 비밀값으로 토큰을 복호화한 뒤 클레임을 가져오는 private 메소드인 getClaims()를 호출해서 클레임 정보를
	 *   반환받아 사용자 아이디가 들어있는 토큰 제목 sub와 토큰 기반으로 인증 정보를 생성합니다.
	 *   이때, UsernamePasswordAuthenticationToken의 첫 인자로 들어가는 UserDetails는 스프링 시큐리티에서 제공하는 객체인
	 *   User 클래스를 임포트합니다.
	 */
	public Authentication getAuthentication(String token) {
		String memId = getUserId(token);
		UserDetails userDetails = userDetailsService.loadUserByUsername(memId);
		EmpVO memberVO = ((CustomUser)userDetails).getMember();
		return new UsernamePasswordAuthenticationToken(userDetails, "", 
				memberVO.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuthNm()))
				.collect(Collectors.toList()));
	}

	/*
	 * 4. 토큰 기반으로 유저 id를 가져오는 메소드
	 * - 토큰 기반으로 사용자 id를 가져오는 메소드입니다.
	 * - 프로퍼티스 파일에 저장한 비밀키로 토큰을 복호화한 다음 클레임을 가져오는 private 메소드인 getClaims()를 호출해서 클레임 정보를
	 *   반환하고 클레임에서 id 키로 저장된 값을 가져와 반환합니다.
	 */
	private String getUserId(String token) {
		Claims claims = getClaims(token);
		return claims.get("id", String.class);
	}

	private Claims getClaims(String token) {
		return Jwts.parser()
					.setSigningKey(jwtProperties.getSecretKey().getBytes())
					.parseClaimsJws(token)
					.getBody();
	}
	
}












