package kr.or.ddit.vo;

import lombok.Data;

@Data
public class EmpAuthVO {

	private String empNo; /* 년월(6자리) + 순번(3자리) */
	private String authNm; /* 권한명 */
	
}
