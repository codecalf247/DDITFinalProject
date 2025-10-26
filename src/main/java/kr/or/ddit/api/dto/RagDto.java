package kr.or.ddit.api.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * RAG(Relevance-Augmented Generation) 관련 요청/응답 DTO 모음 클래스
 * 
 * - IngestResponse : 문서 업로드(ingest) 후 반환되는 결과
 * - EmbedRequest   : 벡터 임베딩 요청 시 전달하는 데이터
 * - EmbedResponse  : 임베딩 완료 후 반환되는 결과
 */
public class RagDto {

    /**
     * 문서를 "ingest(업로드/저장)"한 뒤 반환되는 응답 DTO
     */
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class IngestResponse {
        private String docId;  // 업로드된 문서의 ID
    }


    /**
     * 특정 문서를 벡터 DB에 임베딩할 때 요청에 사용되는 DTO
     */
    @Getter
    @Setter
    @NoArgsConstructor
    public static class EmbedRequest {
        private String docId; // 임베딩 대상 문서의 ID
    }

    /**
     * 벡터 임베딩 요청에 대한 응답 DTO
     */
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EmbedResponse { 
        private int vectors; // 생성된 벡터 개수
    }
}