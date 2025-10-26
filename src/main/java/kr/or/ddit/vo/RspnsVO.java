package kr.or.ddit.vo;

import lombok.Data;

@Data
public class RspnsVO {

	 private int rspnsNo;			// 응답 번호
	 private int surveyPrtcpntNo;	// 설문 참여자 번호
	 private int questionNo;		// 질문 번호
	 private int qesitmAnswerNo;	// 문항 답변 번호
	 private String qesitmAnswerCn;	// 문항 답변 내용
	 private String empNm;  		// 사원명	
	 
}
