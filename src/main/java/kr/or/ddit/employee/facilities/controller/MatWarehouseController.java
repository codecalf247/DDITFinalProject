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

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.employee.facilities.service.IMatService;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mat")
public class MatWarehouseController {

    @Autowired
    private IMatService matService;

    @GetMapping("/list")
    public String chooseMat(@AuthenticationPrincipal CustomUser user) {
        String empNo = user.getUsername();

        // 관리자
        if ("202508001".equals(empNo)) {
            return "redirect:/admat/admatlist";
        } else { // 일반사원
            return "redirect:/mat/matlist";
        }
    }

    @GetMapping("/matlist")
    public String matlist(Model model,
            @AuthenticationPrincipal CustomUser user,
            @RequestParam(name="page", required=false, defaultValue="1") int currentPage,
            @RequestParam(required=false) String searchWord,
            @RequestParam(required=false, defaultValue="") String statusFilter) {

        log.info("자재 관리 페이지실행....!");
        
        

        PaginationInfoVO<MtrilVO> pagingVO = new PaginationInfoVO<>();

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

        int totalRecord = matService.selectmaterialCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<MtrilVO> dataList = matService.selectmaterialList(pagingVO);
        pagingVO.setDataList(dataList);

        // === 카운트 계산 (검색어는 유지, 상태만 바꿔서 카운트) ===
        PaginationInfoVO<MtrilVO> allCond = new PaginationInfoVO<>();
        allCond.setSearchWord(pagingVO.getSearchWord());
        allCond.setStatusFilter(""); // 전체
        int totalCount = matService.selectmaterialCount(allCond);

        PaginationInfoVO<MtrilVO> normalCond = new PaginationInfoVO<>();
        normalCond.setSearchWord(pagingVO.getSearchWord());
        normalCond.setStatusFilter("normal");
        int normalCount = matService.selectmaterialCount(normalCond);

        PaginationInfoVO<MtrilVO> shortageCond = new PaginationInfoVO<>();
        shortageCond.setSearchWord(pagingVO.getSearchWord());
        shortageCond.setStatusFilter("shortage");
        int shortageCount = matService.selectmaterialCount(shortageCond);
        // ================================================

        List<CommonCodeVO> mtrilTyList = matService.selectCmList("16");
        List<CommonCodeVO> unitList    = matService.selectCmList("14");

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("matList", dataList);
        model.addAttribute("mtrilTyList", mtrilTyList);
        model.addAttribute("unitList", unitList);

        // 타일 숫자 바인딩
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("normalCount", normalCount);
        model.addAttribute("shortageCount", shortageCount);

        return "facilities/matlist";
    }
    // ====== 입/출고 처리 ======
    @PostMapping("/stock")
    public String processStock(
            @AuthenticationPrincipal CustomUser user,
            MtrilVO vo,                         // 자동 바인딩 (mtrilId, inoutQy, sptNm, memo)
            @RequestParam("type") String type,  // "in" | "out"
            HttpServletRequest request,
            RedirectAttributes ra
    ) {
        String empNo = (user != null) ? user.getUsername() : null;
        
        log.info("입출고 ===========================");
        
        // 검증
        if (StringUtils.isBlank(empNo)) {
            ra.addFlashAttribute("msg","로그인이 필요합니다.");
            return "redirect:/login";
        }
        if (StringUtils.isBlank(vo.getMtrilId())) {
            ra.addFlashAttribute("msg","자재 ID가 없습니다.");
            return "redirect:/mat/matlist";
        }
        if (!"in".equals(type) && !"out".equals(type)) {
            ra.addFlashAttribute("msg","처리 타입이 올바르지 않습니다.");
            return "redirect:/mat/matlist";
        }
        if (vo.getInoutQy() <= 0) {
            ra.addFlashAttribute("msg","수량은 1 이상이어야 합니다.");
            return "redirect:/mat/matlist";
        }

        // 정규화/보강
        vo.setEmpNo(empNo);
        vo.setInoutTy("in".equals(type) ? MtrilVO.IN : MtrilVO.OUT);
        vo.setSptNm(StringUtils.trimToNull(vo.getSptNm()));
        vo.setMemo(StringUtils.trimToNull(vo.getMemo()));

        try {
            if (vo.isIn()) matService.stockIn(vo);
            else          matService.stockOut(vo);
            ra.addFlashAttribute("msg","재고가 반영되었습니다.");
        } catch (IllegalStateException e) {
            ra.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("msg","처리 중 오류가 발생했습니다.");
        }

        // 항상 목록으로
        return "redirect:/mat/matlist";
    }
}


