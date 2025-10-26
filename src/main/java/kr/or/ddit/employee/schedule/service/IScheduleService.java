package kr.or.ddit.employee.schedule.service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.SchdulVO;

public interface IScheduleService {

	public int insertSchedule(SchdulVO svo);

	public SchdulVO getSchedule(int id);

	public ServiceResult deleteSchedule(int id);

}
