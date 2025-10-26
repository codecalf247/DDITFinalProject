package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyVO {
	
	 private int surveyNo;				// 설문 번호 SEQ_SURVEY 
	 private String surveyTitle;		// 설문 제목
	 private String surveyCn;			// 설문 내용
	 private String surveyRegDt;		// 설문 등록일시
	 private String surveyDdlnDt;		// 설문 마감일시
	 private String ddlnYn;				// 마감 여부 N:정상 Y:마감
	 private String delYn;				// 삭제 여부 N:정상 Y:삭제
	 private String privateYn;			// 익명 여부 N:정상 Y:익명
	 private String othbcYn;			// 공개 여부 N:비공개 Y:공개
	 
	 private String empNo; 				// 사원번호(참여한 사원번호)
	 
	 private List<QuestionVO> questionList;


}
