package kr.or.ddit.employee.survey.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.survey.service.ISurveyService;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.QesitmVO;
import kr.or.ddit.vo.QuestionVO;
import kr.or.ddit.vo.SurveyPrtcpntVO;
import kr.or.ddit.vo.SurveyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main")
public class SurveyController {
	
	@Autowired
	private ISurveyService service;
	
	@GetMapping("listsurvey")
	public String surveylist(@RequestParam(name="page", required = false, defaultValue = "1") int currentPage, Model model, @AuthenticationPrincipal CustomUser user) {
		
		String empNo = user.getMember().getEmpNo();
		
		
		PaginationInfoVO<SurveyVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		int totalRecord = service.countAllSurveys(empNo);
		pagingVO.setTotalRecord(totalRecord);
		
		List<SurveyVO> surveyList = service.selectSurveyList(pagingVO, empNo);
		pagingVO.setDataList(surveyList);
		
		model.addAttribute("pagingVO", pagingVO);
		return "survey/listsurvey";
	}
	
	
	@GetMapping("endsurvey")
	public String endsurvey(@RequestParam(name="page", required = false, defaultValue = "1") int currentPage, Model model, @AuthenticationPrincipal CustomUser user) {
		log.info("endsurvey 실행...!");
		
		PaginationInfoVO<SurveyVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		
		// 1. 마감된 설문 총 개수 조회
		int totalRecord = service.countEndedSurveys();
		pagingVO.setTotalRecord(totalRecord);
		
		// 2. 마감된 설문 목록 조회
		List<SurveyVO> endedSurveyList = service.selectEndedSurveyList(pagingVO);
		pagingVO.setDataList(endedSurveyList);
		
		model.addAttribute("pagingVO", pagingVO);
		
		return "survey/endsurvey";
	}
	
	@GetMapping("endsurvey/detail")
	public String endSurveyDetail(@RequestParam int surveyNo, Model model, @AuthenticationPrincipal CustomUser user) throws Exception {
		log.info("마감된 설문 detail 페이지 요청...! - surveyNo : {}", surveyNo);
		
		// 1. 설문 통계 데이터 전체를 가져오는 서비스 메서드 호출
		SurveyVO stats = service.getStats(surveyNo);
		
		// 2. 총 응답자 수를 가져와 모델에 추가
		int totalParticipants = service.countSurveyParticipants(surveyNo);
		model.addAttribute("totalParticipants", totalParticipants);
		
		// 3 익명 여부(privateYn)에 따라 답변자 목록 조회
		if("N".equals(stats.getPrivateYn())) {
			List<SurveyPrtcpntVO> respondents = service.getRespondents(surveyNo);
			
			
			model.addAttribute("respondents", respondents);
		}
		
		ObjectMapper jhObj = new ObjectMapper();
		String jhResStr  = jhObj.writeValueAsString(stats);
		model.addAttribute("jhStr",jhResStr);
		
		model.addAttribute("survey", stats);
		
		return "survey/endsurveydetail";
	
	}
	
	
	
