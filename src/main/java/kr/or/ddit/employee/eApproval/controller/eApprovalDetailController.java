package kr.or.ddit.employee.eApproval.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/eApprovalDetail")
public class eApprovalDetailController {
	
	@GetMapping("register")
	public String approvalRegisterForm(){
		log.info("approvalWriteForm() 실행");
		return "eApproval/register";
	}
	
}
 