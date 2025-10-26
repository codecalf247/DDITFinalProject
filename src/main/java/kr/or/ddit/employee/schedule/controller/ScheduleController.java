package kr.or.ddit.employee.schedule.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.main.service.IWidgetService;
import kr.or.ddit.employee.schedule.service.IScheduleService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpAuthVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SchdulVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/schedule")
public class ScheduleController {

	@Autowired
	private IWidgetService widgetService;
	@Autowired
	private IScheduleService schservice;
	
	@GetMapping("/list")
	public String scheduleList() {
		return "schedule/list";
	}
	
	@GetMapping("/getData")
	public ResponseEntity<List<SchdulVO>> scheduleData(@AuthenticationPrincipal CustomUser user){
		EmpVO empVO = user.getMember();
		
		List<SchdulVO> schdulList = widgetService.getSchdulWidget(empVO);
		return new ResponseEntity<List<SchdulVO>>(schdulList,HttpStatus.OK);
	}
	
	@PostMapping("/register")
	public ResponseEntity<ServiceResult> scheduleRegister(@RequestBody SchdulVO svo,@AuthenticationPrincipal CustomUser user){
		svo.setEmpNo(user.getMember().getEmpNo());
		svo.setDeptNo(user.getMember().getDeptNo());
		int cnt = schservice.insertSchedule(svo);
		
		ServiceResult result = null;
		if(cnt > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	@PostMapping("/delete/{id}")
	public ResponseEntity<ServiceResult> scheduleDelete(@PathVariable int id,@AuthenticationPrincipal CustomUser user){
		EmpVO empVO = user.getMember();
		List<EmpAuthVO> empauth =  empVO.getAuthList();
		boolean admin = false;
		boolean member = false;
		for(EmpAuthVO ea : empauth) {
			if(ea.getAuthNm().equals("ROLE_MANAGER")) {
				admin = true;
			}else {
				member = true;
			}
		}
		SchdulVO schVO = schservice.getSchedule(id);
		String ty = schVO.getSchdulTy();
		ServiceResult result = null;
		if("11001".equals(ty)) {
			result = schservice.deleteSchedule(id);
		}else if("11002".equals(ty)) {
			result = schservice.deleteSchedule(id);
		}else if("11003".equals(ty) && admin == true){
			result = schservice.deleteSchedule(id);
		}else {
			result = ServiceResult.FAILED;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
}
