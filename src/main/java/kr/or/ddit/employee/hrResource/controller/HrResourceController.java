package kr.or.ddit.employee.hrResource.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.hrResource.service.IHrService;
import kr.or.ddit.login.service.IEmpLoginService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/hr")
public class HrResourceController {
	
	@Autowired
	private IHrService service;
	
	@Autowired
	private PasswordEncoder pe;

	@GetMapping("/myhr")
	public String myHr(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		CustomUser user = (CustomUser) authentication.getPrincipal();
		EmpVO empUser = service.getMyInfo(user.getMember().getEmpNo()); 
		model.addAttribute("empMem", empUser);
		
		return "hr/myhr";
	}
	
	
	@PostMapping("/passwordVerify")
	public ResponseEntity<ServiceResult> checkPassword(@RequestBody Map<String, String> inputPassword
			,@AuthenticationPrincipal CustomUser user
			){
		ServiceResult result = null;
		String inputVal = inputPassword.get("inputPassword");
		String empNo = user.getMember().getEmpNo();
		String currentPassword =  service.checkPassword(empNo);
		log.info(currentPassword);
	    log.info("inputPassword : " + inputVal);
	    log.info("currentPassword : " + currentPassword);
	    if (currentPassword == null || !pe.matches(inputVal, currentPassword)) {
	        result = ServiceResult.NOTEXIST;
	      }else {
	    	  result = ServiceResult.OK;
	      }

	    return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
		
	}
	
	@PostMapping("/chagnePassword")
	public ResponseEntity<ServiceResult> changePassword(@RequestBody Map<String, String> newPassword,
			@AuthenticationPrincipal CustomUser user){
		EmpVO emp = user.getMember();
		String newPWD =  newPassword.get("newPassword");
		emp.setPassword(pe.encode(newPWD));
		int cnt = service.changePw(emp);
		ServiceResult result = null;
		if(cnt > 0) {
			//emailSend(password,empVO.getEmail().toString());
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);

	}
	
	@PostMapping("/infoChange")
	public ResponseEntity<ServiceResult> changeInfo(@RequestBody EmpVO emp,@AuthenticationPrincipal CustomUser user){
		emp.setEmpNo(user.getMember().getEmpNo());
		ServiceResult result = null;
		
		result =  service.changeInfo(emp);
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
}
