package kr.or.ddit.manager.hrManagement.controller;

import java.text.DateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.manager.hrManagement.service.IHrManagementService;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/hr")
@PreAuthorize("hasRole('ROLE_MANAGER')")
public class HrManagement {

	@Autowired
	private IHrManagementService service;
	
	@GetMapping("/hrList")
	public String hrList(
			@RequestParam(required = false, defaultValue = "active") String status
			,@RequestParam(required=false) String searchWord
			,@RequestParam(name="page",required = false,defaultValue = "1")int currentPage
			,Model model) {
		
		PaginationInfoVO<EmpVO> pagingVO = new PaginationInfoVO<>();
		
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchWord", searchWord);
		}
		log.info("currentPage" + currentPage);
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setSearchType(status);
		int totalRecord = service.selectEmpCount(pagingVO);
		
		pagingVO.setTotalRecord(totalRecord);
		List<EmpVO> empList = service.selectAllEmp(pagingVO);
		pagingVO.setDataList(empList);
		
		List<DeptVO> dept = service.selectalldept();
		model.addAttribute("dept", dept);
		model.addAttribute("pagingVO", pagingVO);
		return "hr/hrList";
	}
	
	
	@PostMapping("/hrinsert")
	public ResponseEntity<ServiceResult> hrinsert(EmpVO emp){
		
		int cnt = service.insert(emp);
		return new ResponseEntity<ServiceResult>(ServiceResult.OK,HttpStatus.OK);
	}
	
	
	@GetMapping("/hrmodify")
	@ResponseBody
	public ResponseEntity<EmpVO> hrmodify(String empNo){
		
		EmpVO emp = service.selectOne(empNo);
		
		return new ResponseEntity<EmpVO>(emp,HttpStatus.OK);
	}

	@PostMapping("/hrupdate")
	@ResponseBody
	public ResponseEntity<ServiceResult> hrUpdate(EmpVO empvo){
		ServiceResult result = null;
		int cnt = service.update(empvo);
		if(cnt > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	@PostMapping("/leave")
	public ResponseEntity<ServiceResult> hrDelete(@RequestBody EmpVO empvo){
		ServiceResult result = null;
		int cnt = service.delete(empvo);
		if(cnt > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	@PostMapping("/reactivate")
	public ResponseEntity<ServiceResult> hrReactivate(@RequestBody EmpVO empvo){
		ServiceResult result = null;
		int cnt = service.reactivate(empvo);
		if(cnt > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
		
	}
	
}
