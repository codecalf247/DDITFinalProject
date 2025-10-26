package kr.or.ddit.employee.eApproval.service;

import java.util.List;

import kr.or.ddit.vo.ApprovalFormVO;
import kr.or.ddit.vo.DeptVO;

public interface ITreeApprovalFormService {
	public List<ApprovalFormVO> getDocumentList();
	public String getDocumentDC(int formNo);
	public List<DeptVO> getApprovalLine();
}
