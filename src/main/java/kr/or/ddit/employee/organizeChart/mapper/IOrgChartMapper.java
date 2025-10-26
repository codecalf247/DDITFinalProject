package kr.or.ddit.employee.organizeChart.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;

@Mapper
public interface IOrgChartMapper {
	
	// 조직도에서 선택된 사원정보 가져오기
	public EmpVO getOrgEmpInfo(String empNo);

}
