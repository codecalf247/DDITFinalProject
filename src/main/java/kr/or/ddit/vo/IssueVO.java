package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class IssueVO {


	 private int issueNo;					// 이슈 번호
	 private String empNo;					// 사원 번호
	 private int prjctNo;					// 프로젝트 번호 시퀀스
	 private String issueTitle;				// 이슈 제목
	 
	
	 private String issueCn;				// 이슈 내용
	 private String issueManager;			// 이슈 담당자 (사원번호)
	 private String issueManagerNm;          // 이슈 담당자 (이름)
	 private String issueTy;				// 이슈 타입: 05001:민원 05002:현장 05003:설계 05004:안전 05005:기타
	 private String issueSttus;				// 이슈 상태: 22002:처리중 22003:처리완료 22004:반려
	 private String emrgncyYn;				// 긴급 여부: N:일반 Y:긴급
	 private int fileGroupNo;				// 파일그룹번호
	 private String empNm;					// 사원명
	
	 // 추가 
	 private int issueCmtCnt; // 이슈 댓글 수 (추가)
	 private List<IssueCommentVO> commentList; // 댓글 목록 (추가)
	 private List<FilesVO> fileList;		// 파일 리스트
	 
	}


