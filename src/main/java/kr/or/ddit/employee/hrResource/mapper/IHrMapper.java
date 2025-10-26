package kr.or.ddit.employee.hrResource.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;

@Mapper
public interface IHrMapper {

	public String checkPassword(String empNo);

	public int changePW(EmpVO emp);

	public int changeInfo(EmpVO emp);

	public EmpVO getMyInfo(String empNo);

}
