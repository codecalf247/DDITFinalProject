package kr.or.ddit.employee.organizeChart.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.organizeChart.mapper.IOrgChartMapper;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class OrgChartServiceImpl implements IOrgChartService {

	@Autowired
	private IOrgChartMapper chartMapper;

	// 조직도에서 선택된 사원정보 가져오기
	@Override
	public EmpVO getOrgEmpInfo(String empNo) {
		EmpVO empInfo = chartMapper.getOrgEmpInfo(empNo);
		return empInfo;
	}
	
}
