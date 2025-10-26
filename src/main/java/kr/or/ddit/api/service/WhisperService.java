package kr.or.ddit.api.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.openai.OpenAiAudioTranscriptionModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import ws.schild.jave.Encoder;
import ws.schild.jave.EncoderException;
import ws.schild.jave.MultimediaObject;
import ws.schild.jave.encode.AudioAttributes;
import ws.schild.jave.encode.EncodingAttributes;
import ws.schild.jave.info.MultimediaInfo;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
public class WhisperService {

    private static final Logger log = LoggerFactory.getLogger(WhisperService.class);
    private final OpenAiAudioTranscriptionModel transcriptionModel;

    private static final Set<String> SUPPORTED_FORMATS = Set.of(
            "flac", "m4a", "mp3", "mp4", "mpeg", "mpga", "oga", "ogg", "wav", "webm"
    );
    private static final long MAX_FILE_SIZE_BYTES = 25 * 1024 * 1024;

    @Autowired
    public WhisperService(OpenAiAudioTranscriptionModel transcriptionModel) {
        this.transcriptionModel = transcriptionModel;
    }


    public String transcribeAudio(MultipartFile audioFile) throws IOException {
        if (audioFile.getSize() > MAX_FILE_SIZE_BYTES) {
            log.warn("File size exceeds 25MB. Starting chunking process for '{}'", audioFile.getOriginalFilename());
            return transcribeLargeAudio(audioFile);
        } else {
            log.info("File size is within the limit. Processing '{}' as a single file.", audioFile.getOriginalFilename());
            return transcribeSmallAudio(audioFile);
        }
    }

    /**
     * 25MB 이하의 작은 파일을 처리하는 기존 로직
     */
    private String transcribeSmallAudio(MultipartFile audioFile) throws IOException {
        validateFileExtension(audioFile);
        String originalFilename = audioFile.getOriginalFilename();
        String extension = StringUtils.getFilenameExtension(originalFilename).toLowerCase();

        File inputFile = null;
        File convertedFile = null;
        try {
            inputFile = File.createTempFile("input_small_", "." + extension);
            audioFile.transferTo(inputFile);
            validateAudioContent(inputFile);

            Resource audioResource;
            if (!"mp3".equals(extension)) {
                convertedFile = File.createTempFile("converted_small_", ".mp3");
                convertToMp3(inputFile, convertedFile, null, null); // 전체 변환
                audioResource = new FileSystemResource(convertedFile);
            } else {
                audioResource = new FileSystemResource(inputFile);
            }

            validateFileSize(audioResource); // 최종 크기 한번 더 확인
            return transcriptionModel.call(audioResource);
        } finally {
            // ... 임시 파일 정리 로직 ...
            if (inputFile != null) inputFile.delete();
            if (convertedFile != null) convertedFile.delete();
        }
    }


