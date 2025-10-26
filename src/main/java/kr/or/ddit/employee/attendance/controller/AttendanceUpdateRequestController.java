package kr.or.ddit.employee.attendance.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
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
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistMdfncRequstVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/attendance")
public class AttendanceUpdateRequestController {
	
	@Autowired
	private IAttendanceService attendanceService;
	
	@Autowired
	private ICMMNService cmmnService;
	
	@GetMapping("/attdUpdateReq")
	public String attdUpdateReq(@AuthenticationPrincipal CustomUser user, Model model,
			  @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			  @RequestParam(required = false) String empNm,
			  @RequestParam(required = false) String status,
			  @RequestParam(required = false) Integer deptNo
			) {
		
		PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO = new PaginationAttdInfoVO<>();
		
		// 사용자 정보 가져오기
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername();
		Map<String, Object> result = new HashMap<>();
		pagingVO.setCurrentPage(currentPage);
		
		// 관리자 권한을 가졌을 때
		if (user.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_MANAGER"))) {
			
			pagingVO.setEmpNm(empNm);
			pagingVO.setStatus(status);
			pagingVO.setDeptNo(deptNo);
			
			result = attendanceService.getAllEmpRequestList(pagingVO);
			
		}else {	// 일반 사원일 때
			
			pagingVO.setEmpNo(empNo);
			result = attendanceService.getEmpRequestList(pagingVO);
		}
		
		List<DeptVO> deptList = attendanceService.getDeptList();
		List<CommonCodeVO> statusList = cmmnService.getCMMNListbyGroupId("22");

		// model에 담아서 전송
		model.addAttribute("empVO", empVO);					// 사원정보
		model.addAttribute("activeMenu","attdUpdateReq");	// 근태메뉴
		model.addAttribute("pagingVO", pagingVO);			// 페이징 처리
		model.addAttribute("countRequestVO", result.get("countRequestVO"));		// 수치 데이터
		model.addAttribute("requestList", result.get("requestList"));			// 요청 리스트
		model.addAttribute("searchedEmpNm", empNm);			// 검색이름
		model.addAttribute("searchedStatus", status);		// 검색상태
		model.addAttribute("searchedDeptNo", deptNo);		// 검색부서번호
		model.addAttribute("deptList", deptList); 			// 부서목록
		model.addAttribute("statusList", statusList); 		// 상태목록
		
		return "attendance/attdUpdateReq";
	}
	
	@PostMapping("/getRequestDetail")
	@ResponseBody
	public ResponseEntity<WorkHistMdfncRequstVO> getRequestDetail(@RequestBody Map<String, Object> param) {
	    int requestNo = Integer.parseInt(param.get("requestNo").toString());

	    WorkHistMdfncRequstVO requestVO = attendanceService.getRequestDetail(requestNo);

	    return new ResponseEntity<>(requestVO, HttpStatus.OK);
	}
	
	@PostMapping("/updateRequestStatus")
	@ResponseBody
	public ResponseEntity<String> updateRequestStatus(@RequestBody Map<String, Object> param){
		
		ServiceResult result = attendanceService.updateRequestStatus(param);
		
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	
	}
	
}
