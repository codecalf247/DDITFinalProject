package kr.or.ddit.vo.main;

import lombok.Data;

@Data
public class WidgetVO {

	// GRID_MASTER
	private int gridMasterNo;	// 그리드 마스터 번호
	private String widgetTy;	// 위젯 타입
	private String widgetNm;	// 위젯 이름
	private String widgetDc;	// 위젯 설명
	private int defaultWidth;	// 기본 가로 길이
	private int defaultHeight;	// 기본 세로 길이
	
	// USER_LAYOUT
	private int layoutNo;		// 레이아웃 번호
	private String empNo;		// 사원 번호
	private int gridX;			// 그리드 X 좌표
	private int gridY;			// 그리드 Y 좌표
//	private int gridMasterNo;
	
	
	// 기본 생성자
    public WidgetVO() {}

    // 4개 필드만 받는 생성자
    public WidgetVO(int gridMasterNo, String empNo, int gridX, int gridY) {
        this.gridMasterNo = gridMasterNo;
        this.empNo = empNo;
        this.gridX = gridX;
        this.gridY = gridY;
    }
    
}
