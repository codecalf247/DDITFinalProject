package kr.or.ddit.employee.organizeChart.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.employee.organizeChart.service.IOrgChartService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("orgChart")
public class OrgChartController {

	@Autowired
	private IOrgChartService chartService;
	
	// 조직도에서 선택된 사원정보 가져오기
	@ResponseBody
	@GetMapping("orgEmpInfo")
	public ResponseEntity<EmpVO> getOrgEmpInfo(@RequestParam String empNo, Model model){
		log.debug("getOrgEmpInfo() 실행!! empNo : {}", empNo);
		
		EmpVO empInfo = chartService.getOrgEmpInfo(empNo);
		
		return new ResponseEntity<EmpVO>(empInfo, HttpStatus.OK);
	}
	
}
