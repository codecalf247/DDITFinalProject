package kr.or.ddit.employee.boards.freeBoard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IFreeBoardMapper {

	public int generateFileGroupNo();

	public void insert(BoardVO board);

	public void insertFile(FilesVO fileVO);

	public BoardVO selectFreeBoard(int boNo);

	public int selectFreeBoardCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectFreeBoardList(PaginationInfoVO<BoardVO> pagingVO);

	public void boardrdCnt(int boNo);

	public FilesVO selectFileBySavedNm(String savedNm);

	public void freeboardupdate(BoardVO boardVO);

	public void updateFileGroupNo(BoardVO boardVO);

	public int updateFileDelYn(int fileNo);

	public void deleteFileGroupNo(int fileGroupNo);

	public void deleteBoard(int boNo);
	
	

}
