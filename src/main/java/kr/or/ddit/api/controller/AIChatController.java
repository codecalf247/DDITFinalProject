package kr.or.ddit.api.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import kr.or.ddit.api.dto.AIChatDto.ChatRequest;
import kr.or.ddit.api.service.IAIChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController // Spring MVC REST 컨트롤러
@RequestMapping("/api")
@RequiredArgsConstructor	// final 필드를 자동으로 생성자 주입해주는 lombok 어노테이션
@Slf4j
public class AIChatController {
	
	// @RequiredArgsConstructor로 의존성 자동 주입(@Autowired 불필요)
    private final IAIChatService chatService;

    // 클라이언트가 ChatDto.ChatRequest 객체를 요청 바디로 보내면 처리
    @PostMapping("/query-stream")
    public Flux<String> streamQuery(@RequestBody ChatRequest request) {
    	// chatService의 streamQuery 메서드 호출
    	// Flux는 Reactor 기반의 비동기 스트리밍 데이터 타입으로, 데이터가 여러 개 순차적으로 올 때 사용
    	
    	log.info("쿼리스트림");
        return chatService.streamQuery(request);
    }
}
