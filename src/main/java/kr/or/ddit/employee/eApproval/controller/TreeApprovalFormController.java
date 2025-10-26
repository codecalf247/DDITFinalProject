package kr.or.ddit.employee.eApproval.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.employee.eApproval.service.ITreeApprovalFormService;
import kr.or.ddit.vo.ApprovalFormVO;
import kr.or.ddit.vo.DeptVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/eApprovalTree")
public class TreeApprovalFormController {

	@Autowired
	private ITreeApprovalFormService service;

	@ResponseBody
	@GetMapping("/documentList")
	public List<ApprovalFormVO> getDocumentList() {
		log.info("getDocumentList() 실행!");
		List<ApprovalFormVO> documentList = service.getDocumentList();
		return documentList;
	}
	
	@ResponseBody
	@GetMapping("/documentDC")
	public String getDocumentDC(@RequestParam int formNo) {
		log.info("getDocumentDC() 실행! formNo={}", formNo);
		String formDC = service.getDocumentDC(formNo);
		return formDC;
	}
	
	@ResponseBody
	@GetMapping("/approvalLine")
	public List<DeptVO> getApprovalLine(){
		log.info("getApprovalLine() 실행!");
		List<DeptVO> approvalLine = service.getApprovalLine();
		return approvalLine;
	}
	
	
}
