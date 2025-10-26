package kr.or.ddit.api.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class MeetingDto {

    @Getter
    @Setter
    @NoArgsConstructor
    public static class TranscriptionResponse {
        private String transcription; // 변환된 텍스트(회의록 원문)

        public TranscriptionResponse(String transcription) {
            this.transcription = transcription;
        }
    }

    @Getter
    @Setter
    @NoArgsConstructor
    public static class SummarizeRequest {
        private String transcription;	
    }

    @Getter
    @Setter
    @NoArgsConstructor
    public static class SummaryResponse {
        private String summary;

        public SummaryResponse(String summary) {
            this.summary = summary;
        }
    }

    @Getter
    @Setter
    @NoArgsConstructor
    public static class DownloadRequest {
        private String content;
        private String file_format;
    }
}