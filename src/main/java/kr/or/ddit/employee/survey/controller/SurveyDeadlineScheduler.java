package kr.or.ddit.employee.survey.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.employee.survey.service.ISurveyService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SurveyDeadlineScheduler {

    @Autowired
    private ISurveyService service;

    /**
     * 매일 자정에 마감된 설문을 처리하는 스케줄러
     * cron = "초 분 시 일 월 요일"
     * "0 0 0 * * *" -> 매일 0시 0분 0초에 실행
     */
    @Scheduled(cron = "* * 1 * * *")
    public void checkSurveyDeadlines() {
        log.info("설문 마감일 스케줄러 실행");
        
        // 서비스 메서드를 호출하여 마감일이 지난 설문을 업데이트
        int updatedCount = service.updateExpiredSurveys();
        
        log.info("{}개의 설문이 마감 처리되었습니다.", updatedCount);
    }
}