package kr.or.ddit.vo;

import lombok.Data;

@Data 
public class BoardCMVO {

	 private int cmNo;				// 게시판 댓글 번호
	 private int boardNo;			// 게시판 번호
	 private String empNo;			// 사원 번호
	 private String cmCn;			// 댓글 내용
	 private String cmWrtDt;		// 댓글 작성일시
	 private String cmMdfcnDt;		// 댓글 수정일시
	 private String delYn;			// 삭제 여부
	 private int upperCmNo;			// 상위 댓글 번호
	 private int cmOrdr;			// 댓글 순서
	 private int cmDp;				// 댓글 깊이
	 private String empNm;
}
