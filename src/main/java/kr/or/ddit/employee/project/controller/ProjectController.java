package kr.or.ddit.employee.project.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.service.IProjectPhotosService;
import kr.or.ddit.employee.project.service.IProjectService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectFileVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectPhotosVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectController {

	@Autowired 
	private IProjectService pService;
	
	@Autowired
	private IProjectPhotosService photoService;
	

	
///////////////////////////////////////////////////////////////////////////////////////////////	
//================================= 1. 프로젝트 목록 페이지   =====================================//
///////////////////////////////////////////////////////////////////////////////////////////////	
	
	
	
	// 프로젝트 목록 페이지 호출 + 검색기능 (Pagination)
	@GetMapping("/projectList")
	public String projectList(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name="sttus", required = false, defaultValue = "17002") String prjctSttus,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,Model model) {
		
		log.info("프로젝트 목록 호출");
		
		// 페이징 검색 
		PaginationInfoVO<ProjectVO> pagingVO = new PaginationInfoVO<>(6,5);
		
		// 검색 기능 추가 
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		ProjectVO pjVO = new ProjectVO();
		pjVO.setPrjctSttus(prjctSttus);
		pagingVO.setData(pjVO);	// 프로젝트 상태 설정(진행중,완료,보류)
		// 페이지 세팅 + 전체 건수 조회 + 리스트 조회 
		pagingVO.setCurrentPage(currentPage);
		int totalRecord = pService.selectProjectListCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		
		// 검색 + 페이징 반영된 목록 호출 
		List<ProjectVO> projectList = pService.selectProjectList(pagingVO);
		
		pagingVO.setDataList(projectList);
		model.addAttribute("pagingVO", pagingVO);  				//  조회된 목록을 Model에 담아 JSP 전달 
		model.addAttribute("projectList", projectList);
		
		return "project/projectList";
	}
	
	
	
	// 프로젝트 등록하기 (AJAX)
	@PostMapping("/createProject")
	@ResponseBody
	public Map<String, Object> createProjectAjax(@RequestBody ProjectVO pVO) {
		log.info("모달창에서 프로젝트 등록 AJAX 요청", pVO);
		
		Map<String, Object> resp = new HashMap<>();
	    ServiceResult result = pService.insertProject(pVO);
	    
	    if(result == ServiceResult.OK) {
	    	
	    	// insertProject() 내 selectKey로 prjctNo 채워짐 
	    	resp.put("result", "OK");
	    	
//	    	resp.put("project",pVO);	//prjctNo 포함된 최신값 전달 
	    	ProjectVO fresh = pService.selectProjectByNo(pVO.getPrjctNo());
	    	resp.put("project", fresh);
	    }else {
	    	resp.put("result", "FAIL");
	    }
		
		return resp;
	}
	
	
	
	

	// 대시보드 (프로젝트별) 
	@GetMapping("/dashboard")
	public String projectDashboard(@RequestParam("prjctNo") int prjctNo, RedirectAttributes ra ,Model model) {
		log.info("프로젝트 대시보드 호출", prjctNo);
		
		// 1) 프로젝트 기본 정보 조회 
		ProjectVO project = pService.selectProjectByNo(prjctNo);
		
		// 프로젝트 존재하지 않을떄 
		if(project == null) {
			model.addAttribute("msg", "존재하지 않는 프로젝트 입니다." ); 
			return "redirect:/project/projectList"; 
		}
		
		// 현장 사진 목록 조회 
		List<ProjectPhotosVO> photoList = photoService.selectPhotoList(prjctNo);
		
		model.addAttribute("project", project);
		model.addAttribute("photoList", photoList);
		
		return "project/dashboard";
	}
	
	
	// 프로젝트 업데이트 수정폼 호출
	@GetMapping("/update/data")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateProjectData(@RequestParam("prjctNo") int prjctNo) {
	    ProjectVO project = pService.selectProjectByNo(prjctNo);
	    
	    if (project == null) {
	        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	    }
	    
	    // 프로젝트에 참여자 목록이 없으면 별도 조회
	    if (project.getParticipantsList() == null || project.getParticipantsList().isEmpty()) {
	        project.setParticipantsList(pService.selectParticipantsByProject(prjctNo));
	    }
	    
	    Map<String, Object> param = new HashMap<>();
	    param.put("data", project);
	    param.put("status", "u");

	    return new ResponseEntity<Map<String, Object>>(param, HttpStatus.OK);
	}
	
	
	

	// 프로젝트 업데이트 처리
	@ResponseBody
	@PostMapping("/update")
	public ResponseEntity<String> updateProjectInfo(@RequestBody ProjectVO pVO, @RequestParam Map<String, String> param) {
		int prjctNo = Integer.parseInt(param.get("prjctNo"));
		
		//ServiceResult result = ServiceResult.FAILED;
		// 1) 기본 정보만 업데이트
        ServiceResult base = pService.updateProjectBasic(pVO);
        ServiceResult result = base;
        
        
		/*
		 * if(base.equals(ServiceResult.OK)) { // 2) 참여자 추가만 반영(중복 무시, 삭제 금지)
		 * List<ProjectPerticipantVO> list = pVO.getParticipantsList(); if (list != null
		 * && !list.isEmpty()) { result = pService.addParticipants(prjctNo, list); } }
		 */
        

			if (base == ServiceResult.OK) {
			    List<ProjectPerticipantVO> list = pVO.getParticipantsList();
			    if (list != null && !list.isEmpty()) {
			        result = pService.addParticipants(prjctNo, list); // 추가가 있으면 그 결과로 덮어씀
			    }
			}


        return new ResponseEntity<>(result.toString(), HttpStatus.OK);
    }
	
	

	
