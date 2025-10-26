	package kr.or.ddit.employee.library.Tlibrary.contoller;
	
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
	
	import kr.or.ddit.employee.library.Tlibrary.service.Itlibrary;
	import kr.or.ddit.vo.CustomUser;
	import kr.or.ddit.vo.EmpVO;
	import kr.or.ddit.vo.FolderFileVO;
	import kr.or.ddit.vo.FoldersVO;
	import lombok.extern.slf4j.Slf4j;
	
	@Slf4j
	@Controller
	@RequestMapping("/main")
	public class TlibraryController {
	
	    @Autowired
	    private Itlibrary service;
	    
	    @Value("${kr.or.ddit.upload.path}")
	    private String uploadPath;
	
	    // 팀별 자료실 페이지
	    @GetMapping("/teamlibrary")
	    public String teamlibrary(
	        Model model,
	        @AuthenticationPrincipal CustomUser user,
	        @RequestParam(defaultValue = "2") int upperFolder,
	        @RequestParam(required = false) String searchType,
	        @RequestParam(required = false) String searchWord
	    ) {
	    	
	    	EmpVO empVO = user.getMember();
	        int deptNo = empVO.getDeptNo();
	        Long totalSizeInBytes = service.selectTotalFileSize(deptNo);
	        String formattedTotalSize = "0 B"; // 기본 값
	        
	        if(totalSizeInBytes != null) {
	        	formattedTotalSize = FileUtils.byteCountToDisplaySize(totalSizeInBytes);
	        }
	        
	        // 반환된 값을 모델에 담아 전달
	        model.addAttribute("totalSize", formattedTotalSize);
	        model.addAttribute("totalCapacity", "20 GB"); 	// 총 용량은 고정 값
	
	        // 1. 폴더 목록 조회
	        Map<String, Object> folderParam = new HashMap<>();
	        folderParam.put("deptNo", deptNo);
	        folderParam.put("folderTy", "10002");
	        folderParam.put("upperFolder", upperFolder);
	        folderParam.put("delYn", "N");
	        folderParam.put("searchType", searchType);
	        folderParam.put("searchWord", searchWord);
	        List<FoldersVO> folderList = service.selectTfolderList(folderParam);
	
	        // 2. 파일 목록 조회
	        Map<String, Object> fileParam = new HashMap<>();
	        fileParam.put("deptNo", deptNo);
	        fileParam.put("folderNo", upperFolder);
	        fileParam.put("delYn", "N");
	        fileParam.put("searchType", searchType);
	        fileParam.put("searchWord", searchWord);
	        List<FolderFileVO> fileList = service.selectTfileList(fileParam);
	
	        // 3. 현재 폴더의 상위 폴더 경로 조회
	        List<FoldersVO> pathList = service.getParentFolders(upperFolder);
	        
	        log.info("pathList ====================== : {} ", pathList.toString());
	        model.addAttribute("folders", folderList);
	        model.addAttribute("files", fileList);
	        model.addAttribute("pathList", pathList);
	        model.addAttribute("searchType", searchType);
	        model.addAttribute("searchWord", searchWord);
	
	        return "library/teamlibrary";
	    }
	
	    // 팀별 파일 업로드
	    @ResponseBody
	    @PostMapping("/tuploadFile")
	    public ResponseEntity<Map<String, String>> uploadTFile(
	        @RequestParam MultipartFile[] uploadFiles,
	        @RequestParam int folderNo,
	        @AuthenticationPrincipal CustomUser user
	    ) {
	    	
	        log.info("tuploadFile 실행...!");
	        Map<String, String> response = new HashMap<>();
	    	
	    	EmpVO empVO = user.getMember();
	        String empNo = user.getUsername();
	        Integer deptNo = empVO.getDeptNo();
	        
	
	        if (uploadFiles == null || uploadFiles.length == 0) {
	            response.put("status", "error");
	            response.put("msg", "파일이 선택되지 않았습니다.");
	            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
	        }
	
	        for (MultipartFile file : uploadFiles) {
	            if (!file.isEmpty()) {
	                try {
	                    String originalFileName = file.getOriginalFilename();
	                    String savedName = UUID.randomUUID().toString() + "_" + originalFileName;
	                    String filePath = "/upload/" + savedName;
	
	                    FolderFileVO folderFileVO = new FolderFileVO();
	                    folderFileVO.setEmpNo(empNo);
	                    folderFileVO.setDeptNo(deptNo);
	                    folderFileVO.setFolderNo(folderNo);
	                    folderFileVO.setOriginalNm(originalFileName);
	                    folderFileVO.setSavedName(savedName);
	                    folderFileVO.setFilePath(filePath);
	                    folderFileVO.setFileSize((int) file.getSize());
	                    folderFileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(file.getSize()));
	                    folderFileVO.setFileMime(file.getContentType());
	                    folderFileVO.setDelYn("N");
	
	                    service.TinsertFile(folderFileVO);
	
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
	    
	    // 팀별 폴더 생성
	    @ResponseBody
	    @PostMapping("/tuploadFolder")
	    public ResponseEntity<Map<String, String>> uploadTFolder(
	        FoldersVO foldersVO,
	        @AuthenticationPrincipal CustomUser user
	    ) {
	        log.info("tuploadFolder 실행...!");
	        log.info(foldersVO.toString());
	        Map<String, String> response = new HashMap<>();
	    	
	    	EmpVO empVO = user.getMember();
	        String empNo = user.getUsername();
	        Integer deptNo = empVO.getDeptNo();
	
	        foldersVO.setEmpNo(empNo);
	        foldersVO.setDeptNo(deptNo);
	        foldersVO.setDelYn("N");
	        foldersVO.setFolderTy("10002"); // 팀 자료실 코드
	
	        try {
	            service.TinsertFolder(foldersVO);
	            response.put("status", "success");
	            response.put("msg", "팀 폴더 생성 완료!");
	            return new ResponseEntity<>(response, HttpStatus.OK);
	        } catch (Exception e) {
	            log.error("폴더 생성 중 오류 발생", e);
	            response.put("status", "error");
	            response.put("msg", "팀 폴더 생성에 실패했습니다.");
	            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	        }
	    }
	    
	    // 팀별 파일 다운로드
	    @GetMapping("/tdownloadFile/{fileNo}")
	    public ResponseEntity<byte[]> downloadTFile(@PathVariable int fileNo, @AuthenticationPrincipal CustomUser user) {
	    	// PlibraryController의 downloadFile 로직과 유사하게 구현
	    	InputStream in = null;
	    	ResponseEntity<byte[]> entity = null;
	    	
	    	try {
	    		FolderFileVO fileVO = service.selectFileByFileNo(fileNo);
	    		
	    		if (fileVO == null || !fileVO.getEmpNo().equals(user.getUsername())) {
	    			log.info("파일을 찾을 수 없거나 권한이 없습니다. fileNo: " + fileNo);
	    			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	    		}
	    		
	    		String savedName = fileVO.getSavedName();
	            String fullFilePath = uploadPath + File.separator + savedName;
	            in = new FileInputStream(fullFilePath);
	            
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	            String originalNm = new String(fileVO.getOriginalNm().getBytes("UTF-8"), "ISO-8859-1");
	            headers.add("Content-Disposition", "attachment;filename=\"" + originalNm + "\"");
	            
	            entity  = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
	    		
	    	} catch (Exception e) {
	    		log.error("팀 파일 다운로드 중 오류 발생", e);
	    		entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	    	} finally {
	    		if(in != null) {
	    			try {
	    				in.close();
	    			} catch (IOException e) {
	    				log.error("파일 스트림 닫기 실패", e);
	    			}
	    		}
	    	}
	    	return entity;
	    }
	
	    // 팀별 파일/폴더 이동
	    @ResponseBody
	    @PostMapping("/tmoveItem")
	    public ResponseEntity<Map<String, String>> tmoveItem(@RequestParam String type, @RequestParam int itemId, @RequestParam int targetFolderNo, @AuthenticationPrincipal CustomUser user) {
	        log.info("tmoveItem 실행...! type: {}, itemId: {}, targetFolderNo: {}", type, itemId, targetFolderNo);
	
	        Map<String, String> response = new HashMap<>();
	        try {
	            Map<String, Object> param = new HashMap<>();
	            if ("file".equals(type)) {
	                param.put("fileNo", itemId);
	                param.put("targetFolderNo", targetFolderNo);
	                service.updateFileFolder(param);
	                response.put("msg", "파일이 성공적으로 이동되었습니다.");
	            } else if ("folder".equals(type)) {
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
	    
	    @GetMapping("/ttrashcan")
		public String getTrashcan(Model model, @AuthenticationPrincipal CustomUser user) {
		    return "library/ttrashcan";
		}

		// JSON 데이터를 반환하는 새로운 메서드 추가
		@ResponseBody
		@GetMapping("/ttrashcanData")
		public Map<String, Object> getTrashcanData(@AuthenticationPrincipal CustomUser user) {
			EmpVO empVO = user.getMember();
		    String empNo = user.getUsername();
	        Integer deptNo = empVO.getDeptNo();
		    
	        
		    Map<String, Object> response = new HashMap<>();

		    // 1. DEL_YN이 'Y'인 폴더 목록 조회
		    Map<String, Object> folderParam = new HashMap<>();
		    folderParam.put("empNo", empNo);
		    folderParam.put("delYn", "Y");
		    folderParam.put("deptNo", deptNo);
		    log.info("부서번호 : {} ", empVO.toString());
		    log.info("부서번호 : {} ", deptNo);
		    List<FoldersVO> folderList = service.selectTyfolderList(folderParam);

		    // 2. DEL_YN이 'Y'인 파일 목록 조회
		    Map<String, Object> fileParam = new HashMap<>();
		    fileParam.put("empNo", empNo);
		    fileParam.put("delYn", "Y");
		    fileParam.put("deptNo", deptNo);
		    log.info("deptNo 번호 {} ------------", deptNo);
		    List<FolderFileVO> fileList = service.selectTyfileList(fileParam);

		    response.put("folders", folderList);
		    response.put("files", fileList);
		    
		    return response;
		}
	    
	    // 팀별 삭제
	    @PostMapping("/tdeleteFolder")
	    @ResponseBody
	    public Map<String, Object> tdeleteFolder(@RequestParam int folderNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.tdeleteFolder(folderNo);
	            response.put("status", "success");
	            response.put("msg", "폴더가 휴지통으로 이동되었습니다.");
	        } catch (Exception e) {
	            log.error("폴더 삭제 실패", e);
	            response.put("status", "error");
	            response.put("msg", "폴더 삭제에 실패했습니다.");
	        }
	        return response;
	    }
	    
	    @PostMapping("/tdeleteFile")
	    @ResponseBody
	    public Map<String, Object> tdeleteFile(@RequestParam int fileNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.tdeleteFile(fileNo);
	            response.put("status", "success");
	            response.put("msg", "파일이 휴지통으로 이동되었습니다.");
	        } catch (Exception e) {
	            log.error("파일 삭제 실패", e);
	            response.put("status", "error");
	            response.put("msg", "파일 삭제에 실패했습니다.");
	        }
	        return response;
	    }
	    
	    // 팀별 복원
	    @PostMapping("/trestoreFolder")
	    @ResponseBody
	    public Map<String, Object> trestoreFolder(@RequestParam int folderNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.trestoreFolder(folderNo);
	            response.put("status", "success");
	            response.put("msg", "폴더가 성공적으로 복원되었습니다.");
	        } catch (Exception e) {
	            log.error("폴더 복원 실패", e);
	            response.put("status", "error");
	            response.put("msg", "폴더 복원에 실패했습니다.");
	        }
	        return response;
	    }
	
	    @PostMapping("/trestoreFile")
	    @ResponseBody
	    public Map<String, Object> trestoreFile(@RequestParam int fileNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.trestoreFile(fileNo);
	            response.put("status", "success");
	            response.put("msg", "파일이 성공적으로 복원되었습니다.");
	        } catch (Exception e) {
	            log.error("파일 복원 실패", e);
	            response.put("status", "error");
	            response.put("msg", "파일 복원에 실패했습니다.");
	        }
	        return response;
	    }
	    
	    // 팀별 영구 삭제
	    @PostMapping("/tpermanentlyDeleteFile")
	    @ResponseBody
	    public Map<String, Object> tpermanentlyDeleteFile(@RequestParam int fileNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.tpermanentlyDeleteFile(fileNo);
	            response.put("status", "success");
	            response.put("msg", "파일이 완전히 삭제되었습니다.");
	        } catch (Exception e) {
	            log.error("파일 영구 삭제 실패", e);
	            response.put("status", "error");
	            response.put("msg", "파일 영구 삭제에 실패했습니다.");
	        }
	        return response;
	    }
	
	    @PostMapping("/tpermanentlyDeleteFolder")
	    @ResponseBody
	    public Map<String, Object> tpermanentlyDeleteFolder(@RequestParam int folderNo) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            service.tpermanentlyDeleteFolder(folderNo);
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