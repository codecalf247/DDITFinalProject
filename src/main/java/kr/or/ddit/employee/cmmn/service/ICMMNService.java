package kr.or.ddit.employee.cmmn.service;

import java.util.List;

import kr.or.ddit.vo.CommonCodeVO;

public interface ICMMNService {
	
	// CMMN_NM 을 통해서 해당 ID 값 가져오기
	public String getCMMNId(String CMMNCdNm);
	
	// CMMN_ID 를 통해서 해당 NAME 값 가져오기
	public String getCMMNName(String CMMNId);
	
	// CMMN_NM 을 통해서 해당 ID 값 가져오기
	public String getCMMNIdByGroupId(String groupId, String CMMNCdNm);
	
	// CMMN_ID 를 통해서 해당 NAME 값 가져오기
	public String getCMMNNamebyGroupId(String groupId, String CMMNId);
	
	// CMMN_GROUP_ID 를 통해서 CMMN_CD 테이블 해당 데이터 LIST 가져오기
	public List<CommonCodeVO> getCMMNListbyGroupId(String groupId);
	
}
