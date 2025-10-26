package kr.or.ddit.common.notification.controller;

import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.common.notification.service.INotificationService;
import kr.or.ddit.vo.CustomUser;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ntcn")
public class NotificationController {
		
	
	private final INotificationService service;
	
	  @GetMapping("/unread-count")
	  public Map<String,Integer> unreadCount(@AuthenticationPrincipal CustomUser user){
	    int cnt = service.countUnread(user.getMember().getEmpNo());
	    return Map.of("count", cnt);
	  }

	  @PostMapping("/{id}/read")
	  public void markRead(@PathVariable("id") Long id, @AuthenticationPrincipal CustomUser user){
	    service.markRead(id, user.getMember().getEmpNo());
	  }
	  
	    // ✅ 여기 추가: 내 모든 미읽음을 한 번에 읽음 처리
	    @PostMapping("/readAll")
	    public Map<String,Object> readAll(@AuthenticationPrincipal CustomUser user){
	        String empNo = user.getMember().getEmpNo();
	        int updated = service.markAllRead(empNo);     // 영향을 받은 건수
	        int unread  = service.countUnread(empNo);     // 처리 후 잔여 미읽음
	        return Map.of("updated", updated, "unread", unread);
	    }
	
}