    private String transcribeLargeAudio(MultipartFile audioFile) throws IOException {
        File inputFile = null;
        List<File> chunkFiles = new ArrayList<>();
        try {
            // 1. 원본 파일을 임시 저장
            String extension = StringUtils.getFilenameExtension(audioFile.getOriginalFilename()).toLowerCase();
            inputFile = File.createTempFile("input_large_", "." + extension);
            audioFile.transferTo(inputFile);
            validateAudioContent(inputFile);

            // 2. 오디오 총 길이와 분할할 청크 개수 계산
            MultimediaObject multimediaObject = new MultimediaObject(inputFile);
            long totalDurationSeconds = multimediaObject.getInfo().getDuration() / 1000;
            // 안전하게 24MB 기준으로 청크 크기 계산
            long chunkDurationSeconds = (long) (totalDurationSeconds * (MAX_FILE_SIZE_BYTES * 0.95) / audioFile.getSize());

            // 3. 오디오를 여러 청크로 분할 및 변환
            for (long offset = 0; offset < totalDurationSeconds; offset += chunkDurationSeconds) {
                File chunk = File.createTempFile("chunk_", ".mp3");
                chunkFiles.add(chunk);
                log.info("Creating chunk: offset={}s, duration={}s", offset, chunkDurationSeconds);
                convertToMp3(inputFile, chunk, (float) offset, (float) chunkDurationSeconds);
            }

            // 4. 각 청크를 API로 전송하고 결과 취합
            StringBuilder fullTranscript = new StringBuilder();
            for (File chunk : chunkFiles) {
                log.info("Transcribing chunk: {}", chunk.getName());
                // ✅ API 호출
                String chunkTranscript = transcriptionModel.call(new FileSystemResource(chunk));
                // ✅ [핵심] API 호출이 성공했음을 알리는 로그 추가
                log.info("Transcription for chunk {} successful. Length: {}", chunk.getName(), chunkTranscript.length());
                fullTranscript.append(chunkTranscript).append(" ");
            }

            return fullTranscript.toString().trim();

        } catch (EncoderException e) {
            throw new RuntimeException("Failed to process large audio file.", e);
        } finally {
            // 5. 모든 임시 파일(원본, 청크) 정리
            log.debug("Cleaning up all temporary files for large audio processing.");
            if (inputFile != null) inputFile.delete();
            for (File chunk : chunkFiles) {
                chunk.delete();
            }
        }
    }

    /**
     * ✅ [수정] 오디오 파일을 MP3로 변환 (시간 오프셋 및 길이 지정 기능 추가)
     * @param offset 시작 시간 (초)
     * @param duration 변환할 길이 (초)
     */
    private void convertToMp3(File source, File target, Float offset, Float duration) {
        try {
            AudioAttributes audio = new AudioAttributes();
            audio.setCodec("libmp3lame");
            audio.setBitRate(128000);
            audio.setChannels(1);
            audio.setSamplingRate(16000);

            EncodingAttributes attrs = new EncodingAttributes();
            attrs.setOutputFormat("mp3");
            attrs.setAudioAttributes(audio);
            if (offset != null) attrs.setOffset(offset);
            if (duration != null) attrs.setDuration(duration);

            Encoder encoder = new Encoder();
            encoder.encode(new MultimediaObject(source), target, attrs);
        } catch (EncoderException e) {
            throw new RuntimeException("오디오 변환(MP3) 실패", e);
        }
    }

    // ... 나머지 validate 메서드들은 동일 ...
    private void validateFileExtension(MultipartFile audioFile) {
        String extension = StringUtils.getFilenameExtension(audioFile.getOriginalFilename());
        if (extension == null || !SUPPORTED_FORMATS.contains(extension.toLowerCase())) {
            throw new IllegalArgumentException("지원하지 않는 오디오 포맷입니다: " + extension);
        }
    }

    private void validateAudioContent(File file) {
        try {
            MultimediaObject multimediaObject = new MultimediaObject(file);
            MultimediaInfo info = multimediaObject.getInfo();

            if (info.getVideo() != null) {
                log.warn("Video stream detected in the file: {}", file.getName());
                throw new IllegalArgumentException("비디오 파일은 지원하지 않습니다. 오디오만 포함된 파일을 업로드해주세요.");
            }
            if (info.getAudio() == null) {
                log.warn("No audio stream detected in the file: {}", file.getName());
                throw new IllegalArgumentException("파일에 오디오 정보가 없습니다.");
            }
        } catch (EncoderException e) {
            log.error("Failed to read multimedia file info: {}", file.getName(), e);
            throw new RuntimeException("파일 정보를 읽는 데 실패했습니다.", e);
        }
    }

    private void validateFileSize(Resource resource) throws IOException {
        long fileSize = resource.contentLength();
        if (fileSize > MAX_FILE_SIZE_BYTES) {
            double sizeInMb = fileSize / (1024.0 * 1024.0);
            String errorMessage = String.format(
                    "파일 크기(%.2fMB)가 최대 허용 크기(25MB)를 초과합니다. 더 짧은 파일을 업로드해주세요.",
                    sizeInMb
            );
            log.warn(errorMessage);
            throw new IllegalArgumentException(errorMessage);
        }
    }
}