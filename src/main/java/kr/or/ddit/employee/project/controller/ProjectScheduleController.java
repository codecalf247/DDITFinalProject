package kr.or.ddit.employee.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.service.IProjectScheduleService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.SchdulVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project/schedule")
public class ProjectScheduleController {


	@Autowired
	private IProjectScheduleService psService;
	
	
	
	// 일정 조회 (AJAX) 
	@GetMapping("/list")
	@ResponseBody
	public ResponseEntity<List<SchdulVO>> getSchedules(@RequestParam("prjctNo") int prjctNo ){
		
		List<SchdulVO> schedules = psService.getProjectSchedules(prjctNo);
		
		return new ResponseEntity<>(schedules, HttpStatus.OK);
		
	}
	
	

	// 일정 등록 (AJAX) 
	@PostMapping("/create")
	@ResponseBody
	public ResponseEntity<String> createSchedule(@RequestBody SchdulVO schedule, @AuthenticationPrincipal CustomUser customUser){
		// 로그인한 사용자 정보가 유효한지 확인
        if (customUser == null || customUser.getMember() == null || customUser.getMember().getEmpNo() == null) {
           
        	log.info("로그인한 사용자 정보를 가져올 수 없습니다. empNo가 누락되었습니다.");
            
        	return new ResponseEntity<>("로그인 정보가 유효하지 않습니다.", HttpStatus.UNAUTHORIZED); 
        }
        
        // 로그인한 사용자 정보 (empNo)를 VO에 설정
        String empNo = customUser.getMember().getEmpNo();
        schedule.setEmpNo(empNo);
        
        ServiceResult result = psService.createSchedule(schedule);

        if (result.equals(ServiceResult.OK)) {
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("FAILED", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

	
	// 일정 상세 조회 
	@GetMapping("/detail")
	@ResponseBody
	public ResponseEntity<SchdulVO> getScheduleDetail(@RequestParam("schdulNo") int schdulNo){
		SchdulVO schedule = psService.getScheduleDetail(schdulNo);
		if(schedule != null) {
			return new ResponseEntity<>(schedule, HttpStatus.OK);
		}else {
			return new ResponseEntity<>(schedule, HttpStatus.NOT_FOUND);
		}
	}
	
	
	
	
	// 일정 수정 (AJAX)
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<String> updateSchedule(@RequestBody SchdulVO schedule) {
        ServiceResult result = psService.updateSchedule(schedule);

        if (result.equals(ServiceResult.OK)) {
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("FAILED", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    
    
    
    
    // 일정 삭제 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteSchedule(@RequestBody Map<String, Integer> param) {
        int schdulNo = param.get("schdulNo");
        ServiceResult result = psService.deleteSchedule(schdulNo);

        if (result.equals(ServiceResult.OK)) {
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("FAILED", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
}
	
	

