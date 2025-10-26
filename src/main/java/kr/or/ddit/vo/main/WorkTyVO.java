package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class WorkTyVO {
	
	 private int workTyNo;				// 유형번호
	 private String workTyNm;			// 유형명
	 private String workTyDc;			// 유형설명	
	 private String workBeginTime;		// 정규근무제 출근시간
	 private String workEndTime;		// 정규근무제 퇴근시간
	 private String flextimeBeginTime;	// 유연근무제 출근시간(최소)
	 private String flextimeEndTime;	// 유연근무제 출근시간(최대)
	 private String useYn;				// 사용여부
	 private String regYmd;				// 등록일자
	 private String mdfcnYmd;			// 수정일자
}
