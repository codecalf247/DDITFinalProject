package kr.or.ddit.employee.mail.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.boards.notice.controller.MediaUtils;
import kr.or.ddit.employee.mail.service.IMailService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmailTrashVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.SendEmailBoxVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mail")
public class MailController {

    @Autowired
    private IMailService mailService;
    @Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

    /** 받은메일함 목록 */
    @GetMapping("/inbox")
    public String inbox(Model model,
                        @AuthenticationPrincipal CustomUser user,
                        @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
                        @RequestParam(required = false, defaultValue = "all") String searchType,
                        @RequestParam(required = false) String searchWord) {

        PaginationInfoVO<SendEmailBoxVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchType(searchType);
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchType", searchType);
            model.addAttribute("searchWord", searchWord);
        }

        // 로그인 사용자
        String empNo = (user != null) ? user.getUsername() : null;
        pagingVO.setEmpNo(empNo);

        // 페이징
        pagingVO.setCurrentPage(currentPage);
        int totalRecord = mailService.selectInboxCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setScreenSize(10);

        List<SendEmailBoxVO> dataList = mailService.selectInboxList(pagingVO);
        pagingVO.setDataList(dataList);

        log.info("inbox dataList: {}", dataList);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("inboxList", dataList);

        if (empNo != null) {
            EmpVO empInfo = mailService.getEmpInfo(empNo);
            model.addAttribute("empInfo", empInfo);
        }

