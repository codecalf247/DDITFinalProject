package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class CcpyVO {

    private int ccpyNo;            // 업체번호 (PK, SEQ_CCPY)
    private String ccpyNm;         // 업체명
    private String chargerNm;      // 담당자명
    private String chargerTelno;   // 담당자 전화번호
    private String ccpyEmail;      // 업체 이메일
    private String ccpyTy;         // 공통코드 (24001 등)
    private String ccpyImagePath;  // 업체 이미지 경로
    
	 private List<FilesVO> fileList;  	// 파일 리스트

   
    
    
    
}
