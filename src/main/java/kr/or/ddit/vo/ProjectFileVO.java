package kr.or.ddit.vo;

import java.sql.Date;
import java.util.List;

import lombok.Data;


// 프로젝트 전체적인 VO

@Data
public class ProjectFileVO {
	
	 private int prjctFileNo;		
	 private int prjctNo;			
	 private String fileTy;			
	 private int fileGroupNo;		
	 private String fileTitle;      
	 private String fileCn;
	    
   // 'selectFileList' 쿼리 결과를 매핑하기 위해 추가된 필드들
   private String originalNm;
   private String empNm;
   private String empNo;
   private Date fileRegDt;
   private String filePath;
   private int fileSize;       // <<--  이 부분을 추가해야 합니다.
   private String fileUploader; 
   
   // 상세 페이지 조회 시 사용되는 FilesVO 리스트
   private List<FilesVO> fileList;
}
