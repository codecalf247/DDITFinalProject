package kr.or.ddit.api.service;

import kr.or.ddit.api.dto.AIChatDto.ChatRequest;
import reactor.core.publisher.Flux;

public interface IAIChatService {

	public Flux<String> streamQuery(ChatRequest request);

}
