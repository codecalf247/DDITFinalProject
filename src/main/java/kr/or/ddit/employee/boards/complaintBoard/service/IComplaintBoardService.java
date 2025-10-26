package kr.or.ddit.employee.boards.complaintBoard.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IComplaintBoardService {

	public int generateFileGroupNo();

	public void insert(BoardVO board);

	public void insertFile(FilesVO fileVO);

	public BoardVO selectComplaintBoard(int boNo);

	public int selectComplaintBoardCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectComplaintBoardList(PaginationInfoVO<BoardVO> pagingVO);

	public void complaintboardupdate(BoardVO boardVO);

	public void updateFileGroupNo(BoardVO boardVO);

	public int updateFileDelYn(int fileNo);

	public void deleteBoard(int boNo);

	public FilesVO selectFileBySavedNm(String savedNm);

	ServiceResult updateComment(BoardCMVO boardCMVO);

	ServiceResult insertSubComment(BoardCMVO boardCMVO);

	List<BoardCMVO> selectCommentList(int boNo);

	ServiceResult insertComment(BoardCMVO boardCMVO);

	ServiceResult deleteComment(int boNo);

	ServiceResult updateSubComment(BoardCMVO boardCMVO);
	
	

}
