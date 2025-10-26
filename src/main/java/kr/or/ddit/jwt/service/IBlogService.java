package kr.or.ddit.jwt.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BlogFileVO;
import kr.or.ddit.vo.BlogMemberVO;
import kr.or.ddit.vo.BlogVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IBlogService {
	public ServiceResult idCheck(String memId);
	public ServiceResult signup(BlogMemberVO memberVO);
	public String signin(BlogMemberVO memberVO);
	
	public ServiceResult insert(BlogVO blogVO);
	public int selectBlogCount(PaginationInfoVO<BlogVO> pagingVO);
	public List<BlogVO> selectBlogList(PaginationInfoVO<BlogVO> pagingVO);
	public BlogVO detail(int blogNo);
	public BlogFileVO getFileInfo(int fileNo);
}
