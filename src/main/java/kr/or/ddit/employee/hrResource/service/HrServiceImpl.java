package kr.or.ddit.employee.hrResource.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.hrResource.mapper.IHrMapper;
import kr.or.ddit.vo.EmpVO;

@Service
public class HrServiceImpl implements IHrService{

	
	@Autowired
	private IHrMapper mapper;
	
	@Override
	public String checkPassword(String empNo) {
		// TODO Auto-generated method stub
		return mapper.checkPassword(empNo);
		
	}

	@Override
	public int changePw(EmpVO emp) {
		// TODO Auto-generated method stub
		return mapper.changePW(emp);
	}

	@Override
	public ServiceResult changeInfo(EmpVO emp) {
		// TODO Auto-generated method stub
		ServiceResult result = null;
		int cnt = mapper.changeInfo(emp);
		if(cnt > 0 ) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}

	@Override
	public EmpVO getMyInfo(String empNo) {
		// TODO Auto-generated method stub
		return mapper.getMyInfo(empNo);
	}

	
	
	
}
