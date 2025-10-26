package kr.or.ddit.employee.eApproval.service;

import java.util.List;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProxySanctnerVO;
import kr.or.ddit.vo.SanctnCCVO;
import kr.or.ddit.vo.SanctnDocVO;
import kr.or.ddit.vo.SanctnFormBkmkVO;
import kr.or.ddit.vo.SanctnFormVO;
import kr.or.ddit.vo.SanctnLineBkmkVO;
import kr.or.ddit.vo.SanctnerVO;

public interface IeApprovalService {
	// 전자결재 기안 관련
	public void insertSaveLine(SanctnLineBkmkVO saveLine);
	public List<SanctnLineBkmkVO> getSaveLineList(String empNo);
	public List<SanctnLineBkmkVO> getSaveLineEmp(int saveLineSelect);
	public String insertSanctnDoc(SanctnDocVO sanctnDoc);
	public void insertProxySanctner(ProxySanctnerVO proxySanctner);
	public String getEmpNo(String loginEmpNo);
	public ProxySanctnerVO getProxyInfo(String empNo);
	public void deleteProxySanctner(int proxySanctnerNo);
	public ProxySanctnerVO getProxySanctner(String empNo);
	public void insertSanctner(SanctnerVO sanctner);
	public void insertSanctnCC(SanctnCCVO sancterCC);
	
	// 전자결재 양식 관련
	public void approvalFormRegister(SanctnFormVO sanctnForm);
	public List<SanctnFormVO> getApprovalFolderList(PaginationInfoVO<SanctnFormVO> pagingVO);
	public int getApprovalFolderListCnt(PaginationInfoVO<SanctnFormVO> pagingVO);
	public List<SanctnFormVO> getApprovalFormList(PaginationInfoVO<SanctnFormVO> pagingVO);
	public int getApprovalFormListCnt(PaginationInfoVO<SanctnFormVO> pagingVO);
	public void insertApprovalFolder(SanctnFormVO sanctnForm);
	public SanctnFormVO getFolderInfo(int formNo);
	public void folderModify(SanctnFormVO sanctnForm);
	public void folderDelete(int formNo);
	public SanctnFormVO getApprovalFormDetail(int formNo);
	public void docDetailModify(SanctnFormVO sanctnForm);
	
	// 전자결재 기안 관련
	public SanctnDocVO getApprovalDocInfo(String sanctnDocNo);
	public List<SanctnerVO> getApprovalSanctnerList(String sanctnDocNo);
	public List<SanctnCCVO> getApprovalSanctnerCCList(String sanctnDocNo);
	
	// 전자결재 기안서 상신
	public void approvalDocRegister(SanctnDocVO sanctnDoc);
	// 전자결재 기안 파일 그룹 번호 생성
	public int getFileGroupNo();
	// 전자결재 파일 등록
	public void approvalFileRegister(FilesVO file);
	
	// 전자결재 날인 삭제
	public void deleteStamp(String empNo);
	
	// 전자결재 날인 등록
	public void insertStamp(EmpVO empInfo);
	
	// 전자결재 등록된 날인 정보 가져오기
	public String getStampFilePath(String empNo);
	
	// 전자결재 상신진행함 목록 가져오기
	public List<SanctnDocVO> getApprovalInProcess(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 전자결재 상신진행함 건수 가져오기
	public int getApprovalInProcessCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 기안자 전자결재 상신 회수
	public int deleteApprovalDoc(String sanctnDocNo);
	
	// 전자결재 수신결재함 정보 가져오기
	public List<SanctnDocVO> getInboxList(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 수신결재함 건수 가져오기
	public int getInboxCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 전자결재 승인/반려/전결
	public void approvalDocTyMof(SanctnerVO sanctner);
	
	// 현재 로그인한 사원의 날인 파일 경로 가져오기
	public String getSanctnerSignFilePath(String empNo);
	
	// 결재내역 cnt 가져오기
	public int getHistoryCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 전자결재 결재내역 List 가져오기
	public List<SanctnDocVO> getHistoryList(PaginationInfoVO<SanctnDocVO> pagingVO);
	
	// 재기안시 문서 정보 가져오기
	public SanctnDocVO getReSubmitDocInfo(String sanctnDocNo);
	
	// 재기안시 결재선 가져오기
	public List<SanctnerVO> getApprovalReSubmitSanctnerList(String sanctnDocNo);
	// 임시저장 건수 가져오기
	public int getDraftDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 임시저장 List 가져오기
	public List<SanctnDocVO> getDraftDoc(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 임시저장 삭제
	public int draftApprovalDocDel(String sanctnDocNo);
	// 휴지통 건수 가져오기
	public int getTrashDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 휴지통 List 가져오기
	public List<SanctnDocVO> getTrashList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 휴지통에서 복원시
	public int restoreDoc(String sanctnDocNo);
	// 결재 대기 중 건수 가져오기
	public int getPendingCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 대기 중 List 가져오기
	public List<SanctnDocVO> getPendingList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 완료 건수 가져오기
	public int getCompletedCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 완료 List 가져오기
	public List<SanctnDocVO> getCompletedList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 참조 건수 가져오기
	public int getCCDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 참조 List 가져오기
	public List<SanctnDocVO> getCCDocList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 반려 건수 가져오기
	public int getRejectDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 반려 List 가져오기
	public List<SanctnDocVO> getRejectDoc(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 파일 그룹 번호 가져오기
	public Integer getSaveFileGroupNo(String sanctnDocNo);
	// 사용자 최근 기안 문서 가져오기
	public List<SanctnDocVO> getDashBoardList(String empNo);
	// 전자결재 양식 즐겨찾기
	public List<SanctnFormBkmkVO> getSanctnFormBkmk(String empNo);
	// 양식 즐겨찾기 insert
	public int insertApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk);
	// 양식 즐겨찾기 delete
	public int deleteApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk);
	// 즐겨찾기 갯수 get
	public int getBkmkCnt(String empNo);
	// 전자결재 임시저장 파일 삭제
	public int delFile(FilesVO file);
	// 재기안을 위한 지난 결재내용 내역 가져오기
	public SanctnDocVO getApprovalLastDocInfo(String reSanctnDocNo);
	// 기안 문서 취소시 삭제
	public int delDoc(String sanctnDocNo);
}
