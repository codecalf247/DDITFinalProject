package kr.or.ddit.employee.main.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.attendance.WorkRcordVO;
import kr.or.ddit.vo.main.WorkTyVO;

@Mapper
public interface ICommuteMapper {

	// 사원의 오늘날짜 근무기록을 조회하는 메서드
	public WorkRcordVO getTodayEmpRecord(WorkRcordVO insertWorkRecord);
	
	// 사원 번호로 근무 유형 찾는 메서드
	public WorkTyVO getWorkType(String empNo);
	
	// 출근 기록 삽입
	public int insertWorkRecord(WorkRcordVO insertWorkRecord);
	
	// 출근 이력 삽입
	public int insertWorkHistory(WorkRcordVO insertWorkRecord);

	// 퇴근 기록 수정
	public int updateRecordEndTime(WorkRcordVO updateWorkRecord);
	
	// 근태 연차 기록 삽입
	public void insertWorkRecordForVacation(WorkRcordVO workRecord);
	
	// 반차 시 출근 시간 update
	public void updateBeginTime(WorkRcordVO insertWorkRecord);

}
