package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class EmailTrashVO {
	private int boxNo; 			// 수신,송신,참조 메일함 번호
	private int emailNo;		// 이메일 번호
	private String empNm;		// 작성자 이름
	private String wrterEmpNo;	// 작성자 사원번호
	private String emailWrtDt;	// 작성일시
	private String emailTitle;	// 이메일 제목
	private String emailCn;		// 이메일 내용
	private int type;			// 메일함 타입(1 : 수신, 2 : 송신, 3 : 참조) 
	private List<FilesVO> fileList;	// 첨부파일리스트
}
