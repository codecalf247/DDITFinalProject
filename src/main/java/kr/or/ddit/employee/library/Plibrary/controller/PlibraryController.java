package kr.or.ddit.employee.library.Plibrary.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

import kr.or.ddit.employee.library.Plibrary.service.Iplibrary;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("main")
public class PlibraryController {
	
	@Autowired
	private Iplibrary service;
	
	
	
	// application.properties 파일에 설정된 경로를 주입받음
    @Value("${kr.or.ddit.upload.path}")
    private String uploadPath;
	
	// 파일 업로드
	@ResponseBody
	@PostMapping("/puploadFile")
	public ResponseEntity<Map<String, String>> uploadFile(@RequestParam MultipartFile[] uploadFiles, @RequestParam int folderNo, @AuthenticationPrincipal CustomUser user) {
		
		log.info("puploadFile 실행...!");
		
		Map<String, String> response = new HashMap<>();
		String empNo = user.getUsername();	// 로그인한 사용자 이름
		
		// 파일 검증
		if (uploadFiles == null || uploadFiles.length == 0) {
		    response.put("status", "error");
		    response.put("msg", "파일이 선택되지 않았습니다.");
		    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
		}

		for (MultipartFile file : uploadFiles) {
			if(!file.isEmpty()) {
				 try {
					 String originalFileName = file.getOriginalFilename();
                     String savedName = UUID.randomUUID().toString() + "_" + originalFileName;
                     String filePath = "/upload/" + savedName;

                     FolderFileVO folderFileVO = new FolderFileVO();
                     folderFileVO.setEmpNo(empNo);
                     folderFileVO.setFolderNo(folderNo);
                     folderFileVO.setOriginalNm(originalFileName);
                     folderFileVO.setSavedName(savedName);
                     folderFileVO.setFilePath(filePath);
                     folderFileVO.setFileSize((int) file.getSize());
                     folderFileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(file.getSize()));
                     folderFileVO.setFileMime(file.getContentType());
                     folderFileVO.setDelYn("N");
                     
                     // 개인 파일 insert
                     service.PinsertFile(folderFileVO);
                     
                     // 물리적 파일 저장
                     File saveFile = new File(uploadPath, savedName);
                     file.transferTo(saveFile);
				 } catch (IOException e) {
                 	log.error("파일 업로드 실패", e);
                 	response.put("status", "error");
                 	response.put("msg", "파일 업로드에 실패했습니다.");
                 	return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
                 } catch (Exception e) {
                 	log.error("파일 등록 중 오류 발생", e);
                 	response.put("status", "error");
                 	response.put("msg", "파일 등록 중 오류가 발생했습니다.");
                 	return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
                 }
			}
		}
		
