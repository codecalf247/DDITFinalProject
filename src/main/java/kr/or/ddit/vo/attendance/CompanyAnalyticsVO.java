package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class CompanyAnalyticsVO {
	
	private int deptNo;				// 부서번호
	private String deptNm;			// 부서명
	private int empCount;			// 인원수
	private int workTimeMin;		// 부서근무시간합계
	private int avgWorkTimeMin;		// 부서근무시간합계
	private int overTimeMin;		// 부서연장근무시간합계
	private int countWork;			// 부서출근수
	private int countLate;			// 부서지각수
	private int countAnnualLeave;	// 부서연차수
	private double workRatio;		// 부서 출근 비율
	private double lateRatio;		// 부서 지각 비율
	private double annualRatio;		// 부서 연차 비율
	
	private String workTyNm;		// 근무 형태명
	
	private String formatWorkTime;		// 0시간 00분 || 0분
	private String formatOverTime;		// 000시간 00분 || 0분
	private String formatAvgWorkTime;	// 00시간 00분
	
    // DB에서 workTimeMin 세팅될 때 formatWorkTime 자동 계산
    public void setWorkTimeMin(int workTimeMin) {
        this.workTimeMin = workTimeMin;
        this.formatWorkTime = formatMinutes(workTimeMin);
    }

    public void setOverTimeMin(int overTimeMin) {
        this.overTimeMin = overTimeMin;
        this.formatOverTime = formatMinutes(overTimeMin);
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
