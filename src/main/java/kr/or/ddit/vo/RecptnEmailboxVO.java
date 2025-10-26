package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class RecptnEmailboxVO {
	
	 /** EMAIL.EMAIL_NO (PK, SEQ_EMAIL) */
    private Long emailNo;

    /** EMAIL.WRTER_EMP_NO 작성자사번번호 */
    private String wrterEmpNo;

    /** EMAIL.EMAIL_TITLE 메일제목 */
    private String emailTitle;

    /** EMAIL.EMAIL_CN 메일내용(CLOB) */
    private String emailCn;

    /** EMAIL.EMAIL_WRT_DT 작성일시 */
    private String emailWrtDt;

    /** EMAIL.RESVE_DSPTCH_DT 예약발송일시 (nullable) */
    private String resveDsptchDt;

    /** EMAIL.TEMP_SAVE_YN 임시저장여부('Y'/'N') */
    private String tempSaveYn;

    /** EMAIL.FILE_GROUP_NO 파일그룹번호 (nullable) */
    private Long fileGroupNo;
	
	 /** RECPTN_EMAILBOX.RECPTN_EMAILBOX_NO (PK, SEQ_RECPTN_EMAILBOX) */
    private Long recptnEmailboxNo;

    /** RECPTN_EMAILBOX.EMAIL_RCVR_NO (FK → EMAIL_RCVR) */
    private Long emailRcvrNo;

    /** RECPTN_EMAILBOX.RECPTN_DT 수신일시 (NOT NULL) */
    private String recptnDt;

    /** RECPTN_EMAILBOX.READNG_DT 열람일시 (NULL 가능) */
    private String readngDt;

    /** RECPTN_EMAILBOX.DEL_YN 정상:N / 삭제:Y (NOT NULL) */
    private String delYn;
    
	 private List<FilesVO> fileList;  	// 파일 리스트

    
    
}
