package kr.or.ddit.manager.admat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IAdmatMapper {

	public void insertFile(FilesVO fileVO);

	public int selectNextFileGroupNo();

	public int insertMtril(MtrilVO mtrilVO);

	public int selectmatCount(PaginationInfoVO<MtrilVO> pagingVO);

	public List<MtrilVO> selectmatList(PaginationInfoVO<MtrilVO> pagingVO);

	public List<CommonCodeVO> selectCommonList(String groupCd);

	public int deleteFilesByGroupNo(int fileGroupNo);

	public int updateMtril(MtrilVO mtrilVO);

	public int deleteMtril(String mtrilId);

}
