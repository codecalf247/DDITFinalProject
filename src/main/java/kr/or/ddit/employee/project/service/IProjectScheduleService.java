package kr.or.ddit.employee.project.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.SchdulVO;

public interface IProjectScheduleService {

	public List<SchdulVO> getProjectSchedules(int prjctNo);

	public ServiceResult createSchedule(SchdulVO schedule);

	public SchdulVO getScheduleDetail(int schdulNo);

	public ServiceResult updateSchedule(SchdulVO schedule);

	public ServiceResult deleteSchedule(int schdulNo);

	
}
