package kr.or.ddit.employee.boards.freeBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.boards.freeBoard.mapper.ICommentMapper;
import kr.or.ddit.employee.boards.freeBoard.mapper.IFreeBoardMapper;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class FreeBoardServiceImpl implements IFreeBoardService {

	@Autowired
	public IFreeBoardMapper mapper;
	
	@Autowired
	public ICommentMapper commentmapper;

	@Override
	public int generateFileGroupNo() {
		return mapper.generateFileGroupNo();
	}

	@Override
	public void insert(BoardVO board) {
		mapper.insert(board);
		
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		mapper.insertFile(fileVO);
	}

	@Override
	public BoardVO selectFreeBoard(int boNo) {
		mapper.boardrdCnt(boNo);
		BoardVO boardVO = mapper.selectFreeBoard(boNo);
		return boardVO;
	}

	@Override
	public int selectFreeBoardCount(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectFreeBoardCount(pagingVO);
	}

	@Override
	public List<BoardVO> selectFreeBoardList(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectFreeBoardList(pagingVO);
	}

	@Override
	public FilesVO selectFileBySavedNm(String savedNm) {
		return mapper.selectFileBySavedNm(savedNm);
	}

	@Override
	public void freeboardupdate(BoardVO boardVO) {
		mapper.freeboardupdate(boardVO);
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

	@Override
	public ServiceResult insertComment(BoardCMVO boardCMVO) {
		ServiceResult result = null;
		
		int status = commentmapper.insertComment(boardCMVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}


	@Override
	public List<BoardCMVO> selectCommentList(int boNo) {
		return commentmapper.selectCommentList(boNo);
	}

	@Override
	public ServiceResult insertSubComment(BoardCMVO boardCMVO) {
		ServiceResult result = null;
		
		int status = commentmapper.insertSubComment(boardCMVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	
	@Override
	public ServiceResult updateComment(BoardCMVO boardCMVO) {
		ServiceResult result = null;
		
		int status = commentmapper.updateComment(boardCMVO);
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult deleteComment(int boNo) {
	ServiceResult result = null;
		
		int status = commentmapper.deleteComment(boNo);
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult updateSubComment(BoardCMVO boardCMVO) {
	ServiceResult result = null;
		
		int status = commentmapper.updateSubComment(boardCMVO);
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}
}
