package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class ChattingVO {
	private int chatRoomNo; /* SEQ_CHAT_ROOM */
	private String empNo; /* 년월(6자리) + 순번(3자리) */
	private String chatRoomNm; /* 최대 15자, */
	private String chatRoomCrtYmd; /* yyyyMMdd */
	private String delYn; /* 정상 : N / 삭제 : Y */
	private int fileGroupNo; /* 파일그룹번호 */
	private String chatRoomTy; /* 개인 P / 단체 G */
	private List<String> memberEmpNos;
}
