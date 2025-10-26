package kr.or.ddit.employee.survey.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.QesitmVO;
import kr.or.ddit.vo.QuestionVO;
import kr.or.ddit.vo.RspnsVO;
import kr.or.ddit.vo.SurveyPrtcpntVO;
import kr.or.ddit.vo.SurveyVO;

public interface ISurveyService {
//
//	public int generateSurveyNo();
//
//	public void insertSurvey(SurveyVO surveyVO);
//
//	public int generateQuestionNo();
//
//	public QuestionVO insertQuestion(QuestionVO questionVO);
//
//	public void insertQesitm(QesitmVO qesitmVO);

	   public int countAllSurveys(String empNo);

	    public List<SurveyVO> selectSurveyList(PaginationInfoVO<SurveyVO> pagingVO, String empNo);

	    public ServiceResult insertSurvey(SurveyVO surveyVO);

	    public List<QuestionVO> selectQuestions(int surveyNo);

	    public List<QesitmVO> selectQesitms(int questionNo);

		public ServiceResult submitSurveyAnswers(int surveyNo, String empNo, Map<String, List<String>> formData);

		public int countJoinedSurveys(String empNo);

		public List<SurveyVO> selectJoinedSurveyList(String empNo, PaginationInfoVO<SurveyVO> pagingVO);

		public List<RspnsVO> selectUserRspnsList(int surveyNo, String empNo);

		SurveyVO selectSurvey(int surveyNo, String empNo);

		// 질문번호와 사원번호로 질문에 있는 답변까지 가져오는 쿼리
		public List<QuestionVO> selectQuestionsWithRspns(int surveyNo, String empNo);

		public int countEndedSurveys();

		public List<SurveyVO> selectEndedSurveyList(PaginationInfoVO<SurveyVO> pagingVO);

		public SurveyVO getStats(int surveyNo);

		public List<SurveyPrtcpntVO> getRespondents(int surveyNo);

		public int updateExpiredSurveys();

		public int countSurveyParticipants(int surveyNo);

		public List<SurveyPrtcpntVO> getRespondentsForOption(int surveyNo, int qesitmNo);
		
	}