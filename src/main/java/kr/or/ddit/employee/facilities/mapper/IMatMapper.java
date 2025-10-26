package kr.or.ddit.employee.facilities.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IMatMapper {

	public int selectFileGroupNo();

	public int selectmaterialCount(PaginationInfoVO<MtrilVO> pagingVO);

	public List<MtrilVO> selectmaterialList(PaginationInfoVO<MtrilVO> pagingVO);

	public List<CommonCodeVO> selectCmList(String string);

	public int updateStockPlus(MtrilVO vo);

	public int insertHist(MtrilVO vo);

	public int updateStockMinusSafe(MtrilVO vo);

	

}
