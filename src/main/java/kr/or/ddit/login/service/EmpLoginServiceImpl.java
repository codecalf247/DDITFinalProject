package kr.or.ddit.login.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.login.mapper.ILoginMapper;
import kr.or.ddit.vo.EmpVO;

@Service
public class EmpLoginServiceImpl implements IEmpLoginService{

	@Autowired
	private PasswordEncoder pe;
	
	@Autowired
	private ILoginMapper mapper;
	
	@Override
	public String findId(EmpVO empVO) {
		// TODO Auto-generated method stub
		String empNo = mapper.findId(empVO);
		
		return empNo;
	}

	@Override
	public String changePw(EmpVO empVO) {
		// TODO Auto-generated method stub
		String result = null;
		int cnt = mapper.checkPw(empVO);
		if(cnt > 0) {
			LocalDateTime dateTime = LocalDateTime.now();
			DateTimeFormatter formmat = DateTimeFormatter.ofPattern("HHmmss");
			String newPassword = dateTime.format(formmat);
			
			empVO.setPassword(pe.encode(newPassword));
			mapper.changePw(empVO);
			result = newPassword;
			System.out.println(newPassword);
		}
		String encodedPassword = pe.encode("1234");
		System.out.println(encodedPassword);
		System.out.println(encodedPassword);

		System.out.println(encodedPassword);
		return result;
	}

}
