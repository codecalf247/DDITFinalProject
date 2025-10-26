package kr.or.ddit.employee.survey.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.QesitmVO;
import kr.or.ddit.vo.QuestionVO;
import kr.or.ddit.vo.RspnsVO;
import kr.or.ddit.vo.SurveyPrtcpntVO;
import kr.or.ddit.vo.SurveyVO;

@Mapper
public interface ISurveyMapper {

//	public int generateSurveyNo();
//
//	public void insertSurvey(SurveyVO surveyVO);
//
//	public int generateQuestionNo();
//
//	public QuestionVO insertQuestion(QuestionVO questionVO);
//
//	public int generateQesitmNo();
//
//	public void insertQesitm(QesitmVO qesitmVO);

	public int countAllSurveys(@Param("empNo") String empNo);

	public List<SurveyVO> selectSurveyList(@Param("pagingVO") PaginationInfoVO<SurveyVO> pagingVO, @Param("empNo") String empNo);

	public SurveyVO selectSurvey(@Param("surveyNo") int surveyNo, @Param("empNo") String empNo);

	public int insertSurvey(SurveyVO surveyVO);

	public int insertQuestion(QuestionVO questionVO);

	public int insertQesitm(QesitmVO qesitmVO);

    public List<QesitmVO> selectQesitms(int questionNo);

	public List<QuestionVO> selectQuestions(int surveyNo);

	public ServiceResult submitSurveyAnswers(Map<String, List<String>> formData);

	public int insertSurveyPrtcpnt(SurveyPrtcpntVO prtcpntVO);

	public int insertRspns(RspnsVO rspnsVO);

	public int countJoinedSurveys(String empNo);

	public List<SurveyVO> selectJoinedSurveyList(String empNo, PaginationInfoVO<SurveyVO> pagingVO);

	public List<RspnsVO> selectUserRspnsList(@Param("surveyNo") int surveyNo, @Param("empNo") String empNo);

	public List<QuestionVO> selectQuestionsWithRspns(@Param("surveyNo") int surveyNo, @Param("empNo") String empNo);

	public List<SurveyPrtcpntVO> getRespondents(int surveyNo);

	public List<RspnsVO> selectSubjectiveAnswers(int questionNo);

	public List<QesitmVO> selectQesitmStatistics(int questionNo);

	public List<SurveyVO> selectEndedSurveyList(PaginationInfoVO<SurveyVO> pagingVO);

	public int countEndedSurveys();

	public int updateExpiredSurveys();

	public int countSurveyParticipants(int surveyNo);

	public List<SurveyPrtcpntVO> getRespondentsForOption(int surveyNo, int qesitmNo);

	public List<EmpVO> allEmpNotification(String empNo);
	

}
