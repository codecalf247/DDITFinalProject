package kr.or.ddit.vo;

import lombok.Data;

@Data
public class ProxySanctnerVO {
	 private int proxySanctnerNo;	// 대결자 등록 번호
	 private String empNo;			// 위임자
	 private String proxyEmpNo;		// 대결자
	 private String beginYmd;		// 시작일자
	 private String endYmd;			// 종료일자
	 
	 private String proxyNm;		// 대결자 이름
	 private String jbgdCd;			// 직급
	 private String deptNm;			// 부서
}
