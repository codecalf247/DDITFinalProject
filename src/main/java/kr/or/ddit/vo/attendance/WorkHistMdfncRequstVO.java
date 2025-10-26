package kr.or.ddit.vo.attendance;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class WorkHistMdfncRequstVO {
	
	private int workHistMdfncRequstNo;	// 수정 요청 번호
	private int workRcordNo;			// 근무 기록 번호
	private String requstResn;			// 수정 사유	
	private String requstRegYmd;		// 수정 요청 날짜
	private String requstTime;			// 변경 요청 시간
	private Integer fileGroupNo;			// 파일 그룹 번호
	private String requstTy;			// 요청 유형
	private String requstSttus;			// 요청 상태
	private String returnResn;			// 반려 사유
	
	private String savedNm;				// 파일 이름
	private String originalNm;			// 파일 원본 명
	
	private String empNm;				// 사원 이름
	private String deptNm;				// 부서명
	
	private String workYmd;				// 기준날짜
	private String defaultTime;			// 기준시간
	
	private MultipartFile attachFile;	// 첨부파일
}
