package kr.or.ddit.employee.organizeChart.service;

import java.util.List;

import kr.or.ddit.vo.EmpVO;

public interface IOrgChartService {

	// 조직도에서 선택된 사원정보 가져오기
	public EmpVO getOrgEmpInfo(String empNo);

}
