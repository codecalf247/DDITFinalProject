package kr.or.ddit.common.chatting.dto;

import lombok.Data;

@Data
public class MeetingMsgRow {
  private int   msgNo;  // 메시지 번호 (PK)
  private String msgCn;  // 메시지 내용 (JSON 또는 텍스트)
}