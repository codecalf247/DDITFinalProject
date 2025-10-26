package kr.or.ddit.employee.attendance.controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.MonthDay;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.attendance.service.IAttendanceService;
import kr.or.ddit.employee.cmmn.service.ICMMNService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.attendance.CompanyAttendSearchVO;
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistMdfncRequstVO;
import kr.or.ddit.vo.attendance.WorkHistVO;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import kr.or.ddit.vo.attendance.YrycSttusVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/attendance")
public class AttendanceController {
	
	@Autowired
	private ICMMNService cmmnService;
	
	@Autowired
	private IAttendanceService attendanceService;
	
	// 근태 메인 페이지 
	@GetMapping
	public String myattd(@AuthenticationPrincipal CustomUser user,  Model model) {
		
		Map<String, Object> param = new HashMap<>();
		
		// 사용자 정보 가져오기
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername();
		
		// 현재 날짜
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		// 화면용 날짜 (월 ~ 일)
	    LocalDate monday = today.with(DayOfWeek.MONDAY);
	    LocalDate sunday = monday.plusDays(6);
		
		param.put("empNo", empNo);
		param.put("formatDay", formatDay);
		
		List<WorkRcordVO> workRecordList = attendanceService.getWeeklyWorkRecord(param);
		
		// model에 담아서 전송
		model.addAttribute("empVO", empVO);						// 사원정보
		model.addAttribute("activeMenu","attendance");			// 근태메뉴
		model.addAttribute("workRecordList", workRecordList);	// 근태기록
		model.addAttribute("monday", monday);					// 월요일 날짜
		model.addAttribute("sunday", sunday);					// 일요일 날짜
		return "attendance/attendance";
	}
	
