package kr.or.ddit.jwt.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BlogMemberVO;

@Mapper
public interface ISecMemberMapper {
	public BlogMemberVO readByUserInfo(String username);
}
