// GooroomeeController.java — 인메모리 Map 제거, DB 앵커(JSON) 사용
package kr.or.ddit.common.chatting.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import kr.or.ddit.common.chatting.service.IGooroomeeService;
import kr.or.ddit.common.chatting.service.GooroomeeServiceImpl; // TTL 읽기
import kr.or.ddit.common.chatting.service.IChatService;
import kr.or.ddit.common.chatting.dto.MeetingMsgRow;
import kr.or.ddit.common.chatting.mapper.IChatMapper;

import kr.or.ddit.vo.ChatMessageVO;
import kr.or.ddit.vo.CustomUser;

import java.time.*;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@RestController
@RequestMapping("/api/gooroomee")
@RequiredArgsConstructor
public class GooroomeeController {

  private final IGooroomeeService service;
  private final IChatService chatService;
  private final IChatMapper chatMsgMapper;       // ★ DB 앵커 조회/업데이트
  private final ObjectMapper om = new ObjectMapper();
  private final SimpMessagingTemplate messagingTemplate; 

  @PostMapping("/start")
  public ResponseEntity<?> start(@RequestBody Map<String, Object> req,
                                 @AuthenticationPrincipal CustomUser user) {
    try {
      // 0) 입력/사용자
      String chatRoomNo = String.valueOf(req.get("chatRoomNo"));
      if (chatRoomNo == null || chatRoomNo.isBlank()) {
        return ResponseEntity.badRequest().body(Map.of("error", "chatRoomNo is required"));
      }
      String username = (user != null && user.getMember() != null && user.getMember().getEmpNm() != null)
          ? user.getMember().getEmpNm() : "Guest";
      String empNoStr = (user != null && user.getMember() != null && user.getMember().getEmpNo() != null)
          ? String.valueOf(user.getMember().getEmpNo()) : "0";

      // 1) 최신 04001 앵커 조회 + 메타 파싱
      MeetingMsgRow last = chatMsgMapper.selectLastMeetingMsg(chatRoomNo); // 없을 수도 있음
      Meta meta = (last != null ? parseMeta(last.getMsgCn()) : null);

      int ttl = durationMinutesOrDefault();
      boolean valid = (meta != null && !isExpired1(meta.createdAt, ttl));

      // 2) 유효한 앵커가 없으면: 시퀀스 선점 → 방 생성 → INSERT 1회 (UPDATE X)
      if (!valid) {
        meta = createNewAnchorAndInsert(chatRoomNo, empNoStr); // 아래 helpers 참조
      }

      // 3) OTP 발급. 만약 방 무효(삭제/만료)면 → 새 앵커 만들고 그걸로 발급(UPDATE 대신 INSERT)
      String joinUrl;
      try {
        joinUrl = service.getJoinUrl(meta.roomId, username);
      } catch (Exception ex) {
        String m = String.valueOf(ex.getMessage());
        if (m.contains("GRM_700") || m.contains("invalid roomId")) {
          // 기존 메시지 업데이트하지 않고, 새 "회의 시작" 메시지를 하나 더 INSERT
          meta = createNewAnchorAndInsert(chatRoomNo, empNoStr);
          joinUrl = service.getJoinUrl(meta.roomId, username);
        } else {
          return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
              .body(Map.of("error", "OTP 발급 실패", "detail", ex.getMessage()));
        }
      }

      String shareUrl = (meta.roomUrlId == null ? null : "https://biz.gooroomee.com/" + meta.roomUrlId);
      return ResponseEntity.ok(Map.of(
          "roomId", meta.roomId,
          "joinUrl", joinUrl,
          "shareUrl", shareUrl
      ));

    } catch (Exception e) {
      e.printStackTrace();
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(Map.of("error", "server error", "detail", e.getMessage()));
    }
  }


  /* ===== helpers ===== */
  private long insertSystemStart(String roomNo, String empNo, String empNm){
    ChatMessageVO m = new ChatMessageVO();
    try{ m.setChatRoomNo(Integer.parseInt(roomNo)); }catch(Exception ignore){}
    try{ m.setEmpNo(empNo); }catch(Exception ignore){}
    m.setEmpNm(empNm);
    m.setMsgTy("04001");
    m.setMsgCn("구루미 회의를 시작했어요"); // 곧 JSON으로 덮음
    // m.setMsgWrtDt(LocalDateTime.now());
    chatService.saveMessage(m);
    MeetingMsgRow last = chatMsgMapper.selectLastMeetingMsg(roomNo);
    if (last==null || last.getMsgNo()==0) throw new IllegalStateException("04001 msg_no 조회 실패");
    return last.getMsgNo();
  }

  private void updateMeetingMsgJson(long msgNo, Meta meta){
    ObjectNode n = om.createObjectNode();
    n.put("text", meta.text);
    n.put("roomId", meta.roomId);
    if (meta.roomUrlId!=null) n.put("roomUrlId", meta.roomUrlId);
    n.put("createdAt", meta.createdAt.toString());
    chatMsgMapper.updateMeetingMsgContent(msgNo, n.toString());
  }

  private Meta parseMeta(String msgCn){
    if (msgCn==null || msgCn.isBlank()) return null;
    try{
      var n = om.readTree(msgCn);
      String roomId = n.path("roomId").asText(null);
      String text   = n.path("text").asText("구루미 회의를 시작했어요");
      String urlId  = n.path("roomUrlId").asText(null);
      String created= n.path("createdAt").asText(null);
      Instant at = (created==null? null : Instant.parse(created));
      if (roomId==null || at==null) return null;
      return new Meta(text, roomId, urlId, at);
    }catch(Exception ignore){ return null; }
  }

