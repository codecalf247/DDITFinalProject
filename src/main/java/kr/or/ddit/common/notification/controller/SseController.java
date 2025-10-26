package kr.or.ddit.common.notification.controller;

import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import kr.or.ddit.common.notification.service.INotificationService;
import kr.or.ddit.config.SseBus;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.NotificationVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class SseController {

	  private final INotificationService notiService;

	  /**
	   * 브라우저에서 EventSource로 호출하는 엔드포인트.
	   * - 이 연결은 응답을 닫지 않고 유지됨(계속 듣는 채널)
	   * - 접속 시 DB 미읽음을 즉시 쏟아줌(“접속했을 때 알림이 가는” 요구 충족)
	   */
	  @GetMapping(value="/sse/notifications", produces=MediaType.TEXT_EVENT_STREAM_VALUE)
	  public SseEmitter subscribe(@AuthenticationPrincipal CustomUser user){
	    String empNo = user.getMember().getEmpNo();          // 현재 로그인한 사번
	    SseEmitter emitter = SseBus.add(empNo, 30L*60*1000); // 30분짜리 파이프(원하면 0L로 무제한)

	    // 접속 "하는 순간" 그동안의 미읽음(DB READ_YN='N')을 한 번에 전송
	    for (NotificationVO n : notiService.findUnreadRaw(empNo)) {
	      SseBus.pushTo(empNo, n);  // 프런트에서는 'NOTI' 이벤트로 받음
	    }
	    return emitter;
	  }
	
}
