package kr.or.ddit.employee.address.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.address.mapper.IAddressMapper;
import kr.or.ddit.vo.CcpyVO;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class AddressServiceImpl implements IAddressService {

    @Autowired
    private IAddressMapper addressMapper;

    @Override
    public EmpVO getEmpInfo(String empNo) {
        return addressMapper.selectEmpInfo(empNo);
    }

	@Override
	public int selectEmpAddressCount(PaginationInfoVO<EmpVO> pagingVO) {
		return addressMapper.selectEmpAddressCount(pagingVO);
	}

	@Override
	public List<EmpVO> selectEmpAddressList(PaginationInfoVO<EmpVO> pagingVO) {
		return addressMapper.selectEmpAddressList(pagingVO);
	}

	@Override
	public int selectCcpyAddressCount(PaginationInfoVO<CcpyVO> pagingVO) {
		return addressMapper.selectCcpyAddressCount(pagingVO);
	}

	@Override
	public List<CcpyVO> selectCcpyAddressList(PaginationInfoVO<CcpyVO> pagingVO) {
		return addressMapper.selectCcpyAddressList(pagingVO);
	}

	@Override
	public int insertCcpyAddress(CcpyVO vo) {
		return addressMapper.insertCcpyAddress(vo);
	}

	@Override
	public List<CommonCodeVO> selectCommonList(String groupId) {
		return addressMapper.selectCommonList(groupId);
	}

	@Override
	public int updateCcpyAddress(CcpyVO vo) {
		return addressMapper.updateCcpyAddress(vo);
	}

	@Override
	public int deleteCcpyAddress(int ccpyNo) {
		return addressMapper.deleteCcpyAddress(ccpyNo);
	}

	@Override
	public CcpyVO selectCcpy(int ccpyId) {
		return addressMapper.selectCcpy(ccpyId);
	}

	

}