///////////////////////////////////////////////////////////////////////////////////////////////	
//================================= carousel 내 있는 항목 페이지 =================================//
///////////////////////////////////////////////////////////////////////////////////////////////	
	
	

//-----------------------------------------------------------------------------------------------	

	@GetMapping("/info")
	public String projectInfo(@RequestParam("prjctNo") int prjctNo, Model model) {
		log.info("프로젝트 정보 호출 prjctNo={}", prjctNo);
		
		// 1) 프로젝트 기본 정보 조회 (프로젝트 번호로 DB 검색) 
		ProjectVO project = pService.selectProjectByNo(prjctNo);
		
		// 만약 해당 번화의 프로젝트가 없으면 목록으로 리다이렉트
		if(project == null) {
			model.addAttribute("msg", "존재하지 않는 프로젝트입니다.");
			return "redirect:/project/projectList";
		}
		
		// 2) 프로젝트에 참여자 목록이 아직 채워져 있지 않으면 별도 조회 
		if(project.getParticipantsList() == null) {
			project.setParticipantsList(pService.selectParticipantsByProject(prjctNo));
		}
		
		
		// 4) 모델에 데이터 담기 => JSP에서 사용 가능 
		model.addAttribute("project", project);		// 프로젝트 기본 정보 + 참여자 목록 
		putTeamLists(model, project);
		
		model.addAttribute("status", "u");
		
		// 5) 프로젝트 상세 페이지로 이동 
		return "project/tab/projectInfo";
	}
	
	
	
//-----------------------------------------------------------------------------------------------	
	 @GetMapping("/kanban")
		public String kanbanBoard(@RequestParam("prjctNo") int prjctNo, Model model) {
		 	
		 model.addAttribute("prjctNo", prjctNo);
			return "project/tab/kanban";
		}
		
	    
	
//-----------------------------------------------------------------------------------------------	
	
	@GetMapping("/gantt")
	public String ganttChart(Model model) {
		return "project/tab/ganttChart";
	}
	

	
//-------------------------------------------------------------------------------------------------
	
	public void putTeamLists(Model model, ProjectVO project) {
		List<ProjectPerticipantVO> designerMembers = new ArrayList<>();
		List<ProjectPerticipantVO> fieldStffMembers = new ArrayList<>();
		
		
		if(project != null && project.getParticipantsList() != null) {
			for(ProjectPerticipantVO p : project.getParticipantsList()) {
				if(p == null) continue;
				String team = p.getPrjctPrtcpntType();
				team = (team == null) ? "" : team.trim().toUpperCase();
				if("DESIGN".equals(team)) {
					designerMembers.add(p);
				}else {
					// DESIGN 이외는 전부 FIELD
					fieldStffMembers.add(p);
				}
			}
		}
		
		log.info("designerMembers.size = {}", designerMembers.size());
		log.info("fieldStffMembers.size = {}", fieldStffMembers.size());
		
		model.addAttribute("designerMembers", designerMembers);
		model.addAttribute("fieldStffMembers", fieldStffMembers);
	}
	
}
	
	

