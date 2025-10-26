package kr.or.ddit.manager.deptManagement.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.DeptVO;

@Mapper
public interface IDeptMapper {
	// 상위 부서 정보 가져오기
	public List<DeptVO> getUpperDeptList();
	// 부서 정보 가져오기
	public List<DeptVO> getDeptList();
	// 하위 부서 정보 가져오기
	public List<DeptVO> getDeptSubList();
	// 부서별 사원 정보
	public List<DeptVO> getDeptEmpList(DeptVO dept);
	// 하위 부서별 사원 정보
	public List<DeptVO> getDeptTeamEmpList(DeptVO dept);
	// 사원 부서 이동
	public int empDeptMove(DeptVO dept);
	// 부서 수정
	public int mdfDept(DeptVO dept);
	// 상위 부서부터 삭제
	public int parentDelDept(DeptVO dept);
	// 부서 삭제
	public int delDept(DeptVO dept);
	// 상위 부서 만들기
	public int insertUpperDept(DeptVO dept);
	// 하위 부서 만들기
	public int insertDept(DeptVO dept);
	// 부서 jstree 가져오기
	public List<DeptVO> getUpperDeptTreeList();

}
