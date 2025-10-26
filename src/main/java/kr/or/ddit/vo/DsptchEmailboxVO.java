package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class DsptchEmailboxVO {

	 /** PK: SEQ_DSPTCH_EMAILBOX */
    private Long dsptchEmailboxNo;

    /** FK → EMAIL.EMAIL_NO */
    private Long emailNo;

    /** 발신자 사원번호 */
    private String dsptchEmpNo;

    /** 발신일시 */
    private String dsptchDt;

    /** 삭제 여부(정상:N / 삭제:Y) */
    private String delYn;
    
	 private List<FilesVO> fileList;  	// 파일 리스트

}
