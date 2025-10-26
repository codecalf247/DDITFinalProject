package kr.or.ddit.employee.main.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.employee.main.service.ICommuteService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main")
public class CommuteController {

	@Autowired
	private ICommuteService commuteService;
	
	@ResponseBody
	@PostMapping("/startWork")
	public ResponseEntity<WorkRcordVO> startWork(@AuthenticationPrincipal CustomUser user){
		
		String empNo = user.getUsername();
		
		WorkRcordVO workRecord = commuteService.startWork(empNo);
		
		if(workRecord == null) {
			return new ResponseEntity<WorkRcordVO>(workRecord, HttpStatus.BAD_REQUEST);
		}else {
			return new ResponseEntity<WorkRcordVO>(workRecord, HttpStatus.OK);
		}
		
	}
	
	@ResponseBody
	@PostMapping("/endWork")
	public ResponseEntity<Map<String, Object>> endWork(@AuthenticationPrincipal CustomUser user){
		Map<String, Object> result = new HashMap<>();
		String empNo = user.getUsername();
		
		result = commuteService.endWork(empNo);
		
		if(result.get("record") == null) {
			return new ResponseEntity<Map<String, Object>>(result, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
		
	}
}
