package kr.or.ddit.manager.adequip.controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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

import kr.or.ddit.ServiceResult;
import kr.or.ddit.manager.adequip.service.IAdequipService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adequip")
public class adequipWarehouse {

    @Autowired
    private IAdequipService adequipService;

    @Value("${kr.or.ddit.upload.path}")
    private String uploadPath;

    
    
    
    
    // 장비 목록
    @GetMapping("/adeqlist")
    public String adeqlist(Model model,
            @AuthenticationPrincipal CustomUser user,
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false, defaultValue = "") String statusFilter
    ){
        log.info("관리자장비 목록 페이지 실행....!");

        PaginationInfoVO<EqpmnVO> pagingVO = new PaginationInfoVO<>();

        
        
        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord);
        }

        if (StringUtils.isNotBlank(statusFilter)) {
            pagingVO.setStatusFilter(statusFilter);
            model.addAttribute("statusFilter", statusFilter);
        }

        pagingVO.setCurrentPage(currentPage);

        int totalRecord = adequipService.selectEqpmnCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<EqpmnVO> dataList = adequipService.selectEqpmnList(pagingVO);
        pagingVO.setDataList(dataList);

        List<CommonCodeVO> commonList = adequipService.selectCommonList("13");

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("eqpmnList", dataList);
        model.addAttribute("commonList", commonList);

        return "facilities/adeqlist";
    }

    // 장비 등록
    @PostMapping("/insert")
    public String insertEquip(@AuthenticationPrincipal CustomUser user,
                               EqpmnVO eqpmnVO,
                               @RequestParam("uploadFile") List<MultipartFile> uploadFile,
                               RedirectAttributes ra,
                               Model model) {

        String empNo = (user != null) ? user.getUsername() : null;
        log.info("장비 등록 요청: {}", eqpmnVO);

        // 오늘 날짜 세팅 (YYYYMMDD)
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        eqpmnVO.setEqpmnRegYmd(today);

        // 파일 그룹 번호 발급
        int fileGroupNo = adequipService.generateFileGroupNo();
        eqpmnVO.setFileGroupNo(fileGroupNo);

        // 파일 저장 처리 (공통 메서드 호출)
        saveFiles(uploadFile, fileGroupNo, empNo);

        // DB 저장
        int cnt = adequipService.insertEquip(eqpmnVO);
        if (cnt > 0) {
            ra.addFlashAttribute("msg", "장비 등록이 완료되었습니다!");
        } else {
            ra.addFlashAttribute("msg", "장비 등록 실패!");
        }

        return "redirect:/adequip/adeqlist";
    }

    /* 공통 파일 업로드 메서드 */
    private void saveFiles(List<MultipartFile> uploadFile, int fileGroupNo, String empNo) {
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

                    adequipService.insertFile(fileVO);

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

    // 장비 수정
    @PostMapping("/update")
    public String update(@AuthenticationPrincipal CustomUser user,
                         EqpmnVO eqpmnVO,
                         RedirectAttributes ra) {
    	log.info("### 장비 수정 데이터 : " + eqpmnVO.toString());
    	EmpVO empVO = user.getMember();
    	
    	eqpmnVO.setEmpNo(empVO.getEmpNo());
    	ServiceResult result = adequipService.updateEqpmn(eqpmnVO);
    	if(result.equals(ServiceResult.OK)) {
    		ra.addFlashAttribute("msg", "장비 수정에 성공했습니다!");
    	}else {
    		ra.addFlashAttribute("msg", "서버에러!, 장비 수정에 실패했습니다!");
    	}
 
        return "redirect:/adequip/adeqlist";
    }

 // 삭제(동기, 단건) - 폼 submit 용
    @PostMapping("/delete")
    public String delete(@RequestParam("eqpmnNo") String eqpmnNo,
                         @RequestParam(value = "fileGroupNo", required = false, defaultValue = "0") int fileGroupNo,
                         RedirectAttributes ra) {
        try {
            // 파일 그룹이 있으면 파일부터 소프트삭제 → 장비 삭제
            adequipService.deleteEqpmnCascade(eqpmnNo, fileGroupNo);
            ra.addFlashAttribute("msg", "장비가 삭제되었습니다.");
        } catch (Exception e) {
            log.error("장비 삭제 실패 eqpmnNo={}, fileGroupNo={}", eqpmnNo, fileGroupNo, e);
            ra.addFlashAttribute("msg", "장비 삭제에 실패했습니다.");
        }
        return "redirect:/adequip/adeqlist";
    }
    
    
    
    
    
    
    
    
}
