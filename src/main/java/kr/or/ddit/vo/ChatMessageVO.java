package kr.or.ddit.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ChatMessageVO {

	private int chatMsgNo; /* SEQ_CHAT_MSG */
	private String msgCn; /* 채팅내용 */
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date msgWrtDt; /* 작성일자(SYSDATE) */
	private String msgTy; /* 채팅유형(03001) */
	private int fileGroupNo; /* 파일그룹번호 */
	private int chatRoomNo; /* SEQ_CHAT_ROOM */
	private String empNo; /* 년월(6자리) + 순번(3자리) */
	private String empNm;	// 이름표시위해 vo추가
	
	private String fileUrl;
	private String fileNm;
	private Long   fileSize;
	private String mimeType;
	private String imageYn;   // 'Y'/'N'
	private String thumbUrl;
	
}
