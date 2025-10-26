package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class YrycSttusVO {
	
	private int yrycSttusNo;	// 연차 현황 번호
	private String empNo;		// 사원번호
	private String empNm;		// 사원이름
	private String issuYr;		// 발급연도
	private int totYrycCo;		// 총 연차개수
	private double useCo;		// 사용 연차개수	
	private String startDt;		// 시작일시
	private String endDt;		// 종료일시
	
	private double allUseCo;	// 총 사용 연차개수
}
