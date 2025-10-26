package kr.or.ddit.manager.deptManagement.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.manager.deptManagement.mapper.IDeptMapper;
import kr.or.ddit.vo.DeptVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DeptServiceImpl implements IDeptService {
	
	@Autowired
	public IDeptMapper deptMapper;
	
	/**
	 * <p>상위 부서정보 가져오기</p>
	 * 
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param 
	 * @return 상위 부서 정보
	 */
	@Override
	public List<DeptVO> getUpperDeptList() {
		List<DeptVO> upperDeptInfo = deptMapper.getUpperDeptList();
		return upperDeptInfo;
	}
	
	/**
	 * <p>부서정보 가져오기</p>
	 * 
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param 
	 * @return 부서 정보
	 */
	@Override
	public List<DeptVO> getDeptList() {
		List<DeptVO> deptInfo = deptMapper.getDeptList();
		return deptInfo;
	}
	
	/**
	 * <p>하위 부서정보 가져오기</p>
	 * 
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param 
	 * @return 하위 부서 정보
	 */
	@Override
	public List<DeptVO> getDeptSubList() {
		List<DeptVO> deptSubInfo = deptMapper.getDeptSubList();
		return deptSubInfo;
	}
	
	/**
	 * <p>부서별 팀원 목록 가져오기</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return 부서별 사원 정보
	 */
	@Override
	public List<DeptVO> getDeptEmpList(DeptVO dept) {
		List<DeptVO> deptInfo = deptMapper.getDeptEmpList(dept);
		return deptInfo;
	}
	
	/**
	 * <p>하위 부서별 팀원 목록 가져오기</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return 하위 부서별 사원 정보
	 */
	@Override
	public List<DeptVO> getDeptTeamEmpList(DeptVO dept) {
		List<DeptVO> deptTeamEmpInfo = deptMapper.getDeptTeamEmpList(dept);
		return deptTeamEmpInfo;
	}

	/**
	 * <p>사원 부서 이동</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return int status 상태값(성공 1, 실패 0)
	 */
	@Override
	public int empDeptMove(DeptVO dept) {
		int status = deptMapper.empDeptMove(dept);
		return status;
	}

	/**
	 * <p>부서 수정</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return int status 상태값(성공 1, 실패 0)
	 */
	@Override
	public int mdfDept(DeptVO dept) {
		int status = deptMapper.mdfDept(dept);
		return status;
	}

	
	/**
	 * <p>부서 삭제</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return int status 상태값(성공 1, 실패 0)
	 */
	@Override
	public int delDept(DeptVO dept) {
		int status = 0;
		int upperDeptNo = dept.getUpperDeptNo();
		
		// 자식부터 삭제
		if(upperDeptNo > 0) {
			dept.setDeptNo(upperDeptNo);
			status = deptMapper.parentDelDept(dept);
			status = deptMapper.delDept(dept);
		}else if(upperDeptNo == 0) {
			status = deptMapper.delDept(dept);
		}
		
		return status;
	}

	/**
	 * <p>부서 등록</p>
	 * @date 2025.09.22.
	 * @author lyj(ddit)
	 * @param DeptVO dept
	 * @return int status 상태값(성공 1, 실패 0)
	 */
	@Override
	public int insertDept(DeptVO dept) {
		int status = 0;
		int upperDeptNo = dept.getUpperDeptNo();

		// 하위 부서 만들기
		if(upperDeptNo == 0) {
			status = deptMapper.insertUpperDept(dept);
		}else { 
			// 상위 부서 만들기
			status = deptMapper.insertDept(dept);
		}
		
		return status;
	}

	/**
	 * <p>부서 jstree 가져오기</p>
	 * @date 2025.09.25.
	 * @author lyj(ddit)
	 * @param -
	 * @return List<DeptVO> deptList
	 */
	@Override
	public List<DeptVO> getUpperDeptTreeList() {
		List<DeptVO> deptList = deptMapper.getUpperDeptTreeList();
		return deptList;
	}

}
