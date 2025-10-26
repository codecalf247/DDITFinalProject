package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SanctnFormBkmkVO {
	private String empNo;	// 사번
	private int formNo;		// 양식번호
	
	private String formDc; // 양식 설명
	private String formNm; // 양식 이름
	private String isBkmk; // 즐겨찾기 y,n
}
