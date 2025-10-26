package kr.or.ddit.employee.eApproval.controller;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

import kr.or.ddit.employee.eApproval.service.IeApprovalService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.SanctnFormBkmkVO;
import kr.or.ddit.vo.SanctnFormVO;
import kr.or.ddit.vo.SanctnLineBkmkVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("eApprovalForm")
public class eApprovalFormController {
	
	@Autowired
	private IeApprovalService service;
	
	// 새로운 상위 폴더 등록
	@GetMapping("registerFolder")
	public String approvalFolder() {
		return "eApproval/approvalFolderForm";
	}
	
	// 양식 상위 폴더 등록 요청
	@ResponseBody
	@PostMapping("folderRegister")
	public ResponseEntity<String> approvalFolderRegister(@RequestBody SanctnFormVO sanctnForm){
		log.debug("approvalFolderRegister() 실행, 들어온 데이터: {}", sanctnForm.getFormNm());
		
		service.insertApprovalFolder(sanctnForm);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 양식 상위 폴더 수정 form 요청
	@GetMapping("modifyFolder/{formNo}")
	public String folderModifyForm(@PathVariable int formNo, Model model) {
		log.debug("folderModifyForm() 실행!, formNo={}:", formNo);
		
		SanctnFormVO sanctnFolderInfo = service.getFolderInfo(formNo);
		
		model.addAttribute("sanctnFolderInfo", sanctnFolderInfo);
		
		return "eApproval/approvalFolderForm";
	}
	
	// 양식 상위 폴더 수정 요청
	@PostMapping("modifyFolder/{formNo}")
	public String folderModify(@PathVariable int formNo, SanctnFormVO sanctnForm){
		log.debug("folderModify() 실행, sanctnForm={}:", sanctnForm.getFormNm());
		
		service.folderModify(sanctnForm);
		
		return "redirect:/eApproval/approvalFormFolder";
	}
	
	// 양식 상위 폴더 삭제 요청
	@ResponseBody
	@PostMapping("deleteFolder/{formNo}")
	public ResponseEntity<String> folderDelete(@PathVariable int formNo) {
		log.debug("folderDelete() 실행, formNo={}: ");
		
		service.folderDelete(formNo);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	/////////////////////////////////////////
	// 새로운 양식 등록
	@GetMapping("registerForm/{formNo}")
	public String approvalForm(Model model, @PathVariable int formNo) {
		log.debug("approvalForm() 실행");
		
		PaginationInfoVO<SanctnFormVO> pagingVO = new PaginationInfoVO<>();
		
		// 양식 type 가져오기
		List<SanctnFormVO> approvalFolderList = service.getApprovalFolderList(pagingVO);
		
		model.addAttribute("approvalFolderList", approvalFolderList);
		model.addAttribute("formNo", formNo);
		return "eApproval/approvalFormRegister";
	}
	
	// 양식 문서 등록 요청
	@ResponseBody
	@PostMapping("formRegister")
	public ResponseEntity<String> approvalFormRegister(@RequestBody SanctnFormVO sanctnForm){
		log.debug("approvalFormRegister() 실행, 들어온 데이터: {}", sanctnForm.getFormCn());
		service.approvalFormRegister(sanctnForm);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 양식 문서 list 가져오기
	@GetMapping("approvalFormList/{formNo}")
	public String getApprovalFormList(@PathVariable int formNo, Model model, @AuthenticationPrincipal CustomUser user,
			@RequestParam(name="page", required=false, defaultValue="1")int currentPage,
			@RequestParam(required=false, defaultValue="title") String searchType,
			@RequestParam(required=false)String searchWord){
		log.debug("getApprovalFormList() 실행");
		
		PaginationInfoVO<SanctnFormVO> pagingVO = new PaginationInfoVO<>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
			pagingVO.setSearchType(searchType);
			model.addAttribute("searchWord", searchWord);
			model.addAttribute("searchType", searchType);
		}
		
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setFormNo(formNo);
		
		List<SanctnFormVO> sanctnFormList = service.getApprovalFormList(pagingVO);
		pagingVO.setDataList(sanctnFormList);
		int cnt = service.getApprovalFormListCnt(pagingVO);
		pagingVO.setTotalRecord(cnt);
		
		String upperFormNm = "";
		if(!sanctnFormList.isEmpty()) {
			upperFormNm = sanctnFormList.get(0).getUpperFormNm();
			model.addAttribute("upperFormNm", upperFormNm);
		}else {
			model.addAttribute("msg", "하위 문서가 없습니다.");
		}
		
		String empNo = user.getUsername();
		
		List<SanctnFormBkmkVO> sanctnFormBkmkList = service.getSanctnFormBkmk(empNo);
		 
		model.addAttribute("sanctnFormBkmkList", sanctnFormBkmkList);
		model.addAttribute("sanctnFormList", sanctnFormList);
		model.addAttribute("cnt", cnt);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("empNo", empNo);
		
		return "eApproval/approvalFormList";
	}
	
	// 양식 문서 상세정보 가져오기
	@GetMapping("approvalFormDetail/{formNo}")
	public String getApprovalFormDetail(@PathVariable int formNo, Model model, @AuthenticationPrincipal CustomUser user){
		log.debug("getApprovalFormDetail() 실행");
		
		String loginEmpNo = user.getUsername();
		
		SanctnFormVO sanctnFormInfo = service.getApprovalFormDetail(formNo);
		
		model.addAttribute("form", sanctnFormInfo);
		model.addAttribute("loginEmpNo", loginEmpNo);
		
		return "eApproval/approvalFormDetail";
	}
	
	// 양식 문서 상세정보 수정 form 가져오기
	@GetMapping("docDetailModify/{formNo}")
	public String getDocDetailModifyForm(@PathVariable int formNo, Model model) {
		log.debug("detailModify() 실행");
		
		SanctnFormVO sanctnFormInfo = service.getApprovalFormDetail(formNo);
		
		model.addAttribute("form", sanctnFormInfo);
		
		return "eApproval/approvalFormRegister";
	}
	
	// 양식 문서 상세정보 수정 요청
	@PostMapping("docDetailModify/{formNo}")
	public ResponseEntity<String> docDetailModify(@PathVariable int formNo, @RequestBody SanctnFormVO sanctnForm) {
		log.debug("docDetailModify() 실행, formNo:{}", formNo);
		
		service.docDetailModify(sanctnForm);
		
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	// 양식 즐겨찾기
	@ResponseBody
	@PostMapping("approvalFormBkmk")
	public ResponseEntity<String> approvalFormBkmk(@RequestBody SanctnFormBkmkVO sanctnBkmk, @AuthenticationPrincipal CustomUser user){
		log.debug("approvalFormBkmk() 실행");
		
		String empNo = user.getUsername();
		sanctnBkmk.setEmpNo(empNo);
		
		int status = 0;
		if(sanctnBkmk.getIsBkmk().equals("Y")) {
			int bkmkCnt = service.getBkmkCnt(empNo);
			if(bkmkCnt >= 4) {
				return new ResponseEntity<String>("즐겨찾기는 4개까지만 가능합니다.",HttpStatus.BAD_REQUEST);
			}
			status = service.insertApprovalFormBkmk(sanctnBkmk);
		}else {
			status = service.deleteApprovalFormBkmk(sanctnBkmk);
		}
		
		
		if(status > 0) {
			log.debug("즐겨찾기 성공");
			return new ResponseEntity<String>("SUCCESS",HttpStatus.OK);
		}else {
			return new ResponseEntity<String>("FAIL",HttpStatus.BAD_REQUEST);
		}
		
	}

}