	@GetMapping("surveyDo")
	public String surveyDo(@RequestParam int surveyNo, Model model, @AuthenticationPrincipal CustomUser user) {
	    log.info("detailsurvey 상세보기 요청 - surveyNo: {}", surveyNo);
	    
	    String empNo = user.getMember().getEmpNo();
	    
	    // 1. 설문 기본 정보 가져오기
	    SurveyVO surveyVO = service.selectSurvey(surveyNo, empNo);

	    // 2. 질문 목록 가져오기
	    List<QuestionVO> questionVOList = service.selectQuestions(surveyNo);
	    
//	    for(QuestionVO q : questionVOList) {
//	    	log.info(q.getUserRspnsList().toString());
//	    }
	    
	    // 3. 설문 구조에 해당 사용자의 답변 가져오기
	    // List<RspnsVO> userRspnsList = service.selectQuestionsWithRspns(surveyNo, empNo);
	    
	    // 4. 질문 목록을 순회하며 각 질문에 해당하는 문항(옵션) 목록을 가져와서 채워넣기
	    if (questionVOList != null && !questionVOList.isEmpty()) {
	        for (QuestionVO question : questionVOList) {
	            int questionNo = question.getQuestionNo(); // 각 질문의 PK를 가져옴
	            List<QesitmVO> qesitmList = service.selectQesitms(questionNo);
	            question.setQesitmList(qesitmList); // 가져온 문항 목록을 QuestionVO에 설정
	        }
	    }
	    
	    // 5. 모든 데이터가 담긴 질문 목록을 SurveyVO에 설정
	    surveyVO.setQuestionList(questionVOList);
	    
	    // 사용자가 제출한 답변 데이터를 별도로 조회하여 모델에 추가
	    // model.addAttribute("userRspnsList", userRspnsList);
	    
	    log.info("최종 surveyVO : " + surveyVO);
	    model.addAttribute("survey", surveyVO);
	    
	    return "survey/detailsurvey";
	}	

@GetMapping("detailsurvey")
public String joinsurvey(@RequestParam int surveyNo, Model model, @AuthenticationPrincipal CustomUser user) {
    log.info("detailsurvey 상세보기 요청 - surveyNo: {}", surveyNo);
    
    String empNo = user.getMember().getEmpNo();
    
    // 1. 설문 기본 정보 가져오기
    SurveyVO surveyVO = service.selectSurvey(surveyNo, empNo);

    // 2. 질문 목록 가져오기
    List<QuestionVO> questionVOList = service.selectQuestionsWithRspns(surveyNo, empNo);
    
    for(QuestionVO q : questionVOList) {
    	log.info(q.getUserRspnsList().toString());
    }
    
    // 3. 설문 구조에 해당 사용자의 답변 가져오기
    // List<RspnsVO> userRspnsList = service.selectQuestionsWithRspns(surveyNo, empNo);
    
    // 4. 질문 목록을 순회하며 각 질문에 해당하는 문항(옵션) 목록을 가져와서 채워넣기
    if (questionVOList != null && !questionVOList.isEmpty()) {
        for (QuestionVO question : questionVOList) {
            int questionNo = question.getQuestionNo(); // 각 질문의 PK를 가져옴
            List<QesitmVO> qesitmList = service.selectQesitms(questionNo);
            question.setQesitmList(qesitmList); // 가져온 문항 목록을 QuestionVO에 설정
        }
    }
    
    // 5. 모든 데이터가 담긴 질문 목록을 SurveyVO에 설정
    surveyVO.setQuestionList(questionVOList);
    
    // 사용자가 제출한 답변 데이터를 별도로 조회하여 모델에 추가
    // model.addAttribute("userRspnsList", userRspnsList);
    
    log.info("최종 surveyVO : " + surveyVO);
    model.addAttribute("survey", surveyVO);
    
    return "survey/detailsurvey";
}
	
	@GetMapping("insertsurvey")
	public String insertsurvey(Model model, @AuthenticationPrincipal CustomUser user) {
		EmpVO empVO = user.getMember(); // 로그인 사용자 정보
		model.addAttribute("empNm", empVO.getEmpNm());
		
		log.info("insertsurvey 실행...!");
		return "survey/insertsurvey";
	}
	
	@PostMapping("insertsurvey")
    public String insertSurvey(
    		@ModelAttribute SurveyVO surveyVO,
    		RedirectAttributes ra, @AuthenticationPrincipal CustomUser user
    	) {
		
	
		if(surveyVO.getPrivateYn() == null) {
			surveyVO.setPrivateYn("N");
		}
		if(surveyVO.getOthbcYn() == null) {
			surveyVO.setOthbcYn("N");
		}
		
		for(int i=0; i<surveyVO.getQuestionList().size(); i++) {
			if(surveyVO.getQuestionList().get(i).getMandatoryYn() == null)
				surveyVO.getQuestionList().get(i).setMandatoryYn("N");
		}
		
		log.info("설문 등록 시작: {}", surveyVO);
		log.info("문항 등록 시작: {}", surveyVO.getQuestionList());
		log.info("옵션 등록 시작: {}", surveyVO.getQuestionList().get(0).getQesitmList());
		
		surveyVO.setEmpNo(user.getUsername());
		
		try {
			
			ServiceResult result = service.insertSurvey(surveyVO);
			
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("msg", "설문이 성공적으로 등록되었습니다.");
			} else {
				ra.addFlashAttribute("msg", "설문 등록 중 오류가 발생했습니다.");
			}

		} catch (Exception e) {
			log.error("설문 등록 중 오류 발생", e);
			ra.addFlashAttribute("msg", "설문 등록 중 오류가 발생했습니다.");
		}
		
