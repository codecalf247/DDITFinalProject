package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class SanctnLineBkmkVO {
	 private int bkmkNo;	// 즐겨찾기번호
	 private String empNo;	// 즐겨찾기 만든 사원번호
	 private String bkmkNm;	// 즐겨찾기 이름
	 private int sanctnOrdr;	// 결재순서
	 
	 private String empNm; // 사원이름
	 private String deptNm; // 부서이름
	 private String jbgdNm; // 직급
	 
	 private String proxyEmpNm; // 대리자 이름
	 
	 private List<String> empNoList; // 즐겨찾기 결재선 사원번호
}