	// 근태 이력 페이지
	@GetMapping("/history")
	public String attdHistory(@AuthenticationPrincipal CustomUser user, 
							  @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
							  @RequestParam(required = false, defaultValue = "all") String searchType,
							  @RequestParam(required = false) LocalDate startDay,
							  @RequestParam(required = false) LocalDate endDay,
							  Model model) {
		
	    if (startDay == null) {
	    	startDay = LocalDate.now().minusMonths(1);
	    }
	    
	    if (endDay == null) {
	    	endDay = LocalDate.now();
	    }
		
		PaginationAttdInfoVO<WorkHistVO> pagingVO = new PaginationAttdInfoVO<>();
		
		// 사용자 정보 가져오기
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername();
		
		// 현재 페이지 전달 후, start/endRow, start/endPage 설정
		log.info("페이지 넣기 전 pagingVO");
		log.info(pagingVO.toString());
		pagingVO.setCurrentPage(currentPage);
		log.info("페이지 넣은 후 pagingVO");
		log.info(pagingVO.toString());
		
		
		pagingVO.setEmpNo(empNo);
		pagingVO.setSearchType(searchType);
		pagingVO.setStartDay(startDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setEndDay(endDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		
		List<WorkHistVO> workHistList = attendanceService.getRangeWorkHistory(pagingVO);
		pagingVO.setDataList(workHistList);
		
		log.info(pagingVO.toString());
		
		// model에 담아서 전송
		model.addAttribute("empVO", empVO);					// 사원정보
		model.addAttribute("activeMenu","history");			// 근태메뉴
		model.addAttribute("startDay", startDay);			// 시작날짜
		model.addAttribute("endDay", endDay);				// 종료날짜
		model.addAttribute("pagingVO", pagingVO);			// 페이징 처리
		
		return "attendance/attendanceHistory";
	}
	
	@ResponseBody
	@PostMapping("/updateRequest")
	public ResponseEntity<String> updateRequest(@AuthenticationPrincipal CustomUser user, WorkHistMdfncRequstVO requestVO) {
		
		Map<String, Object> param = new HashMap<>();
		String empNo = user.getUsername();
		
		param.put("empNo", empNo);
		param.put("requestVO", requestVO);
		
		ServiceResult result = attendanceService.updateRequest(param);
		
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/getRequest")
	public ResponseEntity<WorkHistMdfncRequstVO> getRequest(@RequestBody WorkHistMdfncRequstVO vo){
		
		WorkHistMdfncRequstVO requestVO = attendanceService.getRequest(vo.getWorkRcordNo());
		
		return new ResponseEntity<WorkHistMdfncRequstVO>(requestVO, HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("/downloadFile")	// 파일 다운로드용 메서드
	public ResponseEntity<byte[]> downloadFile(@RequestParam String fileName) {
		
		ResponseEntity<byte[]> entity = attendanceService.downloadFile(fileName);
		
		return entity;
	}
	
	@ResponseBody
	@PostMapping("/getExcelData")
	public ResponseEntity<List<WorkHistVO>> getExcelData(@AuthenticationPrincipal CustomUser user, @RequestBody PaginationAttdInfoVO<WorkHistVO> pagingVO){
		List<WorkHistVO> workList = null;
		
		pagingVO.setEmpNo(user.getUsername());
		workList = attendanceService.getExcelData(pagingVO);
		
		return new ResponseEntity<List<WorkHistVO>>(workList, HttpStatus.OK);
	}
	
	// 근태 이력 페이지
	
	// 연차 현황 페이지
	@GetMapping("/yearVacation")
	public String attdYearVacation(@AuthenticationPrincipal CustomUser user,  Model model) {
		
		Map<String, Object> param = new HashMap<>();
		
		// 사용자 정보 가져오기
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername();

		// 오늘 날짜
		LocalDate today = LocalDate.now();

		// 입사일자
		String jncmpYmd = empVO.getJncmpYmd();
		LocalDate joinDate = LocalDate.parse(jncmpYmd, DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		// 입사 월/일 추출
		MonthDay joinMonthDay = MonthDay.from(joinDate);
		
		// 올해 기준 입사기념일
		LocalDate thisYearAnniversary = joinMonthDay.atYear(today.getYear());
		
		// 발급연도 결정
		int year;
		if (today.isBefore(thisYearAnniversary)) {
		    // 입사 월일 안 지난 경우 : 작년 연차 이력
		    year = today.getYear() - 1;
		} else {
		    // 입사 월일 지난 경우 : 올해 연차 이력
		    year = today.getYear();
		}
		
		// 다음 발급일
		LocalDate nextVacationDay = 
				today.isBefore(joinDate) ? joinDate : joinMonthDay.atYear(today.getYear() + 1);

		// D-day 계산
		long daysUntil = ChronoUnit.DAYS.between(today, nextVacationDay);
		
		// D-Day 문자열 만들기
		String dDay;
		if (daysUntil == 0) {
		    dDay = "D-365";
		} else {
		    dDay = "D-" + daysUntil;
		}
		
		param.put("empNo", empNo);
		param.put("year", year);
		
		List<YrycSttusVO> vacationList = attendanceService.getVacation(param);
		
		// model에 담아서 전송
		model.addAttribute("empVO", empVO);						// 사원정보
		model.addAttribute("activeMenu","yearVacation");		// 근태메뉴
		model.addAttribute("vacationList", vacationList);		// 근태기록
		model.addAttribute("year", year);						// 기준년도
		model.addAttribute("joinDate", joinDate);				// 입사일자
		model.addAttribute("dDay", dDay);						// 연차 생성 남은 일수
		
		return "attendance/yearVacation";
	}
	
	@GetMapping("/changeVacationRange")
	@ResponseBody
	public Map<String, Object> changeVacationRange(
			@AuthenticationPrincipal CustomUser user,
			@RequestParam int baseyear,
			@RequestParam int offset
			){
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		
		String empNo = user.getUsername();
		
		param.put("offset", offset);
		param.put("year", baseyear);
		param.put("empNo", empNo);
		
		result = attendanceService.getVacationRangeData(param);
		
		return result;
 	}

	@GetMapping("/changeRange")
	@ResponseBody
	public Map<String, Object> changeRange(
			@AuthenticationPrincipal CustomUser user,
			@RequestParam String baseDate,
			@RequestParam int offset,
			@RequestParam String type
			){
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		String empNo = user.getUsername();
		
		param.put("baseDate", baseDate);
		param.put("offset", offset);
		param.put("type", type);
		param.put("empNo", empNo);
		
		result = attendanceService.getRangeData(param);
		
		return result;
 	}

}
