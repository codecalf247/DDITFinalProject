package kr.or.ddit.api.service;

import io.qdrant.client.QdrantClient;
import io.qdrant.client.grpc.Collections;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.embedding.EmbeddingOptions;
import org.springframework.ai.embedding.EmbeddingOptionsBuilder;
import org.springframework.ai.embedding.EmbeddingRequest;
import org.springframework.ai.embedding.EmbeddingResponse;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Slf4j
@Service
@RequiredArgsConstructor
public class VectorService {

    private final QdrantClient qdrantClient;
    private final EmbeddingModel embeddingModel;
    private final VectorStore vectorStore;

    private static final String DEFAULT_COLLECTION = "my-ai-collection";
    private static final int EMBEDDING_DIMENSION = 1536;

    /**
     * Qdrant 컬렉션이 존재하는지 확인 후 없으면 생성
     */
    public void initCollectionIfNeeded() {
        try {
            qdrantClient.getCollectionInfoAsync(DEFAULT_COLLECTION).get();
            log.info("✅ Qdrant 컬렉션 존재함: {}", DEFAULT_COLLECTION);
        } catch (ExecutionException e) {
            if (e.getCause().getMessage().contains("Not found")) {
                log.info("📁 컬렉션 없음. 새로 생성합니다: {}", DEFAULT_COLLECTION);
                try {
                    Collections.VectorParams vectorParams = Collections.VectorParams.newBuilder()
                            .setSize(EMBEDDING_DIMENSION)
                            .setDistance(Collections.Distance.Cosine)
                            .build();

                    Collections.CreateCollection createRequest = Collections.CreateCollection.newBuilder()
                            .setCollectionName(DEFAULT_COLLECTION)
                            .setVectorsConfig(Collections.VectorsConfig.newBuilder()
                                    .setParams(vectorParams)
                                    .build())
                            .build();

                    qdrantClient.createCollectionAsync(createRequest).get();
                    log.info("✅ 컬렉션 생성 성공: {}", DEFAULT_COLLECTION);
                } catch (Exception ex) {
                    log.error("❌ 컬렉션 생성 실패: {}", ex.getMessage(), ex);
                }
            } else {
                log.error("❌ 컬렉션 확인 실패: {}", e.getMessage(), e);
            }
        } catch (Exception e) {
            log.error("❌ 예외 발생: {}", e.getMessage(), e);
        }
    }

    /**
     * 문서를 벡터로 저장
     */
    public void saveDocument(String content, Map<String, Object> metadata) {
        Document doc = new Document(content, metadata);
        vectorStore.add(List.of(doc));
        log.info("✅ 문서 저장 완료: {}", content);
    }

    /**
     * 질의문을 기반으로 유사한 문서 검색
     */
    public List<Document> searchSimilar(String query, int topK) {
        SearchRequest request = SearchRequest.builder()
                .query(query)
                .topK(topK)
                .build();

        return vectorStore.similaritySearch(request);
    }

    /**
     * 질의를 벡터로 임베딩 후 반환
     */
    public List<Float> embedQuery(String query) {
        EmbeddingOptions options = EmbeddingOptionsBuilder.builder()
                .withModel("text-embedding-3-small")
                .build();

        EmbeddingRequest embeddingRequest = new EmbeddingRequest(List.of(query), options);
        EmbeddingResponse embeddingResponse = embeddingModel.call(embeddingRequest);

        float[] vectorArray = embeddingResponse.getResults().get(0).getOutput();
        List<Float> vectorList = new ArrayList<>();
        for (float f : vectorArray) vectorList.add(f);

        return vectorList;
    }
}
