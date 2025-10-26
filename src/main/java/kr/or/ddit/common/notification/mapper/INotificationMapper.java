package kr.or.ddit.common.notification.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.NotificationVO;

@Mapper
public interface INotificationMapper {

	public void insert(NotificationVO notifiVO);

	public List<NotificationVO> selectUnreadByRcvr(String rcver);

	public int markRead(Long ntcnNo, String rcver);

	public int countUnread(String rcver);

	public int markAllRead(String empNo);

}
