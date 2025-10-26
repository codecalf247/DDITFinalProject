
package kr.or.ddit.employee.project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ProcessBuilder.Redirect;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.employee.boards.notice.controller.MediaUtils;
import kr.or.ddit.employee.project.service.IProjectService;
import kr.or.ddit.employee.project.service.IissueService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.IssueCommentVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import lombok.extern.slf4j.Slf4j;





@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectIssueController {

	@Autowired
	private IissueService service;
	
	@Autowired
	private IProjectService pService;
	
	
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	
	
	
	
	
	
	
	
	
	  // 카운트 조회 로직 추가 및 응답 구성
	@ResponseBody // JSON 응답을 위해 사용
	@GetMapping("/issues/listAjax") 
	public Map<String, Object> getIssueListAjax(
	    @RequestParam int prjctNo,
	    @RequestParam(required = false, defaultValue = "") String status,
	    @RequestParam(required = false, defaultValue = "") String type,
	    @RequestParam(required = false, defaultValue = "1") int currentPage,
	    @RequestParam(required = false, defaultValue = "") String searchWord) {
	    
	    log.info("getIssueListAjax() 실행. prjctNo={}, status={}, type={}, currentPage={}", prjctNo, status, type, currentPage);

	    // 1. PaginationInfoVO 설정
	    // 기본 생성자 사용 후 screenSize와 blockSize를 명시적으로 설정합니다.
	    PaginationInfoVO<IssueVO> pagingVO = new PaginationInfoVO<>();
	    
	    // 🔥 한 페이지에 6개 항목 표시를 위해 명시적으로 설정
	    pagingVO.setScreenSize(6); 
	    pagingVO.setBlockSize(5);
	    pagingVO.setCurrentPage(currentPage);
	    
	    // 검색어 설정
	    if (StringUtils.isNotBlank(searchWord)) {
	        pagingVO.setSearchType("title");
	        pagingVO.setSearchWord(searchWord);
	    }
	    
	    // 조회 조건 VO 설정
	    IssueVO cond = new IssueVO();
	    cond.setPrjctNo(prjctNo);
	    cond.setIssueSttus(status);
	    cond.setIssueTy(type);
	    pagingVO.setData(cond);
	    
	    
	    // 2. 총 레코드 수 조회 및 설정
	    // PaginationInfoVO에 Total Record Count를 먼저 설정해야 페이지네이션이 정확히 계산됩니다.
	    // 💡 Service에 'int selectIssueTotalCount(PaginationInfoVO<IssueVO> pagingVO)' 메서드 필요
	    int totalRecord = service.selectIssueTotalCount(pagingVO); 
	    pagingVO.setTotalRecord(totalRecord);
	    
	    // 3. 페이지네이션이 적용된 목록 데이터 조회
	    // 💡 Service에 'List<IssueVO> selectIssueListWithPaging(PaginationInfoVO<IssueVO> pagingVO)' 메서드 필요
	    List<IssueVO> dataList = service.selectIssueListWithPaging(pagingVO);
	    pagingVO.setDataList(dataList); // 조회된 목록을 VO에 설정
	    
	    // 4. 전체/미해결/완료 카운트 조회 (탭 상단 카운트용)
	    Map<String, Integer> counts = service.getIssueCounts(prjctNo);

	    // 5. 응답 Map 구성
	    Map<String, Object> response = new HashMap<>();
	    response.put("issueList", pagingVO.getDataList());
	    response.put("pagingHTML", pagingVO.getPagingHTML2());
	    
	    // 카운트 정보 추가
	    response.put("totalCount", counts.get("TOTALCOUNT"));
	    response.put("unresolvedCount", counts.get("UNRESOLVEDCOUNT"));
	    response.put("resolvedCount", counts.get("RESOLVEDCOUNT"));
	    
	    return response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("/issues/lists")
	public String getissueList(@RequestParam int prjctNo, Model model,@AuthenticationPrincipal CustomUser user) {
		
		List<IssueVO> issueList = service.issueList(prjctNo);
		
	
		
		model.addAttribute("issueList", issueList);
		model.addAttribute("prjctNo", prjctNo);
		
		return "project/tab/issues";
	}
	// 이슈 등록 폼 페이지를 보여주는 메서드 (GET 요청)
    @GetMapping("/issues/insert")
    public String showIssueInsertForm(@RequestParam int prjctNo, Model model) {
        log.info("showIssueInsertForm() 실행");
        model.addAttribute("prjctNo", prjctNo);
        return "project/tab/issues_insert";
    }
    
    
    
    @ResponseBody
    @GetMapping("/issues/participants")
    public ResponseEntity<List<ProjectPerticipantVO>> getProjectParticipants(@RequestParam int prjctNo) {
        try {
            List<ProjectPerticipantVO> participants = pService.selectProjectIssuesParticipants(prjctNo);
            return new ResponseEntity<>(participants, HttpStatus.OK);
        } catch (Exception e) {
            log.error("프로젝트 참여자 목록 조회 실패: prjctNo={}", prjctNo, e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
    
    

    // 이슈 등록 데이터를 처리하는 메서드 (POST 요청)
    @PostMapping("/issues/insert")
    public String issueInsert(@ModelAttribute IssueVO issueVO, RedirectAttributes ra, 
    		 @RequestParam List<MultipartFile> uploadFiles,
             Model model,  @AuthenticationPrincipal CustomUser user) {

        log.info("issueInsert() 실행");
        String empNo = user.getUsername();
        
        if (issueVO.getEmrgncyYn() == null || issueVO.getEmrgncyYn().isEmpty()) {
            issueVO.setEmrgncyYn("N"); // 미체크 시 "N"으로 설정
        }

        // 파일 그룹번호 생성
        int fileGroupNo = service.generateFileGroupNo();
        issueVO.setFileGroupNo(fileGroupNo);

        // 사원번호 생성
        issueVO.setEmpNo(empNo);

        // 게시판 insert
        service.insert(issueVO);

        // 파일 insert
        if (uploadFiles != null && !uploadFiles.isEmpty() && !uploadFiles.get(0).isEmpty()) {
            for (MultipartFile file : uploadFiles) {
                String originalFileName = file.getOriginalFilename();
                String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                FilesVO fileVO = new FilesVO();
                fileVO.setFileGroupNo(fileGroupNo);
                fileVO.setOriginalNm(originalFileName);
                fileVO.setSavedNm(saveFileName);
                fileVO.setFilePath("/upload/" + saveFileName);
                fileVO.setFileSize((int) file.getSize());
                fileVO.setFileUploader(issueVO.getEmpNo());
                fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
                fileVO.setFileMime(file.getContentType());
                
                service.insertFile(fileVO);

                File saveFile = new File(uploadPath, saveFileName);
                try {
                    file.transferTo(saveFile);
                } catch (IOException e) {
                    log.error("파일 저장 실패", e);
                    // 파일 저장 실패 시 예외 처리 로직 추가
                }
            }
        }
        
        ra.addFlashAttribute("msg", "이슈게시판 등록 완료!");
        ra.addFlashAttribute("prjctNo", issueVO.getPrjctNo());
        
        return "redirect:/project/issues/lists?prjctNo=" + issueVO.getPrjctNo();
    }
	
    // 상세 페이지 
    @GetMapping("/issues/detail")
    public String issueDetail(@RequestParam int issueNo, Model model) {
        IssueVO issueVO = service.selectIssue(issueNo);
        model.addAttribute("issueVO",issueVO);
        return "project/tab/issues_detail";
        }
	
	 // 파일 다운로드 메서드
    @GetMapping("/issues/download/{savedNm}") 
    public ResponseEntity<byte[]> downloadFile(
            @PathVariable String savedNm,
            HttpServletResponse response) {

    	InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		try {
			String formatName = savedNm.substring(savedNm.lastIndexOf(".")+1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			
			String fullFilePath = uploadPath + File.separator + savedNm; // savedNm은 이미 확장자 포함
			
			in = new FileInputStream(fullFilePath);
			
			savedNm = savedNm.substring(savedNm.indexOf("_") + 1);
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			// 다운로드 처리 시 사용
			headers.add("Content-Disposition", "attachment;filename=\"" + 
			new String(savedNm.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			entity  = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		}catch(Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			if(in != null) {
				try {
					in.close();
				}catch(IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		return entity;
    }
    
    
    @ResponseBody
    @PostMapping("/issues/comment/insert")
    public Map<String, String> insertComment(
            @ModelAttribute IssueCommentVO commentVO,
            @AuthenticationPrincipal CustomUser user) {
        
        // 현재 로그인한 사용자의 사원 번호를 댓글 작성자로 설정
        commentVO.setEmpNo(user.getUsername());
        
        Map<String, String> response = new HashMap<>();
        
        try {
            service.insertIssueComment(commentVO);
            response.put("status", "SUCCESS");
        } catch (Exception e) {
            log.error("댓글 등록 실패: {}", commentVO, e);
            response.put("status", "FAIL");
        }
        return response;
    }
    
    
    
    
	
	@GetMapping("/issues/update")
	public String showIssueUpdateForm(@RequestParam int issueNo, Model model) {
		 log.info("showIssueUpdateForm() 실행. issueNo={}", issueNo);
		    
		    // 1. 이슈 상세 정보 조회 (기존 값 바인딩용)
		    IssueVO issueVO = service.selectIssue(issueNo);
		    
		    // 2. 모델에 데이터 및 수정 모드 설정
		    model.addAttribute("issueVO", issueVO);
		    model.addAttribute("prjctNo", issueVO.getPrjctNo()); // 등록 페이지와의 호환성을 위해 prjctNo도 추가
		    model.addAttribute("status", "u"); // 수정 모드임을 JSP에 알림
		    
		    return "project/tab/issues_insert"; // issues_insert.jsp 재활용
	}
	
	
	// 이슈 수정 데이터를 처리하는 메서드 (POST 요청)
	@PostMapping("/issues/update")
	public String issueUpdate(@ModelAttribute IssueVO issueVO, RedirectAttributes ra, 
	                         @RequestParam List<MultipartFile> uploadFiles,
	                         @RequestParam(required = false) List<Integer> deleteFileNos,
	                         @AuthenticationPrincipal CustomUser user) {

	    log.info("issueUpdate() 실행. issueNo={}", issueVO.getIssueNo());
	    String empNo = user.getUsername();
	    
	    if (issueVO.getEmrgncyYn() == null || issueVO.getEmrgncyYn().isEmpty()) {
	        issueVO.setEmrgncyYn("N"); // 미체크 시 "N"으로 설정
	    }

	    // 1. 이슈 본문 업데이트
	    issueVO.setEmpNo(empNo); // 최종 수정자 정보 업데이트용 (필요시)
	    service.updateIssue(issueVO); // Service/Mapper에 updateIssue 구현 필요

	    // 2. 파일 처리: 삭제 파일 처리
	    if (deleteFileNos != null && !deleteFileNos.isEmpty()) {
	        for (int fileNo : deleteFileNos) {
	            // 파일을 삭제(DEL_YN='Y'로 업데이트)하는 서비스 메서드 호출
	            service.deleteFile(fileNo); // Service/Mapper에 deleteFile 구현 필요
	        }
	    }

	    // 3. 파일 처리: 신규 파일 등록
	    // issueVO에는 기존 파일 그룹 번호(fileGroupNo)가 포함되어 있음
	    int fileGroupNo = issueVO.getFileGroupNo();
	    if (uploadFiles != null && !uploadFiles.isEmpty() && !uploadFiles.get(0).isEmpty()) {
	        for (MultipartFile file : uploadFiles) {
	            String originalFileName = file.getOriginalFilename();
	            String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	            FilesVO fileVO = new FilesVO();
	            fileVO.setFileGroupNo(fileGroupNo);
	            fileVO.setOriginalNm(originalFileName);
	            fileVO.setSavedNm(saveFileName);
	            fileVO.setFilePath("/upload/" + saveFileName);
	            fileVO.setFileSize((int) file.getSize());
	            fileVO.setFileUploader(issueVO.getEmpNo()); // 등록자와 수정자가 다를 수 있으나, 여기서는 이슈 등록자로 통일
	            fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
	            fileVO.setFileMime(file.getContentType());
	            
	            // 신규 파일 등록
	            service.insertFile(fileVO);

	            // 실제 파일 저장
	            File saveFile = new File(uploadPath, saveFileName);
	            try {
	                file.transferTo(saveFile);
	            } catch (IOException e) {
	                log.error("파일 저장 실패", e);
	            }
	        }
	    }
	    
	    ra.addFlashAttribute("msg", "이슈게시판 수정 완료!");
	    // 수정 후 상세 페이지로 리다이렉트
	    return "redirect:/project/issues/detail?issueNo=" + issueVO.getIssueNo();
	}

	
	
	
	// 댓글 수정 처리 (AJAX)
    @ResponseBody
    @PostMapping("/issues/comment/update")
    public Map<String, String> updateComment(@ModelAttribute IssueCommentVO commentVO) {
        
        Map<String, String> response = new HashMap<>();
        
        try {
            service.updateIssueComment(commentVO);
            response.put("status", "SUCCESS");
        } catch (Exception e) {
            log.error("댓글 수정 실패: issueCmNo={}", commentVO.getIssueCmNo(), e);
            response.put("status", "FAIL");
        }
        return response;
    }
	
	
	// 이슈 삭제 처리 (AJAX)
    @ResponseBody
    @PostMapping("/issues/delete")
    public ResponseEntity<String> issueDelete(@RequestParam int issueNo) {
        try {
            // Service 호출하여 삭제 처리
            // 실제 구현에서는 파일 및 댓글도 함께 삭제/업데이트 처리 필요
            service.deleteIssue(issueNo); 
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } catch (Exception e) {
            log.error("이슈 삭제 실패: issueNo={}", issueNo, e);
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
   
    
 //  댓글 삭제 처리 (AJAX)
    @ResponseBody
    @PostMapping("/issues/comment/delete")
    public Map<String, String> deleteComment(@RequestParam int issueCmNo) {
        
        Map<String, String> response = new HashMap<>();
        
        try {
            service.deleteIssueComment(issueCmNo);
            
            // 댓글 수 감소 로직 (선택적: 댓글 수를 캐시하거나 별도로 관리하는 경우)
            // 여기서는 페이지 새로고침을 통해 댓글 수가 반영되므로 별도 로직은 생략합니다.
            
            response.put("status", "SUCCESS");
        } catch (Exception e) {
            log.error("댓글 삭제 실패: issueCmNo={}", issueCmNo, e);
            response.put("status", "FAIL");
        }
        return response;
    }
	
	
}
	
	

