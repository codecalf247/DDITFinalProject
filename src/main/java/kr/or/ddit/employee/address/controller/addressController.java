package kr.or.ddit.employee.address.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
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

import kr.or.ddit.employee.address.service.IAddressService;
import kr.or.ddit.vo.CcpyVO;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/address")
public class addressController {

    @Autowired
    private IAddressService addressService;
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
    
    

    @GetMapping("/board")
    public String board(Model model, @AuthenticationPrincipal CustomUser user,  
    	@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
    	@RequestParam(required = false, defaultValue = "all") String searchType,
    	@RequestParam(required =false) String searchWord
    	){
        log.info("사내 주소록 페이지 실행....!");
    	PaginationInfoVO<EmpVO> pagingVO = new PaginationInfoVO<>();
    	
    	if(StringUtils.isNotBlank(searchWord)) {
   			pagingVO.setSearchType(searchType);
   			pagingVO.setSearchWord(searchWord);
   			// 검색 후, 목록 페이지로 이동할 때 검색된 내용들 적용시키기 위한 데이터 전달
   			model.addAttribute("searchType", searchType);
   			model.addAttribute("searchWord", searchWord);
   			
   		}
    	
    	// 현재 페이지 전달 후, start/endRow, start/endPage 설정
   		pagingVO.setCurrentPage(currentPage);
   		// 총 게시글 수 가져오기
   		int totalRecord = addressService.selectEmpAddressCount(pagingVO);
   		// 총 게시글 수 설정, 총 페이지 수 결정
   		pagingVO.setTotalRecord(totalRecord);
   		List<EmpVO> dataList = addressService.selectEmpAddressList(pagingVO);
   		pagingVO.setDataList(dataList);
   		

   		model.addAttribute("pagingVO", pagingVO);	
   		model.addAttribute("empList", dataList);
    	
        // 로그인 시 세션에 저장된 사번 가져오기
        String empNo = user.getUsername();

        if(empNo != null) {
            EmpVO empInfo = addressService.getEmpInfo(empNo);
            model.addAttribute("empInfo", empInfo);
        }

        return "address/board";
    }    
    

	    
	    @GetMapping("/partner")
	    public String partner(Model model, @AuthenticationPrincipal CustomUser user,  
		    	@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
		    	@RequestParam(required = false, defaultValue = "all") String searchType,
		    	@RequestParam(required =false) String searchWord
		    	){
		       log.info("업체 주소록 페이지 실행....!");
		       
		       PaginationInfoVO<CcpyVO> pagingVO = new PaginationInfoVO<>();
		   	
		   	if(StringUtils.isNotBlank(searchWord)) {
		  			pagingVO.setSearchType(searchType);
		  			pagingVO.setSearchWord(searchWord);
		  			// 검색 후, 목록 페이지로 이동할 때 검색된 내용들 적용시키기 위한 데이터 전달
		  			model.addAttribute("searchType", searchType);
		  			model.addAttribute("searchWord", searchWord);
		  			
		  		}
		   	
		   	// 현재 페이지 전달 후, start/endRow, start/endPage 설정
		  		pagingVO.setCurrentPage(currentPage);
		  		// 총 게시글 수 가져오기
		  		int totalRecord = addressService.selectCcpyAddressCount(pagingVO);
		  		// 총 게시글 수 설정, 총 페이지 수 결정
		  		pagingVO.setTotalRecord(totalRecord);
		  		List<CcpyVO> dataList = addressService.selectCcpyAddressList(pagingVO);
		  		pagingVO.setDataList(dataList);
		  		
		   		// 공통코드 리스트 가져오기
		   		List<CommonCodeVO> commonList = addressService.selectCommonList("24");
		  		
		  		model.addAttribute("pagingVO", pagingVO);	
		  		model.addAttribute("ccpyList", dataList);  
		  		model.addAttribute("commonList", commonList);  
		  		
		  	// 로그인 시 세션에 저장된 사번 가져오기 
		        String empNo = user.getUsername();
		
		        if(empNo != null) {
		            EmpVO empInfo = addressService.getEmpInfo(empNo);
		            model.addAttribute("empInfo", empInfo);
		        }
		        
		        // 기존의 목록 조회 메서드를 수정합니다.   
		        
		    return "address/partner";
	    }
		   
