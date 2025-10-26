package kr.or.ddit.employee.eApproval.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.eApproval.mapper.ITreeApprovalFormMapper;
import kr.or.ddit.vo.ApprovalFormVO;
import kr.or.ddit.vo.DeptVO;

@Service
public class TreeApprovalFormServiceImpl implements ITreeApprovalFormService {

	@Autowired
	private ITreeApprovalFormMapper mapper;
	
	@Override
	public List<ApprovalFormVO> getDocumentList(){
		return mapper.getDocumentList();
	}

	@Override
	public String getDocumentDC(int formNo) {
		return mapper.getDocumentDC(formNo);
	}

	@Override
	public List<DeptVO> getApprovalLine() {
		return mapper.getApprovalLine();
	}
	
}