        return "mail/inbox";
    }
    
    

    /** 받은메일 상세 (들어오면서 읽음 처리) */
    @GetMapping("/detail")
    public String detail(@RequestParam(required = false) Long recptnEmailboxNo,
    					 @RequestParam(required = false) Long refrnEmailboxNo,
                         @AuthenticationPrincipal CustomUser user,
                         Model model) {

    	
    	if(recptnEmailboxNo != null) {
    		// 1) 읽음 처리 (이미 읽었으면 그대로)
            mailService.markInboxAsRead(recptnEmailboxNo);
            
            
            // 2) 상세 조회 
            SendEmailBoxVO mail = mailService.getInboxDetail(recptnEmailboxNo);
            if (mail == null || "Y".equalsIgnoreCase(mail.getDelYn())) {
                // 없거나 삭제된 경우 목록으로
                return "redirect:/mail/inbox";
            }
            log.info(mail.toString());
            
            model.addAttribute("mail", mail);
    	}else if(refrnEmailboxNo != null){
    		// 1) 읽음 처리 (이미 읽었으면 그대로)
            mailService.markRefAsRead(refrnEmailboxNo);
            
            
            // 2) 상세 조회 
            SendEmailBoxVO mail = mailService.getRefDetail(refrnEmailboxNo);
            log.info(mail.toString());
            
            if (mail == null || "Y".equalsIgnoreCase(mail.getDelYn())) {
                // 없거나 삭제된 경우 목록으로
                return "redirect:/mail/inbox";
            }
            
            model.addAttribute("mail", mail);
    	}
        
        // 상단 카드 사용자 정보(옵션)
        if (user != null && user.getUsername() != null) {
            EmpVO empInfo = mailService.getEmpInfo(user.getUsername());
            model.addAttribute("empInfo", empInfo);
        }

        return "mail/detail";
    }
    

    /** 체크박스 다중 읽음 처리 **/
    @PostMapping(value = "/inbox/read", consumes = "application/json")
    @ResponseBody
    public ResponseEntity<?> markInboxListAsRead(@RequestBody ReadIds req,
                                                 @AuthenticationPrincipal CustomUser user) {
        if (req == null || req.getIds() == null || req.getIds().isEmpty()) {
            return ResponseEntity.badRequest().body("EMPTY");
        }
        String empNo = (user != null) ? user.getUsername() : null;
        int updated = mailService.markInboxListAsRead(empNo, req.getIds());
        return ResponseEntity.ok(updated); // 업데이트된 건수 반환
    }

    @PostMapping(value = "/inbox/delete", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String moveInboxToTrashForm(
            @RequestParam(name = "ids", required = false) List<Long> ids,
            @AuthenticationPrincipal CustomUser user,
            RedirectAttributes ra) {

        if (user == null || user.getUsername() == null) {
            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/mail/inbox";
        }
        
        // 👈 1. 유효성 검사: 선택된 메일이 없으면 경고 메시지 전달 후 종료
        if (ids == null || ids.isEmpty()) {
            ra.addFlashAttribute("msg", "삭제할 메일을 선택하세요.");
            return "redirect:/mail/inbox";
        }
        
        // 👈 2. 메일이 선택되었고, 클라이언트에서 이미 '확인'을 눌렀다고 가정하고 실제 삭제 처리
        String empNo = user.getUsername();
        int updated = mailService.markInboxListAsDeleted(empNo, ids);

        ra.addFlashAttribute("msg", updated + "건을 휴지통으로 이동했습니다.");
        return "redirect:/mail/inbox";
    }
    
    /** 휴지통 */
    @GetMapping("/trash")
    public String trash(Model model,
            @AuthenticationPrincipal CustomUser user,
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false, defaultValue = "all") String searchType,
            @RequestParam(required = false) String searchWord) {
        log.info("휴지통 페이지 실행....!!");
        
        PaginationInfoVO<EmailTrashVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchType(searchType);
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchType", searchType);
            model.addAttribute("searchWord", searchWord);
        }

        // 로그인 사용자
        String empNo = (user != null) ? user.getUsername() : null;
        pagingVO.setEmpNo(empNo);

        // 페이징
        pagingVO.setCurrentPage(currentPage);
        int totalRecord = mailService.selectTrashCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setScreenSize(10);

        List<EmailTrashVO> dataList = mailService.selectTrashList(pagingVO);
        pagingVO.setDataList(dataList);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("trashList", dataList);

        if (empNo != null) {
            EmpVO empInfo = mailService.getEmpInfo(empNo);
            model.addAttribute("empInfo", empInfo);
        }
    
        
    return "mail/trash";      
    }
    
    /** 휴지통 상세 */
    @GetMapping("/trash/trashdetail")
    public String trashDetail(@RequestParam Long emailNo,
                              @AuthenticationPrincipal CustomUser user,
                              Model model) {
        // 로그인 사용자(받는 사람) 검증용
        String empNo = (user != null) ? user.getUsername() : null;

        // 메일 번호로 삭제된 메일 내용 가져옴
        EmailTrashVO trashMail = mailService.getTrashInboxDetail(emailNo);
        
        if (trashMail == null) {
            // 없거나 권한 없는 경우 목록으로
            return "redirect:/mail/trash";
        }
        

        model.addAttribute("trashMail", trashMail);

        if (empNo != null) {
            EmpVO empInfo = mailService.getEmpInfo(empNo);
            model.addAttribute("empInfo", empInfo);
        }

        // 기존 mail/detail.jsp 재사용 (isTrash=true로 분기)
        return "mail/trashdetail";
    }

    // ===== 휴지통 → 받은함 복구 =====   
    @PostMapping(value = "/trash/restore", consumes = "application/json", produces = "application/json")
    @ResponseBody
    public ResponseEntity<?> restoreTrash(@RequestBody List<EmailTrashVO> data,
                                          @AuthenticationPrincipal CustomUser user) {

        String empNo = user.getUsername();
        int restored = 0;
        if(data.size() > 0) {
        	restored = mailService.restoreTrashEmail(data);
        }
        return ResponseEntity.ok(Map.of("success", true, "restored", restored));
    }
    
    
    

 // ===== 휴지통 영구삭제 (폼 전송 + 플래시 메시지) =====
    @PostMapping(value = "/trash/erase", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String eraseTrashForm(
            @RequestParam(name = "ids", required = false) List<Long> ids,
            @AuthenticationPrincipal CustomUser user,
            RedirectAttributes ra) {

        if (user == null || user.getUsername() == null) {
            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/mail/trash";
        }
        if (ids == null || ids.isEmpty()) {
            ra.addFlashAttribute("msg", "영구삭제할 메일을 선택하세요.");
            return "redirect:/mail/trash";
        }

        String empNo = user.getUsername();
        int erased = mailService.eraseTrash(empNo, ids);

        ra.addFlashAttribute("msg", erased + "건을 영구삭제했습니다.");
        return "redirect:/mail/trash";
    }
       
 // 사내 주소록: 이름/부서/이메일만 조회해서 JSON 반환
    @GetMapping(value = "/addressbook/emp", produces = "application/json")
    @ResponseBody
    public ResponseEntity<List<EmpVO>> addressbookEmployees(
            @RequestParam(name = "q", required = false) String q,           // 검색어(이름/부서/이메일)
            @RequestParam(name = "limit", required = false, defaultValue = "50") int limit) {

        log.info("주소록(사내) 조회 q='{}', limit={}", q, limit);

        // 서비스에서 EMP INNER JOIN DEPT, 필요한 컬럼만 SELECT 해서 EmpVO( empNm, deptNm, email ) 채워서 리턴
        List<EmpVO> list = mailService.findAddressbookEmployees(StringUtils.trimToEmpty(q), limit);

        return ResponseEntity.ok(list);
    }
	    
    /** 메일쓰기: 쿼리스트링으로 to/cc 넘어오면 입력칸 프리필 */
    @GetMapping("/form")
    public String mailForm(@RequestParam(required = false) String to,
                           @RequestParam(required = false) String cc,
                           @RequestParam(required = false) String empEmail,
                           Model model) {
        log.info("메일등록 페이지 실행....!! to={}, cc={}, empEmail={}", to, cc, empEmail); // ← 라벨 수정
        if (StringUtils.isNotBlank(to)) model.addAttribute("prefillTo", to);
        if (StringUtils.isNotBlank(cc)) model.addAttribute("prefillCc", cc);
        if (StringUtils.isNotBlank(empEmail)) model.addAttribute("empEmail", empEmail);
        return "mail/form";
    }

    
    
    
    /** 메일쓰기: 쿼리스트링으로 to/cc 넘어오면 입력칸 프리필 */
    @GetMapping("/draftForm")
    public String mailDraftForm(@RequestParam Long draftEmailNo, Model model) {
    	
    	SendEmailBoxVO email = mailService.getDraftEmail(draftEmailNo);
    	
    	log.info("emali정보 : {}", email);
    	model.addAttribute("email", email);
    	return "mail/form";
    }

  
 // ✅ 신규 추가: 예약/즉시/임시 분기 저장
    @PostMapping("/insert")
    public String mailInsert(@AuthenticationPrincipal CustomUser user,
                             SendEmailBoxVO emailVO,
                             RedirectAttributes ra, 
                             @RequestParam List<MultipartFile> uploadFiles,
                 			 Model model) {
        String empNo = (user != null) ? user.getUsername() : null;
        
        
        
        int fileGroupNo = mailService.generateFileGroupNo();
        emailVO.setFileGroupNo(fileGroupNo);
        emailVO.setWrterEmpNo(empNo);
        
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
     					fileVO.setFileUploader(empNo);
     	                fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
     	                fileVO.setFileMime(file.getContentType());
     	                
     	               mailService.insertFile(fileVO);
     	                
     	                File saveFile = new File(uploadPath + saveFileName);
     	                try {
     	                	file.transferTo(saveFile);
     	                } catch (IOException e) {
     	                	e.printStackTrace();
     	                }
     				}
     			}
     		}
        
        if ("Y".equalsIgnoreCase(emailVO.getTempSaveYn())) {
            ServiceResult draft = mailService.saveDraft(emailVO); // EMAIL만 INSERT 하는 서비스(신규)
            if (draft == ServiceResult.OK) {
                ra.addFlashAttribute("msg", "임시보관함에 저장했습니다.");
                return "redirect:/mail/temporary";                 // ← 임시보관함으로
            } else {
                ra.addFlashAttribute("msg", "임시저장에 실패했습니다.");
                return "redirect:/mail/form";
            }
        }
        
        

        // 예약 저장 분기: resveDsptchDt 존재 && 임시저장 아님
        if (StringUtils.isNotBlank(emailVO.getResveDsptchDt())
                && !"Y".equalsIgnoreCase(emailVO.getTempSaveYn())) {
            ServiceResult r = mailService.addReservedEmail(emailVO);
            if (r == ServiceResult.OK) {
                ra.addFlashAttribute("msg", "예약메일로 저장되었습니다.");
                return "redirect:/mail/reservation";
            } else {
                ra.addFlashAttribute("msg", "예약메일 저장에 실패했습니다.");
                return "redirect:/mail/form";
            }
        }

        // 기존 즉시발송/임시저장 흐름
        ServiceResult result = mailService.addEmail(emailVO);
        if (result == ServiceResult.OK) {
        	ra.addFlashAttribute("msg", "이메일 전송에 성공했습니다!");
            return "redirect:/mail/inbox";
        } else {
            ra.addFlashAttribute("msg", "이메일 전송에 실패했습니다!");
            return "redirect:/mail/form";
        }
    }
        
    /** 예약메일함 */
    @GetMapping("/reservation")
    public String reservation(Model model,
    	            @AuthenticationPrincipal CustomUser user,
    	            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
    	            @RequestParam(required = false, defaultValue = "all") String searchType,
    	            @RequestParam(required = false) String searchWord) {
    	
    	        log.info("예약페이지 페이지 실행....!!");
    	        
    	        PaginationInfoVO<SendEmailBoxVO> pagingVO = new PaginationInfoVO<>();

    	        if (StringUtils.isNotBlank(searchWord)) {
    	            pagingVO.setSearchType(searchType);
    	            pagingVO.setSearchWord(searchWord);
    	            model.addAttribute("searchType", searchType);
    	            model.addAttribute("searchWord", searchWord);
    	        }

    	        // 로그인 사용자
    	        String empNo = (user != null) ? user.getUsername() : null;
    	        pagingVO.setEmpNo(empNo);

    	        // 페이징
    	        pagingVO.setCurrentPage(currentPage);
    	        int totalRecord = mailService.selectReserveCount(pagingVO);
    	        pagingVO.setTotalRecord(totalRecord);
    	        pagingVO.setScreenSize(10);

    	        List<SendEmailBoxVO> dataList = mailService.selectReserveList(pagingVO);
    	        pagingVO.setDataList(dataList);

    	        model.addAttribute("pagingVO", pagingVO);
    	        model.addAttribute("reserveList", dataList);

    	        if (empNo != null) {
    	            EmpVO empInfo = mailService.getEmpInfo(empNo);
    	            model.addAttribute("empInfo", empInfo);
    	        }
    	    
    	        
    	    return "mail/reservation";      
    	    }
    
    @PostMapping("/reservation/erase")
    public String eraseReservationForm(
            @RequestParam("ids") List<Long> ids,
            RedirectAttributes ra,
            @AuthenticationPrincipal CustomUser user
    ) {
        if (user == null || user.getUsername() == null) {
            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/login"; // 필요 경로로 변경
        }
        if (ids == null || ids.isEmpty()) {
            ra.addFlashAttribute("msg", "삭제할 항목이 없습니다.");
            return "redirect:/mail/reservation";
        }

        String empNo = user.getUsername();
        int erased = mailService.eraseReservedEmails(empNo, ids);

        ra.addFlashAttribute("msg", erased > 0 ? "예약 메일이 삭제되었습니다." : "삭제할 수 있는 항목이 없습니다.");
        return "redirect:/mail/reservation";
    }
	   
	    
	    @GetMapping("/tempdetail")
	    public String reservedDetail(@RequestParam("emailNo") int emailNo,
	                                 @AuthenticationPrincipal CustomUser user,
	                                 Model model) {
	        String empNo = (user != null) ? user.getUsername() : null;

	        // 본인이 쓴 예약 메일만 조회
	        SendEmailBoxVO mail = mailService.selectReserveDetail(empNo, emailNo);
	        if (mail == null) {
	            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "예약 메일을 찾을 수 없습니다.");
	        }

	        // tempdetail.jsp가 recptnDt를 보여주도록 되어 있다면, 예약시간을 맵핑해줌
	        mail.setRecptnDt(mail.getResveDsptchDt());

	        model.addAttribute("mail", mail);
	        
	        log.info("받은메일함? : {}" , mail);
	        // 좌측 프로필 영역
	        if (empNo != null) {
	            EmpVO empInfo = mailService.getEmpInfo(empNo);
	            model.addAttribute("empInfo", empInfo);
	        }

	        return "mail/tempdetail";
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
    
    
	    /** 임시보관함 */
	    @GetMapping("/temporary")
	    public String temporary(Model model,
	            @AuthenticationPrincipal CustomUser user,
	            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
	            @RequestParam(required = false, defaultValue = "emailTitle") String searchType,
	            @RequestParam(required = false) String searchWord) {
	
	        log.info("예약페이지 페이지 실행....!!");
	        
	        PaginationInfoVO<SendEmailBoxVO> pagingVO = new PaginationInfoVO<>();

	        if (StringUtils.isNotBlank(searchWord)) {
	            pagingVO.setSearchType(searchType);
	            pagingVO.setSearchWord(searchWord);
	            model.addAttribute("searchType", searchType);
	            model.addAttribute("searchWord", searchWord);
	        }

	        // 로그인 사용자
	        String empNo = (user != null) ? user.getUsername() : null;
	        pagingVO.setEmpNo(empNo);

	        // 페이징
	        pagingVO.setCurrentPage(currentPage);
	        int totalRecord = mailService.selecttemporaryCount(pagingVO);
	        pagingVO.setTotalRecord(totalRecord);
	        pagingVO.setScreenSize(10);

	        List<SendEmailBoxVO> dataList = mailService.selecttemporaryList(pagingVO);
	        pagingVO.setDataList(dataList);

	        model.addAttribute("pagingVO", pagingVO);
	        model.addAttribute("temporaryList", dataList);

	        if (empNo != null) {
	            EmpVO empInfo = mailService.getEmpInfo(empNo);
	            model.addAttribute("empInfo", empInfo);
	        }
	    
	        
	    return "mail/temporary";      
	    }
    
	 // ===== 임시보관함: 체크박스 선택 항목 영구삭제 (A안: 폼 전송) =====
	    @PostMapping(value = "/temporary/erase", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
	    public String eraseDraftsForm(@RequestParam(name = "ids", required = false) List<Long> ids,
	                                  @AuthenticationPrincipal CustomUser user,
	                                  RedirectAttributes ra) {

	        // 1) 인증 확인
	        if (user == null || user.getUsername() == null) {
	            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
	            return "redirect:/login"; // 필요 시 경로 조정
	        }

	        // 2) 파라미터 확인
	        if (ids == null || ids.isEmpty()) {
	            ra.addFlashAttribute("msg", "삭제할 임시메일을 선택하세요.");
	            return "redirect:/mail/temporary";
	        }

	        String empNo = user.getUsername();

	        // 3) 서비스 호출: 본인 + TEMP_SAVE_YN='Y'만 안전 삭제
	        int erased = mailService.eraseDrafts(empNo, ids);

	        // 4) 결과 플래시 메시지 후 목록으로 리다이렉트
	        ra.addFlashAttribute("msg", erased > 0 ? (erased + "건을 영구삭제했습니다.") : "삭제할 수 있는 항목이 없습니다.");
	        return "redirect:/mail/temporary";
	    }
	    
	    
	    /** 참조메일함 */
	    @GetMapping("/refmail")
	    public String refmail(Model model,
	            @AuthenticationPrincipal CustomUser user,
	            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
	            @RequestParam(required = false, defaultValue = "all") String searchType,
	            @RequestParam(required = false) String searchWord) {
	    	log.info("참조메일함 실행....!!");
	    	
	    	  PaginationInfoVO<SendEmailBoxVO> pagingVO = new PaginationInfoVO<>();

  	        if (StringUtils.isNotBlank(searchWord)) {
  	            pagingVO.setSearchType(searchType);
  	            pagingVO.setSearchWord(searchWord);
  	            model.addAttribute("searchType", searchType);
  	            model.addAttribute("searchWord", searchWord);
  	        }

  	        // 로그인 사용자
  	        String empNo = (user != null) ? user.getUsername() : null;
  	        pagingVO.setEmpNo(empNo);

  	        // 페이징
  	        pagingVO.setCurrentPage(currentPage);
  	        int totalRecord = mailService.selectRefCount(pagingVO);
  	        pagingVO.setTotalRecord(totalRecord);
  	        pagingVO.setScreenSize(10);

  	        List<SendEmailBoxVO> dataList = mailService.selectRefList(pagingVO);
  	        pagingVO.setDataList(dataList);

  	        model.addAttribute("pagingVO", pagingVO);
  	        model.addAttribute("RefList", dataList);

  	        if (empNo != null) {
  	            EmpVO empInfo = mailService.getEmpInfo(empNo);
  	            model.addAttribute("empInfo", empInfo);
  	        }
	    	
	    	return "mail/refmail";
	    }
    
	 // 참조메일함 → 휴지통 이동 (A안: form-urlencoded + redirect)
	    @PostMapping(value = "/refmail/delete", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
	    public String moveRefToTrashForm(
	            @RequestParam(name = "ids", required = false) List<Long> ids,
	            @AuthenticationPrincipal CustomUser user,
	            RedirectAttributes ra
	    ) {
	        // 로그인 체크
	        if (user == null || user.getUsername() == null) {
	            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
	            return "redirect:/mail/refmail";
	        }

	        // 선택값 체크
	        if (ids == null || ids.isEmpty()) {
	            ra.addFlashAttribute("msg", "삭제할 메일을 선택하세요.");
	            return "redirect:/mail/refmail";
	        }

	        String empNo = user.getUsername();
	        int updated = mailService.markRefListAsDeleted(empNo, ids);

	        ra.addFlashAttribute("msg",
	                (updated > 0) ? (updated + "건을 휴지통으로 이동했습니다.") : "이동할 수 있는 항목이 없습니다.");
	        return "redirect:/mail/refmail";
	    }
    
    
    /** 보낸메일함 */
    @GetMapping("/sentbox")
    public String sentbox(Model model,
            @AuthenticationPrincipal CustomUser user,
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false, defaultValue = "all") String searchType,
            @RequestParam(required = false) String searchWord) {
    	
        	log.info("보낸메일함 실행....!!");
        	
        	PaginationInfoVO<SendEmailBoxVO> pagingVO = new PaginationInfoVO<>();

  	        if (StringUtils.isNotBlank(searchWord)) {
  	            pagingVO.setSearchType(searchType);
  	            pagingVO.setSearchWord(searchWord);
  	            model.addAttribute("searchType", searchType);
  	            model.addAttribute("searchWord", searchWord);
  	        }

  	        // 로그인 사용자
  	        String empNo = (user != null) ? user.getUsername() : null;
  	        pagingVO.setEmpNo(empNo);

  	        // 페이징
  	        pagingVO.setCurrentPage(currentPage);
  	        int totalRecord = mailService.selectSendCount(pagingVO);
  	        pagingVO.setTotalRecord(totalRecord);
  	        pagingVO.setScreenSize(10);

  	        List<SendEmailBoxVO> dataList = mailService.selectSendList(pagingVO);
  	        pagingVO.setDataList(dataList);

  	        model.addAttribute("pagingVO", pagingVO);
  	        model.addAttribute("SendList", dataList);

  	        if (empNo != null) {
  	            EmpVO empInfo = mailService.getEmpInfo(empNo);
  	            model.addAttribute("empInfo", empInfo);
  	        }
    	
    	 
    	return "mail/sent";
    }
	    
    @PostMapping(value = "/sentbox/delete", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String moveSentToTrashForm(
            @RequestParam(name = "ids", required = false) List<Long> ids,
            @AuthenticationPrincipal CustomUser user,
            RedirectAttributes ra
    ) {
        // 로그인 확인
        if (user == null || user.getUsername() == null) {
            ra.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/mail/sentbox";
        }
        // 선택값 확인
        if (ids == null || ids.isEmpty()) {
            ra.addFlashAttribute("msg", "삭제할 메일을 선택하세요.");
            return "redirect:/mail/sentbox";
        }

        String empNo = user.getUsername();
        int updated = mailService.markSentListAsDeleted(empNo, ids);

        ra.addFlashAttribute("msg",
                (updated > 0) ? (updated + "건을 휴지통으로 이동했습니다.") : "이동할 수 있는 항목이 없습니다.");
        return "redirect:/mail/sentbox";
    }

    /** 보낸메일 상세 조회 */
    @GetMapping("/senddetail")
    public String senddetail(@RequestParam("emailNo") Long emailNo,
                             @AuthenticationPrincipal CustomUser user,
                             Model model) {
        String empNo = (user != null) ? user.getUsername() : null;

        // 보낸 메일 상세 정보 조회 (첨부파일 포함)
        SendEmailBoxVO mail = mailService.selectSentDetail(empNo, emailNo);
        if (mail == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "보낸 메일을 찾을 수 없습니다.");
        }

        // 뷰로 데이터 전달
        model.addAttribute("mail", mail);
        model.addAttribute("empInfo", mailService.getEmpInfo(empNo));
        
        return "mail/senddetail";
    }
    
    /** 이메일 보낸 메일함에서 읽은 사람 확인 - 비동기 */
    @ResponseBody
    @GetMapping("/sentUserList/{emailNo}")
    public ResponseEntity<List<SendEmailBoxVO>> getSentEmailUserList(@PathVariable int emailNo){
    	List<SendEmailBoxVO> mailBoxList = mailService.getSentEmailUserList(emailNo);
    	return new ResponseEntity<List<SendEmailBoxVO>>(mailBoxList, HttpStatus.OK);
    }
    
    

    /** 다중 읽음 요청 바디용 VO */
    public static class ReadIds {
        private List<Long> ids;
        public List<Long> getIds() { return ids; }
        public void setIds(List<Long> ids) { this.ids = ids; }
    }
}
