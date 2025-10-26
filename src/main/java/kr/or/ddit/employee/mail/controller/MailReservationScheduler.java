package kr.or.ddit.employee.mail.controller;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import kr.or.ddit.employee.mail.service.IMailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class MailReservationScheduler {

    private final IMailService mailService;

    // 5분마다 예약건 처리
    @Scheduled(cron = "0 */5 * * * *", zone = "Asia/Seoul")
    public void dispatchReservedEmails() {
        int processed = mailService.reservedEmails(200);
        if (processed > 0) {
            log.info("[예약발송] 처리 건수: {}", processed);
        }
    }
}