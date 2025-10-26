package kr.or.ddit.employee.survey.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.survey.mapper.ISurveyMapper;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.QesitmVO;
import kr.or.ddit.vo.QuestionVO;
import kr.or.ddit.vo.RspnsVO;
import kr.or.ddit.vo.SurveyPrtcpntVO;
import kr.or.ddit.vo.SurveyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class SurveyServiceImpl implements ISurveyService {

	@Autowired
	private ISurveyMapper mapper;
	
	@Autowired 
	private NotificationConfig noti;


//	@Override
//	public int generateSurveyNo() {
//		return mapper.generateSurveyNo();
//	}
//
//	@Override
//	public void insertSurvey(SurveyVO surveyVO) {
//		 mapper.insertSurvey(surveyVO);
//	}
//
//	@Override
//	public int generateQuestionNo() {
//		return mapper.generateQuestionNo();
//	}
//
//	@Override
//	public QuestionVO insertQuestion(QuestionVO questionVO) {
//		return mapper.insertQuestion(questionVO);
//	}
//
//
//	@Override
//	public void insertQesitm(QesitmVO qesitmVO) {
//		mapper.insertQesitm(qesitmVO);
//	}

	@Override
	public int countAllSurveys(String empNo) {
		return mapper.countAllSurveys(empNo);
	}

	@Override
	public List<SurveyVO> selectSurveyList(PaginationInfoVO<SurveyVO> pagingVO, String empNo) {
		return mapper.selectSurveyList(pagingVO,empNo);
	}

	@Override
	public SurveyVO selectSurvey(int surveyNo, String empNo) {
		// 1. Survey 기본 정보 가져오기
		SurveyVO surveyVO = mapper.selectSurvey(surveyNo, empNo);
		if (surveyVO == null) {
			return null;
		}

		// 2. Survey에 속한 모든 Question 목록 가져오기
		List<QuestionVO> questionList = mapper.selectQuestions(surveyNo);

		// 3. 사용자의 모든 답변을 한 번에 가져오기
		List<RspnsVO> allUserRspns = mapper.selectUserRspnsList(surveyNo, empNo);

		// 4. 각 질문에 속한 Qesitm 목록과 답변을 가져와서 채워넣기
		if (questionList != null && !questionList.isEmpty()) {
			for (QuestionVO question : questionList) {
				// 옵션 목록 가져오기
				List<QesitmVO> qesitmList = mapper.selectQesitms(question.getQuestionNo());
				question.setQesitmList(qesitmList);

				// 전체 답변 리스트에서 현재 질문에 해당하는 답변만 필터링하여 담기
				List<RspnsVO> userRspnsForQuestion = new ArrayList<>();
				if (allUserRspns != null) {
					for (RspnsVO rspns : allUserRspns) {
						if (rspns.getQuestionNo() == question.getQuestionNo()) {
							userRspnsForQuestion.add(rspns);
						}
					}
				}
				question.setUserRspnsList(userRspnsForQuestion);
			}
		}

		// 5. 완성된 질문 목록을 SurveyVO에 설정
		surveyVO.setQuestionList(questionList);

		return surveyVO;
	}

	@Override
	public ServiceResult insertSurvey(SurveyVO surveyVO) {
		ServiceResult result = null;

		if (surveyVO.getPrivateYn() == null) {
			surveyVO.setPrivateYn("N");
		}
		if (surveyVO.getOthbcYn() == null) {
			surveyVO.setOthbcYn("N");
		}

		int status1 = mapper.insertSurvey(surveyVO);

		if (status1 > 0) {
			int status2 = 0;
			int questionOrdr = 1;
			for (QuestionVO questionVO : surveyVO.getQuestionList()) {
				questionVO.setSurveyNo(surveyVO.getSurveyNo());

				if (questionVO.getMandatoryYn() == null) {
					questionVO.setMandatoryYn("N");
				}
				questionVO.setQuestionOrdr(questionOrdr++);

				
				
				status2 = mapper.insertQuestion(questionVO);
				

				if (status2 > 0) {
					int status3 = 0;
					int questionNo = questionVO.getQuestionNo();
					int count = 1;

					if (questionVO.getQesitmList() != null && !questionVO.getQesitmList().isEmpty()) {
						for (QesitmVO qesitmVO : questionVO.getQesitmList()) {
							qesitmVO.setQuestionNo(questionNo);
							qesitmVO.setQesitmNo(count);
							qesitmVO.setQesitmOrdr(count++);

							status3 = mapper.insertQesitm(qesitmVO);

							if (status3 <= 0) {
								result = ServiceResult.FAILED;
								break;
							}
						}
					}

				} else {
					result = ServiceResult.FAILED;
					break;
				}

			}

			// 모든 DB 작업이 성공적으로 완료되었을 때만 알림 전송
			if (result != ServiceResult.FAILED) {
				String empNo = surveyVO.getEmpNo();
				List<EmpVO> empList = mapper.allEmpNotification(empNo);
				
				for(EmpVO emp : empList) {
					noti.notify(emp.getEmpNo(), "12007", "설문", "/main/listsurvey");
					log.info("empList 알림 전송: " + emp.getEmpNo());
				}
			}

			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}

		return result;
	}
	@Override
	public List<QuestionVO> selectQuestions(int surveyNo) {
		// 설문 번호에 해당하는 질문 목록을 반환합니다.
		return mapper.selectQuestions(surveyNo);
	}

	@Override
	public List<QesitmVO> selectQesitms(int questionNo) {
		// 질문 번호에 해당하는 문항 목록을 반환합니다.
		return mapper.selectQesitms(questionNo);
	}

	@Override
	public ServiceResult submitSurveyAnswers(int surveyNo, String empNo, Map<String, List<String>> formData) {
		
        List<QuestionVO> allQuestions = mapper.selectQuestions(surveyNo);

		
	    for (QuestionVO question : allQuestions) {
	        // 'Y'는 필수 답변(mandatory)을 의미
	        if ("Y".equals(question.getMandatoryYn())) {
	            String questionKey = "q_" + question.getQuestionNo();
	            
	            // 사용자가 제출한 폼 데이터(formData)에 필수 질문의 키가 없거나
	            // 해당 키의 값이 비어 있는지 확인합니다.
	            if (!formData.containsKey(questionKey) || formData.get(questionKey).isEmpty()) {
	                // 필수 질문에 답변이 누락되었다면, 에러를 로깅하고 FAILED를 반환합니다.
	                log.error("필수 질문 답변 누락: {}", question.getQuestionNo());
	                return ServiceResult.FAILED; 
	            }
	        }
	    }
		

		try {
			// 1. SURVEY_PRTCPNT 테이블에 설문 참여자 정보 저장
			SurveyPrtcpntVO prtcpntVO = new SurveyPrtcpntVO();
			prtcpntVO.setSurveyNo(surveyNo);
			prtcpntVO.setEmpNo(empNo);

			int prtcpntInsertStatus = mapper.insertSurveyPrtcpnt(prtcpntVO);
			if (prtcpntInsertStatus == 0) {
				throw new RuntimeException("설문 참여자 정보 저장에 실패했습니다.");
			}

			int surveyPrtcpntNo = prtcpntVO.getSurveyPrtcpntNo();

			for (String key : formData.keySet()) {
				if (key.startsWith("q_")) {
					List<String> values = formData.get(key);

					if (values == null || values.isEmpty()) {
						continue;
					}

					int questionNo = Integer.parseInt(key.substring(2));

					// 복수 선택된 값을 처리하기 위해 List를 순회하는 루프 추가
					for (String value : values) {
						if (value == null || value.isEmpty()) {
							continue;
						}

						RspnsVO rspnsVO = new RspnsVO();
						rspnsVO.setSurveyPrtcpntNo(surveyPrtcpntNo);
						rspnsVO.setQuestionNo(questionNo);

						// 답변 값을 확인하여 객관식인지 주관식인지 구분
						if (value.matches("\\d+")) { // 값(String)이 숫자인지 확인
							rspnsVO.setQesitmAnswerNo(Integer.parseInt(value));
						} else { // 그 외의 값은 주관식 답변
							rspnsVO.setQesitmAnswerCn(value);
						}

						int rspnsInsertStatus = mapper.insertRspns(rspnsVO);
						if (rspnsInsertStatus == 0) {
							throw new RuntimeException("답변 저장에 실패했습니다.");
						}
					}
				}
			}

			return ServiceResult.OK;

		} catch (Exception e) {
			log.error("설문 답변 처리 중 예외 발생", e);
			throw new RuntimeException("설문 답변 저장 실패", e);
		}
	}

	@Override
	public int countJoinedSurveys(String empNo) {
		return mapper.countJoinedSurveys(empNo);
	}

	@Override
	public List<SurveyVO> selectJoinedSurveyList(String empNo, PaginationInfoVO<SurveyVO> pagingVO) {
		return mapper.selectJoinedSurveyList(empNo, pagingVO);
	}

	@Override
	public List<RspnsVO> selectUserRspnsList(int surveyNo, String empNo) {
		return mapper.selectUserRspnsList(surveyNo, empNo);
	}

	@Override
	public List<QuestionVO> selectQuestionsWithRspns(int surveyNo, String empNo) {
		return mapper.selectQuestionsWithRspns(surveyNo, empNo);
	}

	@Override
	public int countEndedSurveys() {
		return mapper.countEndedSurveys();
	}

	@Override
	public List<SurveyVO> selectEndedSurveyList(PaginationInfoVO<SurveyVO> pagingVO) {
		return mapper.selectEndedSurveyList(pagingVO);
	}

	@Override
	public SurveyVO getStats(int surveyNo) {
		
		// 1. 설문 기본 정보 가져오기
		SurveyVO surveyVO = mapper.selectSurvey(surveyNo, null);
		
		// 2. 질문 목록 가져오기
		List<QuestionVO> questionList = mapper.selectQuestions(surveyNo);
		
		// 3. 각 질문별 통계 데이터 채우기 (로직 처리)
		for(QuestionVO question : questionList) {
	        if ("08001".equals(question.getQuestionTy()) || "08002".equals(question.getQuestionTy())) {
	        	
	    // 객관식, 복수선택 옵션별 투표수 집계
	        List<QesitmVO> qesitmList = mapper.selectQesitmStatistics(question.getQuestionNo());
	        
	        question.setQesitmList(qesitmList);
	        } else if ("08003".equals(question.getQuestionTy())) {
	        	
	            // 주관식 모든 답변 가져오기
	            List<RspnsVO> rspnsList = mapper.selectSubjectiveAnswers(question.getQuestionNo());
	            question.setUserRspnsList(rspnsList);
	        }
	    }
	    surveyVO.setQuestionList(questionList);
	    return surveyVO;
	}

	@Override
	public List<SurveyPrtcpntVO> getRespondents(int surveyNo) {
		return mapper.getRespondents(surveyNo);
	}

	@Override
	public int updateExpiredSurveys() {
		return mapper.updateExpiredSurveys();
	}

	@Override
	public int countSurveyParticipants(int surveyNo) {
		return mapper.countSurveyParticipants(surveyNo);
	}

	@Override
	public List<SurveyPrtcpntVO> getRespondentsForOption(int surveyNo, int qesitmNo) {
		return mapper.getRespondentsForOption(surveyNo ,qesitmNo);
	}

}
