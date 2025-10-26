package kr.or.ddit.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EqpmnVO {
	
	private String eqpmnNo;         // 장비번호 (PK)
    private String eqpmnNm;         // 장비명
    private int fileGroupNo;  		// 파일그룹번호
    private String filePath;
    private String eqpmnSttus;      // 장비상태
    private String eqpmnSttusNm;      // 장비상태명
    private String eqpmnDc;         // 장비설명 (nullable)
    private String eqpmnRegYmd;     // 장비등록일자
    private String empNm;          //사원번호
    
    
	private Long eqpmnHistNo;   // 장비 이력 번호 (PK)
	private int eqpmnHistCnt;
    private String empNo;       // 사원 번호
    private String reqstDt;     // 신청 일시
    private String resveStartDt;// 예약 시작 일시
    private String resveEndDt;  // 예약 종료 일시
    private String rturnDt;     // 반납 일시
    private String sptNm;       // 지원 부서명
    private String memo;        // 비고/메모
    private MultipartFile uploadFile;		// 장비 이미지
    private FilesVO filesVO;
    public void setUploadFile(MultipartFile item) {
    	this.uploadFile = item;
    	FilesVO fVO = new FilesVO(item);
    	this.filesVO = fVO;
    }
}
