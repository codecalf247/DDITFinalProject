package kr.or.ddit.api.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface IRagService {
    /**
     * 업로드된 DOCX 파일을 임베딩 후 저장
     * @param file 업로드된 파일
     * @return 생성된 벡터(청크)의 개수
     */
    int ingestAndEmbedDocx(MultipartFile file) throws Exception;

    /**
     * 임베딩된 모든 파일 목록 조회
     * @return 파일명 + 생성일시 리스트
     */
    List<Map<String, Object>> listEmbeddedFiles();

    /**
     * 특정 임베딩 파일의 텍스트 내용 조회
     * @param filename 조회할 파일명
     * @return 텍스트 청크 리스트
     */
    List<String> getEmbeddedFileContent(String filename) throws IOException;

    /**
     * 특정 임베딩 파일 삭제
     * @param filename 삭제할 파일명
     * @return 삭제 성공 여부
     */
    boolean deleteEmbeddedFile(String filename) throws IOException;

    /**
     * 쿼리와 유사한 청크 검색
     * @param query 검색어
     * @return 관련 텍스트 청크 리스트
     */
    List<String> searchSimilarChunks(String query);
}
