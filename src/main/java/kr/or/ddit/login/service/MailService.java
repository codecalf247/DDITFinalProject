package kr.or.ddit.login.service;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class MailService {

	private final JavaMailSender mailSender;
	
	public MailService (JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}
	
	public void sendSimpleMail(String to,String password) {
		try {
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			
			helper.setTo(to);
			
			helper.setSubject("그룹웨어 임시 비밀번호 발송해드립니다.");
			
			helper.setFrom("kickgm@naver.com");
			
			
            // HTML 형식의 메일 본문 작성
            // %s → 나중에 String.format 또는 .formatted()로 비밀번호 삽입
            String html = """
                <html>
                <head>
                  <meta charset="UTF-8">
                  <style>
                    body { font-family: Arial, sans-serif; }
                    .card { border:1px solid #ddd; border-radius:8px; padding:20px; max-width:500px; margin:0 auto; }
                    .title { font-size:20px; font-weight:bold; margin-bottom:16px; }
                    .password { font-size:22px; font-weight:bold; color:#0066ff; margin:16px 0; }
                    .info { font-size:14px; color:#666; }
                  </style>
                </head>
                <body>
                  <div class="card">
                    <div class="title">임시 비밀번호 발급 안내</div>
                    <p>안녕하세요. 요청하신 임시 비밀번호를 아래와 같이 안내드립니다.</p>
                    <p class="password">%s</p>
                    <p class="info">로그인 후 반드시 [비밀번호 변경] 메뉴에서 새로운 비밀번호로 수정해주세요.</p>
                  </div>
                </body>
                </html>
            """.formatted(password); // %s 자리에 tempPassword 삽입

            // HTML 형식으로 메일 내용 설정
            helper.setText(html, true); // true = HTML 형식

            // 메일 전송
            mailSender.send(message);
			
		} catch (Exception e) {
			// TODO: handle exception
			throw new RuntimeException("메일 전송 실패", e);
		}
	}

	
	public void sendJoinMail(String to,String id,String password) {
		try {
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			
			helper.setTo(to);
			
			helper.setSubject("Groovior 입사를 축하드립니다.");
			
			helper.setFrom("kickgm@naver.com");
			
			
            // HTML 형식의 메일 본문 작성
            // %s → 나중에 String.format 또는 .formatted()로 비밀번호 삽입
			String html = """
					<!DOCTYPE html>
					<html lang="ko">
					<head>
					  <meta charset="UTF-8" />
					</head>
					<body>
					  <h2>회사 입사를 환영합니다 🎉</h2>
					  <p>
					    사원번호 : <strong>%s</strong><br/>
					    임시 비밀번호 : <strong>%s</strong>
					  </p>
					  <p style="color:red;">비밀번호는 로그인 후 즉시 변경 바랍니다.</p>
					</body>
					</html>
					""".formatted(id, password);

            // HTML 형식으로 메일 내용 설정
            helper.setText(html, true); // true = HTML 형식

            // 메일 전송
            mailSender.send(message);
			
		} catch (Exception e) {
			// TODO: handle exception
			throw new RuntimeException("메일 전송 실패", e);
		}
	}
	
	
}
