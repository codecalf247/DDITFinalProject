package kr.or.ddit.common.chatting.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GooroomeeServiceImpl implements IGooroomeeService {

  private final WebClient client;
  private final ObjectMapper om = new ObjectMapper();

  public GooroomeeServiceImpl(
      @Value("${gooroomee.api.base-url}") String baseUrl,   // https://openapi.gooroomee.com
      @Value("${gooroomee.api.token}") String token
  ) {
    this.client = WebClient.builder()
        .baseUrl(baseUrl)
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE + "; charset=UTF-8")
        .defaultHeader("X-GRM-AuthToken", token)
        .build();
  }

  @Value("${gooroomee.room.duration-minutes:120}")
  private int durationMinutes;  // TTL

  public int getDurationMinutes() { return durationMinutes; }

  /* ===== IGooroomeeService 표준 메서드 ===== */
  @Override
  public String createRoom(String title) throws Exception {
    return createRoom(title, null); // urlId 없이도 생성 가능
  }

  @Override
  public String getJoinUrl(String roomId, String username) throws Exception {
    MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
    form.add("roomId", roomId);
    // 계정별 파라미터 차이 커버
    form.add("username", username);
    form.add("userName", username);

    String body = client.post().uri("/api/v1/room/user/otp/url")
        .body(BodyInserters.fromFormData(form))
        .retrieve().bodyToMono(String.class)
        .block();

    JsonNode json = om.readTree(body);
    String code = json.path("resultCode").asText("");
    if (!"GRM_200".equals(code)) {
      throw new IllegalStateException("구루미 OTP 실패 resultCode=" + code + " raw=" + body);
    }

    String url = json.path("result").path("url").asText(null);
    if (isBlank(url)) url = json.path("data").path("url").asText(null);
    if (isBlank(url)) url = json.path("data").path("otpUrl").asText(null);
    if (isBlank(url)) throw new IllegalStateException("OTP url 파싱 실패 raw=" + body);

    return url;
  }

  /* ===== 구현체 전용 오버로드 (공유 URL 만들 때 사용) ===== */
  public String createRoom(String title, String roomUrlId) throws Exception {
    MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
    form.add("roomTitle", title);
    form.add("callType", "SFU");
    form.add("layoutType", "4");
    form.add("maxJoinCount", "8");
    form.add("durationMinutes", String.valueOf(durationMinutes)); // ← 하드코딩 제거

    if (roomUrlId != null && !roomUrlId.isBlank()) {
      form.add("roomUrlId", roomUrlId);
    }

    String body = client.post().uri("/api/v1/room")
        .body(BodyInserters.fromFormData(form))
        .retrieve().bodyToMono(String.class)
        .block();

    JsonNode json = om.readTree(body);
    String code = json.path("resultCode").asText("");
    if (!"GRM_200".equals(code)) {
      throw new IllegalStateException("구루미 방 생성 실패 resultCode=" + code + " raw=" + body);
    }

    String roomId = json.path("result").path("roomId").asText(null);
    if (isBlank(roomId)) roomId = json.path("data").path("roomId").asText(null);
    if (isBlank(roomId)) roomId = json.path("data").path("room").path("roomId").asText(null);
    if (isBlank(roomId)) throw new IllegalStateException("roomId 파싱 실패 raw=" + body);

    return roomId;
  }

  private static boolean isBlank(String s){ return s == null || s.isBlank(); }
}
