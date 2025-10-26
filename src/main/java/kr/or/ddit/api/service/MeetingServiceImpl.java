package kr.or.ddit.api.service;

import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.api.dto.MeetingDto;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MeetingServiceImpl implements IMeetingService {

	private final WhisperService whisperService;
	private final MeetingSummaryService meetingSummaryService;
	private final DocxGeneratorService docxGeneratorService;

	public MeetingDto.TranscriptionResponse transcribeAudio(MultipartFile audioFile) throws IOException {
		String transcript = whisperService.transcribeAudio(audioFile);
		return new MeetingDto.TranscriptionResponse(transcript);
	}

	public MeetingDto.SummaryResponse summarizeTranscription(MeetingDto.SummarizeRequest summarizeRequest) {
		String summary = meetingSummaryService.summarizeMeeting(summarizeRequest.getTranscription());
		return new MeetingDto.SummaryResponse(summary);
	}

	public byte[] generateDocument(MeetingDto.DownloadRequest downloadRequest) throws IOException {
		return docxGeneratorService.generateDocx(downloadRequest.getContent());
	}
}
