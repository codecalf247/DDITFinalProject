package kr.or.ddit.common.notification.service;

import java.util.List;

import kr.or.ddit.vo.NotificationVO;

public interface INotificationService {
	
	
	/** 미읽음으로 저장하고 새 PK를 돌려줌 */
	public Long saveUnread(String rcver, String type, String content, String path);
	
	public List<NotificationVO> findUnreadRaw(String rcver);
	
	public int markRead(Long ntcnNo, String rcver);
	
	public int countUnread(String rcver);

	public int markAllRead(String empNo);
	
}
