package kr.or.ddit.manager.deptManagement.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.manager.deptManagement.service.IDeptService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.DeptVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("dept")
public class DeptController {

	@Autowired
	private IDeptService deptService;
	
	// 부서 목록 가져오기
	@GetMapping("deptList")
	public String getDeptList(@AuthenticationPrincipal CustomUser user, Model model){
		log.debug("getDeptList() 실행");
		
		// 부서 목록 가져오기
		List<DeptVO> deptList = deptService.getDeptList();
		// 하위 부서 목록 가져오기
		List<DeptVO> deptSubList = deptService.getDeptSubList();
		// 상위 부서 정보 가져오기
		List<DeptVO> upperDeptList = deptService.getUpperDeptList();
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("deptSubList", deptSubList);
		model.addAttribute("upperDeptList", upperDeptList);
		
		return "dept/deptList";
	}
	
	// 부서별 팀원 목록 가져오기
	@ResponseBody
	@GetMapping("deptEmpList")
	public ResponseEntity<List<DeptVO>> getDeptEmpList(DeptVO dept){
		log.debug("getDeptEmpList() 실행, dept : {}", dept);
		
		List<DeptVO> deptEmpInfo = deptService.getDeptEmpList(dept);
		
		return new ResponseEntity<List<DeptVO>>(deptEmpInfo, HttpStatus.OK);
	}
	
	// 부서별 하위 팀원 목록 가져오기
	@ResponseBody
	@GetMapping("deptTeamEmpList")
	public ResponseEntity<List<DeptVO>> getDeptTeamEmpList(DeptVO dept){
		log.debug("getDeptTeamEmpList() 실행, dept : {}", dept);
		
		List<DeptVO> deptTeamEmpInfo = deptService.getDeptTeamEmpList(dept);
		
		return new ResponseEntity<List<DeptVO>>(deptTeamEmpInfo, HttpStatus.OK);
	}
	
	// 사원 부서 이동
	@ResponseBody
	@PostMapping("empDeptMove")
	public ResponseEntity<String> empDeptMove(@RequestBody DeptVO dept){
		log.debug("empDeptMove() 실행, dept : {}", dept);
		
		int status = deptService.empDeptMove(dept);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 부서 수정
	@ResponseBody
	@PostMapping("mdfDept")
	public ResponseEntity<String> mdfDept(@RequestBody DeptVO dept) {
		log.debug("mdfDept() 실행, dept : {}", dept);
		
		int status = deptService.mdfDept(dept);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 부서 삭제
	@ResponseBody
	@PostMapping("delDept")
	public ResponseEntity<String> delDept(@RequestBody DeptVO dept) {
		log.debug("delDept() 실행, dept : {}", dept);
		
		int status = deptService.delDept(dept);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 부서 등록
	@ResponseBody
	@PostMapping("insertDept")
	public ResponseEntity<String> insertDept(@RequestBody DeptVO dept) {
		log.debug("insertDept() 실행, dept : {}", dept);
		
		int status = deptService.insertDept(dept);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 부서 jstree
	@ResponseBody
	@GetMapping("upperDeptTreeList")
	public ResponseEntity<List<DeptVO>> getUpperDeptTreeList(){
		log.debug("getUpperDeptList() 실행");
		List<DeptVO> deptList = deptService.getUpperDeptTreeList();
		return new ResponseEntity<List<DeptVO>>(deptList, HttpStatus.OK);
	}
}
