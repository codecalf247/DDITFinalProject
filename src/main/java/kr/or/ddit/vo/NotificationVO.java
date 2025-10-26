package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NotificationVO {
	  private Long ntcnNo;        // NTCN_NO
	  private String rcver;        // RCVR (사번)
	  private String ntcnTy;      // NTCN_TY
	  private String ntcnCn;      // NTCN_CN (내용)
	  private Date ntcnTrnsmitDt; // NTCN_TRNSMIT_DT
	  private String readYn;      // READ_YN (N/Y)
	  private String ntcnPath;    // NTCN_PATH (링크)
}
