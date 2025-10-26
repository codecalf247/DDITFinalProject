package kr.or.ddit.employee.attendance.controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.employee.attendance.service.IAttendanceService;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class AttendanceScheduler {
	
    @Autowired
    private IAttendanceService attendacneService;

    @Scheduled(cron = "0 0 19 * * *")
    public void runDailyAtMidnight() {	// 매일 19시 00분
        
    	LocalDate yesterday = LocalDate.now().minusDays(1);
    	String formatDay	= yesterday.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
    	
        // 주말(토,일) 제외
        DayOfWeek dayOfWeek = yesterday.getDayOfWeek();
	    if (dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY) {
	        log.debug("runDailyAtMidnight: {} 는 주말이므로 작업을 건너뜀", formatDay);
	        return;
	    }
    	
    	// 1. 입사일 기준으로 연차 관리 하는데 연차 없는 사람들만 연차 넣기 (왜냐하면 입사하면 바로 입력됨)
    	int yearVacationCount = attendacneService.manageYearVacation(formatDay);
    	
    	log.debug("runDailyAtMidnight.manageYearVacation : {} 명", yearVacationCount);
    	
    	// 2. 근태 관리 (출근은 찍었는데 퇴근은 안 찍은 사람 및 출근 조차 안 찍은 사람 들의 이력 및 기록을 삽입)
    	int attendanceCount = attendacneService.manageAttendance(formatDay);
    	
    	log.debug("runDailyAtMidnight.manageAttendance : {} 명", attendanceCount);
    	
    }
    
//    @Scheduled(cron = "*/30 * * * * *")
//    public void testSchedule() {	// 매일 00시 00분
//        
//    	LocalDate yesterday = LocalDate.now().minusDays(1);
//    	String formatDay	= yesterday.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
//    	
//    	// 1. 입사일 기준으로 연차 관리 하는데 연차 없는 사람들만 연차 넣기 (왜냐하면 입사하면 바로 입력됨)
//    	int yearVacationCount = attendacneService.manageYearVacation(formatDay);
//    	
//    	log.debug("runDailyAtMidnight.manageYearVacation : {} 명", yearVacationCount);
//    	
//    	// 2. 근태 관리 (출근은 찍었는데 퇴근은 안 찍은 사람 및 출근 조차 안 찍은 사람 들의 이력 및 기록을 삽입)
//    	int attendanceCount = attendacneService.manageAttendance(formatDay);
//    	
//    	log.debug("runDailyAtMidnight.manageAttendance : {} 명", attendanceCount);
//    	
//    }
    
}