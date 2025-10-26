package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class RefrnEmailboxVO {
	
	 private Long refrnEmailboxNo;

	    /** REFRN_EMAILBOX.EMAIL_NO (FK → EMAIL) */
	    private Long emailNo;

	    /** REFRN_EMAILBOX.EMAIL_CC_NO (FK → EMAIL_CC) */
	    private Long emailCcNo;

	    /** REFRN_EMAILBOX.RECPTN_DT 수신일시 (NOT NULL) */
	    private String recptnDt;

	    /** REFRN_EMAILBOX.READNG_DT 열람일시 (NULL 가능) */
	    private String readngDt;

	    /** REFRN_EMAILBOX.DEL_YN 정상:N / 삭제:Y (NOT NULL) */
	    private String delYn;
	    
		 private List<FilesVO> fileList;  	// 파일 리스트

}
