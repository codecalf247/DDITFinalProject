package kr.or.ddit.employee.boards.freeBoard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BoardCMVO;

@Mapper
public interface ICommentMapper {

	public int insertComment(BoardCMVO boardCMVO);

	public List<BoardCMVO> selectCommentList(int boNo);

	public int insertSubComment(BoardCMVO boardCMVO);

	public int updateComment(BoardCMVO boardCMVO);

	public int deleteComment(int boNo);

	public int updateSubComment(BoardCMVO boardCMVO);

}
