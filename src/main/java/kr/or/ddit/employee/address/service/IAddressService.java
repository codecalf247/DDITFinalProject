package kr.or.ddit.employee.address.service;

import java.util.List;

import kr.or.ddit.vo.CcpyVO;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IAddressService {

	public EmpVO getEmpInfo(String empNo);

	public int selectEmpAddressCount(PaginationInfoVO<EmpVO> pagingVO);

	public List<EmpVO> selectEmpAddressList(PaginationInfoVO<EmpVO> pagingVO);

	public int selectCcpyAddressCount(PaginationInfoVO<CcpyVO> pagingVO);

	public List<CcpyVO> selectCcpyAddressList(PaginationInfoVO<CcpyVO> pagingVO);

	public int insertCcpyAddress(CcpyVO vo);

	public List<CommonCodeVO> selectCommonList(String groupId);

	public int updateCcpyAddress(CcpyVO vo);

	public int deleteCcpyAddress(int ccpyNo);

	// 비동기 이벤트로 목록에서 한명의 정보를 가져올 때 사용하는 함수
	public CcpyVO selectCcpy(int ccpyId);

	
	

	


	

	

	

}