		    @PostMapping("/partner/insert")
		    public String insertPartnerAjax(CcpyVO vo, RedirectAttributes ra,
		    	@RequestParam MultipartFile uploadFile,
		 	    Model model, @AuthenticationPrincipal CustomUser user) {
		    	
		    	log.info(" 파일 ==================== {}", uploadFile.toString());
		    	log.info(" 파일 ==================== {}", uploadFile.getOriginalFilename());
		    	// 파일 이름 설정
		    	String originalFileName = uploadFile.getOriginalFilename();
		    	String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
		    	
		    	// 파일저장
		    	File saveFile = new File(uploadPath + saveFileName);
		        try {
		        	uploadFile.transferTo(saveFile);
                } catch (IOException e) {
                	e.printStackTrace();
                }
		        
		        // 파일 경로 설정 (CCPY)
		        vo.setCcpyImagePath("/upload/" + saveFileName);
		        
		    	log.info("#### : " + vo.toString());
		    	
		    	// DB 저장
		    	String goPage = "";
		    	int cnt = addressService.insertCcpyAddress(vo);
		    	if(cnt > 0) {
		    		ra.addFlashAttribute("message", "등록이 완료되었습니다!");
		    		goPage = "redirect:/address/partner";
		    	}else {
		    		ra.addFlashAttribute("message", "협력업체 등록 실패!");
		    		goPage = "redirect:/address/partner";
		    	}
		    	return goPage;
		    }	
	    
	    // 비동기 이벤트로, Ccpy 목록에서 한명의 정보를 가져올 때 사용합니다.
	    @ResponseBody
	    @PostMapping("/partner/{ccpyId}")
	    public ResponseEntity<CcpyVO> selectCcpy(@PathVariable int ccpyId){
	    	CcpyVO ccpy = addressService.selectCcpy(ccpyId);
	    	return new ResponseEntity<CcpyVO>(ccpy, HttpStatus.OK);
	    }
	    
	    
	    @PostMapping("/partner/update")
	    public String updatePartner(CcpyVO ccpyVO, RedirectAttributes ra, @RequestParam MultipartFile uploadFile,
		 	    Model model, @AuthenticationPrincipal CustomUser user){
	    	String goPage = "";
	    	log.info("### : " + ccpyVO.toString());
	    	
	    	// 파일 이름 설정
	    	String originalFileName = uploadFile.getOriginalFilename();
	    	String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	    	
	    	// 파일저장
	    	File saveFile = new File(uploadPath + saveFileName);
	        try {
	        	uploadFile.transferTo(saveFile);
            } catch (IOException e) {
            	e.printStackTrace();
            }
	        
	        // 파일 경로 설정 (CCPY)
	        ccpyVO.setCcpyImagePath("/upload/" + saveFileName);
	    	
	    	int cnt = addressService.updateCcpyAddress(ccpyVO);
	    	if(cnt > 0) {
	    		ra.addFlashAttribute("message", ccpyVO.getCcpyNm() + " 수정이 완료되었습니다!");
	    		goPage = "redirect:/address/partner";
	    	}else {
	    		ra.addFlashAttribute("message", "협력업체 수정 실패!");
	    		goPage = "redirect:/address/partner";
	    	}
	    	return goPage;
	    }
	    
	    // ---------------------- 업체 삭제(AJAX) ----------------------
	    @PostMapping("/partner/delete/{ccpyId}")
	    @ResponseBody
	    public ResponseEntity<String> deletePartner(@PathVariable int ccpyId,  RedirectAttributes ra) {
	    	
            int cnt = addressService.deleteCcpyAddress(ccpyId);
            if (cnt > 0) {
            	ra.addFlashAttribute("message", "삭제가 완료되었습니다!");
            	return new ResponseEntity<String>("OK", HttpStatus.OK);
            }else {
            	ra.addFlashAttribute("message", "협력업체 삭제 실패!");
            	return new ResponseEntity<String>("FAILED", HttpStatus.OK);
            }
	    }
	}
