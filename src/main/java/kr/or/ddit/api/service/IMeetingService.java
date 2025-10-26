package kr.or.ddit.api.service;

import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.api.dto.MeetingDto;

public interface IMeetingService {
	 /**
     * 업로드된 오디오 파일을 텍스트로 전사합니다.
     * @param audioFile 오디오 파일(MultipartFile)
     * @return 전사된 텍스트를 담은 DTO
     * @throws IOException 파일 처리 중 오류 발생 시
     */
    MeetingDto.TranscriptionResponse transcribeAudio(MultipartFile audioFile) throws IOException;

    /**
     * 전사된 텍스트를 기반으로 회의 요약을 생성합니다.
     * @param summarizeRequest 요약 요청 DTO
     * @return 요약 결과를 담은 DTO
     */
    MeetingDto.SummaryResponse summarizeTranscription(MeetingDto.SummarizeRequest summarizeRequest);

    /**
     * 회의 요약 또는 텍스트 내용을 기반으로 문서를 생성합니다.
     * @param downloadRequest 다운로드 요청 DTO (내용 + 파일 형식)
     * @return 생성된 문서의 바이트 배열
     * @throws IOException 문서 생성 중 오류 발생 시
     */
    byte[] generateDocument(MeetingDto.DownloadRequest downloadRequest) throws IOException;
}
