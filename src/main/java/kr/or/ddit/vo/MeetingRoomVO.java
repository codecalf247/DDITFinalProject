package kr.or.ddit.vo;

import lombok.Data;

@Data
public class MeetingRoomVO {

	 private Long   mtg_room_resve_no; // PK
     private Long   mtg_room_no;       // FK → MTG_ROOM.MTG_ROOM_NO
     private String emp_no;            // 년월(6자리)+순번(3자리) (VARCHAR2(9))
     private String  resve_dt;          // 예약일시 (DATE)
     private String   resve_begin_dt;    // 예약시작일시 (DATE)
     private String   resve_end_dt;      // 예약종료일시 (DATE)
     private String use_purps;         // 사용목적 (VARCHAR2(300))
	
    
     private String  mtg_room_nm;   // 회의실명 (VARCHAR2(50))
     private String  use_posbl_yn;  // 사용 가능 Y / 사용 불가능 N (VARCHAR2(1))
     private Integer max_capa;      // 최대인원 (NUMBER)
     private Integer file_group_no; // 회의실사진 파일그룹번호 (NUMBER)

     private Long   fxtrs_no;    // PK
     
     private String fxtrs_nm;    // 비품명 (VARCHAR2(100))
     private String exist_yn;    // 있음 Y / 없음 N (VARCHAR2(1))
     private String icon_nm;     // 아이콘명 (VARCHAR2(100))
     
     
     
     
}
