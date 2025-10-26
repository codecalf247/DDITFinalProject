package kr.or.ddit.employee.boards.complaintBoard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IComplaintBoardMapper {

	public int generateFileGroupNo();

	public void insert(BoardVO board);

	public void insertFile(FilesVO fileVO);

	public void boardrdCnt(int boNo);

	public BoardVO selectComplaintBoard(int boNo);

	public int selectComplaintBoardCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectComplaintBoardList(PaginationInfoVO<BoardVO> pagingVO);

	public FilesVO selectFileBySavedNm(String savedNm);

	public void complaintboardupdate(BoardVO boardVO);

	public void updateFileGroupNo(BoardVO boardVO);

	public int updateFileDelYn(int fileNo);

	public BoardVO selectFreeBoard(int boNo);

	public void deleteBoard(int boNo);
	
	public void deleteFileGroupNo(int fileGroupNo);

}
