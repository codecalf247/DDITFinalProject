package kr.or.ddit.employee.hrResource.service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmpVO;

public interface IHrService {

	public String checkPassword(String empNo);

	public int changePw(EmpVO emp);

	public ServiceResult changeInfo(EmpVO emp);

	public EmpVO getMyInfo(String empNo);

}
