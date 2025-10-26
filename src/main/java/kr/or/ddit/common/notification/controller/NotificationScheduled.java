package kr.or.ddit.common.notification.controller;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.config.SseBus;

@Component
@EnableScheduling
public class NotificationScheduled {

		@Scheduled(fixedDelayString = "${sse.ping.interval:30000}")
	  public void ping(){ SseBus.pingAll(); }

}
