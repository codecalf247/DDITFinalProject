package kr.or.ddit.vo;

import lombok.Data;

@Data
public class FoldersVO {
	
	 private int folderNo;			// 폴더번호
	 private Integer upperFolder;	// 상위폴더
	 private String empNo;			// 사원번호
	 private String folderName;		// 폴더명
	 private String folderCrtYmd;	// 폴더 생성일자
	 private String folderMdfcnYmd;	// 폴더 수정일자
	 private String folderTy;		// 폴더유형: 10001 개인, 10002 팀, 10003 전사(전체), 10004 루트(최상위 폴더)
	 private Integer deptNo;		// 부서번호
	 private String delYn;			// 삭제여부	정상:N 삭제:Y 
	 
	 private String empNm;			// 작성자 이름
}
