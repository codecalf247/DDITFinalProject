package kr.or.ddit.employee.boards.complaintBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.boards.complaintBoard.mapper.IComplaintBoardMapper;
import kr.or.ddit.employee.boards.freeBoard.mapper.ICommentMapper;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class ComplaintBoardServiceImpl implements IComplaintBoardService {

	@Autowired
	private IComplaintBoardMapper mapper;
	
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
	public BoardVO selectComplaintBoard(int boNo) {
		mapper.boardrdCnt(boNo);
		BoardVO boardVO = mapper.selectComplaintBoard(boNo);
		return boardVO;
	}

	@Override
	public int selectComplaintBoardCount(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectComplaintBoardCount(pagingVO);
	}

	@Override
	public List<BoardVO> selectComplaintBoardList(PaginationInfoVO<BoardVO> pagingVO) {
		return mapper.selectComplaintBoardList(pagingVO);
	}
	

	@Override
	public FilesVO selectFileBySavedNm(String savedNm) {
		return mapper.selectFileBySavedNm(savedNm);
	}
	

	@Override
	public void complaintboardupdate(BoardVO boardVO) {
		mapper.complaintboardupdate(boardVO);
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
