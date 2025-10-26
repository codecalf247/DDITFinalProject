package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class WorkWeekRcordVO {
	private int week;			// 주차
	private int countWork;		// 출근횟수
	private int countLate;		// 지각횟수
	private int workTimeMin;	// 근무시간
	private int avgWorkTimeMin;	// 평균근무시간
	
	private String formatWorkTime;		// 포맷팅한 근무시간
	private String formatAvgWorkTime;	// 포맷팅한 평균 근무시간
	
	public void setWorkTimeMin(int workTimeMin) {
		this.workTimeMin = workTimeMin;
		this.formatWorkTime = formatMinutes(workTimeMin);
	}
	
	public void setAvgWorkTimeMin(int avgWorkTimeMin) {
        this.avgWorkTimeMin = avgWorkTimeMin;
        this.formatAvgWorkTime = formatMinutes(avgWorkTimeMin);
	}
	
	// 포맷팅 메서드
    private String formatMinutes(int minutes) {
        if (minutes <= 0) return "0분";
        int hours = minutes / 60;
        int mins = minutes % 60;
        return (hours > 0) ? hours + "시간 " + mins + "분" : mins + "분";
    }
	
}
