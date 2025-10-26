package kr.or.ddit.employee.project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
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

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.employee.boards.notice.controller.MediaUtils;
import kr.or.ddit.employee.project.service.Iestimate;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PrqudoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectEstimateController {

	@Autowired
	private Iestimate service;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@GetMapping("/estimate")
	public String estimatePanel(@RequestParam Integer prjctNo, Model model) {
		
		List<PrqudoVO> prqudoList = service.estimateList(prjctNo);
		
		// 총 견적 금액을 계산
		long totalAmount = 0;
		for (PrqudoVO prqudo : prqudoList) {
		    totalAmount += prqudo.getEstmtAmount();
		}

		// 계산된 총액을 모델에 추가
		model.addAttribute("totalAmount", totalAmount);
		model.addAttribute("prqudoList", prqudoList);
		model.addAttribute("prjctNo", prjctNo);
		
		return "project/tab/estimate";
	}
	
	
	@PostMapping("/estimateInsert")
	public String estimateInsert(PrqudoVO prq, RedirectAttributes ra, 
			@RequestParam List<MultipartFile> uploadFiles, Model model, @AuthenticationPrincipal CustomUser user) {
		
		String empNo = user.getUsername();
		
		// 파일 그룹번호 생성
		
		int fileGroupNo = service.generateFileGroupNo();
		prq.setFileGroupNo(fileGroupNo);
		
		// 사원번호 생성
		prq.setEmpNo(empNo);
		
		// 견적서 insert
		service.insert(prq);
		
		// 파일 insert
				if(uploadFiles != null && !uploadFiles.isEmpty()) {
					for(MultipartFile file : uploadFiles) {
						if(!file.isEmpty()) {
							String originalFileName = file.getOriginalFilename();
							String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
							
							FilesVO fileVO = new FilesVO();
							
							fileVO.setFileGroupNo(fileGroupNo);
							fileVO.setOriginalNm(originalFileName);
							fileVO.setSavedNm(saveFileName);
							fileVO.setFilePath("/upload/" + saveFileName);
							fileVO.setFileSize((int) file.getSize());
							fileVO.setFileUploader(prq.getEmpNo());
			                fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
			                fileVO.setFileMime(file.getContentType());
			                
			                service.insertFile(fileVO);
			                
			                File saveFile = new File(uploadPath + saveFileName);
			                try {
			                	file.transferTo(saveFile);
			                } catch (IOException e) {
			                	e.printStackTrace();
			                }
						}
					}
				}

		ra.addFlashAttribute("msg", "견적서 등록 완료!");
		ra.addAttribute("prjctNo", prq.getPrjctNo());
		return "redirect:/project/estimate";
		
	}
	
	
	@GetMapping("/estimateInsert")
	public String showEstimateInsertForm(@RequestParam int prjctNo, Model model) {
		model.addAttribute("prjctNo", prjctNo);
		return "project/tab/estimate_insert";
	}
	
	@GetMapping("/estimateDetail")
	public String estimateDetail(@RequestParam int prqudoNo, Model model) {
		log.info("견적서 상세 조회 요청 ! - prqudoNo: { }", prqudoNo);
		PrqudoVO prqVO = service.selectEstimate(prqudoNo);
		model.addAttribute("prjct", prqVO);
		return "project/tab/estimate_detail";
	}
	
	// 업데이트 폼 요청
	@GetMapping("/estimateUpdate")
	public String estimateUpdateForm(@RequestParam int prqudoNo, Model model) {
		log.info("견적서 수정 폼 요청...!");
		
		PrqudoVO prqVO = service.selectEstimate(prqudoNo);
		model.addAttribute("prq", prqVO);
		
		return "project/tab/estimate_update";
	}
	
	@PostMapping("/estimateUpdate")
	public String estimateUpdate(PrqudoVO prqVO, RedirectAttributes ra, @RequestParam(required = false) List<MultipartFile> uploadFiles, @AuthenticationPrincipal CustomUser user) {
		log.info("prqVO : " + prqVO.toString());
		
		String empNo = user.getUsername();
		prqVO.setEmpNo(empNo);
		
		// 견적서 업데이트
		service.estimateUpdate(prqVO);

		// 새로운 파일 업로드 처리
		if (uploadFiles != null && !uploadFiles.isEmpty() && !uploadFiles.get(0).isEmpty()) {
			
			// 기존 파일 그룹번호 가져오기
			int fileGroupNo = prqVO.getFileGroupNo();
			
			if(fileGroupNo == 0) {
				fileGroupNo = service.generateFileGroupNo();
				prqVO.setFileGroupNo(fileGroupNo);
				service.updateFileGroupNo(prqVO);
			}
			
			 for (MultipartFile file : uploadFiles) {
	                if (!file.isEmpty()) {
	                    String originalFileName = file.getOriginalFilename();
	                    String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	                    
	                    FilesVO fileVO = new FilesVO();
	                    fileVO.setFileGroupNo(fileGroupNo); // 기존 파일 그룹 번호 사용
	                    fileVO.setOriginalNm(originalFileName);
	                    fileVO.setSavedNm(saveFileName);
	                    fileVO.setFilePath("/upload/" + saveFileName);
	                    fileVO.setFileSize((int) file.getSize());
	                    fileVO.setFileUploader(prqVO.getEmpNo());
	                    log.info("EmpNo ----------------------------" + prqVO.getEmpNo());
	                    fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
	                    fileVO.setFileMime(file.getContentType());    
	                    
	                    service.insertFile(fileVO);
	                    
	                    // 실제 서버에 파일 저장
	                    // 실제 서버에 파일 저장
	                    try {
	                        File saveFile = new File(uploadPath, saveFileName);
	                        file.transferTo(saveFile);
	                    } catch (IOException e) {
	                        log.error("파일 저장 중 오류 발생", e);
	                    }
	                }
	            }
	        }
	  
		ra.addFlashAttribute("msg", "견적서 수정 완료!");
		return "redirect:/project/estimateDetail?prqudoNo=" + prqVO.getPrqudoNo();

}
	
	
	 // 파일 다운로드 메서드
    @GetMapping("/estimate/download/{savedNm}") 
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
    
    @PostMapping("/estimate/deleteFile")
    @ResponseBody
    public String deleteFile(@RequestParam int fileNo) {
    	int result = service.updateFileDelYn(fileNo);
    	return result > 0 ? "OK" : "FAIL";
    }

    @PostMapping("/estimate/delete")
    public String deleteEstimate(@RequestParam int prqudoNo, RedirectAttributes ra) {
        log.info("견적서 삭제 요청 = prqudoNo {} " , prqudoNo);
        
        PrqudoVO prqVO = service.selectEstimate(prqudoNo);
        
        if(prqVO != null) {
            
            int fileGroupNo = prqVO.getFileGroupNo();
            
            if (fileGroupNo > 0) {
                service.deleteFileGroupNo(fileGroupNo);
            }
            
            service.deleteEstimate(prqudoNo);
            
            ra.addFlashAttribute("msg", "게시글 삭제 완료!");
      
            return "redirect:/project/estimate?prjctNo=" + prqVO.getPrjctNo();        
        }
        
        return "redirect:/project/estimate"; 
    }
}
