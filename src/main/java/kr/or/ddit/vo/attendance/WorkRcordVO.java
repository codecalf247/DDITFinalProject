package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class WorkRcordVO {
	// work_rcord 테이블 데이터
	private int workRcordNo; 	// 근무기록번호
	private String empNo;	 	// 사원번호
	private String workYmd;	 	// 근무기록일자
	private String beginTime;	// 출근시간
	private String endTime;		// 퇴근시간
	private String workSttus;	// 근무상태
	
	// 화면에 띄울 데이터
	private String empNm;		// 사원이름
	private int workTimeMin;	// 근무시간(분)
	private int overTimeMin;		// 연장근무시간(분)
	private String dayOfTheWeek;	// 요일(월 ~ 일)
	
	// 일주일 합계 데이터 
	private int countWork;		// 출근일수
	private int allWorkTimeMin;	// 총 근무시간(분)
	private int avgWorkTimeMin;	// 평균 근무시간(분)
	private int countLate;		// 지각횟수
	
	// 회사 전체용 데이터
	private int countAnnualLeave;	// 연차 일수
	private String deptNm;			// 부서 이름
	private String workTyNm;		// 근무유형명
	
	// 포맷팅된 데이터
	private String formatWorkTime;		// 0시간 00분 || 0분
	private String formatOverTime;		// 0시간 00분 || 0분
	private String formatAllWorkTime;	// 00시간
	private String formatAvgWorkTime;	// 00시간 0분
	
    // DB에서 workTimeMin 세팅될 때 formatWorkTime 자동 계산
    public void setWorkTimeMin(int workTimeMin) {
        this.workTimeMin = workTimeMin;
        this.formatWorkTime = formatMinutes(workTimeMin);
    }

    public void setOverTimeMin(int overTimeMin) {
        this.overTimeMin = overTimeMin;
        this.formatOverTime = formatMinutes(overTimeMin);
    }

    public void setAllWorkTimeMin(int allWorkTimeMin) {
        this.allWorkTimeMin = allWorkTimeMin;
        this.formatAllWorkTime = formatMinutes(allWorkTimeMin);
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
