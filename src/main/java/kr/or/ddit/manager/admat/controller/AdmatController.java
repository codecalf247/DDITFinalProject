package kr.or.ddit.manager.admat.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.manager.admat.service.IAdmatService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admat")
public class AdmatController {

	@Autowired
	 private IAdmatService admatService;

    @Value("${kr.or.ddit.upload.path}")
    private String uploadPath;
	
	@GetMapping("/admatlist")
	public String admatlist(Model model,
            @AuthenticationPrincipal CustomUser user,
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false, defaultValue = "") String statusFilter
			){
		log.info("자재 관리 페이지실행....!");
		
		PaginationInfoVO<MtrilVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord);
        }

        if (StringUtils.isNotBlank(statusFilter)) {
            pagingVO.setStatusFilter(statusFilter);
            model.addAttribute("statusFilter", statusFilter);
        }

        pagingVO.setCurrentPage(currentPage);

        int totalRecord = admatService.selectmatCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<MtrilVO> dataList = admatService.selectmatList(pagingVO);
        pagingVO.setDataList(dataList);

        List<CommonCodeVO> mtrilTyList = admatService.selectCommonList("16");
        List<CommonCodeVO> unitList    = admatService.selectCommonList("14");

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("matList", dataList);
        model.addAttribute("mtrilTyList", mtrilTyList);
        model.addAttribute("unitList", unitList);
		
		
		return "facilities/admatlist";
	  } 
	
	// 자재 등록 (장비등록과 동일 패턴)
	@PostMapping("/insert")
	public String insertMaterial(@AuthenticationPrincipal CustomUser user,
	                             MtrilVO mtrilVO,
	                             @RequestParam(value = "uploadFile", required = false) List<MultipartFile> uploadFile,
	                             RedirectAttributes ra) {

	    String empNo = (user != null) ? user.getUsername() : null;
	    log.info("자재 등록 요청: {}", mtrilVO);

	    // 최소재고 기본값
	    if (mtrilVO.getMinStock() <= 0) {
	        mtrilVO.setMinStock(30);
	    }

	    // 파일 그룹 번호 발급(업로드가 있을 때만)
	    int fileGroupNo = 0;
	    boolean hasFiles = (uploadFile != null) && uploadFile.stream().anyMatch(f -> f != null && !f.isEmpty());
	    if (hasFiles) {
	        // 프로젝트에 맞는 서비스명 사용: selectNextFileGroupNo() 또는 generateFileGroupNo()
	        fileGroupNo = admatService.selectNextFileGroupNo();
	        mtrilVO.setFileGroupNo(fileGroupNo);
	        // 파일 저장 (이미 가지고 있는 saveFiles(List<MultipartFile>...) 재사용)
	        saveFile(uploadFile, fileGroupNo, empNo);
	    }

	    // DB 저장
	    int cnt = admatService.insertMtril(mtrilVO);
	    if (cnt > 0) {
	        ra.addFlashAttribute("msg", "자재 등록이 완료되었습니다!");
	    } else {
	        ra.addFlashAttribute("msg", "자재 등록 실패!");
	    }

	    return "redirect:/admat/admatlist";
	}
	
	
	
	
	 /* 공통 파일 업로드 메서드 */
    private void saveFile(List<MultipartFile> uploadFile, int fileGroupNo, String empNo) {
        if (uploadFile != null && !uploadFile.isEmpty()) {
            for (MultipartFile file : uploadFile) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                    FilesVO fileVO = new FilesVO();
                    fileVO.setFileGroupNo(fileGroupNo);
                    fileVO.setOriginalNm(originalFileName);
                    fileVO.setSavedNm(saveFileName);
                    fileVO.setFilePath("/upload/" + saveFileName);
                    fileVO.setFileSize((int) file.getSize());
                    fileVO.setFileUploader(empNo);
                    fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
                    fileVO.setFileMime(file.getContentType());

                    admatService.insertFile(fileVO);

                    File saveFile = new File(uploadPath + saveFileName);
                    try {
                        file.transferTo(saveFile);
                    } catch (IOException e) {
                        log.error("파일 저장 실패", e);
                    }
                }
            }
        }
    }
    /** 자재 수정 */
    @PostMapping("/update")
    public String updateMaterial(@AuthenticationPrincipal CustomUser user,
                                 MtrilVO mtrilVO,
                                 // input name="uploadFile" 그대로 사용. 단일 업로드여도 List 로 받으면 자동 1건 바인딩됨
                                 @RequestParam(value = "uploadFile", required = false) List<MultipartFile> uploadFiles,
                                 RedirectAttributes ra) {

        String empNo = (user != null) ? user.getUsername() : null;
        log.info("자재 수정 요청: {}", mtrilVO);

        // 최소재고 기본값 보정
        if (mtrilVO.getMinStock() <= 0) {
            mtrilVO.setMinStock(30);
        }

        // 새 파일 업로드가 있는지 확인
        boolean hasNewFile = uploadFiles != null
                && uploadFiles.stream().anyMatch(f -> f != null && !f.isEmpty());

        if (hasNewFile) {
            Integer fileGroupNo = mtrilVO.getFileGroupNo();

            // 파일그룹 없으면 새로 발급
            if (fileGroupNo == null || fileGroupNo == 0) {
                fileGroupNo = admatService.selectNextFileGroupNo();
                mtrilVO.setFileGroupNo(fileGroupNo);
            } else {
                // 기존 파일들 소프트 삭제(DEL_YN='Y')
                admatService.deleteFilesByGroupNo(fileGroupNo);
            }

            // 기존 saveFile 재사용(여러 건도 처리 가능; 단일 업로드면 1건만 저장됨)
            saveFile(uploadFiles, fileGroupNo, empNo);
        }

        int cnt = admatService.updateMtril(mtrilVO);
        ra.addFlashAttribute("msg", cnt > 0 ? "자재가 수정되었습니다." : "자재 수정 실패");

        return "redirect:/admat/admatlist";
    }
   
    @PostMapping("/delete")
    public String deleteMaterial(@RequestParam("mtrilId") String mtrilId,
                                 @RequestParam(value = "fileGroupNo", required = false, defaultValue = "0") int fileGroupNo,
                                 RedirectAttributes ra) {

        int affected = admatService.deleteMaterial(mtrilId, fileGroupNo); // <- int

        if (affected > 0) {
            ra.addFlashAttribute("msg", "자재가 삭제되었습니다.");
        } else {
            ra.addFlashAttribute("msg", "자재 삭제에 실패했습니다.");
        }
        return "redirect:/admat/admatlist";
    }
}
           