package kr.or.ddit.employee.address.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CcpyVO;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IAddressMapper {

	public EmpVO selectEmpInfo(String empNo);

	public int selectEmpAddressCount(PaginationInfoVO<EmpVO> pagingVO);

	public List<EmpVO> selectEmpAddressList(PaginationInfoVO<EmpVO> pagingVO);

	public int selectCcpyAddressCount(PaginationInfoVO<CcpyVO> pagingVO);

	public List<CcpyVO> selectCcpyAddressList(PaginationInfoVO<CcpyVO> pagingVO);

	public int insertCcpyAddress(CcpyVO vo);

	public List<CommonCodeVO> selectCommonList(String groupId);

	public int updateCcpyAddress(CcpyVO vo);

	public int deleteCcpyAddress(int ccpyNo);

	// 비동기 이벤트로, 목록 데이터에서 한명의 정보를 가져올 때 사용한다.
	public CcpyVO selectCcpy(int ccpyId);

	


	

}
