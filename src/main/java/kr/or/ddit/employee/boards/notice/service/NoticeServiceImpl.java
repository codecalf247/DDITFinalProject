package kr.or.ddit.employee.boards.notice.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.boards.notice.mapper.INoticeMapper;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class NoticeServiceImpl implements INoticeService {

	@Autowired
	public INoticeMapper mapper; 
	@Autowired NotificationConfig noti;
	
	@Override
	public void insert(BoardVO board) {
		String empNo =  board.getEmpNo();
		
		List<EmpVO> empList = mapper.allEmpNotification(empNo);
		mapper.insert(board);
		
		for (EmpVO emp : empList) {
			noti.notify(emp.getEmpNo(), "12003", "공지사항", "/boards/noticelist");
		}

	}

	@Override
	public int generateFileGroupNo() {
		return mapper.generateFileGroupNo();
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		mapper.insertFile(fileVO);
		
	}


    @Override
    public BoardVO selectNotice(int boNo) {
    	mapper.boardrdCnt(boNo);
        BoardVO boardVO = mapper.selectNotice(boNo);
        return boardVO;
    }

	@Override
	public FilesVO selectFileBySavedNm(String savedNm) {
		return mapper.selectFileBySavedNm(savedNm);
	}

	@Override
	public int selectNoticeCount(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectNoticeCount(pagingVO);
	}

	@Override
	public List<BoardVO> selectNoticeList(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectNoticeList(pagingVO);
	}

	@Override
	public void update(BoardVO boardVO) {
		 mapper.update(boardVO);
	}

	@Override
	public void updateFileGroupNo(BoardVO boardVO) {
		 mapper.updateFileGroupNo(boardVO);
	}

	@Override
	public int updateFileDelYn(int fileNo) {
		return mapper.updateFileDelYn(fileNo);
	}

	@Override
	public void deleteFileGroupNo(int fileGroupNo) {
		mapper.deleteFileGroupNo(fileGroupNo);
		
	}

	@Override
	public void deleteBoard(int boNo) {
		mapper.deleteBoard(boNo);
		
	}
}
