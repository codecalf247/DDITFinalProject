package kr.or.ddit.jwt.service;

import java.time.Duration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class EmpServiceImpl implements IEmpService{
	
	@Autowired
	private PasswordEncoder pe;
	
	@PostConstruct
	public void init() {
		log.info("###### : " + pe.encode("1234"));
		log.info("###### : " + pe.encode("1234"));
		log.info("###### : " + pe.encode("1234"));
		log.info("###### : " + pe.encode("1234"));
		log.info("###### : " + pe.encode("1234"));
		log.info("###### : " + pe.encode("1234"));
	}
}
