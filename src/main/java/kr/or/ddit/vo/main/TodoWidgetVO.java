package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class TodoWidgetVO {
	
	 private int todoNo;			// 투두번호
	 private String empNo;			// 사원번호
	 private String todoCn;			// 투두내용
	 private String todoCheckYn;	// 투두체크여부
	 private String delYn;			// 삭제여부
	 
}
