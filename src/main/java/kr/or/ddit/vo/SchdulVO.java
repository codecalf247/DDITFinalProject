package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SchdulVO {
	
	 private int schdulNo;				// 일정번호
	 private String empNo;				// 사원번호
	 private String schdulTitle;		// 일정제목
	 private String schdulCn;			// 일정내용
	 private String startDt;			// 시작일
	 private String endDt;				// 종료일
	 private String textColor;			// 글자색
	 private String backgroundColor;	// 배경색
	 private String alldayAt;			// 하루종일 여부
	 private String schdulTy;			// 일정종류 ( 공통코드 : 11001 )
	 private Integer deptNo;			// 부서번호 (null 에러 방지)
	 private Integer prjctNo;			// 프로젝트번호 (null 에러 방지)
	 private String procsTy;			// 공정유형 (새로추가_각 프로젝트마다 사용)
	 
}
