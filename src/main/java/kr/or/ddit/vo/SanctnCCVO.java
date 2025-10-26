package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SanctnCCVO {
	 private String sanctnDocNo; // 문서번호
	 private String empNo; // 사원번호
	 
	 private String empNm; // 사원명
	 private String deptNm; // 부서명
	 private String jbgdCd; // 직급
}
