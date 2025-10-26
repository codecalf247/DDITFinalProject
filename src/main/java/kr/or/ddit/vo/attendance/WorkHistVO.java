package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class WorkHistVO {
	private int workHistNo;		// 근무 이력 번호
	private int workRcordNo;	// 근무 기록 번호
	private String workSttus;	// 근무 상태
	private String histDt;		// 이력 날짜
	
	private String requstResn;	// 비고
	private WorkRcordVO workRcordVO;	// 근무 기록
}
