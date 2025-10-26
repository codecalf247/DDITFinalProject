package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;


// 프로젝트 전체적인 VO

@Data
public class ProjectVO {
	
	 private Integer prjctNo;				// 프로젝트 번호 
	 private String prjctCrdYmd;		// 프로젝트 생성 일자
	 private String prjctStartYmd;		// 프로젝트 시작 일자 
	 private String prjctDdlnYmd;		// 프로젝트 마감 일자 
	 private String prjctMdfcnYmd;		// 프로젝트 수정 일자 
	 private String prjctSttus;			// 프로젝트 상태 
	 private String sptNm;				// 현장명
	 private String sptAddr;			// 현장 주소 
	 private String cstmrNm;			// 고객명
	 private String cstmrTel;			// 고객전화번호 
	
	 private List<ProjectPerticipantVO> participantsList;
}
