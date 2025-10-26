package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class CompanyAttendSearchVO {
    private String startDate;	// 시작일
    private String endDate;		// 종료일
    private Integer deptNo;		// 부서번호
    private String status;		// 상태번호
    private String empNm;		// 사원이름
    private int page;			// 페이지 번호
}
