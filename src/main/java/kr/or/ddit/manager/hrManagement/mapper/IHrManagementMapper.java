package kr.or.ddit.manager.hrManagement.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpAuthVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IHrManagementMapper {

	public int selectEmpNo();

	public List<DeptVO> selectDeptNm();

	public int insertEmp(EmpVO emp);

	public void insertAuth(EmpAuthVO authVO);

	public List<EmpVO> selectAllEmp(PaginationInfoVO<EmpVO> pagingVO);

	public int selectEmpCount(PaginationInfoVO<EmpVO> pagingVO);

	public EmpVO selectOne(String empNo);

	public void deleteAuthByEmpNo(String empNo);

	public int updateEmp(EmpVO empvo);

	public int deleteEmp(EmpVO empvo);

	public int reactivate(EmpVO empvo);

}
