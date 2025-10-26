package kr.or.ddit.employee.eApproval.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.eApproval.mapper.IeApprovalMapper;
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
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EApprovalServiceImpl implements IeApprovalService {

	@Autowired
	private IeApprovalMapper mapper;
	
	@Autowired
	private NotificationConfig noti;

	// 결재선 저장
	@Override
	public void insertSaveLine(SanctnLineBkmkVO saveLine) {
		mapper.insertSaveLineEmp(saveLine);

		// 즐겨찾기 상세 지정
		int order = 1;
		for (String empNo : saveLine.getEmpNoList()) {
			mapper.insertSaveLineEmpList(saveLine.getBkmkNo(), empNo, order++);
		}

	}

	// 결재선 저장 목록 불러오기
	@Override
	public List<SanctnLineBkmkVO> getSaveLineList(String empNo) {
		List<SanctnLineBkmkVO> getSaveLineList = mapper.getSaveLineList(empNo);
		return getSaveLineList;
	}

	// 결재선 저장 목록 선택시 결재선 불러오기
	@Override
	public List<SanctnLineBkmkVO> getSaveLineEmp(int saveLineSelect) {
		List<SanctnLineBkmkVO> getSaveLineEmp = mapper.getSaveLineEmp(saveLineSelect);
		return getSaveLineEmp;
	}

	// 문서정보 insert
	@Override
	public String insertSanctnDoc(SanctnDocVO sanctnDoc) {
		mapper.insertSanctnDoc(sanctnDoc);
		String sanctnDocNo = sanctnDoc.getSanctnDocNo();
		log.info(sanctnDocNo);
		return sanctnDocNo;
	}

	// 대결자 insert
	@Override
	public void insertProxySanctner(ProxySanctnerVO proxySanctner) {
		int status = mapper.insertProxySanctner(proxySanctner);
		
		if(status > 0) {
			String empNo = proxySanctner.getEmpNo(); // 위임자
			String proxyEmpNo = proxySanctner.getProxyEmpNo(); // 대결자
			
			log.debug("empNo:{}, proxyEmpNo:{}", empNo, proxyEmpNo);

			// 결재자에 위임자가 있으면서 그 위임자가 아직 결재하지 못한 List
			List<SanctnerVO> sanctnDocList = mapper.getDocSanctner(empNo);
			
			log.debug("결재문서List sanctnDocList : {}", sanctnDocList);
			
			for(SanctnerVO sdl : sanctnDocList) {
				String sanctnDocNo = sdl.getSanctnDocNo();
				// 최종결재자를 대결자로 update
				Map<String, Object> mdfSanctnInfo = new HashMap<>();
				mdfSanctnInfo.put("proxyEmpNo", proxyEmpNo);
				mdfSanctnInfo.put("sanctnDocNo", sanctnDocNo);
				mdfSanctnInfo.put("empNo", empNo);
				
				mapper.mdfSanctnerInfo(mdfSanctnInfo);
				// 대결자 변경시에도 알림이 갈 수 있도록
				noti.notify(proxyEmpNo, "12006", "결재문서", "/eApproval/inbox");
			}
			
		}
	}

	// 대결자 insert 전 이미 대결자 선택했나 확인 로직
	@Override
	public String getEmpNo(String loginEmpNo) {
		String empNo = mapper.getEmpNo(loginEmpNo);
		return empNo;
	}

	// 대결자 설정 해놨으면 정보 불러오기
	@Override
	public ProxySanctnerVO getProxyInfo(String empNo) {
		ProxySanctnerVO proxyInfo = mapper.getProxyInfo(empNo);
		return proxyInfo;
	}

	// 대결자 삭제
	@Override
	public void deleteProxySanctner(int proxySanctnerNo) {
		ProxySanctnerVO proxySanctnerInfo = mapper.getProxySanctnerInfo(proxySanctnerNo);
		// 대결자 삭제
		int status = mapper.deleteProxySanctner(proxySanctnerNo);
		
		// 대결자 삭제할 때도 현재 날짜랑 비교해서 최종 결재자 다시 원래 결재자로 update
		if(status > 0) {
			// 대결자 등록 번호를 가지고 대결자 정보를 가지고 와야됨
			
			String empNo = proxySanctnerInfo.getEmpNo(); // 위임자
			String proxyEmpNo = proxySanctnerInfo.getProxyEmpNo(); // 대결자
			
			log.debug("empNo:{}, proxyEmpNo:{}", empNo, proxyEmpNo);

			// 결재자에 위임자가 있으면서 그 위임자가 아직 결재하지 못한 List
			List<SanctnerVO> sanctnDocList = mapper.getDocSanctner(proxyEmpNo);
			
			log.debug("결재문서List sanctnDocList : {}", sanctnDocList);
			
			for(SanctnerVO sdl : sanctnDocList) {
				String sanctnDocNo = sdl.getSanctnDocNo();
				// 최종결재자를 대결자로 update
				Map<String, Object> mdfSanctnInfo = new HashMap<>();
				mdfSanctnInfo.put("proxyEmpNo", proxyEmpNo);
				mdfSanctnInfo.put("sanctnDocNo", sanctnDocNo);
				mdfSanctnInfo.put("empNo", empNo);
				
				mapper.mdfProxySanctnerInfo(mdfSanctnInfo);
			}
		}
		
	}

	// 대결자 선택했을 경우 결재자 선택시 대결자 이름도 뜨도록
	@Override
	public ProxySanctnerVO getProxySanctner(String empNo) {
		ProxySanctnerVO proxyInfo = mapper.getProxySanctner(empNo);
		return proxyInfo;
	}

	// 결재자 insert
	@Override
	public void insertSanctner(SanctnerVO sanctner) {
		mapper.insertSanctner(sanctner);
	}

	// 참조자 insert
	@Override
	public void insertSanctnCC(SanctnCCVO sancterCC) {
		mapper.insertSanctnCC(sancterCC);
	}

	//////////////////////////////////////////////////////////////////////
	// 전자결재 양식 insert
	@Override
	public void approvalFormRegister(SanctnFormVO sanctnForm) {
		mapper.approvalFormRegister(sanctnForm);
	}

	// 전자결재 상위 폴더 list 가져오기
	@Override
	public List<SanctnFormVO> getApprovalFolderList(PaginationInfoVO<SanctnFormVO> pagingVO) {
		List<SanctnFormVO> sanctnFormFolderList = mapper.getApprovalFolderList(pagingVO);
		return sanctnFormFolderList;
	}

	// 전자결재 상위 폴더 갯수 가져오기getApprovalFolderList
	@Override
	public int getApprovalFolderListCnt(PaginationInfoVO<SanctnFormVO> pagingVO) {
		int cnt = mapper.getApprovalFolderListCnt(pagingVO);
		return cnt;
	}

	// 전자결재 하위 폴더 list 가져오기
	@Override
	public List<SanctnFormVO> getApprovalFormList(PaginationInfoVO<SanctnFormVO> pagingVO) {
		List<SanctnFormVO> sanctnFormList = mapper.getApprovalFormList(pagingVO);
		return sanctnFormList;
	}

	// 전자결재 하위 양식 갯수 가져오기
	@Override
	public int getApprovalFormListCnt(PaginationInfoVO<SanctnFormVO> pagingVO) {
		int cnt = mapper.getApprovalFormListCnt(pagingVO);
		return cnt;
	}

	// 전자결재 상위 폴더 등록
	@Override
	public void insertApprovalFolder(SanctnFormVO sanctnForm) {
		mapper.insertApprovalFolder(sanctnForm);
	}

	// 전자결재 상위 폴더 수정시 필요한 정보 가져오기
	@Override
	public SanctnFormVO getFolderInfo(int formNo) {
		SanctnFormVO sanctnFolderInfo = mapper.getFolderInfo(formNo);
		return sanctnFolderInfo;
	}

	// 전자결재 상위 폴더 수정
	@Override
	public void folderModify(SanctnFormVO sanctnForm) {
		mapper.folderModify(sanctnForm);
	}

	// 전자결재 상위 폴더 삭제
	@Override
	public void folderDelete(int formNo) {
		// 상위 폴더 내 하위 문서 확인
		List<SanctnFormVO> sanctnFormList = mapper.isFolderDoc(formNo);

		if (sanctnFormList == null) {
			// 상위 폴더 삭제
			mapper.folderDelete(formNo);
		} else {
			for (SanctnFormVO sanctnForm : sanctnFormList) {
				// 하위 문서 먼저 강제 삭제
				int docFormNo = sanctnForm.getFormNo();
				log.debug("docFormNo={}", docFormNo);
				mapper.folderDocDelete(docFormNo);
				log.debug("삭제 완료");
			}
			mapper.folderDelete(formNo);
		}

	}

	// 양식 문서 상세보기
	@Override
	public SanctnFormVO getApprovalFormDetail(int formNo) {
		SanctnFormVO sanctnFormInfo = mapper.getApprovalFormDetail(formNo);
		return sanctnFormInfo;
	}

	// 양식 문서 상세보기 수정
	@Override
	public void docDetailModify(SanctnFormVO sanctnForm) {
		mapper.docDetailModify(sanctnForm);
	}

	//////////////////////////////////////////////////////////
	// 전자결재 기안 관련

	// 결재문서 정보 가져오기
	@Override
	public SanctnDocVO getApprovalDocInfo(String sanctnDocNo) {
		SanctnDocVO sanctnDocInfo = mapper.getApprovalDocInfo(sanctnDocNo);
		return sanctnDocInfo;
	}

	// 결재자 가져오기
	@Override
	public List<SanctnerVO> getApprovalSanctnerList(String sanctnDocNo) {
		List<SanctnerVO> sanctnerList = mapper.getApprovalSanctnerList(sanctnDocNo);
		return sanctnerList;
	}

	// 참조자 가져오기
	@Override
	public List<SanctnCCVO> getApprovalSanctnerCCList(String sanctnDocNo) {
		List<SanctnCCVO> sanctnerCCList = mapper.getApprovalSanctnerCCList(sanctnDocNo);
		return sanctnerCCList;
	}

	// 전자결재 기안서 상신
	@Override
	public void approvalDocRegister(SanctnDocVO sanctnDoc) {
		String sanctnDocNo = sanctnDoc.getSanctnDocNo();
		List<SanctnerVO> sanctnerList = mapper.getApprovalSanctnerList(sanctnDocNo);
		
		for(SanctnerVO sanctner : sanctnerList) {
			if(sanctner.getSanctnOrdr() == 1) {
				noti.notify(sanctner.getEmpNo(), "12006", "결재문서", "/eApproval/inbox");
			}
		}
		
		mapper.approvalDocRegister(sanctnDoc);
	}

	// 전자결재 기안 파일 그룹 번호 생성
	@Override
	public int getFileGroupNo() {
		return mapper.getFileGroupNo();
	}

	// 전자결재 파일 등록
	@Override
	public void approvalFileRegister(FilesVO file) {
		mapper.approvalFileRegister(file);
	}

	// 전자결재 날인 삭제
	@Override
	public void deleteStamp(String empNo) {
		mapper.deleteStamp(empNo);
	}

	// 전자결재 날인 등록
	@Override
	public void insertStamp(EmpVO empInfo) {
		mapper.insertStamp(empInfo);
	}

	// 전자결재 등록된 날인 정보 가져오기
	@Override
	public String getStampFilePath(String empNo) {
		return mapper.getStampFilePath(empNo);
	}

	// 전자결재 상신진행함 목록 가져오기
	@Override
	public List<SanctnDocVO> getApprovalInProcess(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> inProcessList = mapper.getApprovalInProcess(pagingVO);
		return inProcessList;
	}

	// 전자결재 상신진행함 건수 가져오기
	@Override
	public int getApprovalInProcessCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getApprovalInProcessCnt(pagingVO);
	}

	// 전자결재 기안자 회수
	@Override
	public int deleteApprovalDoc(String sanctnDocNo) {
//		// 결재자, 참조자 먼저 삭제
//		int result = mapper.deleteSanctner(sanctnDocNo);
//		if (result == 0) {
//			return 0;
//		}
//		mapper.deleteSanctnerCC(sanctnDocNo);

		// 결재문서 회수 전 결재선 리스트를 불러와서 그 리스트의 결재자가 한명이라도 결재상태가 20003, 20004, 20005, 20007이면 return 0 
		List<SanctnerVO> sanctnerList = mapper.getApprovalSanctnerList(sanctnDocNo);
		for(SanctnerVO scl : sanctnerList) {
			String sanctnSttus = scl.getSanctnSttus();
			if("20003".equals(sanctnSttus) || "20004".equals(sanctnSttus) || "20005".equals(sanctnSttus) || "20007".equals(sanctnSttus)) {
				return 0;
			}
		}
		
		// 결재문서 회수시 결재상태 변경 09001로
		int status = mapper.deleteApprovalDoc(sanctnDocNo);
		
		if(status > 0) {
			return 1;
		}else {
			return 0;
		}
	}

	// 전자결재 수신결재함 정보 가져오기
	@Override
	public List<SanctnDocVO> getInboxList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getInboxList(pagingVO);
		return sanctnDocList;
	}

	// 수신결재함 건수 가져오기
	@Override
	public int getInboxCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getInboxCnt(pagingVO);
	}

	// 전자결재 승인/반려/전결
	@Override
	public void approvalDocTyMof(SanctnerVO sanctner) {
		// 결재자 List 가져오기
		String sanctnDocNo = sanctner.getSanctnDocNo();
		List<SanctnerVO> sanctnerList = mapper.getApprovalSanctnerList(sanctnDocNo);
		String lastEmpNo = sanctnerList.get(sanctnerList.size() - 1).getLastSanctner();
		log.debug("lastEmpNo: {} ", lastEmpNo);
		
		// 다음 사람에게 알림 보내기 위한
		String nextEmpNo = null;
		boolean flag = false;
		for(SanctnerVO sl : sanctnerList) {
			String sttus = sl.getSanctnSttus();
			if(flag) {
				nextEmpNo = sl.getEmpNo();
				flag = false;
			}
			
			if(sttus.equals("20002")) {
				flag = true;
			}
			log.debug("flag : {}", flag);
			log.debug("sttus : {}", sttus);
			log.debug("nextEmpNo : {}", nextEmpNo);
		}
		
		// 승인/반려 상태 upd
		int status = mapper.approvalDocTyMof(sanctner);
		
		// 승인, 대결시 마지막 결재자가 아니면 다음 결재자 대기 -> 처리중으로 변경
		String sanctnSttus = sanctner.getSanctnSttus();
		
		log.debug("sanctner : {}", sanctner);
		
		int completedStatus = 0;
		
		// 전결시 마지막 결재자 여부 상관없이 완료 처리
		if ("20005".equals(sanctnSttus)) {
			completedStatus = mapper.approvalDocProcessStatusUpd(sanctner);
		} else if ("20003".equals(sanctnSttus) || "20004".equals(sanctnSttus)) { // 승인, 대결 처리시
			if (!lastEmpNo.equals(sanctner.getEmpNo())) {
				if (status > 0) {
					// 다음 결재자 상태 변경
					log.debug("현재 사원번호: sanctner.getEmpNo():{} ", sanctner.getEmpNo());
					mapper.approvalOrdrUpd(sanctner);
					noti.notify(nextEmpNo, "12006", "결재문서", "/eApproval/inbox");
				} 
			} else {
				// 마지막 결재자면 결재문서 진행상태 완료로 변경
				completedStatus = mapper.approvalDocProcessStatusUpd(sanctner);
			}
		}
		
		// 문서 정보 가져오기
		SanctnDocVO sanctnDocInfo = mapper.getApprovalDocInfo(sanctnDocNo);
		String sanctnCn = sanctnDocInfo.getSanctnCn(); // 문서 내용
		String empNo = sanctnDocInfo.getEmpNo(); // 기안자
		int formNo = sanctnDocInfo.getFormNo();
		String issurYr= mapper.getIssuYr(empNo);
		
		// 문서 진행상태가 완료, formNo == 102(휴가)
		if(completedStatus > 0 && formNo == 102) {
			log.debug("sanctnCn확인: sanctnCn:{} ", sanctnCn);
			
	        // 사용일수
	        Matcher m1 = Pattern.compile("name=\"days\"[^>]*value=\"(.*?)\"").matcher(sanctnCn);
	        String getDays = m1.find() ? m1.group(1) : null;
	        double days = Double.parseDouble(getDays);

	        // 시작일
	        Matcher m2 = Pattern.compile("name=\"from\"[^>]*value=\"(.*?)\"").matcher(sanctnCn);
	        String from = m2.find() ? m2.group(1) : null;

	        // 종료일
	        Matcher m3 = Pattern.compile("name=\"to\"[^>]*value=\"(.*?)\"").matcher(sanctnCn);
	        String to = m3.find() ? m3.group(1) : null;
	        
	        YrycSttusVO yrycVO = new YrycSttusVO();
	        yrycVO.setEmpNo(empNo); // 사원번호
	        yrycVO.setIssuYr(issurYr); // 발급연도
	        yrycVO.setUseCo(days); // 사용개수
	        yrycVO.setStartDt(from); // 시작일시
	        yrycVO.setEndDt(to); // 종료일시
			
			
			// 마지막 결재자 결재상태 확인(20003, 20004, 20005)
			Map<String, Object> lastSanctnMap = new HashMap<>();
			lastSanctnMap.put("lastEmpNo", lastEmpNo);
			lastSanctnMap.put("sanctnDocNo", sanctnDocNo);
			String lastSanctnSttus = mapper.getLastSanctnSttus(lastSanctnMap);
			if("20003".equals(lastSanctnSttus) || "20004".equals(lastSanctnSttus) || "20005".equals(lastSanctnSttus)) {
				// 연차현황 테이블에 update
				mapper.insertYrycSttus(yrycVO);
			}
			
		}
		
		// 반려시 반려 upd
		if("20007".equals(sanctner.getSanctnSttus())) {
			mapper.approvalDocSttusUdp(sanctnDocNo);
		}

	}

	// 현재 로그인한 사원의 날인 파일 경로 가져오기
	@Override
	public String getSanctnerSignFilePath(String empNo) {
		return mapper.getSanctnerSignFilePath(empNo);
	}

	// 결재내역 cnt 가져오기
	@Override
	public int getHistoryCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getHistoryCnt(pagingVO);
	}

	// 전자결재 결재내역 List 가져오기
	@Override
	public List<SanctnDocVO> getHistoryList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnHistoryList = mapper.getHistoryList(pagingVO);
		return sanctnHistoryList;
	}

	// 재기안시 문서 정보 가져오기
	@Override
	public SanctnDocVO getReSubmitDocInfo(String sanctnDocNo) {
		SanctnDocVO sanctnDocInfo = mapper.getApprovalDocInfo(sanctnDocNo);
		return sanctnDocInfo;
	}

	
	// 재기안시 결재선 가져오기
	@Override
	public List<SanctnerVO> getApprovalReSubmitSanctnerList(String sanctnDocNo) {
		List<SanctnerVO> sanctnerList = mapper.getApprovalReSubmitSanctnerList(sanctnDocNo);
		return sanctnerList;
	}

	// 임시저장 건수 가져오기
	@Override
	public int getDraftDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getDraftDocCnt(pagingVO);
	}

	// 임시저장 List 가져오기
	@Override
	public List<SanctnDocVO> getDraftDoc(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getDraftDoc(pagingVO);
		return sanctnDocList;
	}

	// 임시저장 삭제, 휴지통에서 삭제
	@Override
	public int draftApprovalDocDel(String sanctnDocNo) {
		int status = 0;
		
		// 문서의 delYn을 가져옴
		String delTy = mapper.getSanctnDocDelYn(sanctnDocNo);
		
		// delYn이 d면 현재 휴지통이니까 완전 삭제 L로 upd
		if("D".equals(delTy)) {
			status = mapper.finalTrashApprovalDocDel(sanctnDocNo);
		}else if("N".equals(delTy)) {
			// n이면 휴지통으로 이동이니까 D로 upd
			status = mapper.draftApprovalDocDel(sanctnDocNo);
		}
		
		return status;
	}

	// 휴지통 건수 가져오기
	@Override
	public int getTrashDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getTrashDocCnt(pagingVO);
	}

	// 휴지통 List 가져오기
	@Override
	public List<SanctnDocVO> getTrashList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getTrashList(pagingVO);
		return sanctnDocList;
	}

	// 결재 휴지통에서 복원시
	@Override
	public int restoreDoc(String sanctnDocNo) {
		return mapper.restoreDoc(sanctnDocNo);
	}

	// 결재 대기중 건수
	@Override
	public int getPendingCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getPendingCnt(pagingVO);
	}

	// 결재 대기중 List 가져오기
	@Override
	public List<SanctnDocVO> getPendingList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getPendingList(pagingVO);
		return sanctnDocList;
	}

	// 결재 완료 건수 가져오기
	@Override
	public int getCompletedCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getCompletedCnt(pagingVO);
	}

	// 결재 완료 List 가져오기
	@Override
	public List<SanctnDocVO> getCompletedList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getCompletedList(pagingVO);
		return sanctnDocList;
	}

	// 참조 건수 가져오기
	@Override
	public int getCCDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getCCDocCnt(pagingVO);
	}

	// 참조 List 가져오기
	@Override
	public List<SanctnDocVO> getCCDocList(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getCCDocList(pagingVO);
		return sanctnDocList;
	}
	
	// 반려 건수 가져오기
	@Override
	public int getRejectDocCnt(PaginationInfoVO<SanctnDocVO> pagingVO) {
		return mapper.getRejectDocCnt(pagingVO);
	}

	// 반려 List 가졍괴
	@Override
	public List<SanctnDocVO> getRejectDoc(PaginationInfoVO<SanctnDocVO> pagingVO) {
		List<SanctnDocVO> sanctnDocList = mapper.getRejectDoc(pagingVO);
		return sanctnDocList;
	}

	// 파일 그룹 번호 가져오기 
	@Override
	public Integer getSaveFileGroupNo(String sanctnDocNo) {
		return mapper.getSaveFileGroupNo(sanctnDocNo);
	}

	// 사용자 최근 기안 문서 가져오기
	@Override
	public List<SanctnDocVO> getDashBoardList(String empNo) {
		List<SanctnDocVO> dashBoardList = mapper.getDashBoardList(empNo);
		return dashBoardList;
	}

	// 전자결재 양식 즐겨찾기
	@Override
	public List<SanctnFormBkmkVO> getSanctnFormBkmk(String empNo) {
		List<SanctnFormBkmkVO> sanctnFormBkmkList = mapper.getSanctnFormBkmk(empNo);
		return sanctnFormBkmkList;
	}

	// 양식 즐겨찾기 insert
	@Override
	public int insertApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk) {
		return mapper.insertApprovalFormBkmk(sanctnBkmk);
	}

	// 양식 즐겨찾기 delete
	@Override
	public int deleteApprovalFormBkmk(SanctnFormBkmkVO sanctnBkmk) {
		return mapper.deleteApprovalFormBkmk(sanctnBkmk);
	}

	// 즐겨찾기 갯수 get
	@Override
	public int getBkmkCnt(String empNo) {
		return mapper.getBkmkCnt(empNo);
	}

	// 전자결재 임시저장 파일 delete
	@Override
	public int delFile(FilesVO file) {
		int status = mapper.delFile(file);
		return status;
	}

	// 전 문서 결재 내용 가져오기
	@Override
	public SanctnDocVO getApprovalLastDocInfo(String reSanctnDocNo) {
		SanctnDocVO lastSanctnDocInfo = mapper.getApprovalLastDocInfo(reSanctnDocNo);
		return lastSanctnDocInfo;
	}

	// 기안문서 취소 시 삭제
	@Override
	public int delDoc(String sanctnDocNo) {
		// 결재자 참조자 먼저 삭제
		mapper.deleteSanctner(sanctnDocNo);
		mapper.deleteSanctnerCC(sanctnDocNo);
		
		// 기안문서 삭제
		int status = mapper.deleteDoc(sanctnDocNo);
		
		return status;
	}


}
