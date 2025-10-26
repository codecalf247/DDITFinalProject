package kr.or.ddit.employee.project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.service.IProjectPhotosService;
import kr.or.ddit.employee.project.service.IProjectService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPhotosVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectPhotosController {

    @Autowired
    private IProjectPhotosService pService;
    
    @Autowired
    private IProjectService projectService;
    
    
    
    @Value("${kr.or.ddit.upload.path}")
    private String uploadPath;

    
    
    
    
 // 프로젝트 사진 목록 페이지 가져오기 (PAGINATION 적용)
    @GetMapping("/photos/list")
    public String photosList(
    		@RequestParam Integer prjctNo, 
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchWord,
            Model model) {
        
        // 1. PaginationInfoVO 설정
        // ProjectPhotosVO가 T에 해당되지만, VO 안에 프로젝트 번호와 검색 정보만 담아도 됩니다.
        PaginationInfoVO<ProjectPhotosVO> pagingVO = new PaginationInfoVO<>();
        
        // 사진 목록에서는 검색 타입(searchType)이 특별히 필요하지 않고, 제목 검색만 한다고 가정합니다.
        if(StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchType("title"); // 제목 검색으로 고정 (Mapper에서 처리)
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord); // JSP에 검색어 전달
        }
        
        // 프로젝트 번호를 VO에 설정 (Mapper에서 WHERE 조건으로 사용)
        ProjectPhotosVO conditionVO = new ProjectPhotosVO();
        conditionVO.setPrjctNo(prjctNo);
        pagingVO.setData(conditionVO); // VO에 검색 조건을 담아 Mapper로 전달
        
        // 화면 크기 및 현재 페이지 설정 (사진 목록은 한 페이지에 8~12개 정도가 적당하지만, 일단 10개로 설정)
        pagingVO.setScreenSize(8); // 한 페이지에 12개 항목 표시
        pagingVO.setBlockSize(5);   // 페이지 블록 5개
        pagingVO.setCurrentPage(currentPage);
        
        // 2. 총 레코드 수 조회
        int totalRecord = pService.selectPhotoCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        
        // 3. 목록 데이터 조회
        List<ProjectPhotosVO> dataList = pService.selectPhotoListWithPaging(pagingVO);
        pagingVO.setDataList(dataList);
        
        // 4. 프로젝트 기본 정보 조회
        ProjectVO project = projectService.selectProjectByNo(prjctNo);
        
        // 5. Model에 담아 JSP로 전달
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("photoList", dataList); // dataList는 pagingVO 안에 있지만, 기존 코드 호환을 위해 추가
        model.addAttribute("project", project);
        model.addAttribute("prjctNo", prjctNo); // JSP에서 사용할 수 있도록 명시적으로 추가
        
        return "project/tab/photos";
    }

    
    // 프로젝트 사진 상세 페이지 
    @GetMapping("/photos/detail/{photoNo}")
    public String photosDetail(@RequestParam("prjctNo") int prjctNo, @PathVariable("photoNo") int photoNo, Model model) {
        
    	ProjectPhotosVO photo = pService.selectPhotoDetail(photoNo);
    	if(photo == null) {
    		return "redirect:/project/photos/list?prjctNo=" + prjctNo;
    	}
    	
    	ProjectVO project = projectService.selectProjectByNo(prjctNo);
    	
    	model.addAttribute("photo", photo);
        model.addAttribute("project", project);
        return "project/tab/photos_detail";
    }
    
    
    // 사진 등록 페이지 가져오기 
    @GetMapping("/photos/insert")
    public String getPhotosInsert(
    		@RequestParam("prjctNo") int prjctNo, Model model) {
    	
    	// 공통 코드 테이블에서 공정 유형 (그룹 ID '25') 목록을 조회하여 JSP 전달 
    	List<CommonCodeVO> categoryCodes = projectService.selectCommonCodes("25"); 
    	
        model.addAttribute("prjctNo", prjctNo);
        model.addAttribute("categoryCodes", categoryCodes);
        
        return "project/tab/photos_insert";
    }
    
    // 사진 등록 처리하기
    @PostMapping("/photos/insert")
    @ResponseBody // 메서드 반환 값을 HTTP 응답 본문으로 직접 사용하도록 지정
    public ResponseEntity<Map<String, Object>> photosInsert(
            @RequestParam("prjctNo") int prjctNo,
            @AuthenticationPrincipal CustomUser customUser,
            ProjectPhotosVO photoVO,
            // 💡 가장 중요한 수정: @RequestParam("files") -> @RequestParam("files[]")
            @RequestParam("files[]") List<MultipartFile> files,
            @RequestParam("category") List<String> categories) {

        log.info("--- photosInsert 메서드 시작 (JSON 응답) ---");
        log.info("요청 URL: /project/photos/insert");
        log.info("넘어온 prjctNo: {}", prjctNo);
        log.info("넘어온 제목 (sptPhotoTitle): {}", photoVO.getSptPhotoTitle());
        log.info("선택된 공정유형 목록 (categories): {}", categories);
        
        if (files != null) {
            log.info("files 파라미터가 존재함. 파일 개수: {}", files.size());
            for (MultipartFile file : files) {
                log.info("파일명: {}, 파일 크기: {}", file.getOriginalFilename(), file.getSize());
            }
        } else {
            log.warn("files 파라미터가 null입니다. MultipartResolver 설정을 확인하세요.");
        }
        
        // 이 부분은 기존 로직과 동일
        if (files == null || files.isEmpty() || files.get(0).isEmpty()) {
            log.error("파일이 누락되어 400 Bad Request를 반환합니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", "첨부파일이 누락되었습니다."));
        }

        photoVO.setPrjctNo(prjctNo);
        photoVO.setEmpNo(customUser.getMember().getEmpNo());
        photoVO.setCategories(categories);
            
        ServiceResult result = pService.insertPhoto(photoVO, files);
        
        if (result == ServiceResult.OK) {
            log.info("사진 등록 성공: /project/photos/list?prjctNo={}", prjctNo);
            return ResponseEntity.ok(
                Map.of("success", true, "message", "사진 등록이 완료되었습니다.",
                       "newId", photoVO.getSptPhotoNo(), "prjctNo", prjctNo)
            );
        } else {
            log.error("사진 등록 실패: 서비스 로직에서 오류 발생");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "사진 등록에 실패했습니다."));
        }
    }

    
    // 사진 등록 페이지 가져오기 
    @GetMapping("/photos/update/{photoNo}")
    public String photosUpdate(@PathVariable("photoNo") int photoNo, @RequestParam("prjctNo") int prjctNo, Model model) {
    	
    	// 상세 + 카테고리 코드 목록 
    	ProjectPhotosVO photo = pService.selectPhotoDetail(photoNo);
    	
    	if(photo == null) {
    		return "redirect:/project/photos/list?prjctNo=" + prjctNo;
    	}
    	List<CommonCodeVO> categoryCodes = projectService.selectCommonCodes("25"); // 공정 유형 그룹 
    	
    	// 선택된 코드 목록 
    	List<String> selectedCodes = (photo.getProcsTy() == null || photo.getProcsTy().isEmpty())
                ? List.of()
                : Arrays.asList(photo.getProcsTy().split(","));
    	
    	ProjectVO project = projectService.selectProjectByNo(prjctNo);
    	
    	model.addAttribute("project", project);
	    model.addAttribute("photo", photo);
	    model.addAttribute("categoryCodes", categoryCodes);
	    model.addAttribute("selectedCodes", selectedCodes);
    	 
    	
    	return "project/tab/photos_update";
    }
    
    
    // 사진 업데이트 처리
    @PostMapping("/photos/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPhotosUpdate(
    		@RequestParam("prjctNo") int prjctNo,
            @RequestParam("sptPhotoNo") int sptPhotoNo,
            @AuthenticationPrincipal CustomUser customUser,
            ProjectPhotosVO photoVO,
            @RequestParam(value = "category", required = false) List<String> categories,
            @RequestParam(value = "files[]", required = false) List<MultipartFile> newFiles,
            @RequestParam(value = "deleteFileNos[]", required = false) List<Integer> deleteFileNos) {
    	
    	log.info("=== photosUpdate start ===");
        log.info("prjctNo={}, sptPhotoNo={}, title={}", prjctNo, sptPhotoNo, photoVO.getSptPhotoTitle());
        log.info("categories={}, newFiles={}, deleteFileNos={}", categories, 
                 (newFiles==null?0:newFiles.size()), (deleteFileNos==null?0:deleteFileNos.size()));
        
        photoVO.setPrjctNo(prjctNo);
        photoVO.setSptPhotoNo(sptPhotoNo);
        photoVO.setEmpNo(customUser.getMember().getEmpNo());
        photoVO.setCategories(categories);

        ServiceResult result = pService.updatePhoto(photoVO, newFiles, deleteFileNos);

        if (result == ServiceResult.OK) {
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "수정이 완료되었습니다.",
                    "prjctNo", prjctNo,
                    "sptPhotoNo", sptPhotoNo
            ));
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "수정 중 오류가 발생했습니다."));
    	
    }
    
    
    @PostMapping("/photos/delete-files")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deletePhotoFiles(
            @RequestParam("fileNos[]") List<Integer> fileNos) {

        Map<String, Object> body = new HashMap<>();
        ServiceResult r = pService.deleteFilesImmediately(fileNos);

        if (r == ServiceResult.OK) {
            body.put("success", true);
            body.put("deleted", fileNos);
            return ResponseEntity.ok(body);
        } else {
            body.put("success", false);
            body.put("message", "삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
        }
    }
    
    
 // (최종 경로: /project/photos/delete)
    @GetMapping("/photos/delete")
    public String deletePhoto(@RequestParam int sptPhotoNo,
                              @RequestParam int prjctNo,
                              RedirectAttributes ra) {
        ServiceResult r = pService.deletePhoto(sptPhotoNo);
        ra.addFlashAttribute("msg", r == ServiceResult.OK ? "삭제되었습니다." : "삭제 실패");
        return "redirect:/project/photos/list?prjctNo=" + prjctNo;
    }
    
    
    
    
 // 파일 다운로드 (photos)
    @GetMapping("/photos/download/{savedNm}")
    @ResponseBody
    public ResponseEntity<byte[]> downloadPhoto(@PathVariable String savedNm) {

        InputStream in = null;
        ResponseEntity<byte[]> entity = null;

        try {
            String fullFilePath = uploadPath + File.separator + savedNm; // 업로드 경로 + 저장파일명
            in = new FileInputStream(fullFilePath);

            // 원본 파일명(랜덤prefix_원본명) 추출
            String downName = savedNm.substring(savedNm.indexOf("_") + 1);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.add(
                "Content-Disposition",
                "attachment;filename=\"" + new String(downName.getBytes("UTF-8"), "ISO-8859-1") + "\""
            );

            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);

        } catch (Exception e) {
            e.printStackTrace();
            entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
        } finally {
            if (in != null) {
                try { in.close(); } catch (IOException e) { e.printStackTrace(); }
            }
        }
        return entity;
    }
    
    
    
    
    
}