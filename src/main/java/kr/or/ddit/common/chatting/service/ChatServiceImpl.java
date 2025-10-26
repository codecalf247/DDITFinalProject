package kr.or.ddit.common.chatting.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.chatting.dto.ChatRoomListDTO;
import kr.or.ddit.common.chatting.mapper.IChatMapper;
import kr.or.ddit.vo.ChatMessageVO;
import kr.or.ddit.vo.ChattingVO;
import kr.or.ddit.vo.EmpVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatServiceImpl implements IChatService{

	private final SimpMessagingTemplate messagingTemplate;
	@Autowired
	private IChatMapper mapper;
	
	@Override
	@Transactional
	public void saveMessage(ChatMessageVO payload) {
		// TODO Auto-generated method stub
		mapper.saveMsg(payload);
	    

	    
	    // 3) 트랜잭션 커밋 후에만 브로드캐스트
	    TransactionSynchronizationManager.registerSynchronization(
	        new TransactionSynchronization() {
	            @Override public void afterCommit() {
	                // 그대로 payload를 전송 (필요 없으면 민감정보 세팅 안 하면 됨)
	                messagingTemplate.convertAndSend("/sub/rooms" + payload.getChatRoomNo(), payload);
	                pushUnreadTotalToMembers(payload.getChatRoomNo());
	            }
	        }
	    );
	    
	}

	@Override
	public List<ChatMessageVO> loadMessages(int roomNo, Long cursor,int size) {
	    Map<String,Object> mapValue = new HashMap<>();
	    mapValue.put("roomNo", roomNo);
	    mapValue.put("cursor", cursor);
	    mapValue.put("size", size);
	    return mapper.selectRoomMessages(mapValue);
	}

	@Override
	public List<ChatRoomListDTO> listMyRooms(String empNo) {
		// TODO Auto-generated method stub
		return mapper.selectMyRooms(empNo);
	}

	@Override
	public List<EmpVO> getUsers(String empNo) {
		// TODO Auto-generated method stub
		return mapper.getUsers(empNo);
	}

	@Override
	public ChattingVO selectRoom(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return mapper.getRooms(paramMap);
	}

	@Override
	@Transactional
	public void createRoomP(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		int cnt = mapper.createRoomP(paramMap);
		ServiceResult result = null; 
		if(cnt >0) {
			mapper.insertMem(paramMap);
			
			paramMap.put("empNo", paramMap.get("me"));
			
			mapper.insertMem(paramMap);
			
			result = ServiceResult.OK;
		}
	}

	@Override
	public boolean isMember(int roomNo, String empNo) {
	    return mapper.existsRoomMember(roomNo, empNo) > 0;
	}

	@Override
	public int updateLastRead(int roomNo, String empNo, long lastMsgNo) {
	    Map<String, Object> p = new HashMap<>();                          // 매퍼에 줄 파라미터 맵
	    p.put("roomNo", roomNo);                                          // 방 번호
	    p.put("empNo", empNo);                                            // 내 사번
	    p.put("lastMsgNo", lastMsgNo);                                    // 마지막으로 본 메시지 번호
	    int u = mapper.updateLastRead(p);
	    if (u > 0) pushUnreadTotalToMembers(roomNo);
	    return u;
	}

	@Override
	@Transactional
	public int createRoomG(String roomNm, String creatorEmpNo, List<String> memberEmpNos) {
	    Map<String,Object> p = new HashMap<>();
	    p.put("roomNm", roomNm);
	    p.put("roomTy", "G");
	    p.put("ownerEmpNo", creatorEmpNo);     // ★ 생성자 사번을 전달
	    // 1) 방 생성 (chatRoomNo가 p에 담겨 나옴: selectKey 필요)
	    mapper.createRoomG(p);
	    int roomNo = (int) p.get("chatRoomNo");

	    // 2) 멤버 추가 (나 + 초대한 사람들)
	    mapper.insertMem(Map.of("chatRoomNo", roomNo, "empNo", creatorEmpNo));
	    if (memberEmpNos != null) {
	        for (String emp : memberEmpNos) {
	            if (emp != null && !emp.equals(creatorEmpNo)) {
	                mapper.insertMem(Map.of("chatRoomNo", roomNo, "empNo", emp));
	            }
	        }
	    }

	    // 3) (선택) 시스템 메시지 "그룹이 생성되었습니다."
	    ChatMessageVO chatmessageVO = new ChatMessageVO();
	    chatmessageVO.setChatRoomNo(roomNo);
	    chatmessageVO.setEmpNo(creatorEmpNo);
	    chatmessageVO.setMsgTy("03001");
	    chatmessageVO.setMsgCn("그룹이 생성되었습니다.");
	    chatmessageVO.setMsgWrtDt(new Date());
	    mapper.saveMsg(chatmessageVO);
	    //mapper.updateRoomLastMsgNo(roomNo, chatmessageVO.getChatMsgNo());

	    return roomNo;
	}
	
	
	private void pushUnreadTotalToMembers(int roomNo) {
	    List<String> members = mapper.selectMembersOfRoom(roomNo);
	    for (String emp : members) {
	        int total = mapper.selectTotalUnread(emp);
	        messagingTemplate.convertAndSendToUser(
	            emp, "/queue/unread-total",
	            Map.of("unreadTotal", total)
	        );
	    }
	}

	@Override
	@Transactional
	public void ensureMember(int roomNo, String empNo) {
		// TODO Auto-generated method stub
		mapper.upsertMember(Map.of("chatRoomNo", roomNo, "empNo", empNo));
	}
}
