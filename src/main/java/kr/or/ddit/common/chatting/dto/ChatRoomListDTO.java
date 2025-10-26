package kr.or.ddit.common.chatting.dto;

import java.time.LocalDateTime;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatRoomListDTO {
    private Long chatRoomNo;
    private String chatRoomTy;     // DM / GROUP 등
    private String displayName;    // DM: 상대 사원명, GROUP: 방제목
    private String lastMsg;        // 마지막 메시지 내용
    private Date lastMsgDt;
    private Integer unreadCnt;     // 미확인 개수
}
