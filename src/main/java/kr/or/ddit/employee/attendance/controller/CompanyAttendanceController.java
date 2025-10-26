package kr.or.ddit.employee.attendance.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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

import kr.or.ddit.employee.attendance.service.IAttendanceService;
import kr.or.ddit.employee.cmmn.service.ICMMNService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.attendance.CompanyAnalyticsVO;
import kr.or.ddit.vo.attendance.CompanyYrycSttusVO;
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistVO;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/attendance")
public class CompanyAttendanceController {

	@Autowired
	private ICMMNService cmmnService;

	@Autowired
	private IAttendanceService attendanceService;

	@GetMapping("/companyAttd")
	@PreAuthorize("hasRole('ROLE_MANAGER')") // ROLE_MANAGER 권한만 허용
	public String companyAttd(@AuthenticationPrincipal CustomUser user, Model model) {

		PaginationAttdInfoVO<WorkRcordVO> pagingVO = new PaginationAttdInfoVO<>();

		pagingVO.setCurrentPage(1);

		// 로그인한 사원 정보
		EmpVO empVO = user.getMember();

		// 현재 날짜
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		pagingVO.setStartDay(formatDay);
		pagingVO.setEndDay(formatDay);

		int headCount = attendanceService.getHeadCount(pagingVO);
		List<WorkRcordVO> companyWorkRecordList = attendanceService.getCompanyWorkRecord(pagingVO);
		pagingVO.setDataList(companyWorkRecordList);
		
		List<DeptVO> deptList = attendanceService.getDeptList();
		List<CommonCodeVO> statusList = cmmnService.getCMMNListbyGroupId("01");

		// model에 담아서 전송
		model.addAttribute("empVO", empVO); // 사원정보
		model.addAttribute("activeMenu", "companyAttd"); // 근태메뉴
		model.addAttribute("headCount", headCount); // 사원수
		model.addAttribute("pagingVO", pagingVO); // 근태기록
		model.addAttribute("startDay", today); // 시작일
		model.addAttribute("endDay", today); // 종료일
		model.addAttribute("deptList", deptList); // 부서목록
		model.addAttribute("statusList", statusList); // 상태목록

		return "attendance/companyAttd";
	}

	@PostMapping("/changeCompanyAttend")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> changeCompanyAttend(PaginationAttdInfoVO<WorkRcordVO> pagingVO) {
		Map<String, Object> result = new HashMap<>();

		result = attendanceService.getChangeCompanyAttend(pagingVO);

		log.info(result.toString());

		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
	}

	@ResponseBody
	@PostMapping("/getCompanyAttendanceExcelData")
	public ResponseEntity<List<WorkRcordVO>> getCompanyAttendanceExcelData(
			@RequestBody PaginationAttdInfoVO<WorkHistVO> pagingVO) {
		List<WorkRcordVO> workList = null;

		workList = attendanceService.getCompanyAttendanceExcelData(pagingVO);

		return new ResponseEntity<List<WorkRcordVO>>(workList, HttpStatus.OK);
	}

	@PreAuthorize("hasRole('ROLE_MANAGER')") // ROLE_MANAGER 권한만 허용
	@GetMapping("/companyAttdAnalytics")
	public String companyAttdAnalytics(@AuthenticationPrincipal CustomUser user, Model model) {

		EmpVO empVO = user.getMember();
		Map<String, Object> param = new HashMap<>();
		
		// 현재 날짜
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		param.put("baseDay", formatDay);
		param.put("range", "month");
		
		// model에 담아서 전송
		model.addAttribute("empVO", empVO); 					 // 사원정보
		model.addAttribute("activeMenu", "companyAttdAnalytics");// 근태메뉴

		return "attendance/companyAttdAnalytics";
	}
	
	@ResponseBody
	@PostMapping("/companyDeptAnalytics")
	public ResponseEntity<List<CompanyAnalyticsVO>> companyDeptAnalytics(@RequestBody Map<String, String> body){
		
		Map<String, Object> param = new HashMap<>();
		
		// 현재 날짜
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		param.put("baseDay", formatDay);
		param.put("range", body.get("range"));
		
		List<CompanyAnalyticsVO> analyticsList = attendanceService.companyDeptAnalytics(param);
		
		return new ResponseEntity<List<CompanyAnalyticsVO>>(analyticsList, HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/companyWorkTypeAnalytics")
	public ResponseEntity<List<CompanyAnalyticsVO>> companyWorkTypeAnalytics(@RequestBody Map<String, String> body){
		
		Map<String, Object> param = new HashMap<>();
		
		// 현재 날짜
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		param.put("baseDay", formatDay);
		param.put("range", body.get("range"));
		
		List<CompanyAnalyticsVO> analyticsList = attendanceService.companyWorkTypeAnalytics(param);
		
		return new ResponseEntity<List<CompanyAnalyticsVO>>(analyticsList, HttpStatus.OK);
	}

	@PreAuthorize("hasRole('ROLE_MANAGER')") // ROLE_MANAGER 권한만 허용
	@GetMapping("/companyYearVacation")
	public String companyYearVacation(@AuthenticationPrincipal CustomUser user, Model model) {
		
		EmpVO empVO = user.getMember();
		Map<String, Object> result = new HashMap<>();
		
		PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO = new PaginationAttdInfoVO<>();
		
		LocalDate today = LocalDate.now();
		
		int year = today.getYear();
        LocalDate startDay = LocalDate.of(year, 1, 1);
        LocalDate endDay = LocalDate.of(year, 12, 31);
        
		pagingVO.setStartDay(startDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setEndDay(endDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setYear(year);
		pagingVO.setCurrentPage(1);
		
		List<DeptVO> deptList = attendanceService.getDeptList();
		result = attendanceService.getCompanyVacation(pagingVO);
		
		log.info("====================== {}", result.toString());
		log.info("여기", result.toString());
		
		// model에 담아서 전송
		model.addAttribute("empVO", empVO); 					 // 사원정보
		model.addAttribute("year", year); 					 	 // 기준년도
		model.addAttribute("activeMenu", "companyYearVacation"); // 근태메뉴
		model.addAttribute("deptList", deptList); 				 // 부서목록
		model.addAttribute("result", result); 					 // 결과
		
		return "attendance/companyYearVacation";
	}
	
	@ResponseBody
	@PostMapping("/changeCompanyVacation")
	public ResponseEntity<Map<String, Object>> changeCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<>();
		
		result = attendanceService.changeCompanyVacation(pagingVO);
		
		return new ResponseEntity<Map<String,Object>>(result, HttpStatus.OK);
	}
	
	@PostMapping("/getCompanyVacationByEmp")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getCompanyVacationByEmp(
			@RequestBody Map<String, Object> param){
		
		Map<String, Object> result = new HashMap<>();
		
		param.put("offset", 0);
		
		result = attendanceService.getVacationRangeData(param);
		
		return new ResponseEntity<Map<String,Object>>(result, HttpStatus.OK);
 	}
}
	
