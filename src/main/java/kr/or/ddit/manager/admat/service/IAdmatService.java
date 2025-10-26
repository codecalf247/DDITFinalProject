package kr.or.ddit.manager.admat.service;

import java.util.List;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IAdmatService {


	public int selectNextFileGroupNo();

	public int insertMtril(MtrilVO mtrilVO);

	public void insertFile(FilesVO fileVO);

	public int selectmatCount(PaginationInfoVO<MtrilVO> pagingVO);

	public List<MtrilVO> selectmatList(PaginationInfoVO<MtrilVO> pagingVO);

	public List<CommonCodeVO> selectCommonList(String groupCd);

	public int deleteFilesByGroupNo(int fileGroupNo);

	public int updateMtril(MtrilVO mtrilVO);

	public int deleteMaterial(String mtrilId, int fileGroupNo);

	
}
