package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class CompanyYrycSttusVO {
	
	private String empNo;		// 사원번호
	private String empNm;		// 사원명
	private String jdbcNm;		// 직급명
	private String deptNm;		// 부서명
	
	private int totYrycCo;		// 총 연차개수
	private double useCo;		// 사용 연차개수	
	
	private double companyTotYrycCo;		// 총 회사 연차개수
	private double companyUseCo;			// 총 회사 사용 연차개수
	
}
