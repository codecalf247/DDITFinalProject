package kr.or.ddit.api.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
public class MeetingSummaryService {

    private final ChatClient chatClient;

    public MeetingSummaryService(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    /**
     * 주어진 회의록 텍스트를 AI를 통해 요약합니다.
     * @param meetingTranscript 요약할 회의록 전체 텍스트
     * @return AI가 생성한 요약 내용
     */
    public String summarizeMeeting(String meetingTranscript) {
        // ✅ [개선] AI의 역할을 더욱 구체화하여 전문성을 높입니다.
        String systemPrompt = "당신은 회의의 모든 핵심 사항을 놓치지 않고, 논의 과정과 최종 결정을 상세하게 기록하는 숙련된 회의록 작성 전문가입니다. 대화의 맥락을 파악하여 중요한 내용을 빠짐없이 추출해야 합니다.";

        // ✅ [개선] 더 상세하고 구조화된 결과물을 얻기 위해 사용자 프롬프트를 대폭 강화합니다.
        String userPrompt = """
                아래 회의 녹취록을 바탕으로, 다음 형식과 지침에 따라 매우 상세하고 전문적인 회의록을 작성해 주세요.

                [회의록 작성 지침]
                1.  **회의 개요**: 녹취록에서 파악할 수 있는 회의의 핵심 주제를 명확하게 한 문장으로 요약해 주세요.
                2.  **주요 안건 및 논의 내용**:
                    - 각 안건에 대해, 어떤 배경에서 논의가 시작되었고 어떤 의견들이 오고 갔는지 구체적으로 서술해 주세요.
                    - 단순 나열이 아닌, 대화의 흐름과 맥락이 드러나도록 작성해 주세요.
                    - 긍정, 부정, 대안 제시 등 다양한 의견을 모두 포함해 주세요.
                3.  **핵심 결정 사항**:
                    - 논의 결과, 최종적으로 무엇이 결정되었는지 명확하게 기술해 주세요.
                    - 만장일치, 다수결 등 의사결정 과정이 드러났다면 함께 기록해 주세요.
                4.  **실행 계획 (Action Items)**:
                    - 결정 사항을 이행하기 위해 '누가(담당자)', '무엇을(업무 내용)', '언제까지(기한)' 해야 하는지 구체적인 실행 계획을 목록 형태로 정리해 주세요.
                    - 담당자나 기한이 명확하지 않은 경우, '미정' 또는 '추후 논의'로 표기해 주세요.
                5.  **기타 및 특이 사항**:
                    - 논의되었지만 결론이 나지 않았거나, 추가적으로 논의가 필요한 사항이 있다면 기록해 주세요.
        	
                ---
                [회의 녹취록]
                %s
                ---
                """.formatted(meetingTranscript);

        // ChatClient를 사용하여 AI 모델을 호출합니다.
        return chatClient.prompt()
                .system(systemPrompt) // AI의 역할을 지정합니다.
                .user(userPrompt)     // 실제 요청 내용을 전달합니다.
                .call()
                .content();           // 결과에서 텍스트 내용만 추출합니다.
    }
}