  private boolean isExpired1(Instant createdAt, int ttlMinutes){
    if (ttlMinutes<=0) return false;
    return Duration.between(createdAt, Instant.now()).toMinutes() >= ttlMinutes;
  }
  private int durationMinutesOrDefault(){
    try{ return ((GooroomeeServiceImpl)service).getDurationMinutes(); }
    catch(Throwable ignore){ return 120; }
  }

  private CreateRes createRoomWithFallback(String title, String baseUrlId) throws Exception {
    try{
      String roomId = createRoom(title, baseUrlId); // 고정 urlId
      return new CreateRes(roomId, baseUrlId);
    }catch(IllegalStateException e){
      if (!String.valueOf(e.getMessage()).contains("GRM_701")) throw e;
    }
    for(int i=0;i<5;i++){
      String cand = baseUrlId + "-" + rand(5);
      try{
        String roomId = createRoom(title, cand);
        return new CreateRes(roomId, cand);
      }catch(IllegalStateException e){
        if (!String.valueOf(e.getMessage()).contains("GRM_701")) throw e;
      }
    }
    String roomId = createRoom(title, null); // urlId 없이
    return new CreateRes(roomId, null);
  }
  private String createRoom(String title, String roomUrlId) throws Exception {
    if (service instanceof GooroomeeServiceImpl) return ((GooroomeeServiceImpl)service).createRoom(title, roomUrlId);
    return service.createRoom(title);
  }
  private static String rand(int n){
    final char[] A = "abcdefghijklmnopqrstuvwxyz0123456789".toCharArray();
    var r = ThreadLocalRandom.current(); var b = new char[n];
    for(int i=0;i<n;i++) b[i]=A[r.nextInt(A.length)];
    return new String(b);
  }
  private static class Meta { final String text, roomId, roomUrlId; final Instant createdAt;
    Meta(String t,String id,String u,Instant at){text=t;roomId=id;roomUrlId=u;createdAt=at;} }
  private static class CreateRes { final String roomId, roomUrlId; CreateRes(String a,String b){roomId=a;roomUrlId=b;} }
  
  
  /** UPDATE 없이: 시퀀스 선점 → 방 생성 → 메시지 INSERT 1회 */
  private Meta createNewAnchorAndInsert(String chatRoomNo, String empNoStr) throws Exception {
    // a) 시퀀스 선점
    Long msgNo = chatMsgMapper.selectNextChatMsgNo();         // ex) 12345

    // b) 메시지번호만으로 urlId 고정
    String baseUrlId = "gw-" + msgNo;                         // 요구사항: gw-<msgNo>

    // c) 방 생성 (중복 urlId면 suffix 재시도 → urlId 없이도 최종 생성)
    CreateRes created = createRoomWithFallback("MSG#" + msgNo, baseUrlId);

    // d) JSON 메타 구성(원치 않으면 단순 텍스트 넣어도 되지만, 재사용/복구 위해 JSON 권장)
    ObjectNode n = om.createObjectNode();
    n.put("text", "구루미 회의를 시작했어요");
    n.put("roomId", created.roomId);
    if (created.roomUrlId != null) n.put("roomUrlId", created.roomUrlId);
    n.put("createdAt", Instant.now().toString());

    // e) INSERT 1회 (UPDATE 없음)
    chatMsgMapper.insertMeetingMsg(
        msgNo,
        Integer.parseInt(chatRoomNo),
        empNoStr,                 // EMP_NO = VARCHAR2(9)
        n.toString()
    );
    
 // createNewAnchorAndInsert(...) 안에서 INSERT 한 직후에 추가
    Map<String, Object> payload = new java.util.HashMap<>();
    payload.put("chatMsgNo", msgNo);                   // ★ JS가 getMsgNo로 읽음
    payload.put("chatRoomNo", Integer.parseInt(chatRoomNo));
    payload.put("msgTy", "04001");
    payload.put("msgCn", n.toString());                // JSON 문자열 그대로
    payload.put("empNo", empNoStr);                    // 내 사번(없으면 "0")
    payload.put("empNm", /* 호출자 표시명 */ "system"); // user.getMember().getEmpNm() 넘겨도 됨
    payload.put("msgWrtDt", java.time.LocalDateTime.now().toString());

    // ★ 토픽 경로 꼭 확인! JS는 '/sub/rooms' + roomNo 로 구독함 (점(.) 없음)
    messagingTemplate.convertAndSend("/sub/rooms" + chatRoomNo, payload);

    // (선택) STOMP 브로드캐스트를 즉시 하고 싶으면 여기서 messagingTemplate.convertAndSend(...) 호출
    // messagingTemplate.convertAndSend("/sub/rooms." + chatRoomNo, ...);

    return new Meta("구루미 회의를 시작했어요", created.roomId, created.roomUrlId, Instant.now());
  }

  /** TTL 만료 체크 */
  private boolean isExpired(Instant createdAt, int ttlMinutes) {
    if (ttlMinutes <= 0) return false;
    return Duration.between(createdAt, Instant.now()).toMinutes() >= ttlMinutes;
  }

  
}
