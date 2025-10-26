package kr.or.ddit.vo;

import lombok.Data;

@Data
public class QesitmVO {

	 private int qesitmNo;		// 문항 번호 1~5
	 private int questionNo;	// 질문 번호 SEQ_QUESTION
	 private int qesitmOrdr;	// 문항 순서
	 private String qesitmCn;	// 문항 내용
	 
	 private int rspnsCount;  	// 응답 수 (통계용)
}
