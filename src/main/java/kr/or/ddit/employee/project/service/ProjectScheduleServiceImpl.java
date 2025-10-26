package kr.or.ddit.employee.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.mapper.IProjectScheduleMapper;
import kr.or.ddit.vo.SchdulVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectScheduleServiceImpl implements IProjectScheduleService {
	
	@Autowired
	private IProjectScheduleMapper psMapper;
	
	@Override
	public List<SchdulVO> getProjectSchedules(int prjctNo) {
		return psMapper.getProjectSchedules(prjctNo);
	}

	@Override
	public ServiceResult createSchedule(SchdulVO schedule) {
		int result = psMapper.createSchedule(schedule);
		return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
		
	}

	@Override
	public SchdulVO getScheduleDetail(int schdulNo) {
		return psMapper.getScheduleDetail(schdulNo);
	}

	@Override
	public ServiceResult updateSchedule(SchdulVO schedule) {
		int status = psMapper.updateSchedule(schedule);
		return status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}

	@Override
	public ServiceResult deleteSchedule(int schdulNo) {
		int status = psMapper.deleteSchedule(schdulNo);
		return status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	
	
	
}
	