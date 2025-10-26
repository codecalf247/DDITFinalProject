package kr.or.ddit.api.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Stream;

import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.embedding.EmbeddingOptions;
import org.springframework.ai.embedding.EmbeddingOptionsBuilder;
import org.springframework.ai.embedding.EmbeddingRequest;
import org.springframework.ai.embedding.EmbeddingResponse;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class RagServiceImpl implements IRagService {
	
	// 임베딩(JSON) 파일을 저장할 로컬 경로
	private static final String EMBEDDING_DIR = "src/main/resources/vectorDB";
	private Path embeddingPath;	// Path 객체로 실제 디렉토리 경로를 저장
	
	// 임베딩 모델
	private final EmbeddingModel embeddingModel;
	
	// Jackson 라이브러리 객체, JSON 읽기 / 쓰기용
	private final ObjectMapper objectMapper;
	
	// Bean 생성 후 한번만 실행되는 메서드
	@PostConstruct
	public void init() {
	    try {
	    	// EMBEDDING_DIR 경로를 실제 Path 객체로 변환(파일 입출력 작업에서 사용)
	        this.embeddingPath = Paths.get(EMBEDDING_DIR);
	        
	        // 경로에 디렉토리가 없으면 생성 (존재하면 작업 X) 
	        Files.createDirectories(this.embeddingPath);
	        
	        // 디렉토리 초기화 성공 로그
	        log.info("Initialized embedding storage location: {}", this.embeddingPath.toAbsolutePath());
	    } catch (IOException e) {
	    	// 오류 발생 시 로그 출력
	        log.error("Could not initialize storage location: {}", EMBEDDING_DIR, e);
	        
	        // 애플리케이션 실행 중단을 위해 RuntimeException을 던짐
	        throw new RuntimeException("Could not initialize storage location", e);
	    }
	}
	
    /**
     * 업로드된 DOCX 파일을 메모리에서 직접 처리하여 임베딩을 생성하고,
     * 그 결과를 vectorDB 폴더에 JSON 파일로 저장합니다. (기존 store + embed 통합)
     *
     * @param file 업로드된 MultipartFile
     * @return 생성된 벡터(청크)의 개수
     * @throws Exception 파일 처리, 파싱, 저장 중 오류 발생 시
     */
     public int ingestAndEmbedDocx(MultipartFile file) throws Exception {
    	
    	// 파일 유효성 체크
        if (file.isEmpty()) {
            throw new IOException("Cannot process an empty file.");
        }

        // 1. DOCX에서 텍스트 추출 (메모리에서 직접 처리)
        log.info("Extracting text from uploaded file: {}", file.getOriginalFilename());
        String textContent;
        
        // DOCX 문서의 모든 텍스트를 문자열로 가져옴
        try (InputStream inputStream = file.getInputStream();
             XWPFDocument document = new XWPFDocument(inputStream);
             XWPFWordExtractor extractor = new XWPFWordExtractor(document)) {
            textContent = extractor.getText();
        }

        // 2. 텍스트를 의미있는 단위(청크)로 분할
        List<String> chunks = Arrays.stream(textContent.split("\\n\\s*\\n"))   // 빈 줄 단위로 나누어 의미 있는 단락 단위로 분리
                .map(String::trim) // 공백 제거      
                .filter(s -> !s.isEmpty()) // 빈 문자열 제외
                .toList();
        log.info("Split document into {} chunks", chunks.size());

        // 청크가 없으면 
        if (chunks.isEmpty()) {
            log.warn("No text chunks were extracted from the file: {}", file.getOriginalFilename());
            return 0;
        }

        // 3. 각 청크를 "임베딩"하고 결과를 리스트에 저장
        // OpenAI API 호출
        List<Map<String, Object>> embeddings = new ArrayList<>();
        
        
        for (String chunk : chunks) {
            // 벡터 가져오기
        	
            float[] vector = embeddingModel.embed(chunk);
            
            Map<String, Object> embeddingData = new LinkedHashMap<>();
            embeddingData.put("text", chunk);
            embeddingData.put("vector", vector);
            embeddings.add(embeddingData);
        }

        // 4. 임베딩 결과를 JSON 파일로 저장
        String docId = UUID.randomUUID().toString().substring(0, 8); // 파일명 충돌 방지
        
        // 업로드 된 원본 파일명을 가져옴
        String originalFilename = file.getOriginalFilename() != null ? file.getOriginalFilename() : "unknown.docx";

        // 파일 확장자를 제외한 기본 이름만 추출
        String baseName = originalFilename.contains(".")
                ? originalFilename.substring(0, originalFilename.lastIndexOf('.'))
                : originalFilename;

        // 최종 JSON 파일명 생성 : (기본이름-UUID.json)
        String jsonFileName = String.format("%s-%s.json", baseName, docId);
        
        // vectorDB 경로 안에 JSON 파일 경로 생성
        Path embeddingFilePath = this.embeddingPath.resolve(jsonFileName);

        // Jackson ObjectMapper로 임베딩 리스트를 JSON 파일로 저장
        // PrettyPrinter 적용 (사람이 읽기 좋은 형태로 바꿈)
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(embeddingFilePath.toFile(), embeddings);
        log.info("Saved {} embeddings to {}", embeddings.size(), embeddingFilePath.toAbsolutePath());
        
        // 생성된 임베딩(청크) 개수 반환
        return embeddings.size();
    }

     /**
      * 임베딩된 모든 파일의 목록을 반환합니다.
      * @return 파일명과 생성일시를 담은 Map의 리스트
      */
     public List<Map<String, Object>> listEmbeddedFiles() {
    	 // embeddingPath를 File 객체로 변환(vectorDB 디렉토리)
         File vectorDbDir = embeddingPath.toFile();
         
         // 디렉토리가 존재하지 않거나 디렉토리가 아니면
         if (!vectorDbDir.exists() || !vectorDbDir.isDirectory()) {
             log.warn("VectorDB directory not found: {}", embeddingPath);
             return Collections.emptyList();
         }
         
         // 결과를 담을 리스트 생성
         List<Map<String, Object>> fileList = new ArrayList<>();
         
         // vectorDB 디렉토리 내의 .json 파일들을 탐색합니다. (하위 디렉토리는 제외)
         try (Stream<Path> paths = Files.walk(this.embeddingPath, 1)) { // 1 = 최상위
        	 // json 파일만 선택
             paths.filter(path -> !Files.isDirectory(path) && path.toString().endsWith(".json")) 
                     .forEach(path -> { // json 파일 반복
                         try {
                        	 // 파일 정보를 담을 Map 생성
                             Map<String, Object> fileInfo = new LinkedHashMap<>();
                             fileInfo.put("filename", path.getFileName().toString()); // 파일명 저장
                             // 마지막 수정 시각 저장 (밀리초 단위)
                             fileInfo.put("createdAt", Files.getLastModifiedTime(path).toMillis());
                             // 리스트에 추가
                             fileList.add(fileInfo);
                         } catch (IOException e) {
                        	 // 파일 속성 읽기 실패 시 에러 로그 출력
                             log.error("Could not read file attributes for {}", path, e);
                         }
                     });
         } catch (IOException e) {
        	 // 디렉토리 탐색 실패 시 에러 로그 출력
             log.error("Failed to walk through vectorDB directory: {}", this.embeddingPath, e);
         }
         // 생성일시 기준 내림차순(최신순)으로 정렬(최신 파일이 먼저 오도록)
         fileList.sort((f1, f2) -> Long.compare((long) f2.get("createdAt"), (long) f1.get("createdAt")));
         
         // 최종 리스트 반환
         return fileList;
     }
	
     /**
      * 특정 임베딩 파일의 텍스트 내용을 반환합니다.
      * @param filename 내용을 조회할 파일의 이름
      * @return 파일에 포함된 텍스트 청크(chunk) 리스트
      * @throws IOException 파일 읽기 오류 발생 시
      */
     public List<String> getEmbeddedFileContent(String filename) throws IOException {
    	 
    	 // 파일 경로를 embeddingPath 기준으로 결합하고 정규화
    	 // normalize()를 사용해 경로 조작 방지
         Path filePath = this.embeddingPath.resolve(filename).normalize();

         // 보안: 파일 경로 조작 공격 방지
         // filePath가 embeddingPath 하위가 아니면 접근 거부
         if (!filePath.startsWith(this.embeddingPath.normalize())) {
             throw new IOException("Invalid filename provided. Access denied.");
         }
         
         // 3. 파일 존재 여부 확인, 없으면 예외 발생
         if (!Files.exists(filePath)) {
             throw new IOException("File not found: " + filename);
         }
         
         // JSON 파일을 읽어 List<Map<String, Object>> 형태로 파싱
         List<Map<String, Object>> chunks = objectMapper.readValue(
        		 filePath.toFile(), 
        		 new TypeReference<>() {}	// Jackson에 제네릭 타입 정보 전달
         );

         // "text" 필드만 추출하여 리스트로 반환
         return chunks.stream()
                 .map(chunk -> (String) chunk.get("text"))
                 .filter(Objects::nonNull)
                 .toList();
     }
     
     /**
      * 특정 임베딩 파일을 삭제합니다.
      * @param filename 삭제할 파일의 이름
      * @return 삭제 성공 여부
      * @throws IOException 파일 삭제 오류 발생 시
      */
     public boolean deleteEmbeddedFile(String filename) throws IOException {
         // 보안: 파일 경로 조작 공격 방지
         Path filePath = this.embeddingPath.resolve(filename).normalize();
         if (!filePath.startsWith(this.embeddingPath.normalize())) {
             throw new IOException("Invalid filename provided. Access denied.");
         }

         return Files.deleteIfExists(filePath);
     }
     
     /**
      * 사용자의 질문(query)과 가장 유사한 텍스트 조각(chunk)들을 벡터 데이터베이스에서 검색합니다.
      * 이 과정은 다음과 같이 진행됩니다:
      * 1. 사용자의 질문을 임베딩하여 '쿼리 벡터'를 생성합니다.
      * 2. 로컬에 저장된 모든 JSON 파일(임베딩된 문서 조각들)을 순회합니다.
      * 3. 각 파일 내의 모든 텍스트 조각(chunk)에 대해, 저장된 '문서 벡터'와 '쿼리 벡터' 간의 코사인 유사도를 계산합니다.
      * 4. 계산된 유사도 점수가 가장 높은 상위 10개의 텍스트 조각을 반환합니다.
      *
      * @param query 사용자의 질문 문자열
      * @return 유사도가 높은 순서로 정렬된 상위 10개의 텍스트 조각(chunk) 리스트
      */
     public List<String> searchSimilarChunks(String query) {
         // 단계 0: 입력값 검증. 쿼리가 비어있으면 빈 리스트를 반환합니다.
         if (query == null || query.isBlank()) {
             return Collections.emptyList();
         }

         // 단계 0: 벡터 DB 디렉토리 존재 여부 확인.
         if (this.embeddingPath == null || !Files.exists(this.embeddingPath)) {
             log.warn("VectorDB directory not found: {}", embeddingPath);
             return Collections.emptyList();
         }

         // 단계 1: 사용자의 질문(query)을 임베딩하여 벡터로 변환합니다. (쿼리 벡터 생성)
         float[] queryVector = embeddingModel.embed(query);

         // 각 텍스트 조각(chunk)과 그에 해당하는 코사인 유사도 점수를 저장할 Map을 생성합니다.
         // Key: 텍스트 조각(String), Value: 유사도 점수(Double)
         Map<String, Double> chunkScores = new HashMap<>();

         // 단계 2: 로컬 벡터 DB (JSON 파일들)를 순회하며 유사도를 계산합니다.
         try (Stream<Path> paths = Files.walk(this.embeddingPath)) {
             paths.filter(path -> !Files.isDirectory(path) && path.toString().endsWith(".json"))
                     .forEach(path -> {
                         try {
                             // JSON 파일을 읽어 임베딩된 데이터(텍스트와 벡터) 리스트로 변환합니다.
                             List<Map<String, Object>> chunks = objectMapper.readValue(path.toFile(), new TypeReference<>() {});
                             for (Map<String, Object> chunk : chunks) {
                                 String textContent = (String) chunk.get("text");
                                 Object vectorValue = chunk.get("vector");

                                 // 텍스트나 벡터 정보가 없으면 건너뜁니다.
                                 if (textContent == null || vectorValue == null) {
                                     continue;
                                 }

                                 // 저장된 벡터(List<Double> 형태일 수 있음)를 float[] 배열로 변환합니다.
                                 float[] storedVector = toFloatArray(vectorValue);
                                 // 단계 3: 쿼리 벡터와 저장된 문서 벡터 간의 코사인 유사도를 계산합니다.
                                 double similarity = cosineSimilarity(queryVector, storedVector);

                                 // 동일한 텍스트 조각이 여러 파일에 존재할 경우, 더 높은 유사도 점수로 갱신합니다.
                                 chunkScores.merge(textContent, similarity, Math::max);
                             }
                         } catch (IOException | IllegalStateException e) {
                             log.error("Failed to read or parse embedding file: {}", path, e);
                         }
                     });
         } catch (IOException e) {
             log.error("Failed to walk through vectorDB directory: {}", this.embeddingPath, e);
         }

         // 단계 4: 계산된 모든 유사도 점수를 내림차순(높은 점수 순)으로 정렬하고, 상위 10개만 선택하여 텍스트 조각을 리스트로 반환합니다.
         return chunkScores.entrySet().stream()
                 .sorted((entry1, entry2) -> Double.compare(entry2.getValue(), entry1.getValue()))
                 .limit(10)
                 .map(Map.Entry::getKey)
                 .toList();
     }
     
     @SuppressWarnings("unchecked")
     private float[] toFloatArray(Object vectorValue) {
         if (vectorValue instanceof float[] floatArray) {
             return floatArray;
         }
         if (vectorValue instanceof double[] doubleArray) {
             float[] converted = new float[doubleArray.length];
             for (int i = 0; i < doubleArray.length; i++) {
                 converted[i] = (float) doubleArray[i];
             }
             return converted;
         }
         if (vectorValue instanceof List<?> list) {
             float[] converted = new float[list.size()];
             for (int i = 0; i < list.size(); i++) {
                 Object element = list.get(i);
                 if (!(element instanceof Number number)) {
                     throw new IllegalStateException("Vector element is not numeric.");
                 }
                 converted[i] = number.floatValue();
             }
             return converted;
         }
         throw new IllegalStateException("Unsupported vector type: " + vectorValue.getClass());
     }

     private double cosineSimilarity(float[] left, float[] right) {
         if (left.length != right.length) {
             throw new IllegalArgumentException("Vectors must have the same length.");
         }

         double dotProduct = 0.0;
         double leftMagnitude = 0.0;
         double rightMagnitude = 0.0;

         for (int i = 0; i < left.length; i++) {
             dotProduct += left[i] * right[i];
             leftMagnitude += left[i] * left[i];
             rightMagnitude += right[i] * right[i];
         }

         if (leftMagnitude == 0.0 || rightMagnitude == 0.0) {
             return 0.0;
         }

         return dotProduct / (Math.sqrt(leftMagnitude) * Math.sqrt(rightMagnitude));
     }

     /**
      * OpenAI 임베딩 API를 호출해 텍스트 벡터를 생성합니다.
      */
     private float[] fetchEmbeddingVector(String chunk, EmbeddingOptions options) {
         EmbeddingRequest embeddingRequest = new EmbeddingRequest(List.of(chunk), options);
         EmbeddingResponse embeddingResponse = embeddingModel.call(embeddingRequest);

         if (embeddingResponse.getResults().isEmpty()) {
             throw new IllegalStateException("Embedding API returned no results.");
         }

         return embeddingResponse.getResults().get(0).getOutput();
     }
     
	
}
