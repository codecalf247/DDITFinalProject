package kr.or.ddit.employee.main.service;

import java.util.Map;

import kr.or.ddit.vo.attendance.WorkRcordVO;

public interface ICommuteService {

	public WorkRcordVO startWork(String empNo);

	public Map<String, Object> endWork(String empNo);

}
