package kr.or.ddit.employee.boards.notice.service;

import java.util.List;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface INoticeService {

	public void insert(BoardVO board);

	public int generateFileGroupNo();

	public void insertFile(FilesVO fileVO);

	public BoardVO selectNotice(int boNo);

	public FilesVO selectFileBySavedNm(String savedNm);

	public int selectNoticeCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectNoticeList(PaginationInfoVO<BoardVO> pagingVO);

	public void update(BoardVO boardVO);

	public void updateFileGroupNo(BoardVO boardVO);

	public int updateFileDelYn(int fileNo);

	public void deleteFileGroupNo(int fileGroupNo);

	public void deleteBoard(int boNo);


}
