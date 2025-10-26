package kr.or.ddit.login.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;

@Mapper
public interface ILoginMapper {

	public EmpVO readByUserInfo(String username);

	public String findId(EmpVO empVO);

	public int checkPw(EmpVO empVO);

	public void changePw(EmpVO empVO);
	
}
