package kr.or.ddit.employee.facilities.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.facilities.mapper.IMeetMapper;

@Service
public class MeetServiceImpl implements IMeetService{

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private IMeetMapper MeetMapper;

	
	
	
}
