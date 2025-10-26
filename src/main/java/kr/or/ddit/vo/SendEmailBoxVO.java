package kr.or.ddit.vo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class SendEmailBoxVO {

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
    private int fileGroupNo;
    
	 /** PK: SEQ_DSPTCH_EMAILBOX */
    private Long dsptchEmailboxNo;

    /** 발신일시 */
    private String dsptchDt;

    /** 삭제 여부(정상:N / 삭제:Y) */
    private String delYn;
    
    /** 받는 사람 이름       */
    private String senderEmpNm;
    
    /** 받은 날짜 */
    private String recptnDt;
    
    /**  열람일시 필드 추가  **/
    private String readngDt;
    
    /** 수신메일함 상태 - 읽음,읽지않음 **/
    private String recptnStatus;
    
    /** EMAIL_RCVR 관련 **/
    private Long emailRcvrNo;
    private String rcverEmpNo;
    private String rcverEmpNm;
    private String rcverEmail;
    private String rcverNames;
    
    
    /** 받은함 PK */
    private Long recptnEmailboxNo;
    
    private List<MultipartFile> files;
    
	private List<FilesVO> fileList;	// 첨부파일리스트
    
    
    
    private String toList;
    private String ccList;
    /** 받는사람 이메일 리스트 (사내 주소만 처리) */
    private List<String> toEmails;

    /** 참조 이메일 리스트 (사내 주소만 처리) */
    private List<String> ccEmails;
    
    
    public void setToList(String toList) {
    	this.toList = toList;
    	List<String> ttList = new ArrayList<>();
    	if(toList != null) {
    		String[] tList = toList.split(",");
    		for(int i = 0; i < tList.length; i++) {
    			ttList.add(tList[i]);
    		}
    		toEmails = ttList;
    	}
    }
    
    public void setCcList(String ccList) {
    	this.ccList = ccList;
    	List<String> cArray = new ArrayList<>();
    	if(ccList != null) {
    		String[] cList = ccList.split(",");
    		for(int i = 0; i < cList.length; i++) {
    			cArray.add(cList[i]);
    		}
    		ccEmails = cArray;
    	}
    }
    
}
	
	
	

