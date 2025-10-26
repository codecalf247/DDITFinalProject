package kr.or.ddit.common.notification.service;

import java.util.List;

import javax.management.Notification;

import org.springframework.stereotype.Service;

import kr.or.ddit.common.notification.mapper.INotificationMapper;
import kr.or.ddit.vo.NotificationVO;
import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class INotificationServiceImpl implements INotificationService{

	private final INotificationMapper mapper;
	
	@Override
	public Long saveUnread(String rcver, String type, String content, String path) {
	    NotificationVO notifiVO = new NotificationVO();
	    notifiVO.setRcver(rcver);
	    notifiVO.setNtcnTy(type);
	    notifiVO.setNtcnCn(content);
	    notifiVO.setNtcnPath(path);
	    mapper.insert(notifiVO);             // selectKey로 ntcnNo 채워짐
	    return notifiVO.getNtcnNo();
	}

	@Override
	public List<NotificationVO> findUnreadRaw(String rcver) {
		// TODO Auto-generated method stub
		return mapper.selectUnreadByRcvr(rcver);
	}

	@Override
	public int markRead(Long ntcnNo, String rcver) {
		// TODO Auto-generated method stub
		return mapper.markRead(ntcnNo, rcver);
	}

	@Override
	public int countUnread(String rcver) {
		// TODO Auto-generated method stub
		return mapper.countUnread(rcver);
	}

	@Override
	public int markAllRead(String empNo) {
		// TODO Auto-generated method stub
		return mapper.markAllRead(empNo);
	}

}
