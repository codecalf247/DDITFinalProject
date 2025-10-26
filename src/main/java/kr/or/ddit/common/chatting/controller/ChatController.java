package kr.or.ddit.common.chatting.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.chatting.dto.ChatRoomListDTO;
import kr.or.ddit.common.chatting.mapper.IChatMapper;
import kr.or.ddit.common.chatting.service.IChatService;
import kr.or.ddit.vo.ChatMessageVO;
import kr.or.ddit.vo.ChattingVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;




@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatController {

  
  @Autowired
  private final IChatService chatService; // 메시지 저장/조회

  @Value("${kr.or.ddit.upload.path}")
  private String uploadPath;
  
  @Autowired
  private final IChatMapper chatMapper;
  

  @MessageMapping("/send/rooms") // 클라: /pub/send
  public void send(Principal principal, ChatMessageVO payload) {
	  //log.info("no" + no);
	log.info("📩 @MessageMapping 실행됨");	  
    log.info("RCV payload={}", payload);
    int roomNo = payload.getChatRoomNo() > 0 ? payload.getChatRoomNo() : 0;
    if (roomNo == 0) return; // 방 번호 필수
    
    
    Authentication auth = (Authentication) principal;
    CustomUser user = (CustomUser) auth.getPrincipal();
    EmpVO empvo = user.getMember();
	
    // 서버가 확정
    payload.setEmpNo(empvo.getEmpNo());
    payload.setMsgWrtDt(new Date());
    payload.setEmpNm(empvo.getEmpNm());
    

    // 파일 메시지면 DB 메타로 보강 (fileGroupNo 기반)
    if ("03003".equals(payload.getMsgTy()) && payload.getFileGroupNo() != 0) {
        FilesVO meta = chatMapper.selectFileByGroup(payload.getFileGroupNo());
        if (meta != null) {
            payload.setFileUrl( meta.getFilePath() + "/" + meta.getSavedNm());
            if (payload.getFileNm() == null)    payload.setFileNm(meta.getOriginalNm());
            if (payload.getFileSize() == null)  payload.setFileSize(meta.getFileSize());
            if (payload.getMimeType() == null)  payload.setMimeType(meta.getFileMime());
            if (payload.getImageYn() == null)   payload.setImageYn(meta.getFileMime()!=null && meta.getFileMime().startsWith("image/") ? "Y":"N");
            if ("Y".equals(payload.getImageYn())) {
                payload.setThumbUrl(meta.getFilePath() + "/s_" + meta.getSavedNm());
            }
        }
    }
    
    
    // DB 저장
    chatService.saveMessage(payload);
  }

  // 히스토리 로딩 (프론트가 방 클릭 시 호출)
  @GetMapping("/chat/messages/{roomNo}")
  @ResponseBody
  public List<ChatMessageVO> history(@PathVariable int roomNo,
                                     @RequestParam(required=false) Long cursor,
                                     @RequestParam(defaultValue="50") int size,
                                     Authentication auth) {

      // (권장) 방 멤버인지 확인
	  CustomUser cu = (CustomUser) auth.getPrincipal();
	  String empNo = cu.getMember().getEmpNo();
      if (!chatService.isMember(roomNo, empNo)) {
          throw new ResponseStatusException(HttpStatus.FORBIDDEN, "방 멤버가 아닙니다.");
      }

      return chatService.loadMessages(roomNo, cursor, size);
  }
  
  @GetMapping("/test/chat")
  public String chatTest() {
	  return "chat";
  }
 
  @ResponseBody
  @GetMapping("/chat/users")
  public ResponseEntity<List<EmpVO>> chatUsers(@RequestParam(defaultValue = "0") int page) {
	  Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	  CustomUser user = (CustomUser) authentication.getPrincipal();
	  EmpVO empUser = user.getMember();
	  
	  List<EmpVO> users = chatService.getUsers(empUser.getEmpNo());
	return new ResponseEntity<List<EmpVO>>(users,HttpStatus.OK);
  }
  
  @ResponseBody
  @PostMapping("/chat/roomCreateP")
  public ResponseEntity<Map<String, Object>> chatCreate(@RequestBody Map<String, String> empMap){
	  Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		  if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
		      throw new IllegalStateException("로그인 사용자가 없습니다.");
		  }
		  

	  CustomUser user = (CustomUser) authentication.getPrincipal();
	  EmpVO emp = user.getMember();
	  Map<String, Object> paramMap = new HashMap<>();
	  ChattingVO chatroomVO = new ChattingVO();
	  
	  paramMap.put("me", emp.getEmpNo());
	  paramMap.put("empNo", empMap.get("empNo"));
	  paramMap.put("empNm", empMap.get("empNm"));
	  paramMap.put("targetNm", empMap.get("empNm"));
	  chatroomVO = chatService.selectRoom(paramMap);
//	  ServiceResult result = null;
	  if(chatroomVO == null) {
		  chatService.createRoomP(paramMap);
		  paramMap.put("result", paramMap.get("chatRoomNo"));
	  }else {
		  int roomNo = chatroomVO.getChatRoomNo();

		  // ✅ 기존 방을 찾았어도, 멤버십은 항상 보정(upsert)
		  chatService.ensureMember(roomNo, emp.getEmpNo());              // me
		  chatService.ensureMember(roomNo, empMap.get("empNo"));         // target
		  paramMap.put("result", String.valueOf(chatroomVO.getChatRoomNo()));	
	  }
	  return new ResponseEntity<Map<String,Object>>(paramMap,HttpStatus.OK);
  }
  
  @GetMapping("/chat/roomsList")
  @ResponseBody
  public ResponseEntity<List<ChatRoomListDTO>> myRooms(Authentication auth) {
      CustomUser user = (CustomUser) auth.getPrincipal();
      String empNo = user.getMember().getEmpNo();
      List<ChatRoomListDTO> roomList = null;
      roomList = chatService.listMyRooms(empNo);
      return new ResponseEntity<List<ChatRoomListDTO>>(roomList,HttpStatus.OK);
  }
  
  @PostMapping("/chat/rooms/{roomNo}/read")                               // 읽음 보고용 REST 엔드포인트
  @ResponseBody                                                             // JSON 응답
  public Map<String, Object> markRead(                                      // 간단한 Map으로 응답
          @PathVariable int roomNo,                                         // 경로에서 방 번호 받기
          @RequestParam long lastMsgNo,                                     // 쿼리스트링으로 마지막 메시지 번호 받기
          Authentication auth                                               // 로그인 사용자 정보
  ) {
      CustomUser cu = (CustomUser) auth.getPrincipal();                     // 시큐리티에서 커스텀 유저 꺼내기
      String empNo = cu.getMember().getEmpNo();                             // 내 사번 추출

      int updated = chatService.updateLastRead(roomNo, empNo, lastMsgNo);   // 서비스 호출로 LAST_MSG_NO 상향 갱신

      Map<String, Object> res = new HashMap<>();                            // 응답 JSON 구성
      res.put("ok", true);                                                  // 성공 플래그
      res.put("roomNo", roomNo);                                            // 확인용 방 번호
      res.put("lastReadMsgNo", lastMsgNo);                                  // 저장된 마지막 읽음 번호
      res.put("updated", updated);                                          // 갱신된 행 수(1 기대)
      return res;                                                           // 프론트로 반환
  }
  
  
  @PostMapping("/chat/roomCreateG")
  @ResponseBody
  public ResponseEntity<Map<String, Object>> createGroup(@RequestBody ChattingVO chatvo,
                                                         Authentication auth) {
      CustomUser cu = (CustomUser) auth.getPrincipal();
      String myEmpNo = cu.getMember().getEmpNo();

      // 여기서 service 호출
      int roomNo = chatService.createRoomG(chatvo.getChatRoomNm(), myEmpNo, chatvo.getMemberEmpNos());

      Map<String,Object> res = new HashMap<>();
      res.put("result", roomNo);
      res.put("roomNm", chatvo.getChatRoomNm());
      res.put("chatRoomTy", "G");
      return ResponseEntity.ok(res);
  }
  
  @PostMapping("/chat/upload")
  @ResponseBody
  @Transactional
  public List<AttachmentDto> uploadToChat(
          @RequestParam("files") List<MultipartFile> files,
          @RequestParam("roomNo") String roomNo,
          @AuthenticationPrincipal CustomUser user
  ) throws IOException {

      List<AttachmentDto> result = new ArrayList<>();

      // 1) 파일 그룹 번호(업로드 요청 1건당 1개)
      int fileGroupNo = chatMapper.nextFileGroupNo();

      // 2) 저장 폴더: 물리 경로(디스크)
      //    - uploadPath: 예) D:/upload/chat  (application.properties의 kr.or.ddit.upload.path)
      //    - todayPath : yyyy/MM/dd
      String todayPath = new SimpleDateFormat("yyyy/MM/dd").format(new Date());
      File dir = new File(uploadPath, todayPath);
      if (!dir.exists()) dir.mkdirs();

      // 3) 웹에서 접근할 베이스 URL 경로 (정적리소스 핸들러로 매핑돼 있어야 함)
      //    - 절대 "File.separator" 쓰지 말고, URL은 '/' 고정!
      String webBasePath = ("/upload/" + todayPath).replace("\\", "/");

      for (MultipartFile mf : files) {
          if (mf == null || mf.isEmpty()) continue;

          // 4) 파일명/확장자
          String original = mf.getOriginalFilename();
          if (original == null || original.isBlank()) original = "file";
          String ext = "";
          int dot = original.lastIndexOf('.');
          if (dot >= 0 && dot < original.length() - 1) ext = original.substring(dot + 1);

          // 5) 저장 파일명: UUID.ext  → 실제 파일 저장 (디스크)
          String saveName = UUID.randomUUID().toString().replace("-", "") + (ext.isEmpty() ? "" : "." + ext);
          File dest = new File(dir, saveName);
          mf.transferTo(dest);
          long sizeBytes = dest.length();

          // 6) MIME / 이미지 여부
          String contentType = mf.getContentType();
          if (contentType == null || contentType.isBlank()) contentType = "application/octet-stream";
          boolean image = contentType.startsWith("image/");

          // 7) 웹에서 접근할 파일 URL (프론트 표시용)
          String urlBase  = ("/upload/" + todayPath).replace("\\","/"); // 웹 경로의 디렉터리
          String url      = urlBase + "/" + saveName;                       // 원본 파일 웹 경로
          String thumbUrl = null;

          // 8) 썸네일(이미지일 때만) — 실제 파일 경로로 저장!
          if (image) {
              File thumbFile = new File(dir, "s_" + saveName); // 물리 경로
              try (InputStream in = new FileInputStream(dest)) {
                  BufferedImage img = ImageIO.read(in);
                  if (img != null && img.getWidth() > 0) {
                      BufferedImage thumb = Scalr.resize(
                              img,
                              Scalr.Method.QUALITY,
                              Scalr.Mode.FIT_TO_HEIGHT,
                              100,
                              Scalr.OP_ANTIALIAS
                      );
                      String fmt = (ext == null || ext.isBlank()) ? "jpg" : ext;
                      ImageIO.write(thumb, fmt, thumbFile);
                      // 썸네일의 웹 접근 경로
                      thumbUrl = webBasePath + "/s_" + saveName;
                  }
              } catch (Exception ignore) { /* 실패해도 무시 */ }
          }

          // 9) 파일 번호 발급 + FILE_UPLOADER 생성
          int fileNo = chatMapper.nextFileNo();
          String fileUploader = user.getMember().getEmpNo();

          // 10) DB 저장 (경로만 저장: FILE_PATH = "/files/chat/yyyy/MM/dd")
          FilesVO fvo = new FilesVO();
          fvo.setFileGroupNo(fileGroupNo);
          fvo.setFileNo(fileNo);
          fvo.setOriginalNm(original);
          fvo.setFileUploader(fileUploader);
          fvo.setSavedNm(saveName);
          fvo.setFilePath(webBasePath); // ★ 경로만 저장
          fvo.setFileSize(sizeBytes);
          fvo.setFileFancysize(org.apache.commons.io.FileUtils.byteCountToDisplaySize(sizeBytes));
          fvo.setFileMime(contentType);
          fvo.setDelYn("N");

          chatMapper.insertFile(fvo); // ← MyBatis 매퍼의 insert

          // 11) 프론트 응답
          AttachmentDto dto = new AttachmentDto();
          dto.fileName  = original;
          dto.size      = sizeBytes;
          dto.contentType = contentType;
          dto.url       = url;       // FILE_PATH + "/" + SAVED_NM
          dto.thumbUrl  = thumbUrl;  // 이미지일 때만
          dto.fileGroupNo  = fileGroupNo;    // ★ 중요
          dto.image     = image;
          result.add(dto);
      }

      return result;
  }

  
  public static class AttachmentDto {
	    public String fileName;
	    public long   size;
	    public String contentType;
	    public String url;
	    public String thumbUrl; // 이미지 아니면 null
	    public boolean image;   // 이미지 여부
	    public int     fileGroupNo; // ★ 추가
	}
  
}
