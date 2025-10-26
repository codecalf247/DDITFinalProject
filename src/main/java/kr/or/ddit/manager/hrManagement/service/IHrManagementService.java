package kr.or.ddit.manager.hrManagement.service;

import java.util.List;

import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IHrManagementService {

	public int insert(EmpVO emp);

	public List<DeptVO> selectalldept();

	public List<EmpVO> selectAllEmp(PaginationInfoVO<EmpVO> pagingVO);

	public int selectEmpCount(PaginationInfoVO<EmpVO> pagingVO);

	public EmpVO selectOne(String empNo);

	public int update(EmpVO empvo);

	public int delete(EmpVO empvo);

	public int reactivate(EmpVO empvo);

}
