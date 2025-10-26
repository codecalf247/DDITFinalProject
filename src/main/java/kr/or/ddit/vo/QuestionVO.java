package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class QuestionVO {
	
	 private int questionNo;		// 질문 번호 SEQ_QUESTION
	 private int surveyNo;			// 설문 번호 SEQ_SURVEY
	 private String questionCn;		// 질문 내용
	 private int questionOrdr;		// 질문 순서
	 private String questionTy;		// 질문 유형 
	 /*
	  * 08001 객관식(단일 선택)
	  *	08002 객관식(복수 선택)
	  * 08003 서술형
	  */
	 private String mandatoryYn;	// 필수 여부
	 
	 private List<QesitmVO> qesitmList;
	 private List<RspnsVO> userRspnsList;
}
