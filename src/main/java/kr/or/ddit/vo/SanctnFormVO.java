package kr.or.ddit.vo;

import lombok.Data;

@Data
public class SanctnFormVO {
	 private int formNo;		// 양식번호
	 private int upperFormNo;	// 상위양식번호
	 private String formNm;		// 양식명
	 private String formDc;		// 양식설명
	 private String formCn;		// 양식내용
	 private String regYmd;		// 등록일자
	 private String mdfcnYmd;	// 수정일자
	 private String isFolder;	// 폴더여부
	 
	 private String upperFormNm;	// 상위양식이름
}
