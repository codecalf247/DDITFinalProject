package kr.or.ddit.config;

import java.io.IOException;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public class SseBus {

	  // key=사번, value=그 사람이 열어둔 탭들의 SSE 연결 목록
	  private static final ConcurrentHashMap<String, CopyOnWriteArrayList<SseEmitter>> BOX = new ConcurrentHashMap<>();

	  private static void removeEmitter(String empNo, SseEmitter em) {
		    List<SseEmitter> list = BOX.get(empNo);
		    if (list != null) {
		        list.remove(em);
		        if (list.isEmpty()) {
		            BOX.remove(empNo, list);
		        }
		    }
		}
	  
	  public static SseEmitter add(String empNo, long timeoutMillis) {
		    final long timeout = (timeoutMillis <= 0) ? 0L : timeoutMillis;
		    SseEmitter emitter = new SseEmitter(timeout);

		    // 리스트 준비 & 등록
		    BOX.computeIfAbsent(empNo, k -> new CopyOnWriteArrayList<>()).add(emitter);

		    // 끊기면 정리(메모리/리소스 누수 방지)
		    emitter.onCompletion(() -> removeEmitter(empNo, emitter)); // 이미 complete 상태
		    emitter.onTimeout(() -> { removeEmitter(empNo, emitter); try { emitter.complete(); } catch (Exception ignored) {} });
		    emitter.onError(e -> { removeEmitter(empNo, emitter); try { emitter.complete(); } catch (Exception ignored) {} });

		    // 초기 헬스체크 (실패 시 즉시 정리)
		    try {
		        synchronized (emitter) {
		            emitter.send(SseEmitter.event().name("INIT").data("ok"));
		        }
		    } catch (IOException | IllegalStateException ex) {
		        removeEmitter(empNo, emitter);
		        try { emitter.complete(); } catch (Exception ignored) {}
		    }
		    return emitter; // 응답 스트림은 열린 상태 유지
		}

		/** 특정 사번에게 열린 모든 탭으로 전송: 서비스/비즈니스에서 호출 */
		public static void pushTo(String empNo, Object payload) {
		    List<SseEmitter> list = BOX.get(empNo);
		    if (list == null || list.isEmpty()) return;

		    List<SseEmitter> toRemove = new ArrayList<>();
		    for (SseEmitter em : list) {
		        synchronized (em) { // 동시 send 충돌 방지
		            try {
		                em.send(SseEmitter.event().name("NOTI").data(payload));
		            } catch (IOException | IllegalStateException ex) {
		                toRemove.add(em); // 나중에 일괄 정리
		            }
		        }
		    }

		    if (!toRemove.isEmpty()) {
		        list.removeAll(toRemove);
		        for (SseEmitter em : toRemove) {
		            try { em.complete(); } catch (Exception ignored) {}
		        }
		        if (list.isEmpty()) {
		            BOX.remove(empNo, list);
		        }
		    }
		}

	
	// SseBus에 추가
	  public static void pingAll() {
		    // (empNo, emitter) 쌍을 모아두는 제거 후보 버킷
		    List<Map.Entry<String, SseEmitter>> toRemove = new ArrayList<>();

		    BOX.forEach((empNo, list) -> {
		        for (SseEmitter em : list) {
		            // 동시 send 방지
		            synchronized (em) {
		                try {
		                    em.send(SseEmitter.event().name("KEEPALIVE").data("1"));
		                } catch (IOException | IllegalStateException ex) {
		                    // 지금 remove 하면 ConcurrentModification 문제 가능 → 나중에 일괄 제거
		                    toRemove.add(new AbstractMap.SimpleEntry<>(empNo, em));
		                }
		            }
		        }
		    });

		    // 일괄 제거 + 깔끔히 정리
		    for (Map.Entry<String, SseEmitter> entry : toRemove) {
		        String empNo = entry.getKey();
		        SseEmitter em = entry.getValue();

		        List<SseEmitter> list = BOX.get(empNo);
		        if (list != null) {
		            list.remove(em);
		            try { em.complete(); } catch (Exception ignore) {}
		            // 비면 key도 제거 (메모리 누수 방지)
		            if (list.isEmpty()) {
		                // 동시성 고려해서 현재 list가 그대로일 때만 제거
		                BOX.remove(empNo, list);
		            }
		        }
		    }
		}
	  
}
