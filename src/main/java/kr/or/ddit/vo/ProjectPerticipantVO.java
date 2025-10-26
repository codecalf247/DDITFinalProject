package kr.or.ddit.vo;

import lombok.Data;


// 프로젝트 참여자 VO
@Data
public class ProjectPerticipantVO {
	
	 private int prjctNo;			// 프로젝트 번호
	 private String empNo;			// 사원번호
	 private String timhderYn;		// 팀장 여부 (N:팀원, Y:팀장) 

	 // 조인해서 표시 
	 private String empNm; 			// 사원명 							EMP.EMP_NM
	 private String jbgdCd;			// 직급 코드(코드 => 명으로 변환 필요)    EMP.JBGD_CD
	 private String jbgdNm;			// 직급명
	 private String prjctPrtcpntType;  			// 디자인팀 or 현장팀 					
	 private String deptNm;			// 예: 현장 1팀, 현장 2팀     			DEPT.DEPT_NM
	 private String photoUrl;		// 프로필 경로
}
