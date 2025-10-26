package kr.or.ddit.employee.eApproval.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.ApprovalFormVO;
import kr.or.ddit.vo.DeptVO;

@Mapper
public interface ITreeApprovalFormMapper {
	public List<ApprovalFormVO> getDocumentList();
	public String getDocumentDC(int formNo);
	public List<DeptVO> getApprovalLine();
}
