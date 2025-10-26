package kr.or.ddit.employee.facilities.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.employee.facilities.service.IEquipService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/equip")
public class EquipWarehouseController {

	
	@Autowired
	private IEquipService equipService;
	
	
	
	
	@GetMapping("/list")
	public String chooseMat(@AuthenticationPrincipal CustomUser user) {
		String empNo = user.getUsername();
		
		// 관리자
		if("202508001".equals(empNo)) {
			return "redirect:/adequip/adeqlist";
		}else {	// 일반사원
			return "redirect:/equip/eqlist";
		}
	}
	
	
	
	
	
	 /** 장비 목록 + 요약 카드 */
    @GetMapping("/eqlist")
    public String eqlist(Model model,
                         @AuthenticationPrincipal CustomUser user,
                         @RequestParam(name="page", required=false, defaultValue="1") int currentPage,
                         @RequestParam(required=false) String searchWord,
                         @RequestParam(required=false, defaultValue="") String statusFilter) {

        log.info("장비 관리 페이지 실행");

        PaginationInfoVO<EqpmnVO> pagingVO = new PaginationInfoVO<>();

        pagingVO.setScreenSize(8);
        
        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord);
        }
        if (StringUtils.isNotBlank(statusFilter)) {
            pagingVO.setStatusFilter(statusFilter);
            model.addAttribute("statusFilter", statusFilter);
        }
        pagingVO.setCurrentPage(currentPage);

        // 카운트 & 카드 데이터
        int totalRecord = equipService.selectEquipCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        int normalCount = equipService.selectEquipCountByStatus("13001");
        int rentCount   = equipService.selectEquipCountByStatus("13002");
        int repairCount = equipService.selectEquipCountByStatus("13003");

        model.addAttribute("equipTotalCount", totalRecord);
        model.addAttribute("normalCount", normalCount);
        model.addAttribute("rentCount", rentCount);
        model.addAttribute("repairCount", repairCount);

        // 리스트
        List<EqpmnVO> dataList = equipService.selectEquipList(pagingVO);
        pagingVO.setDataList(dataList);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("equipList", dataList);

        // 공통코드
        List<CommonCodeVO> commonList = equipService.selectCommonList("13");
        model.addAttribute("commonList", commonList);

        
        String loginEmpNo = null;
        if (user != null && user.getMember() != null) {
            loginEmpNo = user.getMember().getEmpNo();
        }
        model.addAttribute("loginEmpNo", loginEmpNo);

        return "facilities/eqlist";
    }
	
	@PostMapping("/rent")
	public String rent(@AuthenticationPrincipal CustomUser user,
	                   EqpmnVO form,
	                   RedirectAttributes ra) {

	    // 1) 필수: 장비번호
	    if (StringUtils.isBlank(form.getEqpmnNo())) {
	        ra.addFlashAttribute("msg","장비번호가 없습니다.");
	        return "redirect:/equip/eqlist";
	    }

	    // 2) 사번 보정: CustomUser → getMember() → EmpVO
	    if (StringUtils.isBlank(form.getEmpNo())) {
	        EmpVO loginEmp = (user != null) ? user.getMember() : null;   // ← getMember() 사용
	        if (loginEmp != null && StringUtils.isNotBlank(loginEmp.getEmpNo())) {
	            form.setEmpNo(loginEmp.getEmpNo());
	        } else {
	            ra.addFlashAttribute("msg","사번이 없습니다.");
	            return "redirect:/equip/eqlist";
	        }
	    }

	    // 3) ERD: SPT_NM NOT NULL
	    if (StringUtils.isBlank(form.getSptNm())) {
	        ra.addFlashAttribute("msg","현장명을 입력하세요.");
	        return "redirect:/equip/eqlist";
	    }

	    // 4) 날짜 필수 + 간단 비교(YYYY-MM-DD 문자열 비교 가능)
	    if (StringUtils.isBlank(form.getResveStartDt()) || StringUtils.isBlank(form.getResveEndDt())) {
	        ra.addFlashAttribute("toastError","대여 시작/반납 예정일을 입력하세요.");
	        return "redirect:/equip/eqlist";
	    }
	    if (form.getResveEndDt().compareTo(form.getResveStartDt()) < 0) {
	        ra.addFlashAttribute("msg","반납 예정일이 시작일보다 빠릅니다.");
	        return "redirect:/equip/eqlist";
	    }

	    // 5) 서비스: 이력 insert + 상태 13002(대여중) 업데이트 (트랜잭션)
	    int ok = equipService.rentEquipment(form);
	    ra.addFlashAttribute(ok > 0 ? "msg" : "msg",
	                         ok > 0 ? "대여가 완료되었습니다." : "대여 처리 실패");
	    return "redirect:/equip/eqlist";
	}
	
	
	/** 장비 반납 */
    @PostMapping("/return")
    public String returnEquipment(@AuthenticationPrincipal CustomUser user,
                                  @RequestParam("equipId") String eqpmnNo,
                                  @RequestParam("returnCondition") String returnCondition, // 정상 | 고장
                                  @RequestParam(value="returnMemo", required=false) String memo,
                                  RedirectAttributes ra) {

        // 로그인 및 필수값 체크
        EmpVO loginEmp = (user != null) ? user.getMember() : null; // ★ getMember() 사용
        if (loginEmp == null || StringUtils.isBlank(loginEmp.getEmpNo())) {
            ra.addFlashAttribute("msg","로그인 정보가 없습니다.");
            return "redirect:/equip/eqlist";
        }
        if (StringUtils.isBlank(eqpmnNo)) {
            ra.addFlashAttribute("msg","장비번호가 없습니다.");
            return "redirect:/equip/eqlist";
        }
        if (!"정상".equals(returnCondition) && !"고장".equals(returnCondition)) {
            ra.addFlashAttribute("msg","반납 상태값이 올바르지 않습니다.");
            return "redirect:/equip/eqlist";
        }

        // 서비스 호출
        int code = equipService.returnEquipment(eqpmnNo, loginEmp.getEmpNo(), returnCondition, StringUtils.defaultString(memo, ""));

        switch (code) {
            case 1:
                ra.addFlashAttribute("msg","반납이 처리되었습니다.");
                break;
            case -1:
                ra.addFlashAttribute("msg","대여자가 아니어서 반납할 수 없습니다.");
                break;
            case -2:
                ra.addFlashAttribute("msg","현재 대여중이 아닙니다.");
                break;
            default:
                ra.addFlashAttribute("msg","반납 처리에 실패했습니다.");
        }
        return "redirect:/equip/eqlist";
    }
}
	

