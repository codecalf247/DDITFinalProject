package kr.or.ddit.common.chatting.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.chatting.dto.ChatRoomListDTO;
import kr.or.ddit.vo.ChatMessageVO;
import kr.or.ddit.vo.ChattingVO;
import kr.or.ddit.vo.EmpVO;

public interface IChatService {

	public void saveMessage(ChatMessageVO payload);

	public List<ChatMessageVO> loadMessages(int roomNo, Long cursor, int size);

	public List<ChatRoomListDTO> listMyRooms(String name);

	public List<EmpVO> getUsers(String empNo);

	public ChattingVO selectRoom(Map<String, Object> paramMap);

	public void createRoomP(Map<String, Object> paramMap);

	public boolean isMember(int roomNo, String empNo);

	public int updateLastRead(int roomNo, String empNo, long lastMsgNo);
	
	public int createRoomG(String roomNm, String creatorEmpNo, List<String> memberEmpNos);

	public void ensureMember(int roomNo, String empNo);

	
}
