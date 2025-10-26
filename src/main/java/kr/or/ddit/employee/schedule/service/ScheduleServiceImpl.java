package kr.or.ddit.employee.schedule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.schedule.mapper.IScheduleMapper;
import kr.or.ddit.vo.SchdulVO;

@Service
public class ScheduleServiceImpl implements IScheduleService{

	@Autowired
	private IScheduleMapper mapper;
	
	@Override
	public int insertSchedule(SchdulVO svo) {
		// TODO Auto-generated method stub
		return mapper.insertSchedule(svo);
	}

	@Override
	public SchdulVO getSchedule(int id) {
		// TODO Auto-generated method stub
		return mapper.getSchedule(id);
	}

	@Override
	public ServiceResult deleteSchedule(int id) {
		// TODO Auto-generated method stub
		ServiceResult result = null;
		int cnt = mapper.deleteSchedule(id);
		if(cnt > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	
	
}
