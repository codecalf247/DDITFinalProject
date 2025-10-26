package kr.or.ddit.vo;

import lombok.Data;

@Data
public class ApprovalFormVO {
	 private int formNo;
	 private int upperFormNo;
	 private String formNm;
	 private String formDc;
	 private String formCn;
	 private String regYmd;
	 private String mdfcnYmd;
	 private String isFolder;
}
