package kr.or.ddit.employee.eApproval.controller;

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

import kr.or.ddit.employee.eApproval.service.IeApprovalService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProxySanctnerVO;
import kr.or.ddit.vo.SanctnCCVO;
import kr.or.ddit.vo.SanctnDocVO;
import kr.or.ddit.vo.SanctnFormBkmkVO;
import kr.or.ddit.vo.SanctnFormVO;
import kr.or.ddit.vo.SanctnLineBkmkVO;
import kr.or.ddit.vo.SanctnerVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/eApproval")
public class eApprovalController {

	@Autowired
	private IeApprovalService service;
	
	@Value("${kr.or.ddit.stamp.upload.path}")
	private String stampPath;
	
	@Value("${kr.or.ddit.approval.file.upload.path}")
	private String filePath;
	
	@GetMapping("dashBoard")
	public String dashBoardForm(@AuthenticationPrincipal CustomUser user, Model model) {
		log.debug("dashBoardForm() 실행");
		
		String empNo = user.getUsername();
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setEmpNo(empNo);
		
		// 상신 진행 문서 cnt
		int getInProcessCnt = service.getApprovalInProcessCnt(pagingVO);
		
		// 결재 요청 문서 cnt
		int getInBoxCnt = service.getInboxCnt(pagingVO);

		// 처리 완료된 결재 cnt
		int getCompletedCnt = service.getCompletedCnt(pagingVO);
		
		// 반려된 결재 cnt
		int getRejectDocCnt = service.getRejectDocCnt(pagingVO);
		
		// 최근 기안 문서(상태가 끝났던 안끝났던)
		List<SanctnDocVO> sanctnDocList = service.getDashBoardList(empNo);
		
		// 결재즐겨찾기 List 가져오기
		List<SanctnFormBkmkVO> sanctnFormBkmkList = service.getSanctnFormBkmk(empNo);
		
		model.addAttribute("getInProcessCnt", getInProcessCnt);
		model.addAttribute("getInBoxCnt", getInBoxCnt);
		model.addAttribute("getCompletedCnt", getCompletedCnt);
		model.addAttribute("getRejectDocCnt", getRejectDocCnt);
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("sanctnFormBkmkList", sanctnFormBkmkList);
		
		return "eApproval/dashBoard";
	}
	
