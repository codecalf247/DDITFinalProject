package kr.or.ddit.vo;

import lombok.Data;

@Data
public class DeptVO {
	 private int deptNo;		// 부서번호
	 private int upperDeptNo;	// 상위부서번호
	 private int workTyNo;		// 근무유형번호
	 private String deptNm;		// 부서명
	 private String deptCrtYmd;	// 부서생성일자
	 
	 private int deptEmpCnt;	// 팀별 인원수
	 private String upperDeptNm; // 상위 부서명
	 
	 private String empNm;	// 사원명
	 private String empNo;	// 사원번호
	 private String jbgdCd; // 직급
}
