package kr.or.ddit.api.service;

import java.util.List;
import java.util.Map;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.SystemPromptTemplate;
import org.springframework.stereotype.Service;

import com.github.gavlyukovskiy.boot.jdbc.decorator.flexypool.FlexyPoolProperties.Metrics.Reporter.Log;

import kr.or.ddit.api.dto.AIChatDto.ChatRequest;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;

@Service
@Slf4j
public class AIChatServiceImpl implements IAIChatService{

    private final ChatClient chatClient;
    private final IRagService ragService;
    
    // 생성자 주입 방식으로 필요한 의존성
     public AIChatServiceImpl(ChatModel chatModel, IRagService ragService) {
         this.chatClient = ChatClient.builder(chatModel).build();
         this.ragService = ragService;
     }
	
	@Override
	public Flux<String> streamQuery(ChatRequest request) {
		
		// Message 객체 안에 있는 실제 채팅 메시지 내용을 가져옴
		String userMessage = request.getMessages().get(request.getMessages().size() - 1).getContent();
		
		// 1. RagService를 사용해 관련 문서 조각(context) 검색
		List<String> context = ragService.searchSimilarChunks(userMessage);
		
		log.info("문서 ==================== ");
		log.info("{}", context);
		
		// 2. 검색된 컨텍스트가 없으면, RAG 없이 일반적인 답변 생성
		if(context.isEmpty()) {
			
			// AI 모델 에 역할 지시(system prompt) 설정
			String systemPrompt = "You are a helpful assistant. Your job is to provide helpful and concise answers to user questions.";
			return chatClient.prompt()	
					.system(systemPrompt)	// 시스템 메시지 설정
					.user(userMessage)		// 사용자 메시지 전달
					.stream()				// 응답을 스트리밍 모드로 받음
					.content();				// 응답에서 텍스트만 추출
		}
		
		// 3. 검색된 컨텍스트가 있으면, RAG를 위한 프롬프트 구성
		// 여러 개의 문서 조각을 구분자 "---"로 합쳐 하나의 문자열로 만듦
		String contextString = String.join("\n---\n", context);
		
		// RAG를 위한 시스템 프롬프트 템플릿
		String systemPromptTemplate = """
				Your name is groovy(그루비).
				You are a helpful AI assistant answering questions based on the provided documents.
                Document-based answers

				If the information is in the documents → answer based on that.
				
				If the information is not in the documents → handle it with great caution.
				
				General conversation
				
				Casual conversation or explanations not directly related to the documents are allowed.
				
				However, if the user wants a fact-based answer grounded in the documents → handle any information not in the documents with great caution or respond with the above phrase.
                Your answer must be in Korean.
				Limit the chat output to 250px width, which allows about 25 Korean characters per line
				
                Here are the documents:
                ---
                {context}
                ---
				""";
		
		// 템플릿에 실제 context 문자열 삽입
		SystemPromptTemplate promptTemplate = new SystemPromptTemplate(systemPromptTemplate);
		Prompt prompt = promptTemplate.create(Map.of("context", contextString));
		
		// ChatClient를 이용해 최종 프롬프트와 사용자 질문 전달 후 스트리밍 응답 반환
		return chatClient.prompt()
				.system(prompt.getContents())	// 생성된 시스템 프롬프트를 적용
				.user(userMessage)				// 사용자 질문 전달
				.stream()						// 응답을 스트리밍 모드로 받음
				.content();						// 텍스트 응답만 추출
	}

}
