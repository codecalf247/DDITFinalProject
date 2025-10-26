package kr.or.ddit.employee.boards.notice.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.employee.boards.notice.service.INoticeService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/boards")
public class NoticeController {
	
	@Autowired 
	private INoticeService service;
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	@GetMapping("notice")
	public String notice() {
		log.info("notice 실행...!");
		return "boards/notice";
	}
	
	@GetMapping("noticeinsert")
	public String noticeinsert(Model model, @AuthenticationPrincipal CustomUser user) {
		EmpVO empVO = user.getMember(); // 로그인 사용자 정보
    	model.addAttribute("empNm", empVO.getEmpNm());

    	log.info("noticeinsert 실행...!");
		return "boards/noticeinsert";
	}
	
	@PostMapping("insert")
	public String insert(BoardVO board, RedirectAttributes ra,
	                     @RequestParam List<MultipartFile> uploadFiles,
	                     Model model,  @AuthenticationPrincipal CustomUser user) {
		
		String empNo = user.getUsername(); // 로그인 사용자 정보
		
	    // 1. 파일 그룹 번호 생성
	    int fileGroupNo = service.generateFileGroupNo();  // 시퀀스 or mapper에서 nextval
	    board.setFileGroupNo(fileGroupNo);
	    
	    // 2. 보내기 전에 사원번호 삽입
	    board.setEmpNo(empNo);

	    // 2-2. 게시글 insert
	    service.insert(board);

	    // 3. 파일 insert
	    if(uploadFiles != null && !uploadFiles.isEmpty()) {
	        for(MultipartFile file : uploadFiles) {
	            if(!file.isEmpty()) {
	            	String originalFileName = file.getOriginalFilename();
	            	String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	            	
	                FilesVO fileVO = new FilesVO();
	                fileVO.setFileGroupNo(fileGroupNo);
	                fileVO.setOriginalNm(originalFileName);
	                fileVO.setSavedNm(saveFileName); // 서버에 저장될 이름
	                fileVO.setFilePath("/upload/" + saveFileName);
	                fileVO.setFileSize((int) file.getSize());
	                fileVO.setFileUploader(board.getEmpNo());
	                fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
	                fileVO.setFileMime(file.getContentType());
	 

	                service.insertFile(fileVO);

	                // 실제 서버에 저장
	                File saveFile = new File(uploadPath + saveFileName);
	                try {
	                    file.transferTo(saveFile);
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	    }

	    //model.addAttribute("msg" , "등록 완료!");  // redirect에선 의미가 없음
	    ra.addFlashAttribute("msg" , "게시글 등록 완료!");
	    return "redirect:/boards/noticelist";
	}
	
	@GetMapping("noticedetail")
	public String detail(@RequestParam int boNo, Model model) { // @RequestParam("noticeNo")로 명시
		log.info("게시글 상세 조회 요청 - noticeNo: {}", boNo);
		BoardVO boardVO = service.selectNotice(boNo); 
		model.addAttribute("board", boardVO);
		return "boards/noticedetail";
	}
	
	@ResponseBody
	@GetMapping("/displayFile")
	public ResponseEntity<byte[]> displayFile(String fileName) {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		try {
			String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(uploadPath + "/" + fileName);
			
			if(mType != null) {  // 이미지 파일
				headers.setContentType(mType);
			}else {              // 일반적인 파일
			    fileName = fileName.substring(fileName.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				// 다운로드 처리 시 사용
				headers.add("Content-Disposition", "attachment;filename=\"" + 
				new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			}
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

	  // 파일 다운로드 메서드
    @GetMapping("/download/{savedNm}") 
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
    
    @GetMapping("noticelist")
	public String list(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model
			) {
		PaginationInfoVO<BoardVO> pagingVO = new PaginationInfoVO<>();
		// 검색 기능 추가
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			// 검색 후, 목록 페이지로 이동할 때 검색된 내용들 적용시키기 위한 데이터 전달
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
			
		}
		
		// 현재 페이지 전달 후, start/endRow, start/endPage 설정
		
		pagingVO.setScreenSize(7);
		pagingVO.setCurrentPage(currentPage);
		// 총 게시글 수 가져오기
		int totalRecord = service.selectNoticeCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 결정
		pagingVO.setTotalRecord(totalRecord);
		List<BoardVO> dataList = service.selectNoticeList(pagingVO);
		pagingVO.setDataList(dataList);
		model.addAttribute("pagingVO", pagingVO);	
		model.addAttribute("boardList", dataList);
		log.info("list 실행...!");
		return "boards/noticelist";
	}
    
    @GetMapping("noticeupdate")
	public String updateform(@RequestParam int boNo, Model model) { 
		log.info("게시글 상세 조회 요청 - noticeNo: {}", boNo);
		BoardVO boardVO = service.selectNotice(boNo); 
		model.addAttribute("board", boardVO);
		return "boards/noticeinsert";
	}
    
    @PostMapping("update")
    public String update(
        BoardVO boardVO,
        RedirectAttributes ra,
        @RequestParam(required = false) List<MultipartFile> uploadFiles, @AuthenticationPrincipal CustomUser user 
    ) {
        log.info("boardVO : "+boardVO.toString());
        
        String empNo = user.getUsername();
        boardVO.setEmpNo(empNo);
        
        // 1. 게시글 정보 업데이트
        service.update(boardVO);
        
        
        // 2. 새로운 파일 업로드 처리
        if (uploadFiles != null && !uploadFiles.isEmpty() && !uploadFiles.get(0).isEmpty()) {
            // 기존 파일 그룹 번호 가져오기
            int fileGroupNo = boardVO.getFileGroupNo();
            
            // 만약 기존 게시글에 파일 그룹 번호가 없었다면 새로 생성
            if (fileGroupNo == 0) { // BoardVO의 fileGroupNo가 primitive int일 경우 초기값 0
                fileGroupNo = service.generateFileGroupNo();
                boardVO.setFileGroupNo(fileGroupNo);
                service.updateFileGroupNo(boardVO); // 게시글에 새로 생성된 파일 그룹 번호 업데이트
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
                    fileVO.setFileUploader(boardVO.getEmpNo());
                    fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
                    fileVO.setFileMime(file.getContentType());
                    
                    // 파일 정보 DB에 insert
                    service.insertFile(fileVO);

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
        
        ra.addFlashAttribute("msg", "게시글 수정 완료!");
        return "redirect:/boards/noticedetail?boNo=" + boardVO.getBoardNo();
    }
    
    @PostMapping("/deleteFile")
    @ResponseBody
    public String deleteFile(@RequestParam int fileNo) {
        int result = service.updateFileDelYn(fileNo); // DEL_YN = 'Y'
        return result > 0 ? "OK" : "FAIL";
    }
    
    @PostMapping("delete")
    public String deleteBoard(@RequestParam int boNo, RedirectAttributes ra) {
        log.info("게시글 삭제 요청 - boNo: {}", boNo);

        BoardVO boardVO = service.selectNotice(boNo);
        
        // 게시글이 존재할 때만 모든 삭제 로직을 실행합니다.
        if (boardVO != null) {
            // 1. 파일 그룹 번호 가져오기
            int fileGroupNo = boardVO.getFileGroupNo();
            
            // 2. 파일 그룹 번호가 0보다 클 때만 파일 삭제 처리
            if (fileGroupNo > 0) {
                service.deleteFileGroupNo(fileGroupNo);
            }
            
            // 3. 게시글 삭제 처리
            service.deleteBoard(boNo);
            
            // 4. 성공 메시지 전달
            ra.addFlashAttribute("msg", "게시글 삭제가 완료되었습니다!");
        } else {
            // 게시글이 존재하지 않을 경우의 메시지
            ra.addFlashAttribute("msg", "게시글 삭제 실패!");
        }
        
        return "redirect:/boards/noticelist";
    }
    
}

	
