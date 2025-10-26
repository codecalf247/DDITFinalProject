package kr.or.ddit.employee.facilities.service;

import java.util.List;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IMatService {
	
	public int selectFileGroupNo();

	public int selectmaterialCount(PaginationInfoVO<MtrilVO> pagingVO);

	public List<MtrilVO> selectmaterialList(PaginationInfoVO<MtrilVO> pagingVO);

	public List<CommonCodeVO> selectCmList(String string);

	public void stockIn(MtrilVO vo);

	public void stockOut(MtrilVO vo);

	

 

}
