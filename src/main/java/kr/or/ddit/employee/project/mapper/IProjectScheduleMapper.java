package kr.or.ddit.employee.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.SchdulVO;

@Mapper
public interface IProjectScheduleMapper {

	public List<SchdulVO> getProjectSchedules(int prjctNo);

	public int createSchedule(SchdulVO schedule);

	public SchdulVO getScheduleDetail(int schdulNo);

	public int updateSchedule(SchdulVO schedule);

	public int deleteSchedule(int schdulNo);


	
}
