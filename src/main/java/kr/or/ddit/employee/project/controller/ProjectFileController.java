package kr.or.ddit.employee.project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.FileVisitOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.service.IProjectFilesService;
import kr.or.ddit.employee.project.service.IProjectService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectFileVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectFileController {

	
	@Autowired
	private IProjectService pService;
	
	@Autowired
	private IProjectFilesService pfService;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
//------------------------------------------------------------------------------------------------------------------
	
	
	
	@GetMapping("/files")
	public String getFiles(@RequestParam(required = false) Integer prjctNo,
	                       Model model,
	                       RedirectAttributes ra) {

	    if (prjctNo == null) {
	        ra.addFlashAttribute("error", "프로젝트 번호가 필요합니다.");
	        return "redirect:/project/projectList";
	    }

	    ProjectVO pNo = pService.selectProjectByNo(prjctNo);
	    if (pNo == null) {
	        ra.addFlashAttribute("error", "존재하지 않는 프로젝트입니다.");
	        return "redirect:/project/projectList";
	    }

	    model.addAttribute("project", pNo);
	    return "project/tab/files";
	}
	
	// AJAX 요청을 받아 카테고리별 자료 목록을 JSON으로 반환하기 
	@GetMapping("/filesAjax")
	@ResponseBody
	public PaginationInfoVO<ProjectFileVO> getFilesByAjax(
			@RequestParam("prjctNo") Integer prjctNo, 
			@RequestParam("fileTy") String fileTy,
			@RequestParam(name="currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model){
		
		// 페이징 검색 
		PaginationInfoVO<ProjectFileVO> pagingVO = new PaginationInfoVO<>(6,5);
		
		// 검색 기능 추가 
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
//			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setCurrentPage(currentPage);
		
		// ProjectFileVO 객체에 검색 및 정렬 정보 설정 
		ProjectFileVO  pfVO = new ProjectFileVO();
		pfVO.setPrjctNo(prjctNo);
		pfVO.setFileTy(fileTy);
		
		pagingVO.setData(pfVO);
		pagingVO.setFileTy(fileTy);
		
		// 전체 게시글 수 조회 
		int totalRecord = pfService.selectFileCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);

		//검색 및 페이징이 반영된 파일 목록 조회
		List<ProjectFileVO> fileList = pfService.selectFileAjaxList(pagingVO);
		pagingVO.setDataList(fileList);
		
		return pagingVO;
		
	}
	
	

	// 자료 등록 페이지 불러오기 
	@GetMapping("/filesInsert")
	public String getFilesInsert(@AuthenticationPrincipal CustomUser user, @RequestParam int prjctNo, Model model) {
		
		
		
		String empNo = user.getUsername();
		
	
		
		model.addAttribute("prjctNo", prjctNo);
		return "project/tab/files_insert";
	}
	
	
	
	
	// 자료 페이지 등록
	@PostMapping("/filesInsert")
	public String filesInsert(
	    // 💡 @ModelAttribute를 사용하여 폼 데이터를 ProjectFileVO 객체에 자동 바인딩
	    @ModelAttribute ProjectFileVO pFile,
	    RedirectAttributes ra,
	    @RequestParam("fileUpload") List<MultipartFile> uploadFiles,
	    @AuthenticationPrincipal CustomUser user) {
	    
	    String empNo = user.getUsername();
	    int prjctNo = pFile.getPrjctNo();
	    
	    log.info("pFile: {}", pFile);

	    
	 
	    
	 // 2. 서버 측 파일 유효성 검사
	    if (uploadFiles == null || uploadFiles.isEmpty() || uploadFiles.get(0).isEmpty()) {
	    	ra.addFlashAttribute("error", "첨부파일은 1개 이상 등록해야 합니다!");
	        return "redirect:/project/filesInsert?prjctNo=" + prjctNo;
	    }
	        
	    int result = pfService.insertProjectFiles(pFile, uploadFiles, empNo);
	    
	    if(result > 0 ) {
	        ra.addFlashAttribute("message", "자료 등록이 완료되었습니다!");
	    } else {
	        ra.addFlashAttribute("error", "자료 등록에 실패하셨습니다!");
	    }
	    
	    return "redirect:/project/files?prjctNo=" + prjctNo;
	}
	
	
	// 자료 상세페이지 
	@GetMapping("/filesDetail")
	public String FilesDetail(@RequestParam int prjctFileNo, Model model) {
		log.info("자료 상세페이지 호출, prjctFileNo={}", prjctFileNo);
		
		// 프로젝트 파일 번호와 일치하는 프로젝트 참여자들 조회
		List<ProjectPerticipantVO> ptcpntList = pfService.selectProjectPrtcptn(prjctFileNo);
		
		// 서비스에서 상세 정보를 조회하는 메서드 호출 
		ProjectFileVO file = pfService.selectProjectFileDetail(prjctFileNo);
		
		model.addAttribute("files", file);
		model.addAttribute("ptcpntList", ptcpntList);
		return "project/tab/files_detail";
	}
	
	@GetMapping("/file/download/{fileNo}")
    @ResponseBody
    public ResponseEntity<byte[]> downloadFile(@PathVariable int fileNo) {
        log.info("파일 다운로드 요청, fileNo={}", fileNo);

        InputStream in = null;
        ResponseEntity<byte[]> entity = null;

        try {
            // 1. fileNo로 FilesVO 정보 조회
            FilesVO filesVO = pfService.selectFileByNo(fileNo);
            log.info("조회된 파일 정보: {}", filesVO);
            if (filesVO == null) {
                log.warn("해당 파일(fileNo={})이 존재하지 않습니다.", fileNo);
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }

            String savedNm = filesVO.getSavedNm();
            String originalNm = filesVO.getOriginalNm();
            String fullFilePath = uploadPath + File.separator + savedNm;

            log.info("파일의 실제 경로: {}", fullFilePath);
            
            File file = new File(fullFilePath);
            if (!file.exists()) {
                log.error("파일이 실제 경로에 존재하지 않습니다: {}", fullFilePath);
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);

            // 2. 파일 이름 인코딩 처리
            String fileName = URLEncoder.encode(originalNm, "UTF-8").replaceAll("\\+", "%20");

            // 3. Content-Disposition 헤더 설정
            headers.add("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            // 4. 파일을 바이트 배열로 읽어와 ResponseEntity로 반환
            in = new FileInputStream(file);
            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
            
            log.info("파일 다운로드 성공: {}", originalNm);

        } catch (IOException e) {
            log.error("파일 다운로드 중 오류 발생", e);
            entity = new ResponseEntity<byte[]>(HttpStatus.INTERNAL_SERVER_ERROR);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    log.error("InputStream 닫는 중 오류 발생", e);
                }
            }
        }
        return entity;
    }

	
	
	
	// 자료 수정페이지
	@GetMapping("/filesUpdate")
	public String getFilesUpdate(@RequestParam int prjctFileNo, Model model, @AuthenticationPrincipal CustomUser user, RedirectAttributes ra) {
		
		log.info("수정페이지 호출 완료!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		String empNo = user.getUsername();
		
		// 해당 자료 정보 조회
		ProjectFileVO pFile = pfService.selectProjectFileDetail(prjctFileNo);
		
		model.addAttribute("files", pFile);
		return "project/tab/files_update";
	}
	
	
	// 자료 페이지 수정 처리
	@PostMapping("/filesUpdate")
	public String filesUpdate(
	        @ModelAttribute ProjectFileVO pFile,
	        @RequestParam(value = "fileUpload", required = false) List<MultipartFile> uploadFiles,
	        @RequestParam(value = "deleteFileNoList", required = false) List<Integer> deleteFileNoList,
	        @AuthenticationPrincipal CustomUser user, RedirectAttributes ra) {
	    
	    log.info("업데이트 처리=======================================");

	    // 수정 전에 상세페이지에 대한 정보 가져오기
	    ProjectFileVO originalFile = pfService.selectProjectFileDetail(pFile.getPrjctFileNo());

	    // 가져온 정보가 없을 경우에 잘못된 요청으로 반환
	    if (originalFile == null) {
	        ra.addFlashAttribute("error", "해당 자료를 찾을 수 없습니다.");
	        return "redirect:/project/files?prjctNo=" + pFile.getPrjctNo();
	    }

	    String empNo = user.getUsername();
//	    String fileUploaderId = originalFile.getFileUploader();
//
//	    if (fileUploaderId == null || !empNo.equals(fileUploaderId)) {
//	        ra.addFlashAttribute("error", "자료 수정 권한이 없습니다!");
//	        return "redirect:/project/filesDetail?prjctFileNo=" + pFile.getPrjctFileNo();
//	    }

	    pFile.setFileUploader(empNo);
	    
	    ServiceResult result = pfService.updateProjectFiles(pFile, uploadFiles, deleteFileNoList);

	    if (result.equals(ServiceResult.OK)) {
	        ra.addFlashAttribute("message", "자료 수정이 완료되었습니다!");
	    } else {
	        ra.addFlashAttribute("error", "자료 수정에 실패했습니다!");
	    }

	    log.info("수정 요청 pFile 객체:{}", pFile);
	    
	    return "redirect:/project/filesDetail?prjctFileNo=" + pFile.getPrjctFileNo();
	}

	
	
	// 자료 수정 페이지에서 개별 파일 삭제 AJAX 요청 처리
	@PostMapping("/file/{fileNo}/deleteAttach")
	@ResponseBody
	public String deleteAttach(@PathVariable int fileNo) {
	    log.info("개별 파일 삭제 요청, fileNo={}", fileNo);
	    
	    // 파일 논리적 삭제 및 물리적 파일 삭제
	    ServiceResult result = pfService.deleteFileByFileNo(fileNo);
	    
	    // 삭제 성공 여부에 따라 응답 반환
	    if (result.equals(ServiceResult.OK)) {
	        return "SUCCESS";
	    } else {
	        return "FAIL";
	    }
	}
	
	
	// 자료 삭제하기 (AJAX 요청 처리)
		@PostMapping("/fileDelete")
		@ResponseBody
		public String deleteFile(@RequestParam("fileNo") int fileNo) {
			log.info("자료 삭제 요청, fileNo={}", fileNo);

			// 서비스 레이어를 호출하여 파일 삭제 로직 실행
			ServiceResult result = pfService.deleteProjectFile(fileNo);

			if(result.equals(ServiceResult.OK)) {
				return "SUCCESS"; // 성공 시 "SUCCESS" 문자열 반환
			}else {
				return "FAIL"; // 실패 시 "FAIL" 문자열 반환
			}
		}
	
	
	
	
}
	
	

