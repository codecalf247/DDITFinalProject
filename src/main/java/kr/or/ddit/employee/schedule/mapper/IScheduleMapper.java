package kr.or.ddit.employee.schedule.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.SchdulVO;

@Mapper
public interface IScheduleMapper {

	public int insertSchedule(SchdulVO svo);

	public SchdulVO getSchedule(int id);

	public int deleteSchedule(int id);



}
