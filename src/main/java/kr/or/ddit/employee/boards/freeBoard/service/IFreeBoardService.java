package kr.or.ddit.employee.boards.freeBoard.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IFreeBoardService {

	public int generateFileGroupNo();

	public void insert(BoardVO board);

	public void insertFile(FilesVO fileVO);

	public BoardVO selectFreeBoard(int boNo);

	public FilesVO selectFileBySavedNm(String savedNm);

	public int selectFreeBoardCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectFreeBoardList(PaginationInfoVO<BoardVO> pagingVO);

	public void freeboardupdate(BoardVO boardVO);

	public void updateFileGroupNo(BoardVO boardVO);

	public int updateFileDelYn(int fileNo);

	public void deleteFileGroupNo(int fileGroupNo);

	public void deleteBoard(int boNo);

	public ServiceResult insertComment(BoardCMVO boardCMVO);

	public List<BoardCMVO> selectCommentList(int boNo);

	public ServiceResult insertSubComment(BoardCMVO boardCMVO);

	public ServiceResult updateComment(BoardCMVO boardCMVO);

	public ServiceResult deleteComment(int boNo);

	public ServiceResult updateSubComment(BoardCMVO boardCMVO);

}
