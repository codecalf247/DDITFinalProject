package kr.or.ddit.common.notification;

import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import kr.or.ddit.common.notification.service.INotificationService;
import kr.or.ddit.config.SseBus;
import kr.or.ddit.vo.NotificationVO;
import lombok.RequiredArgsConstructor;



/**
 * 공통 알림 발송기.
 * 어디서든 notifier.notify(rcvr, type, message, path) 한 줄 호출로:
 *   1) DB에 미읽음 저장
 *   2) 트랜잭션 커밋 후, 접속 중이면 SSE 즉시 푸시
 */
@Component
@RequiredArgsConstructor
public class NotificationConfig {

	
	  private final INotificationService notiService;

	  public Long notify(String rcver, String type, String message, String path) {
	    // (1) DB INSERT (READ_YN='N')
	    Long id = notiService.saveUnread(rcver, type, message, path);

	    
	    if(TransactionSynchronizationManager.isActualTransactionActive()) {
	    // (2) 트랜잭션 "커밋된 뒤"에만 브라우저로 푸시(롤백 시 유령 알림 방지)
	    TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization(){
	      @Override public void afterCommit() {
	        NotificationVO n = new NotificationVO();
	        n.setNtcnNo(id); n.setRcver(rcver); n.setNtcnTy(type); n.setNtcnCn(message); n.setNtcnPath(path);
	        SseBus.pushTo(rcver, n);
	      }
	    });
	    }else {
	    	//
	    	pushNow(rcver, id, type, message, path);
	    }
	    return id;
	  }

	  private void pushNow(String rcver, Long id, String type, String message, String path){
		    var n = new NotificationVO();
		    n.setNtcnNo(id); n.setRcver(rcver); n.setNtcnTy(type); n.setNtcnCn(message); n.setNtcnPath(path);
		    SseBus.pushTo(rcver, n);
		  }
	  
	  /** 여러 명에게 동일 알림 */
	  public void notifyMany(Iterable<String> rcvers, String type, String message, String path){
	    for (String rcver : rcvers) notify(rcver, type, message, path);
	  }
	
}
