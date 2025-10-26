package kr.or.ddit.jwt.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BlogMemberVO;

@Mapper
public interface IBlogMemberMapper {
	public BlogMemberVO readByUserInfo(String username);

	public BlogMemberVO checkId(String memId);

	public int signup(BlogMemberVO memberVO);

	public void addAuth(int memNo);

	public BlogMemberVO signin(BlogMemberVO memberVO);
}
