package kr.or.ddit.jwt.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BlogFileVO;
import kr.or.ddit.vo.BlogMemberVO;
import kr.or.ddit.vo.BlogVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IBlogMapper {
	public BlogMemberVO idCheck(String memId);
	public int signup(BlogMemberVO memberVO);
	public void addMemberAuth(int memNo);
	public BlogMemberVO signin(BlogMemberVO memberVO);
	
	public int insert(BlogVO blogVO);
	public void insertBlogFile(BlogFileVO blogFileVO);
	public int selectBlogCount(PaginationInfoVO<BlogVO> pagingVO);
	public List<BlogVO> selectBlogList(PaginationInfoVO<BlogVO> pagingVO);
	public void incrementHit(int blogNo);
	public BlogVO detail(int blogNo);
	public BlogFileVO getFileInfo(int fileNo);
}
