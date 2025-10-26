package kr.or.ddit.employee.main.service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.main.mapper.ICommuteMapper;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import kr.or.ddit.vo.main.WorkTyVO;

@Transactional
@Service
public class CommuteServiceImpl implements ICommuteService{

	@Autowired
	private ICommuteMapper commuteMapper;
	
	@Override
	public WorkRcordVO startWork(String empNo) {

		// 오늘 날짜 구하기
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		// 현재 시간
        LocalTime nowTime = LocalTime.now();
        
		WorkRcordVO insertWorkRecord = new WorkRcordVO();
		insertWorkRecord.setWorkYmd(formatDay);
		insertWorkRecord.setEmpNo(empNo);
		
		// 1. 데이터 있는 지 확인
		WorkRcordVO existWorkRecord = commuteMapper.getTodayEmpRecord(insertWorkRecord);
		
		// 2. 데이터가 있는데 그 타입이 반차면 
		if(existWorkRecord != null) {
			if(existWorkRecord.getWorkSttus() == "01004") {
				// 출근 시간 저장
				insertWorkRecord.setBeginTime(nowTime.format(DateTimeFormatter.ofPattern("HHmmss")));
				
				commuteMapper.updateBeginTime(insertWorkRecord);
				
				return insertWorkRecord;
			}else { // 아니면 null
				return null;
			}
		}
		
		
		
		// 3. 데이터 없으면 출근 인데 
		
		// 3-1. 근무 형태를 가져와서 비교 
		WorkTyVO workType = commuteMapper.getWorkType(empNo);
		
		switch (workType.getWorkTyNo()) {
			
			case 1: {	// 정규근무제
				
		        String beginTime = workType.getWorkBeginTime(); // "0900" 형태

		        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmm");
		        LocalTime workBegin = LocalTime.parse(beginTime, formatter);

		        // 분까지만 비교(0900까지는 지각 아님)
		        if (nowTime.truncatedTo(ChronoUnit.MINUTES).isAfter(workBegin)) {	// 지각
		        	insertWorkRecord.setWorkSttus("01002");
		        } else {	// 정상출근
		        	insertWorkRecord.setWorkSttus("01001");
		        }
		        break;
			}
			case 2: {	// 유연근무제
				
		        String beginTime = workType.getFlextimeEndTime(); // "0900" 형태

		        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmm");
		        LocalTime workBegin = LocalTime.parse(beginTime, formatter);

		        // 분까지만 비교(0900까지는 지각 아님)
		        if (nowTime.truncatedTo(ChronoUnit.MINUTES).isAfter(workBegin)) {	// 지각
		        	insertWorkRecord.setWorkSttus("01002");
		        } else {	// 정상출근
		        	insertWorkRecord.setWorkSttus("01001");
		        }
				
				break;
			}
		}
		
		// 출근 시간 저장
		insertWorkRecord.setBeginTime(nowTime.format(DateTimeFormatter.ofPattern("HHmmss")));
		
		// 근태 기록 삽입
		int cnt = commuteMapper.insertWorkRecord(insertWorkRecord);
		
		// 근태 이력 삽입
		cnt += commuteMapper.insertWorkHistory(insertWorkRecord);
		
		if(cnt >= 2) {
			return insertWorkRecord;
		}else {
			return null;
		}
		
	}

	@Override
	public Map<String, Object> endWork(String empNo) {
		
		Map<String, Object> result = new HashMap<>();
		
		// 오늘 날짜 구하기
		LocalDate today = LocalDate.now();
		String formatDay = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		// 현재 시간
        LocalTime nowTime = LocalTime.now();
        
		WorkRcordVO updateWorkRecord = new WorkRcordVO();
		updateWorkRecord.setWorkYmd(formatDay);
		updateWorkRecord.setEmpNo(empNo);
		
		// 1. 데이터 있는 지 확인
		WorkRcordVO existWorkRecord = commuteMapper.getTodayEmpRecord(updateWorkRecord);
		
		// 2. 데이터 없으면 return 
		if(existWorkRecord == null) {
			result.put("result", "not_found");
			return result;
		}
		
		// 3. 데이터 있으면 퇴근 인데
		
		// 3-1. 근무 형태를 가져와서 비교 
		WorkTyVO workType = commuteMapper.getWorkType(empNo);
		result.put("workType", workType);
		switch (workType.getWorkTyNo()) {
			
			case 1: {	// 정규근무제
				
		        String endTime = workType.getWorkEndTime(); // "1800" 형태

		        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmm");
		        LocalTime workEnd = LocalTime.parse(endTime, formatter);

		        // 분까지만 비교(1800 이전에 퇴근을 찍으면)
		        if (nowTime.truncatedTo(ChronoUnit.MINUTES).isBefore(workEnd)) {	// 빠른 퇴근
		        	result.put("result", "early");
		        } else {	// 정상 퇴근
		        	result.put("result", "success");
		        }
		        break;
			}
			case 2: {	// 유연근무제
				
				// 시작시간 가져옴
				String beginTime = existWorkRecord.getBeginTime(); // HHmmss

			    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmmss");
			    LocalTime workBegin = LocalTime.parse(beginTime, formatter);

			    // 기준 시작시간 (07:00 이전 출근이면 07:00 고정)
			    LocalTime baseBegin = workBegin.isBefore(LocalTime.of(7, 0))
			            ? LocalTime.of(7, 0)
			            : workBegin;

			    // 퇴근 기준 = 기준 시작시간 + 9시간
			    LocalTime workEnd = baseBegin.plusHours(9);

		        // 9시간 기준을 채우지 못 했을 때
		        if (nowTime.truncatedTo(ChronoUnit.MINUTES).isBefore(workEnd)) {	//이른퇴근
		        	result.put("result", "flexEarly");
		        } else {	// 정상퇴근
		        	result.put("result", "success");
		        }
				
				break;
			}
		}
		
		// 퇴근 시간 저장
		updateWorkRecord.setEndTime(nowTime.format(DateTimeFormatter.ofPattern("HHmmss")));
		
		// 근태 기록 업데이트
		int cnt = commuteMapper.updateRecordEndTime(updateWorkRecord);
		
		if(cnt > 0) {
			result.put("record", updateWorkRecord);
		}else {
			result.put("record", null);
		}
		
		return result;
	}

}
