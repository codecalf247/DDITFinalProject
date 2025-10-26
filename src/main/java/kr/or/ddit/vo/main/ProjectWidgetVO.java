package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class ProjectWidgetVO {
	private int prjctNo;		  // 프로젝트 번호
	private String sptNm; 		  // 현장명
	private String sptAddr; 	  // 현장주소
	private String prjctStartYmd; // 시작일
	private String prjctDdlnYmd;  // 종료일
}
