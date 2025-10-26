package kr.or.ddit.common.chatting.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.common.chatting.dto.ChatRoomListDTO;
import kr.or.ddit.common.chatting.dto.MeetingMsgRow;
import kr.or.ddit.vo.ChatMessageVO;
import kr.or.ddit.vo.ChattingVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;

@Mapper
public interface IChatMapper {

	public List<EmpVO> getUsers(String empNo);

	public ChattingVO getRooms(Map<String, Object> paramMap);

	public int createRoomP(Map<String, Object> paramMap);

	public void saveMsg(ChatMessageVO payload);

	public void insertMem(Map<String, Object> paramMap);

    public int existsRoomMember(@Param("roomNo") int roomNo,
            @Param("empNo") String empNo);
	
	

	public List<ChatMessageVO> selectRoomMessages(Map<String, Object> MapValue);

	public List<ChatRoomListDTO> selectMyRooms(String empNo);

	public int updateLastRead(Map<String, Object> p);

    public int updateRoomLastMsgNo(@Param("roomNo") int roomNo,
            @Param("lastMsgNo") long lastMsgNo);
    
    public int createRoomG(Map<String, Object> p);

	public int selectTotalUnread(String empNo);

	public List<String> selectMembersOfRoom(int roomNo);
	
    public int nextFileGroupNo();   // SELECT SEQ_FILE_GROUP.NEXTVAL FROM DUAL
    public int nextFileNo();        // SELECT SEQ_FILE.NEXTVAL FROM DUAL
    public int insertFile(FilesVO vo);

	public FilesVO selectFileByGroup(int fileGroupNo);

	public void upsertMember(Map<String, Object> of);

	
	 public MeetingMsgRow selectLastMeetingMsg(@Param("chatRoomNo") String chatRoomNo);
	 public Long selectNextChatMsgNo();  // ★ 시퀀스 선점
	 public int insertMeetingMsg(@Param("msgNo") Long msgNo,
	                       @Param("roomNo") Integer roomNo,
	                       @Param("empNo") String empNo,
	                       @Param("msgCn") String msgCnJson);

	public void updateMeetingMsgContent(long msgNo, String string);
	
	
}
