package kr.or.ddit.employee.boards.notice.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface INoticeMapper {

	public void insert(BoardVO board);

	public int generateFileGroupNo();

	public void insertFile(FilesVO fileVO);

	public BoardVO selectNotice(int boNo);

	public FilesVO selectFileBySavedNm(String savedNm);
	
	public int boardrdCnt(int boNo);

	public int selectNoticeCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectNoticeList(PaginationInfoVO<BoardVO> pagingVO);

	public void update(BoardVO boardVO);
	
	public int updateFileDelYn(int fileNo);

	public void updateFileGroupNo(BoardVO boardVO);

	public void deleteFileGroupNo(int fileGroupNo);

	public void deleteBoard(int boNo);

	public List<EmpVO> allEmpNotification(String empNo); 


}
