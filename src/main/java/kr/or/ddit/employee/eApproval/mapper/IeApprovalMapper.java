package kr.or.ddit.employee.eApproval.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

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
import kr.or.ddit.vo.attendance.YrycSttusVO;

@Mapper
public interface IeApprovalMapper {
	public void insertSaveLineEmp(SanctnLineBkmkVO saveLine);
	public void insertSaveLineEmpList(int bkmkNo, String empNo, int sanctnOrdr);
	public List<SanctnLineBkmkVO> getSaveLineList(String empNo);
	public List<SanctnLineBkmkVO> getSaveLineEmp(int saveLineSelect);
	public void insertSanctnDoc(SanctnDocVO sanctnDoc);
	public int insertProxySanctner(ProxySanctnerVO proxySanctner);
	public String getEmpNo(String loginEmpNo);
	public ProxySanctnerVO getProxyInfo(String empNo);
	public int deleteProxySanctner(int proxySanctnerNo);
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
	public List<SanctnFormVO> isFolderDoc(int formNo);
	public void folderDocDelete(int docFormNo);
	public SanctnFormVO getApprovalFormDetail(int formNo);
	public void docDetailModify(SanctnFormVO sanctnForm);
	
	// 전자결재 기안 관련
	public SanctnDocVO getApprovalDocInfo(String sanctnDocNo);
	public List<SanctnerVO> getApprovalSanctnerList(String sanctnDocNo);
	public List<SanctnCCVO> getApprovalSanctnerCCList(String sanctnDocNo);
	
	// 전자결재 기안 상신
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
	// 전자결재 기안자 회수
	public int deleteApprovalDoc(String sanctnDocNo);
	// 기안자 회수시 결재자 먼저 삭제
	public int deleteSanctner(String sanctnDocNo);
	// 기안자 회수시 참조자 먼저 삭제
	public int deleteSanctnerCC(String sanctnDocNo);
	// 전자결재 수신결재함 정보 가져오기
	public List<SanctnDocVO> getInboxList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 수신결재함 건수 가져오기
	public int getInboxCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 전자결재 승인/반려/전결 버튼
	public int approvalDocTyMof(SanctnerVO sanctner);
	// 현재 로그인한 사원의 날인 파일 경로 가져오기
	public String getSanctnerSignFilePath(String empNo);
	// 전자결재 앞사람 승인시 그 다음 사람 sttus 20002로 변경해주기
	public void approvalOrdrUpd(SanctnerVO sanctner);
	// 마지막 결재자면 결재문서 진행상태 완료로 변경
	public int approvalDocProcessStatusUpd(SanctnerVO sanctner);
	// 결재내역 cnt 가져오기
	public int getHistoryCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 전자결재 결재내역 List 가져오기
	public List<SanctnDocVO> getHistoryList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 재기안시 결재자 정보 가져오기
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
	// 결재 대기중 건수
	public int getPendingCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 대기중 List
	public List<SanctnDocVO> getPendingList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 완료 건수
	public int getCompletedCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 결재 완료 List
	public List<SanctnDocVO> getCompletedList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 참조 건수 가져오기
	public int getCCDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 참조 List 가져오기
	public List<SanctnDocVO> getCCDocList(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 페이지 건수 가져오기
	public int getRejectDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 페이지 list 가져오기
	public List<SanctnDocVO> getRejectDoc(PaginationInfoVO<SanctnDocVO> pagingVO);
	// 반려시 반려 upd
	public void approvalDocSttusUdp(String sanctnDocNo);
	// 파일 그룹번호 가져오기
	public Integer getSaveFileGroupNo(String sanctnDocNo);
	// 사용자 기안문서 가져오기
	public List<SanctnDocVO> getDashBoardList(String empNo);
	// 전자결재 즐겨찾기 양식
	public List<SanctnFormBkmkVO> getSanctnFormBkmk(String empNo);
	// 양식 즐겨찾기 insert
	public int insertApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk);
	// 양식 즐겨찾기 delete
	public int deleteApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk);
	// 즐겨찾기 갯수 get
	public int getBkmkCnt(String empNo);
	// 전자결재 임시저장 파일 삭제
	public int delFile(FilesVO file);
	// 현재 문서의 delYn 값 가져옴
	public String getSanctnDocDelYn(String sanctnDocNo);
	// 휴지통에서 진짜 삭제
	public int finalTrashApprovalDocDel(String sanctnDocNo);
	// 마지막 결재자 결재상태 가져오기
	public String getLastSanctnSttus(Map<String, Object> lastSanctnMap);
	// 연차현황 테이블 insert
	public void insertYrycSttus(YrycSttusVO yrycVO);
	// 연차현황 발급연도 가져오기
	public String getIssuYr(String empNo);
	// 대결자 설정 관련
	public List<SanctnerVO> getDocSanctner(String empNo);
	// 최종결재자를 대결자로 update
	public void mdfSanctnerInfo(Map<String, Object> mdfSanctnInfo);
	// 대결자 정보 가져오기
	public ProxySanctnerVO getProxySanctnerInfo(int proxySanctnerNo);
	// 최종결재자를 위임자로 udpate
	public void mdfProxySanctnerInfo(Map<String, Object> mdfSanctnInfo);
	// 전 문서 결재 내용 가져오기
	public SanctnDocVO getApprovalLastDocInfo(String reSanctnDocNo);
	// 결재문서 삭제
	public int deleteDoc(String sanctnDocNo);
}
