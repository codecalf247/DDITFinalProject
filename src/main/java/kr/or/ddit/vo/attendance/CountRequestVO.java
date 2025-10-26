package kr.or.ddit.vo.attendance;

import lombok.Data;

@Data
public class CountRequestVO {
	private int totalCount;		// 전체 수량
	private int pendingCount;	// 처리중 수량
	private int approvedCount;	// 승인 수량
	private int rejectCount;	// 반려 수량
}
