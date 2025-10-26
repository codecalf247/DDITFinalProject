package kr.or.ddit.vo.main;

import lombok.Data;

// 출퇴근 정보 VO
@Data
public class AttendanceWidgetVO {
	
	// emp Table
	private String empNm;				// 사원명
	private String profileFilePath;		// 이미지파일경로
	
	// cmmn_cd Table
	private String jbgdNm;				// 직급명(cmmn_cd 조인)
	
	// dept Table
	private String deptNm;				// 부서명(dept 조인)
	
	// work_rcord Table
	private String beginTime;			// 출근시간(work_rcord 조인)
	private String endTime;				// 퇴근시간(work_rcord 조인)
	
}
