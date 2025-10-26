package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class TaskWidgetVO {
	private int taskNo; 			// 일감번호
	private String taskTitle;		// 일감제목
	private String taskCn;			// 일감내용
	private String taskBeginYmd;	// 시작일
	private String taskDdlnYmd;		// 종료일
	private int taskProgrs;			// 진행률
	private String emrgncyYn;		// 긴급여부
	private String procsTy;			// 공정유형
}
