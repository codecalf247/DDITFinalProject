package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	 private int boardNo; 				// 게시판 번호
	 private String empNo;				// 사원 번호
	 private String boardTitle;			// 게시판 제목
	 private String boardCn;			// 게시판 내용
	 private String boardRegDt;			// 게시판 등록일시
	 private String boardMdfcnDt;		// 게시판 수정일시
	 private int boardRdcnt;			// 게시판 조회수
	 private String imprtncTagYn;		// 중요 태그 여부
	 private String delYn;				// 삭제 여부
	 private int fileGroupNo;			// 파일 그룹번호
	 private String boardTy;			// 게시판 유형
	 private String cvplTy;				// 민원 유형
	 private String cvplSttus;			// 민원 상태
	 private String empNm;				// 사원명
	
	 private List<FilesVO> fileList;  	// 파일 리스트
	 
	 /* 
	  * 민원상태 : 19001 처리중, 19002 처리완료, 19003 반려
	  * 민원유형 : 04001 회의실, 04002 창고, 04003 사무실, 04004 기타  
	  */
	 
}
