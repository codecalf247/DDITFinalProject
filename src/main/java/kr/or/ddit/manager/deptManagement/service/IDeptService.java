package kr.or.ddit.manager.deptManagement.service;

import java.util.List;

import kr.or.ddit.vo.DeptVO;

public interface IDeptService {
	// 상위 부서 정보 가져오기
	public List<DeptVO> getUpperDeptList();
	// 부서 목록 가져오기
	public List<DeptVO> getDeptList();
	// 부서 하위 목록 가져오기
	public List<DeptVO> getDeptSubList();
	// 부서별 팀원 목록 가져오기
	public List<DeptVO> getDeptEmpList(DeptVO dept);
	// 사원 부서 이동
	public int empDeptMove(DeptVO dept);
	// 부서 수정
	public int mdfDept(DeptVO dept);
	// 부서 삭제
	public int delDept(DeptVO dept);
	// 부서 등록
	public int insertDept(DeptVO dept);
	// 부서별 하위 팀원 목록 가져오기
	public List<DeptVO> getDeptTeamEmpList(DeptVO dept);
	// 부서 jstree 가져오기
	public List<DeptVO> getUpperDeptTreeList();

}
