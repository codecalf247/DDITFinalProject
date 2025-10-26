package kr.or.ddit.vo;

import lombok.Data;

@Data
public class FolderFileVO {

	 private int fileNo;			// 파일번호 시퀀스
	 private String empNo;			// 사원번호
	 private int folderNo;			// 폴더번호
	 private String originalNm;		// 원본명
	 private String savedName;		// 저장된 명
	 private String filePath;		// 파일경로
	 private int fileSize;			// 파일크기
	 private String fileFancysize;	// 파일크기(단위)	
	 private String fileMime;		// 파일 MIME
	 private String fileReg_Dt;		// 파일등록 일시
	 private String delYn;			// 삭제여부 정상:N 삭제:Y
	 private int deptNo; 			// 부서번호	
	 
	 private String empNm;			// 작성자 이름
	 
}
