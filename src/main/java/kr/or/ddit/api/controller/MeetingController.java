package kr.or.ddit.api.controller;

import kr.or.ddit.api.dto.MeetingDto;
import kr.or.ddit.api.service.IMeetingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequiredArgsConstructor
@RequestMapping("/meetings")
public class MeetingController {

    private final IMeetingService meetingService;

    /**
     * 음성 파일 → 텍스트 변환 (STT)
     * 요청: MultipartFile(audio) 업로드
     * 응답: 변환된 텍스트(JSON)
     */
    @PostMapping("/generate-summary")
    public ResponseEntity<MeetingDto.TranscriptionResponse> generateSummary(
            @RequestPart("audio") MultipartFile audioFile) throws IOException {
        // 서비스에서 음성을 텍스트로 변환
        MeetingDto.TranscriptionResponse transcriptionResponse = meetingService.transcribeAudio(audioFile);
        // 변환 결과를 JSON으로 응답
        return ResponseEntity.ok(transcriptionResponse);
    }
    
    /**
     * 회의록 요약
     * 요청: { "transcription": "회의록 원문 텍스트" }
     * 응답: { "summary": "요약된 텍스트" }
     */
    @PostMapping("/summarize")
    public ResponseEntity<MeetingDto.SummaryResponse> summarize(
            @RequestBody MeetingDto.SummarizeRequest summarizeRequest) {
    	// 서비스에서 회의록 요약 처리
        MeetingDto.SummaryResponse summaryResponse = meetingService.summarizeTranscription(summarizeRequest);
        // 요약 결과 반환
        return ResponseEntity.ok(summaryResponse);
    }

    /**
     * 회의록 다운로드
     * 요청: { "content": "저장할 텍스트", "file_format": "txt|pdf|docx" }
     * 응답: 바이너리 파일 (첨부파일 다운로드)
     */
    @PostMapping("/download")
    public ResponseEntity<byte[]> download(
            @RequestBody MeetingDto.DownloadRequest downloadRequest) throws IOException {
    	// 요청받은 형식(file_format)에 맞는 문서 생성
        byte[] fileContent = meetingService.generateDocument(downloadRequest);
        
        // 다운로드 시 클라이언트에서 보일 파일 이름 설정
        String fileName = "회의록_요약." + downloadRequest.getFile_format();
        String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8);
        
        // HTTP 헤더에 파일 정보 추가 (브라우저가 다운로드 처리)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFileName);
//        headers.setContentDispositionFormData("attachment", fileName);

        // 파일을 바이너리(byte[]) 형태로 응답
        return ResponseEntity.ok()
                .headers(headers)
                .body(fileContent);
    }
}