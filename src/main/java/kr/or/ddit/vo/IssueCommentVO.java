package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class IssueCommentVO {


	 private int issueCmNo;				// 이슈 댓글 번호 (SEQ_ISSUE_CM)
	 private int issueNo;				// 이슈 번호 (FK)
	 private String empNo;				// 사원 번호 (FK)
	 private String issueCmCn;			// 이슈 댓글 내용
	 private Date issueCmWrtDt;			// 이슈 댓글 작성 일시
	 private Date issueCmMdfcnDt;		// 이슈 댓글 수정 일시
	 private String issueCmDelYn;		// 이슈 댓글 삭제 여부 (N:정상 / Y:삭제)

     // 조인을 위한 필드
     private String empNm;               // 사원명 (EMP.EMP_NM)
	

	}


