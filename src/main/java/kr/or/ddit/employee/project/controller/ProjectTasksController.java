package kr.or.ddit.employee.project.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.service.IProjectService;
import kr.or.ddit.employee.project.service.IProjectTasksService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectTaskVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectTasksController {

	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private IProjectService pService;  // 프로젝트 조회 
	
	@Autowired
	private IProjectTasksService ptService; 
	
	
	
	
	@GetMapping("/tasks")
	public String tasksPanel(@RequestParam(value = "prjctNo", required = false) Integer prjctNo,
	                         RedirectAttributes ra, Model model) {
	    if (prjctNo == null || prjctNo <= 0) {   // null 우선 체크
	        ra.addFlashAttribute("error", "유효하지 않은 프로젝트 번호입니다.");
	        return "redirect:/main/dashboard";
	    }
	    ProjectVO pNo = pService.selectProjectByNo(prjctNo);
	    model.addAttribute("project", pNo);
	    model.addAttribute("prjctNo", prjctNo);
	    return "project/tab/tasks";
	}
	
	// 목록 AJAX
    @GetMapping("/tasks/listAjax")
    @ResponseBody
    public PaginationInfoVO<ProjectTaskVO> getTasksByAjax(
            @RequestParam("prjctNo") int prjctNo,
            @RequestParam(value="status", defaultValue="all") String status,
            @RequestParam(value="procsTy", required=false) String procsTy,
            @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(value="searchWord", required=false) String searchWord,
            @AuthenticationPrincipal CustomUser user,
            Model model) {

    	  String loginEmpNo = (user != null ? user.getUsername() : null);

          // 페이징: 자료실과 동일 스타일 (한 페이지 10, 블록 5)
          PaginationInfoVO<ProjectTaskVO> pagingVO = new PaginationInfoVO<>(6, 5);
          pagingVO.setCurrentPage(currentPage);

          if (org.apache.commons.lang3.StringUtils.isNotBlank(searchWord)) {
              pagingVO.setSearchType("title");
              pagingVO.setSearchWord(searchWord);
              model.addAttribute("searchWord", searchWord);
          }

          // 조회조건 VO에 담아 전달 (status는 VO의 taskSttus 필드에 '선택값'만 싣고,
          // 실제 DB TASK_STTUS와는 무관하게 진행률 필터에만 사용)
          ProjectTaskVO cond = new ProjectTaskVO();
          cond.setPrjctNo(prjctNo);
          cond.setProcsTy(procsTy);
          cond.setTaskSttus(status); // ← XML에서 #{data.taskSttus}로 분기

          
          // ▼ 전역 카운트 조회(상태필터 없이, 검색/유형은 반영)
          Map<String, Integer> counts = ptService.selectEachTaskCounts(prjctNo, procsTy, searchWord);
          cond.setCounts(counts); // ← ProjectTaskVO에 counts(Map<String,Integer>) 필드 하나 추가
          
          pagingVO.setData(cond);

          // 권한 플래그 계산용(리스트 응답에 canEdit/canDelete)
          pagingVO.setEmpNo(loginEmpNo); // ← XML에서 #{empNo} 로 사용

          return ptService.selectTaskAjaxList(pagingVO);
      }
	
	
	
	
 // 등록 화면
    @GetMapping("/tasks/insert")
    public String getTasksInsert(
        @RequestParam("prjctNo") int prjctNo,
        @RequestParam(value="status", required=false) String status, 
        @RequestParam(value="taskNo", required=false) Integer taskNo,
        @AuthenticationPrincipal CustomUser user,
        Model model, 
        RedirectAttributes ra) {

        ProjectVO project = pService.selectProjectByNo(prjctNo);
        List<ProjectPerticipantVO> participants = 
            pService.selectParticipantsByProjectForTasks(prjctNo);
        
        // 수정 모드 (status=u) 처리
        ProjectTaskVO task = null;
        if ("u".equals(status) && taskNo != null) {
            String loginEmpNo = (user != null ? user.getUsername() : null);
            task = ptService.selectTaskByPk(prjctNo, taskNo, loginEmpNo);
            
            if (task == null || !"Y".equals(task.getCanEdit())) {
                ra.addFlashAttribute("error", "수정 권한이 없거나 일감을 찾을 수 없습니다.");
                return "redirect:/project/tasks/detail?prjctNo="+prjctNo+"&taskNo="+taskNo;
            }
            
            // 첨부파일 정보도 가져옵니다.
            List<FilesVO> files = ptService.selectFilesByGroupNo(task.getFileGroupNo());
            model.addAttribute("files", files);
            
            model.addAttribute("task", task); // 조회된 데이터 바인딩
            model.addAttribute("status", "u"); // JSP에서 수정 모드임을 판단하는 플래그
        } else {
            // 등록 모드 ("i" 상태는 JSP에서 생략해도 되지만 명시적으로 설정)
            model.addAttribute("status", "i");
            model.addAttribute("task", new ProjectTaskVO()); // 빈 VO 전달
        }

        model.addAttribute("project", project);
        model.addAttribute("participants", participants);
        model.addAttribute("prjctNo", prjctNo);
        
        return "project/tab/tasks_insert";
    }
	
	
	
    // 등록 처리
    @PostMapping("/tasks/insert")
    public String postTasksInsert(@ModelAttribute ProjectTaskVO task,
                                  @RequestParam(value="files", required=false) List<MultipartFile> files,
                                  @AuthenticationPrincipal CustomUser user,
                                  RedirectAttributes ra) {
    	
    	log.info("일감 등록 시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    	
        try {
            String loginEmpNo = (user != null ? user.getUsername() : null);
            log.info("[TASK-INS][C] loginEmpNo={}", loginEmpNo); // [CHK-2] 로그인 정보
            if (loginEmpNo == null) {
                ra.addFlashAttribute("error", "로그인이 필요합니다.");
                return "redirect:/login";
            }
            
            // 관리자 계정(202508001)은 모든 권한 가짐 
            boolean isAdmin = "202508001".equals(loginEmpNo);
            
            // 참여자 체크(작성자)
            int writerOk = 0;
            if(!isAdmin) { // isAdmin이 false일 때만 체크
                writerOk = ptService.checkProjectParticipant(task.getPrjctNo(), loginEmpNo);
            } else {
                writerOk = 1; // 관리자일 경우 writerOk를 1로 설정하여 다음 로직 진행
            }


            log.info("[TASK-INS][C] writerOk(prjctNo={}, empNo={}) = {}", task.getPrjctNo(), loginEmpNo, writerOk);
            // 참여자 체크(작성자)
//            int writerOk = ptService.checkProjectParticipant(task.getPrjctNo(), loginEmpNo);
            if (writerOk == 0) {
                ra.addFlashAttribute("error", "프로젝트 참여자만 일감을 등록할 수 있습니다.");
                return "redirect:/project/tasks?prjctNo=" + task.getPrjctNo();
            }

            // 담당자 체크
            if (task.getTaskCharger() == null || task.getTaskCharger().isEmpty()) {
                ra.addFlashAttribute("error", "담당자를 선택하세요.");
                return "redirect:/project/tasks/insert?prjctNo=" + task.getPrjctNo();
            }
            int chargerOk = ptService.checkProjectParticipant(task.getPrjctNo(), task.getTaskCharger());
            log.info("[TASK-INS][C] chargerOk(prjctNo={}, charger={}) = {}", task.getPrjctNo(), task.getTaskCharger(), chargerOk);
            if (chargerOk == 0) {
                ra.addFlashAttribute("error", "선택한 담당자는 프로젝트 참여자가 아닙니다.");
                return "redirect:/project/tasks/insert?prjctNo=" + task.getPrjctNo();
            }

            // 기본값 세팅
            task.setEmpNo(loginEmpNo);          // 작성자
            task.setDelYn("N");
            task.setEmrgncyYn( (task.getEmrgncyYn()==null || task.getEmrgncyYn().isEmpty()) ? "N" : "Y");
            // 날짜 포맷 변환(yyyy-MM-dd → yyyyMMdd)
            task.setTaskBeginYmd( toYmd(task.getTaskBeginYmd()) );
            task.setTaskDdlnYmd ( toYmd(task.getTaskDdlnYmd()) );
            task.setTaskRegYmd  ( todayYmd() );

            // 진행률에 따른 상태
            task.setTaskSttus( statusByProgress(task.getTaskProgrs()) );

            // 등록
            ServiceResult r = ptService.insertTask(task, files);
            if (r == ServiceResult.OK) {
                ra.addFlashAttribute("message", "일감이 등록되었습니다.");
            } else {
                ra.addFlashAttribute("error", "일감 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            log.error("일감 등록 중 오류", e);
            ra.addFlashAttribute("error", "일감 등록 중 오류가 발생했습니다.");
        }
        return "redirect:/project/tasks?prjctNo=" + task.getPrjctNo();
    }
    
    
    
    
    
	
	

	
    @GetMapping("/tasks/detail")
    public String tasksDetail(@RequestParam int prjctNo,
                              @RequestParam int taskNo,
                              @AuthenticationPrincipal CustomUser user,
                              Model model) {

        String loginEmpNo = (user != null ? user.getUsername() : null);
        ProjectTaskVO task = ptService.selectTaskByPk(prjctNo, taskNo, loginEmpNo);
        if (task == null) {
            model.addAttribute("error", "일감을 찾을 수 없습니다.");
            return "project/tab/tasks";
        }

        // ✅ 파일그룹 NULL/0 안전 처리
        List<FilesVO> files = ptService.selectFilesByGroupNo(task.getFileGroupNo());
        model.addAttribute("files", files);

        model.addAttribute("canEdit", "Y".equals(task.getCanEdit()));
        model.addAttribute("canDelete", "Y".equals(task.getCanDelete()));
        model.addAttribute("task", task);
        model.addAttribute("prjctNo", prjctNo);
        return "project/tab/tasks_detail";
    }
	
	
	
	
    @GetMapping("/tasks/update")
    public String tasksUpdateForm(@RequestParam int prjctNo,
                                  @RequestParam int taskNo,
                                  @AuthenticationPrincipal CustomUser user,
                                  Model model) {

        String loginEmpNo = (user != null ? user.getUsername() : null);
        ProjectTaskVO task = ptService.selectTaskByPk(prjctNo, taskNo, loginEmpNo);
        if (task == null) {
            model.addAttribute("error", "일감을 찾을 수 없습니다.");
            return "redirect:/project/tasks?prjctNo=" + prjctNo;
        }
        // 담당자 드롭다운용
        List<ProjectPerticipantVO> participants = pService.selectParticipantsByProjectForTasks(prjctNo);

        model.addAttribute("mode", "edit");        // ★ 폼 재사용
        model.addAttribute("task", task);
        model.addAttribute("participants", participants);
        model.addAttribute("prjctNo", prjctNo);
        return "project/tab/tasks_insert"; // ★ insert.jsp 재사용
    }

    
    

@PostMapping("/tasks/update")
public String tasksUpdate(@ModelAttribute ProjectTaskVO task,
                          @AuthenticationPrincipal CustomUser user,
                          RedirectAttributes ra) {
    try {
        String loginEmpNo = (user != null ? user.getUsername() : null);
        if (loginEmpNo == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        // 권한: 작성자 or 담당자
        ProjectTaskVO origin = ptService.selectTaskByPk(task.getPrjctNo(), task.getTaskNo(), loginEmpNo);
        if (origin == null || !"Y".equals(origin.getCanEdit())) {
            ra.addFlashAttribute("error", "수정 권한이 없습니다.");
            return "redirect:/project/tasks/detail?prjctNo="+task.getPrjctNo()+"&taskNo="+task.getTaskNo();
        }

        // 포맷 정리
        task.setTaskBeginYmd(task.getTaskBeginYmd() == null ? null : task.getTaskBeginYmd().replaceAll("-", ""));
        task.setTaskDdlnYmd(task.getTaskDdlnYmd() == null ? null : task.getTaskDdlnYmd().replaceAll("-", ""));
        task.setTaskMdfcnYmd(todayYmd());
        task.setEmrgncyYn( (task.getEmrgncyYn()==null || task.getEmrgncyYn().isEmpty()) ? "N" : "Y");
        task.setTaskSttus( statusByProgress(task.getTaskProgrs()) );

        ServiceResult r = ptService.updateTask(task);
        if (r == ServiceResult.OK) {
            ra.addFlashAttribute("message", "수정되었습니다.");
        } else {
            ra.addFlashAttribute("error", "수정에 실패했습니다.");
        }
    } catch (Exception e) {
        log.error("일감 수정 오류", e);
        ra.addFlashAttribute("error", "수정 중 오류가 발생했습니다.");
    }
    return "redirect:/project/tasks/detail?prjctNo="+task.getPrjctNo()+"&taskNo="+task.getTaskNo();
}
	
	
	
	@PostMapping("tasks/delete")
	@ResponseBody
	public String deleteTasks(@RequestParam int prjctNo, @RequestParam int taskNo, @AuthenticationPrincipal CustomUser user) {
		
		log.info("일감 삭제 요청 - prjctNo={}, taskNo={}", prjctNo, taskNo);

	    ServiceResult result = ptService.deleteTask(prjctNo, taskNo);

	    return result.equals(ServiceResult.OK) ? "SUCCESS" : "FAIL";
	}

	

	
	
	
	/* ====== 유틸 ====== */
    private String toYmd(String d){ if(d==null) return null; return d.replaceAll("-", ""); }
    private String todayYmd(){
        java.time.LocalDate now = java.time.LocalDate.now();
        return now.format(java.time.format.DateTimeFormatter.BASIC_ISO_DATE); // yyyyMMdd
    }
    private String statusByProgress(int p){
        if (p==0) return "대기";
        if (p==90) return "검토중";
        if (p==100) return "완료";
        if (p>=10 && p<=80) return "진행중";
        return "진행중";
    }
    
    

 //-------------------------------------------------------------------------------
    

 // ===== 칸반 초기 로딩: 컬럼별 목록 =====
    @GetMapping("/kanban/listAjax")
    @ResponseBody
    public Map<String, Object> kanbanListAjax(@RequestParam int prjctNo, Model model) {
        // 전체 일감(삭제 제외) 조회
        List<ProjectTaskVO> list = ptService.selectTasksByProject(prjctNo);
        
        List<ProjectTaskVO> todo = new ArrayList<>();
        List<ProjectTaskVO> inprogress = new ArrayList<>();
        List<ProjectTaskVO> pending = new ArrayList<>();
        List<ProjectTaskVO> done = new ArrayList<>();
        
        for (ProjectTaskVO t : list) {
            int p = t.getTaskProgrs();
            if (p == 0)            todo.add(t);
            else if (p == 90)      pending.add(t);
            else if (p == 100)     done.add(t);
            else                   inprogress.add(t); // 10~80, 기타는 진행중으로
        }
    
        model.addAttribute("prjctNo", prjctNo);
        Map<String, Object> out = new HashMap<>();
        out.put("todo", todo);
        out.put("inprogress", inprogress);
        out.put("pending", pending);
        out.put("done", done);
        return out;
    
    
        
        
    }
    

    
	
// 칸반 
    @PostMapping("/kanban/move")
    @ResponseBody
    public String moveOnKanban(@RequestParam int prjctNo,
    		@RequestParam int taskNo,
    		@RequestParam String column,   // todo|inprogress|pending|done
    		@AuthenticationPrincipal CustomUser user) {
    	
    	
    	// 권한 체크: 프로젝트 참여자인지(작성자/담당자) 정도만
    	String empNo = (user != null ? user.getUsername() : null);
    	if (empNo == null) return "LOGIN_REQUIRED"; // 로그인 필요 응답
    	
    	ProjectTaskVO task = ptService.selectTaskByPk(prjctNo, taskNo, empNo);
    	
    	 if (task == null) {
             log.warn("일감(T{})을 찾을 수 없습니다.", taskNo);
             return "TASK_NOT_FOUND";
         }
    	 
    	// 관리자 사번
         final String ADMIN_EMP_NO = "202508001";
         
         boolean isAdmin = ADMIN_EMP_NO.equals(empNo);
         boolean isWriterOrCharger = "Y".equals(task.getCanEdit()); 
         
         if (!isAdmin && !isWriterOrCharger) {
             log.warn("권한 없음: 사용자({})가 일감(T{})을 이동하려 시도함", empNo, taskNo);
             return "NO_PERMISSION"; // 클라이언트가 SweetAlert를 띄우도록 하는 응답 코드
         }
         
         
    	// 칼럼 → 진행률/상태 매핑
    	int progrs;
    	String sttus;
    	switch (column) {
    	case "todo":        progrs = 0;   sttus = "대기";   break;
    	case "inprogress":  progrs = 50;  sttus = "진행중"; break; // 요구사항: 진행중은 50%로
    	case "pending":     progrs = 90;  sttus = "검토중"; break;
    	case "done":        progrs = 100; sttus = "완료";   break;
    	default:            return "ERROR";
    	}
    	
    	int ok = ptService.updateTaskProgressAndStatus(taskNo, prjctNo, progrs, sttus, empNo);
    	return ok > 0 ? "SUCCESS" : "ERROR";
    }
}
	
	


