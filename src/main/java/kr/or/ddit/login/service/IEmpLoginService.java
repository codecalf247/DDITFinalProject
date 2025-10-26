package kr.or.ddit.login.service;

import kr.or.ddit.vo.EmpVO;

public interface IEmpLoginService {

	public String findId(EmpVO empVO);

	public String changePw(EmpVO empVO);

}
