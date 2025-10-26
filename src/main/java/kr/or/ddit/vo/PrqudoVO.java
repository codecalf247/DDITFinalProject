package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class PrqudoVO {
	
	 private int prqudoNo;			// 견적서 번호		
	 private String empNo;			// 사원번호
	 private int prjctNo;			// 프로젝트 번호
	 private String prqudoTitle;	// 견적서 제목
	 private String prqudoCn;		// 견적서 내용
	 private int estmtAmount;		// 견적 금액
	 private int fileGroupNo;		// 파일 그룹 번호
	 private String regDt;			// 등록일자
	 private String empNm;			// 사원명

	 
	 private List<FilesVO> fileList;  	// 파일 리스트

}