	@GetMapping("pending")
	public String pendingForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title")String searchType,
			@RequestParam(required=false)String searchWord) {
		log.debug("pendingForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currentPage);
		int cnt = service.getPendingCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		List<SanctnDocVO> sanctnDocList = service.getPendingList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("pagingVO", pagingVO); 
		
		return "eApproval/pendingApproval";
	}
	
	// 결재진행함
	@GetMapping("inProcess")
	public String inProcessForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1") int currentPage,
			@RequestParam(required=false, defaultValue="title") String searchType,
			@RequestParam(required=false) String searchWord){
		log.debug("inProcessForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		// 검색 기능
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		
		// 게시글 리스트 갯수 설정
		pagingVO.setScreenSize(10);
		pagingVO.setCurrentPage(currentPage);
		// 전체건수 가져오기
		int cnt = service.getApprovalInProcessCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		// inProcessList 가져오기
		List<SanctnDocVO> inProcessList = service.getApprovalInProcess(pagingVO);
		pagingVO.setDataList(inProcessList);
		
		model.addAttribute("inProcessList", inProcessList);
		model.addAttribute("cnt", cnt);
		model.addAttribute("pagingVO", pagingVO);
		
		return "eApproval/inProcessApproval";
	}
	
	// 결재완료함
	@GetMapping("completed")
	public String completedForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title")String searchType,
			@RequestParam(required=false)String searchWord) {
		log.debug("completedForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		String empNo = user.getUsername();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currentPage);
		
		int cnt = service.getCompletedCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		
		List<SanctnDocVO> sanctnDocList = service.getCompletedList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		log.debug("sanctnDocList : {}", sanctnDocList);
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("sanctnDocList", sanctnDocList);
		
		return "eApproval/completedApproval";
	}
	
	// 임시저장함
	@GetMapping("draft")
	public String draftForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1") int currentPage,
			@RequestParam(required=false, defaultValue="title") String searchType,
			@RequestParam(required=false) String searchWord) {
		log.debug("draftForm() 실행");
		String empNo = user.getUsername();
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currentPage);
		int cnt = service.getDraftDocCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		List<SanctnDocVO> sanctnDocList = service.getDraftDoc(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("cnt", cnt);
		model.addAttribute("pagingVO", pagingVO);
		
		return "eApproval/draft";
	}
	
	// 반려함
	@GetMapping("rejectDocument")
	public String rejectDocumentForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currrentPage,
			@RequestParam(required=false, defaultValue="title")String searchType,
			@RequestParam(required=false)String searchWord) {
		log.debug("rejectDocumentForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currrentPage);
		
		int cnt = service.getRejectDocCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		
		List<SanctnDocVO> sanctnDocList = service.getRejectDoc(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("sanctnDocList", sanctnDocList);
		
		return "eApproval/rejectDocument";
	}
	
	// 전자결재 수신함
	@GetMapping("inbox")
	public String inboxForm(@AuthenticationPrincipal CustomUser user, Model model,
		@RequestParam(name="page", required=false, defaultValue="1") int currentPage,
		@RequestParam(required=false, defaultValue="title") String searchType,
		@RequestParam(required=false) String searchWord){
		
		log.debug("inboxForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		// 검색 기능
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		
		// 현재 페이지 전달 후 start/endRow, start/endPage 설정
		pagingVO.setCurrentPage(currentPage);
		// 총 수신결재 가져오기
		int cnt = service.getInboxCnt(pagingVO);
		System.out.println(cnt);
		pagingVO.setTotalRecord(cnt);
		// sanctnDocList 가져오기
		List<SanctnDocVO> sanctnDocList = service.getInboxList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("cnt", cnt);
		model.addAttribute("pagingVO", pagingVO);
		
		return "eApproval/inbox";
	}
	
	@GetMapping("history")
	public String historyForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1") int currentPage,
			@RequestParam(required=false, defaultValue="title") String searchType,
			@RequestParam(required=false) String searchWord) {
		log.debug("historyForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		
		// 현재 페이지 전달
		pagingVO.setCurrentPage(currentPage);
		
		// 전체 total 수 가져오기
		int cnt = service.getHistoryCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		
		// 전체 결재내역 가져오기
		List<SanctnDocVO> sanctnDocList = service.getHistoryList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("cnt", cnt);
		return "eApproval/approvalHistory";
	}
	  
	@GetMapping("CCDocument")
	public String ccDocumentForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title")String searchType,
			@RequestParam(required=false)String searchWord) {
		log.debug("ccDocumentForm 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currentPage);
		
		int cnt = service.getCCDocCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		
		List<SanctnDocVO> sanctnDocList = service.getCCDocList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("cnt", cnt);
		model.addAttribute("sanctnDocList", sanctnDocList);
		
		return "eApproval/CCDocument";
	}
	
	@GetMapping("approvalFormFolder")
	public String getApprovalFolderList(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title") String searchType,
			@RequestParam(required=false) String searchWord){
		log.info("getApprovalFolderList() 출력");
		
		PaginationInfoVO<SanctnFormVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String loginEmpNo = user.getUsername();
		pagingVO.setCurrentPage(currentPage);
		
		int cnt = service.getApprovalFolderListCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		List<SanctnFormVO> sanctnFormFolderList = service.getApprovalFolderList(pagingVO);
		pagingVO.setDataList(sanctnFormFolderList);
		
		model.addAttribute("sanctnFormFolderList", sanctnFormFolderList);
		model.addAttribute("loginEmpNo", loginEmpNo);
		model.addAttribute("cnt", cnt);
		model.addAttribute("pagingVO", pagingVO);
		
		return "eApproval/approvalFormFolder";
	}
	
	@GetMapping("trash")
	public String trashForm(@AuthenticationPrincipal CustomUser user, Model model,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title")String searchType,
			@RequestParam(required=false)String searchWord) {
		log.debug("trashForm() 실행");
		
		PaginationInfoVO<SanctnDocVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		String empNo = user.getUsername();
		pagingVO.setEmpNo(empNo);
		pagingVO.setCurrentPage(currentPage);
		int cnt = service.getTrashDocCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		List<SanctnDocVO> sanctnDocList = service.getTrashList(pagingVO);
		pagingVO.setDataList(sanctnDocList);
		
		model.addAttribute("sanctnDocList", sanctnDocList);
		model.addAttribute("cnt", cnt);
		return "eApproval/trash";
	}
	
	// 문서 삭제
	@ResponseBody
	@PostMapping("trash/{sanctnDocNo}")
	public ResponseEntity<String> draftApprovalDocDel(@PathVariable String sanctnDocNo, Model model){
		log.debug("draftApprovalDocDel() 실행");
		
		int status = service.draftApprovalDocDel(sanctnDocNo);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
		
	}
	
	
	@GetMapping("approvalSetting")
	public String approvalSettingForm(@AuthenticationPrincipal CustomUser user, Model model) {
		log.info("approvalSettingForm() 실행!");
		
		String empNo = user.getUsername();
		log.info("로그인한 사용자:" + empNo);
		
		// 날인 등록 해놓았으면 가져오기
		String stampFilePath = service.getStampFilePath(empNo);
		
		String stampUrl = null;
		if(stampFilePath != null && !stampFilePath.isEmpty()) {
			stampUrl = stampFilePath.replace("//192.168.36.131/groovior", "/upload");
			model.addAttribute("stampUrl", stampUrl);
		}
		
		// 대결자 설정해 놓은 사람 있으면 가져오기
		ProxySanctnerVO proxyInfo = service.getProxyInfo(empNo);
		
		model.addAttribute("proxyInfo", proxyInfo);
		return "eApproval/approvalSetting";
	}
	
	@ResponseBody                                               
	@PostMapping("saveLine")
	public ResponseEntity<String> insertSaveLine(@RequestBody SanctnLineBkmkVO saveLine) {
		log.info("insertSaveLine() 실행! saveLine={}", saveLine);
		service.insertSaveLine(saveLine);
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("saveLineList")
	public List<SanctnLineBkmkVO> getSaveLineList(@RequestParam String empNo) {
		log.info("getSaveLineList() 실행! ");
		List<SanctnLineBkmkVO> saveLineList = service.getSaveLineList(empNo);
		return saveLineList;
	}
	
	@ResponseBody
	@GetMapping("saveLineEmp")
	public List<SanctnLineBkmkVO> getSaveLineEmp(@RequestParam int saveLineSelect){
		log.info("getSaveLineEmp() 실행! ");
		List<SanctnLineBkmkVO> saveLineEmp = service.getSaveLineEmp(saveLineSelect);
		return saveLineEmp;
	}
	
	@ResponseBody
	@PostMapping("sanctnDoc")
	public ResponseEntity<String> insertSanctnDoc(@RequestBody SanctnDocVO sanctnDoc){
		log.info("insertSanctnDoc() 실행! ");
		String sanctnDocNo = service.insertSanctnDoc(sanctnDoc);
		return new ResponseEntity<String>(sanctnDocNo, HttpStatus.OK);
	}
	
	// 대결자 지정
	@ResponseBody
	@PostMapping("proxySave")
	public ResponseEntity<Map<String, Object>> insertProxySanctner(@AuthenticationPrincipal CustomUser user, @RequestBody ProxySanctnerVO proxySanctner){
		log.info("insertProxySanctner() 실행! ");
		
		// 로그인한 사용자가 이미 대결자를 지정해뒀을 때
		String loginEmpNo = user.getUsername();
		String empNo = service.getEmpNo(loginEmpNo);
		
		log.debug("대결자 empNo: empNo : {}", empNo);
		
		// 이미 설정된 대결자가 있을 시 fail 반환
		if(loginEmpNo.equals(empNo)) {
			Map<String, Object> res = new HashMap<>(); 
			res.put("status", "FAIL");
			return new ResponseEntity<>(res, HttpStatus.OK);
		}else {
			service.insertProxySanctner(proxySanctner);
			
			Map<String, Object> res = new HashMap<>();
			res.put("status", "SUCCESS");
			res.put("proxySanctnerNo", proxySanctner.getProxySanctnerNo());
			res.put("startDate", proxySanctner.getBeginYmd());
			res.put("endDate", proxySanctner.getEndYmd());
			return new ResponseEntity<>(res, HttpStatus.OK);	
		}
	}
	
	@ResponseBody
	@PostMapping("proxyDelete")
	public ResponseEntity<String> deleteProxySanctner(@RequestParam int proxySanctnerNo){
		log.info("deleteProxySanctner() 실행!");
		service.deleteProxySanctner(proxySanctnerNo);
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("proxyInfo")
	public ProxySanctnerVO getProxySanctner(@RequestParam String empNo){
		log.info("getProxySanctnerList() 실행!" + empNo);
		log.info("결재자 사번: " + empNo);
		ProxySanctnerVO proxyInfo = service.getProxySanctner(empNo);
		
		if(proxyInfo == null) {
			log.info("대결자 정보 없음");
			return null;
		}else {
			log.info(proxyInfo.getProxyNm());
			return proxyInfo;
		}
	}
	
	@ResponseBody
	@PostMapping("sanctner")
	public ResponseEntity<String> insertSanctner(@AuthenticationPrincipal CustomUser user, @RequestBody List<SanctnerVO> sanctnerList){
		log.info("insertSanctner() 실행");
		
		for(SanctnerVO sanctner : sanctnerList) {
			log.info("결재자: {}", sanctner.getEmpNo());

			service.insertSanctner(sanctner);
		}
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 참조자 insert
	@ResponseBody
	@PostMapping("sanctnCC")
	public ResponseEntity<String> insertSanctnCC(@AuthenticationPrincipal CustomUser user, @RequestBody List<SanctnCCVO> sanctnCCList){
		log.info("insertSanctnCC() 실행");
		
		for(SanctnCCVO sancterCC : sanctnCCList) {
			log.info("참조자: {}", sancterCC.getEmpNo());
			service.insertSanctnCC(sancterCC);
		}
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 날인 저장
	@ResponseBody
	@PostMapping("insertStamp")
	public ResponseEntity<String> insertStamp(@AuthenticationPrincipal CustomUser user, MultipartFile file){
		log.debug("insertStamp() 실행");
		String empNo = user.getUsername();
		
		if(file != null && !file.isEmpty()) {
			String signFileNm = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
			String stampFilePath = stampPath + signFileNm; 
			
			log.debug("stampFilePath : ", stampFilePath);
			
			EmpVO empInfo = new EmpVO();
			empInfo.setEmpNo(empNo);
			empInfo.setSignFilePath(stampFilePath);
			
			service.insertStamp(empInfo);
			
			// 폴더 없으면 폴더 생성
			File dir = new File(stampPath);
			if(!dir.exists()) {
				dir.mkdirs();
			}
			
			// 최종 파일 객체
			File saveStamp = new File(stampPath, signFileNm);
			
			try {
				file.transferTo(saveStamp);
			}catch(IOException e) {
				e.printStackTrace();
			}
		}
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 날인 삭제
	@ResponseBody
	@PostMapping("delStamp")
	public ResponseEntity<String> deleteStamp(@AuthenticationPrincipal CustomUser user){
		log.debug("deleteStamp() 실행");
		String empNo = user.getUsername();
		
		service.deleteStamp(empNo);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 기안서 작성
	@GetMapping("register/{sanctnDocNo}")
	public String getApprovalRegisterForm(@AuthenticationPrincipal CustomUser user, @PathVariable String sanctnDocNo, Model model){
		log.debug("approvalWriteForm() 실행, sanctnDocNo:{}", sanctnDocNo);
		
		String empNo = user.getUsername();
		log.info("로그인한 사용자:" + empNo);
		
		// 날인 등록 해놓았으면 가져오기
		String stampFilePath = service.getStampFilePath(empNo);
		
		String stampUrl = null;
		if(stampFilePath != null && !stampFilePath.isEmpty()) {
			stampUrl = stampFilePath.replace("//192.168.36.131/groovior", "/upload");
			model.addAttribute("stampUrl", stampUrl);
		}
		
		// 결재문서 정보 가져오기
		SanctnDocVO sanctnDocInfo = service.getApprovalDocInfo(sanctnDocNo);
		
		// 결재자 가져오기
		List<SanctnerVO> sanctnerList = service.getApprovalSanctnerList(sanctnDocNo);
		
		// 참조자 가져오기
		List<SanctnCCVO> sanctnerCCList = service.getApprovalSanctnerCCList(sanctnDocNo);
		
		model.addAttribute("sanctnDocInfo", sanctnDocInfo);
		model.addAttribute("sanctnerList", sanctnerList);
		
		if(sanctnerCCList != null) {
			model.addAttribute("sanctnerCCList", sanctnerCCList);
		}
		return "eApproval/register";
	}
	
	// 재기안서 작성
	@GetMapping("reRegister/{reSanctnDocNo}")
	public String getApprovalReRegisterForm(@AuthenticationPrincipal CustomUser user, @PathVariable String reSanctnDocNo, 
			@RequestParam String sanctnDocNo, Model model){
		log.debug("approvalWriteForm() 실행, sanctnDocNo:{}", sanctnDocNo);
		
		String empNo = user.getUsername();
		log.info("로그인한 사용자:" + empNo);
		
		// 날인 등록 해놓았으면 가져오기
		String stampFilePath = service.getStampFilePath(empNo);
		
		String stampUrl = null;
		if(stampFilePath != null && !stampFilePath.isEmpty()) {
			stampUrl = stampFilePath.replace("//192.168.36.131/groovior", "/upload");
			model.addAttribute("stampUrl", stampUrl);
		}
		
		// 새결재문서 정보 가져오기
		SanctnDocVO sanctnDocInfo = service.getApprovalDocInfo(sanctnDocNo);
		
		// 전 문서 정보 가져오기
		SanctnDocVO lastSanctnDocInfo = service.getApprovalLastDocInfo(reSanctnDocNo);
		
		// 결재자 가져오기
		List<SanctnerVO> sanctnerList = service.getApprovalSanctnerList(sanctnDocNo);
		
		// 참조자 가져오기
		List<SanctnCCVO> sanctnerCCList = service.getApprovalSanctnerCCList(sanctnDocNo);
		
		log.debug("재기안문서 정보 확인: reSanctnDocInfo:{}", sanctnDocInfo);
		log.debug("이전기안문서 정보 확인: lastSanctnDocInfo:{}", lastSanctnDocInfo);
		
		model.addAttribute("sanctnDocInfo", sanctnDocInfo);
		model.addAttribute("sanctnerList", sanctnerList);
		model.addAttribute("sanctnDocNo", sanctnDocNo);
		model.addAttribute("lastSanctnDocInfo", lastSanctnDocInfo);
		
		if(sanctnerCCList != null) {
			model.addAttribute("reSanctnerCCList", sanctnerCCList);
		}
		return "eApproval/reRegister";
	}
	
	// 기안서 상신
	@ResponseBody
	@PostMapping("approvalDocRegister")
	public ResponseEntity<String> approvalDocRegister(@RequestBody SanctnDocVO sanctnDoc) {
		log.debug("approvalDocRegister() 실행, sanctnFormContent={}", sanctnDoc);
		
		service.approvalDocRegister(sanctnDoc);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 파일 업로드
	@ResponseBody
	@PostMapping("fileUpload")
	public ResponseEntity<Integer> approvalDocFileUpload(@RequestParam("files") List<MultipartFile> files,
			@RequestParam(name="type") String type,
			@RequestParam("sanctnDocNo") String sanctnDocNo,
			@AuthenticationPrincipal CustomUser user) throws Exception {
		
		log.debug("approvalDocFileUpload() 실행 files:{}", files);
		log.info("type : " + type);
		
		// 파일 그룹번호 생성
		Integer fileGroupNo = 0;
		
		// 파일 그룹번호 가져오기
		fileGroupNo = service.getSaveFileGroupNo(sanctnDocNo);
		if(type.equals("re")) {	// 재기안
			if(fileGroupNo == null) {
				fileGroupNo = service.getFileGroupNo();
			}
		}else {	// 기안
			if(fileGroupNo == null) {
				fileGroupNo = service.getFileGroupNo();
			}
		}
		
		if(files != null && !files.isEmpty()) {
			for(MultipartFile fileInfo : files) {
				FilesVO file = new FilesVO();     
				// 파일 그룹번호 저장
				file.setFileGroupNo(fileGroupNo);
				
				// 원본명 저장
				String originalNm = fileInfo.getOriginalFilename();
				file.setOriginalNm(originalNm);
				
				// 저장된 명 저장
				String savedNm = UUID.randomUUID().toString() + "_" + originalNm;
				file.setSavedNm(savedNm);
				
				// 파일 경로 저장
				file.setFilePath(filePath + savedNm);
				// 파일 크기 설정
				file.setFileSize((int) fileInfo.getSize());
				// 파일 업로더
				file.setFileUploader(user.getUsername());
				// 파일 크기 단위
				file.setFileFancysize(FileUtils.byteCountToDisplaySize(file.getFileSize()));
				// 파일 MIME
				file.setFileMime(fileInfo.getContentType());
				
				service.approvalFileRegister(file);
				
				// 폴더 없으면 폴더 생성
				File dir = new File(filePath);
				if(!dir.exists()) {
					dir.mkdirs();
				}
				
				// 최종 파일 객체
				File saveFile = new File(filePath, savedNm);
				
				try {
					fileInfo.transferTo(saveFile);
				}catch(IOException e) {
					e.printStackTrace();
				}
			}
			
		}
		
		return new ResponseEntity<Integer>(fileGroupNo, HttpStatus.OK);
	}
	
	// 전자결재 상세보기(기안자)
	@GetMapping("detail/{sanctnDocNo}")
	public String approvalDocDetail(@AuthenticationPrincipal CustomUser user, @RequestParam String drafterId ,@PathVariable String sanctnDocNo, Model model) {
		log.debug("approvalDocDetail() 실행, sanctnDocNo:{}", sanctnDocNo);
		
		// 현재 로그인한 사원
		String drafterNo = user.getUsername();
		
		// 기안자 날인 가져오기
		String empNo = drafterId;
		String stampFilePath = service.getStampFilePath(empNo);
		
		String stampUrl = null;
		if(stampFilePath != null && !stampFilePath.isEmpty()) {
			stampUrl = stampFilePath.replace("//192.168.36.131/groovior", "/upload");
			log.debug("stampUrl : ", stampUrl);
			model.addAttribute("stampUrl", stampUrl);
		}
		
		// 결재문서 정보 가져오기
		
		// 결재자 가져오기
		List<SanctnerVO> sanctnerList = service.getApprovalSanctnerList(sanctnDocNo);
		
		// 이전 결재자들이 승인 또는 전결시 날인 이미지 가져올 수 있도록 설정
		SanctnDocVO sanctnDocInfo = service.getApprovalDocInfo(sanctnDocNo);
		for(SanctnerVO sl : sanctnerList) {
			if(sl.getSignFilePath() != null && ("20003".equals(sl.getSanctnSttus()) || "20004".equals(sl.getSanctnSttus()))) {
				sl.setSignFilePath(sl.getSignFilePath().replace("//192.168.36.131/groovior", "/upload"));
			}else if("20005".equals(sl.getSanctnSttus())) {
				sl.setSignFilePath("/upload/stamp/전결.png");
			}
			
			// 현재 로그인한 사원의 날인 등록 여부 확인 후 결재권 부여하기 위한
			if(sl.getLastSanctner().equals(drafterNo) ) {
				String isSignFile = sl.getSignFilePath();
				
				log.debug("isSignFile : {}", isSignFile);
				model.addAttribute("isSignFile", isSignFile);
			}
		}
		
		// 참조자 가져오기
		List<SanctnCCVO> sanctnerCCList = service.getApprovalSanctnerCCList(sanctnDocNo);
		
		model.addAttribute("sanctnDocInfo", sanctnDocInfo);
		model.addAttribute("sanctnerList", sanctnerList);
		model.addAttribute("drafterNo", drafterNo);
		
		if(sanctnerCCList != null) {
			model.addAttribute("sanctnerCCList", sanctnerCCList);
		}
		
		
		
		return "eApproval/approvalDocDetail";
	}
	
	// 기안자 전자결재 상신 회수
	@ResponseBody
	@PostMapping("deleteApproval/{sanctnDocNo}")
	public ResponseEntity<String> deleteApprovalDoc(@PathVariable String sanctnDocNo){
		log.debug("deleteApprovalDoc() 실행");
		
		int result = service.deleteApprovalDoc(sanctnDocNo);
		if(result > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
		
	}

	
	// 전자결재 상세페이지 내 파일 다운로드
	@ResponseBody
	@GetMapping("docFileDownload")
	public ResponseEntity<byte[]> docFileDownload(String fileName) throws IOException{
		log.debug("docFileDownload() 실행");
		
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		try {
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(filePath + "/" + fileName);
			
			// 파일 이름에 붙은 UUID 제거
			fileName = fileName.substring(fileName.indexOf("_") + 1);
			
			// 다운로드용 헤더 설정
			// APPLICATION_OCTET_STREAM: "이게 어떤 타입인지 모르겠으니, 그냥 다운로드 해!!"
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			
			// ATTACHMENT: 덕분에 브라우저가 "이건 다운로드 해야 돼!" 라고 인식
			headers.add("Content-Disposition", "attachment;filename=\"" + 
			new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
			
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
	
	// 전자결재 승인/반려/전결시
	@ResponseBody
	@PostMapping("approvalTy")
	public ResponseEntity<String> approvalDocTy(@AuthenticationPrincipal CustomUser user, @RequestBody SanctnerVO sanctner){
		log.debug("approvalDocTy() 실행! sanctner: {}", sanctner);
		
		// 현재 결재자 사원번호
		String empNo = user.getUsername();
		sanctner.setLastSanctner(empNo);
		sanctner.setEmpNo(empNo);
		
		// 현재 결재자 날인 파일 경로 조회 후 설정
		String signFilePath = service.getSanctnerSignFilePath(empNo);
		sanctner.setSignFilePath(signFilePath);
		
		// 결재문서번호
		String sanctnDocNo = sanctner.getSanctnDocNo();
		
		// 결재자 가져오기
		List<SanctnerVO> sanctnerList = service.getApprovalSanctnerList(sanctnDocNo);
		
		SanctnerVO sanctnOrdrFind = null;
		for(SanctnerVO sl : sanctnerList) {
			// 현재 사번의 결재 순번 찾기
			if(sl.getLastSanctner().equals(empNo)) {
				sanctnOrdrFind = sl;
				break;
			}
		}
			
		// 반려/전결이면 상태만 설정하고 바로 처리
		if("20007".equals(sanctner.getSanctnSttus()) || "20005".equals(sanctner.getSanctnSttus())) {
		    service.approvalDocTyMof(sanctner);
		    return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}
		
		if(sanctnOrdrFind == null) {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
		
		// 현재 사번의 결재 순번 설정
		int sanctnOrdr = sanctnOrdrFind.getSanctnOrdr();
		sanctner.setSanctnOrdr(sanctnOrdr);
		
		// 대결 상태 판단
		if(!empNo.equals(sanctnOrdrFind.getEmpNo())) {
		    sanctner.setSanctnSttus("20004"); // 대결
		} else {
		    sanctner.setSanctnSttus("20003"); // 일반 승인
		}
		
		log.debug("vo에 보내는 data: {}", sanctner);
		
		// 결재 승인/대결/반려 상태값 upd
		service.approvalDocTyMof(sanctner);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 재기안시 문서 정보 가져오기
	@ResponseBody
	@GetMapping("reSubmit/{sanctnDocNo}")
	public ResponseEntity<Map<String, Object>> getReSubmitDocInfo(@PathVariable String sanctnDocNo, Model model){
		log.debug("getReSubmitDocInfo() 실행");
		
		SanctnDocVO sanctnDocInfo = service.getReSubmitDocInfo(sanctnDocNo);
		// 결재자 가져오기
		List<SanctnerVO> sanctnerList = service.getApprovalReSubmitSanctnerList(sanctnDocNo);
		// 참조자 가져오기
		List<SanctnCCVO> sanctnerCCList = service.getApprovalSanctnerCCList(sanctnDocNo);
		
		Map<String, Object> result = new HashMap<>();
	    result.put("sanctnDocInfo", sanctnDocInfo);
	    result.put("sanctnerList", sanctnerList);
	    result.put("sanctnerCCList", sanctnerCCList);
	    
		return ResponseEntity.ok(result);
	}
	
	// 결재 휴지통에서 복원시
	@ResponseBody
	@PostMapping("restore/{sanctnDocNo}")
	public ResponseEntity<String> restoreDoc(@PathVariable String sanctnDocNo){
		log.debug("restoreDoc() 실행, sanctnDocNo : {}", sanctnDocNo);
		
		int status = service.restoreDoc(sanctnDocNo);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 전자결재 임시저장 파일 삭제
	@ResponseBody
	@PostMapping("delFile")
	public ResponseEntity<String> delFile(@RequestBody FilesVO file){
		log.debug("delFile() 실행, file : {}", file);
		
		int status = service.delFile(file);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 전자결재 기안문서 삭제
	@ResponseBody
	@PostMapping("delDoc")
	public ResponseEntity<String> delDoc(@RequestBody String sanctnDocNo){
		log.debug("delDoc() 실행, sanctnDocNo : {}", sanctnDocNo);
		
		int status = service.delDoc(sanctnDocNo);
		
		if(status > 0) {
			return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL", HttpStatus.BAD_REQUEST);
		}
	}
}
