package kr.or.ddit.common.chatting.service;

public interface IGooroomeeService {

	public String createRoom(String string, String roomUrlId) throws Exception;

	public String getJoinUrl(String roomId, String username) throws Exception;

	public String createRoom(String string) throws Exception;



}
