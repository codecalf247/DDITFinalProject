package kr.or.ddit.api.dto;

import lombok.Data;

import java.util.List;

/**
 * AIChatDto: AI 채팅 관련 요청/응답용 DTO 묶음
 * - 내부에 ChatRequest 및 Message 클래스가 중첩
 */
public class AIChatDto {
	
    /**
     * ChatRequest: 클라이언트가 AI에게 질의할 때 보내는 페이로드
     * - messages: 대화(메시지) 이력 또는 전송할 메시지 목록
     * - top_k: (선택) 검색 기반 RAG에서 상위 k개 문서를 참조하도록 하는 옵션값
     */
    @Data
    public static class ChatRequest {
    	// 사용자가 보낸 메시지(들)의 리스트 각 요소는 Message DTO
        private List<Message> messages;
        
        // 검색(Retrieval) 시 상위 몇 개의 관련 문서를 사용할지 지정하는 값
        // 예: top_k=5이면 검색 결과 상위 5개 청크를 컨텍스트로 사용
        private int top_k;

        /**
         * Message: ChatRequest 내부에서 한 개의 메시지를 표현
         * - type: 메시지 유형 
         * - content: 실제 텍스트 내용
         */
        @Data
        public static class Message {
        	
            private String role; 	// 메시지 타입
            private String content; // 메시지 실제 내용
        }
    }
}
