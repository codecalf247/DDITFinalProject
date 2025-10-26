package kr.or.ddit.api.controller;

import kr.or.ddit.api.dto.RagDto;
import kr.or.ddit.api.service.IRagService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
@RestController
@RequestMapping("/rag")
@RequiredArgsConstructor
@Slf4j
public class RagController {

    private final IRagService ragService;

    /**
     * DOCX 파일을 받아 메모리에서 바로 임베딩을 생성하고 결과를 파일로 저장합니다.
     * (기존 ingest-docx + embed 통합)
     */
    @PostMapping("/ingest-and-embed")
    public ResponseEntity<?> ingestAndEmbedDocx(@RequestParam("file") MultipartFile file) {
    	// 업로드 파일이 비었으면 400 Bad Request 반환
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "File is empty"));
        }
        
        try {
        	// 서비스 호출 후 생성된 백터 개수를 DTO로 반환
            int vectorCount = ragService.ingestAndEmbedDocx(file);
            // 백터 개수 반환
            return ResponseEntity.ok(new RagDto.EmbedResponse(vectorCount));
        } catch (Exception e) {
            log.error("Error while ingesting and embedding docx file", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Error processing file: " + e.getMessage()));
        }
    }


    /**
     * 임베딩된 모든 파일의 목록을 조회합니다.
     */
    @GetMapping("/files")
    public ResponseEntity<?> listFiles() {
        try {
        	// ragService를 호출해서, 임베딩된 파일들의 메타데이터 목록을 가져옴
        	// 반환 타입은 List<Map<String, Object>> 형태 
            List<Map<String, Object>> files = ragService.listEmbeddedFiles();
            
            // 정상적으로 데이터를 가져왔다면, HTTP 200 OK와 함께 결과(JSON)를 반환
            return ResponseEntity.ok(files);
        } catch (Exception e) {
            log.error("Error listing embedded files", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Could not list files: " + e.getMessage()));
        }
    }

    /**
     * 특정 파일의 텍스트 내용을 조회합니다.
     * @param filename 조회할 파일명
     */
    @GetMapping("/files/{filename}")	// URL 경로에서 filename을 받아서 실행되는 GET API
    public ResponseEntity<?> getFileContent(@PathVariable String filename) {
        try {
        	// ragService 호출 -> filename에 해당하는 임베딩 JSON 파일을 읽고,
        	// 그 안에서 "text" 필드만 추출하여 문자열 리스트로 반환
            List<String> content = ragService.getEmbeddedFileContent(filename);
            
            // 성공 시, HTTP 200 OK + 추출된 텍스트 리스트 반환
            return ResponseEntity.ok(content);
        } catch (IOException e) {
            log.error("Error getting content for file: {}", filename, e);
            // 에러 메시지가 "File not found" 로 시작하면 -> 404 NOT FOUND 반환
            if (e.getMessage().startsWith("File not found")) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", e.getMessage()));
            }
            // 그 외 모든 경우는 500 INTERNAL SERVER ERROR 반환
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Could not get file content: " + e.getMessage()));
        }
    }

    /**
     * 특정 파일을 삭제합니다.
     * @param filename 삭제할 파일명
     */
    @DeleteMapping("/files/{filename}")	// HTTP DELETE 요청을 처리, URL 경로에서 filename 추출
    public ResponseEntity<?> deleteFile(@PathVariable String filename) {
        try {
        	// ragService 호출 -> filename에 해당하는 임베딩 JSON 파일 삭제 시도
            boolean deleted = ragService.deleteEmbeddedFile(filename);
            
            if (deleted) {
            	// 삭제 성공 시 -> 200 OK + 성공 메시지 반환
                return ResponseEntity.ok(Map.of("message", "File '" + filename + "' deleted successfully."));
            } else {
            	// 파일이 없어서 삭제 못 한 경우 -> 404 NOT FOUND + 에러 메시지 반환
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "File '" + filename + "' not found."));
            }
        } catch (IOException e) {
        	// 파일 삭제 중 IOException 발생하면 서버 에러 로그 남김
            log.error("Error deleting file: {}", filename, e);
            
            // 500 Internal Server Error +  상세메시지 반환
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Could not delete file: " + e.getMessage()));
        }
    }
}