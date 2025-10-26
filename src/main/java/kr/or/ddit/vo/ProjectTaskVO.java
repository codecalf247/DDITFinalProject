package kr.or.ddit.vo;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import lombok.Data;


// 프로젝트 전체적인 VO

@Data
public class ProjectTaskVO {
	
	 private int taskNo;				// 일감 번호 
	 private int prjctNo;				// 프로젝트 번호 
	 private String empNo;				// 사원 번호 
	 private String taskCharger;		// 담당자 
	 private String taskTitle;			// 일감 제목 
	 private String taskCn;				// 일감 내용 
	 private String taskRegYmd;		// 일감 등록 일자 
	 private String taskBeginYmd;		// 일감 시작 일자 
	 private String taskDdlnYmd;		// 일감 데드라인 
	 private String taskMdfcnYmd;		// 일감 수정 일자 
	 private int taskProgrs;			// 일감 진행률 
	 private String taskSttus;			// 일감 상태 
	 private String delYn;				// 삭제 유무 N일때 유지 / Y일때 삭제 
	 private String emrgncyYn;			// 긴급 유무 N일때 일반 / Y일때 긴급 
	 private String procsTy;			// 공정 유형 
	 private Integer fileGroupNo;			// 파일 업로드 그룹번호 
	 
	 
	 // 추가 
	 private String taskChargerNm;   // TASK_CHARGER 사번 → EMP.EMP_NM 조인 표시
	 private String canEdit;         // "Y"/"N" (권한 표시)
	 private String canDelete;       // "Y"/"N"
	 
	 
	 private Map<String, Integer> counts;
	 public Map<String, Integer> getCounts() { return counts; }
	 public void setCounts(Map<String, Integer> counts) { this.counts = counts; }
}
