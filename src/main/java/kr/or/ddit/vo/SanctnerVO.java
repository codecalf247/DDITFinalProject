package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SanctnerVO {
	 private int sanctnerNo;		// 결재자번호
	 private String sanctnDocNo;	// 결재문서번호
	 private String empNo;			// 사원번호
	 private String lastSanctner;	// 최종결재자 사원번호
	 private String lastSanctnerJbgd;	// 최종결재자직급
	 private int sanctnOrdr;		// 결재순번
	 private String sanctnSttus;	// 결재상태(공통코드)
	 private String atrzDt;			// 결재일시
	 private String sanctnOpinion;	// 결재의견
	 private String dcrbAuthYn;		// 전결권한여부
	 private String signFilePath;	// 날인파일경로
	
	 private String deptNm;			// 부서이름
	 private String empNm;			// 사원이름
	 private String jbgdCd;			// 직급
	 private String proxyEmpNm;	// 대결자 이름
}