		response.put("status", "success");
		response.put("msg", "파일 등록 완료!");
		return new ResponseEntity<>(response, HttpStatus.OK);
	}
	
	// 개인 폴더 생성 (10001)
	@ResponseBody
	@PostMapping("/puploadFolder")
	public ResponseEntity<Map<String, String>> puploadFolder(FoldersVO foldersVO, @AuthenticationPrincipal CustomUser user) {
		
		log.info("puploadFolder 실행...!");
		
		Map<String, String> response = new HashMap<>();
		String empNo = user.getUsername();
		
		foldersVO.setEmpNo(empNo);
		foldersVO.setDelYn("N");
		foldersVO.setFolderTy("10001");
		
		try {
			service.PinsertFolder(foldersVO);
			response.put("status", "success");
			response.put("msg", "개인 폴더 생성 완료!"); 
			return new ResponseEntity<>(response, HttpStatus.OK);
		 } catch (Exception e) {
	        log.error("폴더 생성 중 오류 발생", e);
	        response.put("status", "error");
	        response.put("msg", "개인 폴더 생성에 실패했습니다.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	     }
	}
	
	// JSP를 반환하는 메서드
    @GetMapping("/personallibrary")
    public String personallibrary(Model model, @AuthenticationPrincipal CustomUser user,
            @RequestParam(defaultValue = "1") int upperFolder,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchWord
    		) {
        
        String empNo = user.getUsername();
        
        // 데이터베이스에서 총 용량을 바이트 단위로 가져오기
        Long totalSizeInBytes = service.selectTotalFileSize(empNo);
        String formattedTotalSize = "0 B"; // 기본 값
        if(totalSizeInBytes != null) {
        	formattedTotalSize = FileUtils.byteCountToDisplaySize(totalSizeInBytes);
        }
        
        log.info("upperFolder : {} ", upperFolder);
        
        // 반환된 값을 모델에 담아 전달
        model.addAttribute("totalSize", formattedTotalSize);
        model.addAttribute("totalCapacity", "1 GB"); 	// 총 용량은 고정 값
        
        // 2. 폴더 목록 조회
        Map<String, Object> folderParam = new HashMap<>();
        folderParam.put("empNo", empNo);
        folderParam.put("upperFolder", upperFolder);
        folderParam.put("delYn", "N");
        folderParam.put("searchType", searchType);
        folderParam.put("searchWord", searchWord);    
        List<FoldersVO> folderList = service.selectPfolderList(folderParam);
        
        // 3. 파일 목록 조회
        Map<String, Object> fileParam = new HashMap<>();
        fileParam.put("empNo", empNo);
        fileParam.put("folderNo", upperFolder);
        fileParam.put("searchType", searchType);
        fileParam.put("searchWord", searchWord);
        folderParam.put("delYn", "N");
        List<FolderFileVO> fileList = service.selectPfileList(fileParam);
        
        
        // 4. 현재 폴더의 상위 폴더 경로 조회
        List<FoldersVO> pathList = service.getParentFolders(upperFolder);

        
        model.addAttribute("folders", folderList);
        model.addAttribute("files", fileList);
        model.addAttribute("pathList", pathList);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);
        
        log.info("personallibrary 실행...! 폴더 목록 수: " + folderList.size());
        log.info("personallibrary 실행...! 파일 목록 수: " + fileList.size());
        
        return "library/personallibrary";
    }

	// JSON 데이터를 반환하는 메서드 (Ajax용)
	@ResponseBody
	@GetMapping("/pFolderAndFileList")
	public ResponseEntity<Map<String, Object>> pFolderAndFileList(@AuthenticationPrincipal CustomUser user, 
			@RequestParam(defaultValue = "1") int upperFolder) {
		
		String empNo = user.getUsername();
		
		Map<String, Object> folderAndFileMap = new HashMap<>();
		
		// 1. 폴더 목록 조회
		Map<String, Object> folderParam = new HashMap<>();
		folderParam.put("empNo", empNo);
		folderParam.put("upperFolder", upperFolder);
		List<FoldersVO> folderList = service.selectPfolderList(folderParam);
		
		// 2. 파일 목록 조회
		Map<String, Object> fileParam = new HashMap<>();
		fileParam.put("empNo", empNo);
		fileParam.put("folderNo", upperFolder);
		List<FolderFileVO> fileList = service.selectPfileList(fileParam);
		
		folderAndFileMap.put("folders", folderList);
		folderAndFileMap.put("files", fileList);
		
		return new ResponseEntity<>(folderAndFileMap, HttpStatus.OK);
	}
	
	// 파일 또는 폴더 이동 처리
	@ResponseBody
	@PostMapping("/moveItem")
	public ResponseEntity<Map<String, String>> moveItem(@RequestParam String type, 
	                                                    @RequestParam int itemId, 
	                                                    @RequestParam int targetFolderNo, 
	                                                    @AuthenticationPrincipal CustomUser user) {
	    log.info("moveItem 실행...! type: {}, itemId: {}, targetFolderNo: {}", type, itemId, targetFolderNo);

	    Map<String, String> response = new HashMap<>();
	    try {
	        Map<String, Object> param = new HashMap<>();
	        
	        // 이동 대상이 파일인 경우
	        if ("file".equals(type)) {
	            param.put("fileNo", itemId);
	            param.put("targetFolderNo", targetFolderNo);
	            service.updateFileFolder(param);
	            response.put("msg", "파일이 성공적으로 이동되었습니다.");
	        } 
	        // 이동 대상이 폴더인 경우
	        else if ("folder".equals(type)) {
	            param.put("folderNo", itemId);
	            param.put("targetFolderNo", targetFolderNo);
	            service.updateFolderParent(param);
	            response.put("msg", "폴더가 성공적으로 이동되었습니다.");
	        } else {
	            response.put("status", "error");
	            response.put("msg", "잘못된 이동 요청입니다.");
	            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
	        }

	        response.put("status", "success");
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    } catch (Exception e) {
	        log.error("이동 중 오류 발생", e);
	        response.put("status", "error");
	        response.put("msg", "이동 중 오류가 발생했습니다.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 파일 다운로드 기능
	@GetMapping("/downloadFile/{fileNo}")
	public ResponseEntity<byte[]> downloadFile(@PathVariable int fileNo) {
		
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		try {
			
			// 1. fileNo로 파일 정보(경로, 원본명, 저장명)를 조회
			FolderFileVO fileVO = service.selectFileByFileNo(fileNo);
			
			if(fileVO == null) {
				log.info("파일을 찾을 수 없습니다. fileNo : " + fileNo);
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
		
			// 2. 물리적 파일 경로 설정
	        String savedName = fileVO.getSavedName();
	        String fullFilePath = uploadPath + File.separator + savedName;
	        
	        // 3. 파일 스트림 생성
	        in = new FileInputStream(fullFilePath);
	        
	        // 4. HTTP 헤더 설정
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	        
	        // 한글 파일명 처리를 위해 원본 파일명(originalNm) 사용
	        String originalNm = new String(fileVO.getOriginalNm().getBytes("UTF-8"), "ISO-8859-1");
	        headers.add("Content-Disposition", "attachment;filename=\"" + originalNm + "\"");
	        
	        // 5. 파일 데이터를 바이트 배열로 변환하여 응답
	        entity  = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);

	    } catch(Exception e) {
	        log.error("파일 다운로드 중 오류 발생", e);
	        entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
	    } finally {
	        if (in != null) {
	            try {
	                in.close();
	            } catch(IOException e) {
	                log.error("파일 스트림 닫기 실패", e);
	            }
	        }
	    }
	    
	    return entity;
	}
	
	// 폴더 삭제
	@PostMapping("/deleteFolder")
	@ResponseBody
	public Map<String, Object> deleteFolder(@RequestParam int folderNo) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        service.deleteFolder(folderNo);
	        response.put("status", "success");
	        response.put("msg", "폴더가 휴지통으로 이동되었습니다.");
	    } catch (Exception e) {
	        log.error("폴더 삭제 실패", e);
	        response.put("status", "error");
	        response.put("msg", "폴더 삭제에 실패했습니다.");
	    }
	    return response;
	}
	
	// 파일 삭제
	@PostMapping("/deleteFile")
	@ResponseBody
	public Map<String, Object> deleteFile(@RequestParam int fileNo) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        service.deleteFile(fileNo);
	        response.put("status", "success");
	        response.put("msg", "폴더가 휴지통으로 이동되었습니다.");
	    } catch (Exception e) {
	        log.error("폴더 삭제 실패", e);
	        response.put("status", "error");
	        response.put("msg", "폴더 삭제에 실패했습니다.");
	    }
	    return response;
	}
	
	// 폴더 복원
	@PostMapping("/restoreFolder")
	@ResponseBody
	public Map<String, Object> restoreFolder(@RequestParam int folderNo) {
	    Map<String, Object> status = new HashMap<>();
	    try {
	        service.restoreFolder(folderNo);
	        status.put("status", "success");
	        status.put("msg", "폴더가 성공적으로 복원되었습니다.");
	    } catch (Exception e) {
	        log.error("폴더 복원 실패", e);
	        status.put("status", "error");
	        status.put("msg", "폴더 복원에 실패했습니다.");
	    }
	    return status;
	}

	// 파일 복원
	@PostMapping("/restoreFile")
	@ResponseBody
	public Map<String, Object> restoreFile(@RequestParam int fileNo) {
	    Map<String, Object> status = new HashMap<>();
	    
	    try {
	        service.restoreFile(fileNo);
	        status.put("status", "success");
	        status.put("msg", "파일이 성공적으로 복원되었습니다.");
	    } catch (Exception e) {
	        log.error("파일 복원 실패", e);
	        status.put("status", "error");
	        status.put("msg", "파일 복원에 실패했습니다.");
	    }
	    return status;
	}
	@GetMapping("/trashcan")
	public String getTrashcan(Model model, @AuthenticationPrincipal CustomUser user) {
		model.addAttribute("type", "personal");
	    return "library/trashcan";
	}

	// JSON 데이터를 반환하는 새로운 메서드 추가
	@ResponseBody
	@GetMapping("/trashcanData")
	public Map<String, Object> getTrashcanData(@AuthenticationPrincipal CustomUser user) {
	    String empNo = user.getUsername();
	    Map<String, Object> response = new HashMap<>();

	    // 1. DEL_YN이 'Y'인 폴더 목록 조회
	    Map<String, Object> folderParam = new HashMap<>();
	    folderParam.put("empNo", empNo);
	    folderParam.put("delYn", "Y");
	    List<FoldersVO> folderList = service.selectPyfolderList(folderParam);

	    // 2. DEL_YN이 'Y'인 파일 목록 조회
	    Map<String, Object> fileParam = new HashMap<>();
	    fileParam.put("empNo", empNo);
	    fileParam.put("delYn", "Y");
	    List<FolderFileVO> fileList = service.selectPyfileList(fileParam);

	    response.put("folders", folderList);
	    response.put("files", fileList);
	    
	    return response;
	}
	
	// 파일 영구 삭제
	@PostMapping("/permanentlyDeleteFile")
	@ResponseBody
	public Map<String, Object> permanentlyDeleteFile(@RequestParam int fileNo) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        service.permanentlyDeleteFile(fileNo);
	        response.put("status", "success");
	        response.put("msg", "파일이 완전히 삭제되었습니다.");
	    } catch (Exception e) {
	        log.error("파일 영구 삭제 실패", e);
	        response.put("status", "error");
	        response.put("msg", "파일 영구 삭제에 실패했습니다.");
	    }
	    return response;
	}

	// 폴더 영구 삭제
	@PostMapping("/permanentlyDeleteFolder")
	@ResponseBody
	public Map<String, Object> permanentlyDeleteFolder(@RequestParam int folderNo) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        service.permanentlyDeleteFolder(folderNo);
	        response.put("status", "success");
	        response.put("msg", "폴더가 완전히 삭제되었습니다.");
	    } catch (Exception e) {
	        log.error("폴더 영구 삭제 실패", e);
	        response.put("status", "error");
	        response.put("msg", "폴더 영구 삭제에 실패했습니다.");
	    }
	    return response;
	}
}