package kr.or.ddit.jwt.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;

@Mapper
public interface IEmpMapper {
	public EmpVO readByUserInfo(String username);
	public EmpVO signin(EmpVO empVO);
	
}