		return "redirect:/main/listsurvey";
	}
	
	
	@PostMapping("submitSurvey")
	public String submitSurvey(
			@RequestParam MultiValueMap<String, String> formData, @AuthenticationPrincipal CustomUser user,
			RedirectAttributes ra	
			) {
		   log.info("submitSurvey 답변 제출 요청: {}", formData);

	        try {
	        	// 1. 로그인한 사용자 정보 가져오기
	            String empNo = user.getMember().getEmpNo();
	            
	            // 2. 폼 데이터에서 설문 번호 추출
	            int surveyNo = Integer.parseInt(formData.get("surveyNo").get(0));
	            
	            // 3. 서비스에 넘기기 전에 Map에서 불필요한 데이터 제거
	            formData.remove("surveyNo");
	            
	            // 4. 서비스 계층으로 답변 데이터와 사용자 정보를 전달
	            ServiceResult result = service.submitSurveyAnswers(surveyNo, empNo, formData);
	            
	            if (result == ServiceResult.OK) {
	                ra.addFlashAttribute("msg", "설문에 참여가 완료되었습니다!");
	            } else {
	                ra.addFlashAttribute("msg", "설문 참여 중 오류가 발생했습니다.");
	            }
	        } catch (Exception e) {
	            log.error("설문 답변 제출 중 오류 발생", e);
	            ra.addFlashAttribute("msg", "설문 참여 중 오류가 발생했습니다.");
	        }
	        return "redirect:/main/joinedsurvey";
	    }

	@GetMapping("joinedsurvey")
	public String joinedsurvey(
	    @RequestParam(name="page", required = false, defaultValue = "1") int currentPage, 
	    Model model, 
	    @AuthenticationPrincipal CustomUser user
	) {
	    log.info("joinedsurvey 실행...!");
	    
	    // 로그인한 사용자 사원번호 가져오기
	    String empNo = user.getMember().getEmpNo();
	    
	    PaginationInfoVO<SurveyVO> pagingVO = new PaginationInfoVO<>();
	    pagingVO.setCurrentPage(currentPage);
	    
	    // '내가 참여한 설문' 총 레코드 수 조회
	    int totalRecord = service.countJoinedSurveys(empNo);
	    pagingVO.setTotalRecord(totalRecord);
	    
	    // '내가 참여한 설문' 목록 조회
	    List<SurveyVO> joinedSurveyList = service.selectJoinedSurveyList(empNo, pagingVO);
	    pagingVO.setDataList(joinedSurveyList);
	    
	    model.addAttribute("pagingVO", pagingVO);
	    
	    return "survey/joinedsurvey";
	}
	
	// 통계 표에 마우스를 올렸을 때 사원 이름이 뜨게하는 로직
	@GetMapping("/getRespondentsForOption")
	@ResponseBody
	public List<SurveyPrtcpntVO> getRespondentsForOption(
	    @RequestParam int surveyNo,
	    @RequestParam int qesitmNo
	) {
	    log.info("옵션 선택 응답자 조회 요청 - surveyNo: {}, qesitmNo: {}", surveyNo, qesitmNo);
	    
	    // 서비스 계층의 메서드를 호출하여 응답자 목록을 가져옵니다.
	    List<SurveyPrtcpntVO> respondents = service.getRespondentsForOption(surveyNo, qesitmNo);
	    
	    return respondents;
	}	
 }

