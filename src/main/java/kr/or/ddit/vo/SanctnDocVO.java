package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class SanctnDocVO {
	 private String sanctnDocNo;	// 결재문서번호
	 private int formNo;			// 양식번호
	 private String empNo;			// 기안자사번
	 private String wrtDt;			// 기안일시
	 private String sanctnTitle;	// 결재제목
	 private String sanctnCn;		// 결재내용
	 private String sanctnTy;		// 결재유형
	 private String docProcessSttus;	// 문서진행상태
	 private String sanctnOpinion;		// 결재의견
	 private String lastAtrzDt;		// 최종결재일시
	 private String delTy;				// 삭제유형
	 private String emrgncyYn;			// 긴급여부
	 private int fileGroupNo;			// 파일그룹번호
	 
	 private String empNm;	// 기안자이름 
	 private String deptNm; // 부서이름
	 private String jbgdCd; // 직급
	 private String formNm; // 양식이름
	 private String formCn; // 양식틀
	 private String formDc; // 양식설명
	 private String sanctnSttus; // 결재문서의 결재상태
	 private String ccEmpNo; // 참조자 사번
	 private String hasFile; // 파일 여부 확인
	 
	 private List<FilesVO> fileList; // 파일리스트
	 
}
