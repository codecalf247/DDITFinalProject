package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SurveyPrtcpntVO {
	
	 private int surveyPrtcpntNo;	// 설문 참여자 번호
	 private int surveyNo;			// 설문 번호
	 private String empNo;			// 사원 번호
	 private String partcptnYmd;	// 참여 일자
	 private String empNm; 			// 사원 이름
}
 