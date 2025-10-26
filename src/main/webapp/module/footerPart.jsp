<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      <!-- AI 버튼 -->
      <button class="btn btn-primary p-3 rounded-circle d-flex align-items-center justify-content-center customizer-btn" type="button" data-bs-toggle="offcanvas" data-bs-target="#aiOffcanvas" aria-controls="aiOffcanvas">
        <i class="icon ti ti-robot fs-7"></i>
      </button>
       
       <!-- AI 화면 -->
       <%@ include file="./aiCanvas.jsp" %>
	  


  <div class="dark-transparent sidebartoggler"></div>  
<!-- 채팅 아이콘 버튼 (네비게이션에 있는 부분) -->
<!-- 채팅 Offcanvas -->
<div class="offcanvas offcanvas-end chat-offcanvas" tabindex="-1" id="chatDrawer" 
     aria-labelledby="chatDrawerLabel" data-bs-backdrop="true">
  
  <!-- 채팅 헤더 -->
  <div class="offcanvas-header border-bottom bg-primary text-white p-3">
    <div class="d-flex align-items-center w-100">
      <div class="d-flex align-items-center flex-grow-1">
        <i class="ti ti-message-circle fs-6 me-2"></i>
        <h5 class="offcanvas-title mb-0" id="chatDrawerLabel">채팅</h5>
      </div>
      <div class="d-flex align-items-center gap-2">
        <!-- 새 채팅 버튼 -->
        <button type="button" class="btn btn-sm btn-light rounded-circle p-2" 
                data-bs-toggle="modal" data-bs-target="#newChatModal" title="새 채팅">
          <i class="ti ti-plus fs-5"></i>
        </button>
        <!-- 닫기 버튼 -->
        <button type="button" class="btn-close btn-close-white" 
                data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
    </div>
  </div>

  <!-- 채팅 내용 -->
  <div class="offcanvas-body p-0 d-flex flex-column h-100">
    
    <!-- 채팅방 목록/대화 영역 전환 -->
    <div class="chat-container d-flex flex-column h-100">
      
      <!-- 채팅방 목록 화면 -->
      <div id="chatListView" class="chat-list-view h-100">
        
        <!-- 검색 바 -->
        <div class="p-3 border-bottom">
          <div class="input-group">
            <span class="input-group-text bg-light border-0">
              <i class="ti ti-search"></i>
            </span>
            <input type="text" class="form-control border-0 bg-light" 
                   placeholder="채팅방 검색..." id="chatSearchInput">
          </div>
        </div>

        <!-- 채팅방 목록 -->
        <div class="chat-room-list flex-grow-1" style="overflow-y: auto;">
          
          <!-- 즐겨찾기 채팅방 -->
          <div class="p-3 border-bottom">
            <small class="text-muted fw-semibold">즐겨찾기</small>
          </div>
          
          <!-- 개별 채팅방 아이템 -->
          <div class="chat-room-item d-flex align-items-center p-3 border-bottom position-relative" 
               data-room-id="room1" data-room-type="group" data-room-name="개발팀 회의">
            <div class="position-relative">
              <!-- 프로필 이미지 또는 그룹 아바타 -->
              <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" 
                   style="width: 50px; height: 50px; font-size: 18px; font-weight: bold;">
                개
              </div>
              <!-- 온라인 상태 표시 (개인 채팅만) -->
              <span class="position-absolute bottom-0 end-0 bg-success border border-white rounded-circle" 
                    style="width: 14px; height: 14px;"></span>
            </div>
            
            <div class="ms-3 flex-grow-1">
              <div class="d-flex justify-content-between align-items-start">
                <h6 class="mb-1 fw-semibold">개발팀 회의</h6>
                <small class="text-muted">14:30</small>
              </div>
              <div class="d-flex justify-content-between align-items-center">
                <p class="mb-0 text-muted small text-truncate pe-2">김지후: 내일 회의 준비 완료했습니다!</p>
                <span class="badge bg-danger rounded-pill">2</span>
              </div>
            </div>
          </div>

          <!-- 개인 채팅 -->
          <div class="chat-room-item d-flex align-items-center p-3 border-bottom position-relative" 
               data-room-id="user123" data-room-type="private" data-room-name="이유진">
            <div class="position-relative">
              <div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center" 
                   style="width: 50px; height: 50px;">
                <img src="https://via.placeholder.com/50" class="rounded-circle" 
                     style="width: 50px; height: 50px;" alt="이유진">
              </div>
              <span class="position-absolute bottom-0 end-0 bg-success border border-white rounded-circle" 
                    style="width: 14px; height: 14px;"></span>
            </div>
            
            <div class="ms-3 flex-grow-1">
              <div class="d-flex justify-content-between align-items-start">
                <h6 class="mb-1 fw-semibold">이유진</h6>
                <small class="text-muted">11:45</small>
              </div>
              <div class="d-flex justify-content-between align-items-center">
                <p class="mb-0 text-muted small text-truncate pe-2">네, 확인했습니다! 👍</p>
                <span class="badge bg-danger rounded-pill">1</span>
              </div>
            </div>
          </div>

          <!-- 그룹 채팅 -->
          <div class="chat-room-item d-flex align-items-center p-3 border-bottom position-relative" 
               data-room-id="room2" data-room-type="group" data-room-name="디자인팀">
            <div class="position-relative">
              <div class="rounded-circle bg-warning text-white d-flex align-items-center justify-content-center" 
                   style="width: 50px; height: 50px; font-size: 18px; font-weight: bold;">
                디
              </div>
            </div>
            
            <div class="ms-3 flex-grow-1">
              <div class="d-flex justify-content-between align-items-start">
                <h6 class="mb-1 fw-semibold">디자인팀</h6>
                <small class="text-muted">어제</small>
              </div>
              <div class="d-flex justify-content-between align-items-center">
                <p class="mb-0 text-muted small text-truncate pe-2">박민수: 시안 검토 부탁드려요</p>
              </div>
            </div>
          </div>

          <!-- 더 많은 채팅방들... -->
          <div class="chat-room-item d-flex align-items-center p-3 border-bottom position-relative" 
               data-room-id="user456" data-room-type="private" data-room-name="김형준">
            <div class="position-relative">
              <div class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center" 
                   style="width: 50px; height: 50px;">
                <img src="https://via.placeholder.com/50" class="rounded-circle" 
                     style="width: 50px; height: 50px;" alt="김형준">
              </div>
              <!-- 오프라인 상태 -->
              <span class="position-absolute bottom-0 end-0 bg-secondary border border-white rounded-circle" 
                    style="width: 14px; height: 14px;"></span>
            </div>
            
            <div class="ms-3 flex-grow-1">
              <div class="d-flex justify-content-between align-items-start">
                <h6 class="mb-1 fw-semibold">김형준</h6>
                <small class="text-muted">2일 전</small>
              </div>
              <div class="d-flex justify-content-between align-items-center">
                <p class="mb-0 text-muted small text-truncate pe-2">프로젝트 일정 조율 필요합니다</p>
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- 개별 채팅 대화 화면 -->
      <div id="chatConversationView" class="chat-conversation-view d-flex flex-column h-100 d-none">
        
        <!-- 대화 헤더 -->
        <div class="chat-conversation-header d-flex align-items-center p-3 border-bottom bg-light">
          <button class="btn btn-sm btn-outline-secondary me-3" id="backToChatList">
            <i class="ti ti-arrow-left"></i>
          </button>
          <div class="d-flex align-items-center flex-grow-1">
            <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" 
                 style="width: 40px; height: 40px; font-size: 16px; font-weight: bold;" id="chatAvatarConv">
              개
            </div>
            <div>
              <h6 class="mb-0 fw-semibold" id="chatTitleConv">개발팀 회의</h6>
              <small class="text-muted" id="chatStatusConv">3명 참여중</small>
            </div>
          </div>
          <div class="d-flex gap-2">
			 <button class="btn btn-outline-primary d-flex align-items-center gap-1 js-gooroomee-call"
			         id="btnGooroomeeCall"
			         data-chat-room-no="">
			  <i class="ti ti-phone"></i><span class="d-none d-sm-inline">화상회의</span>
            </button>
          </div>
        </div>

        <!-- 메시지 영역 -->
        <div class="chat-messages flex-grow-1 overflow-auto p-3">
          
          <!-- 날짜 구분선 -->
          <!-- <div class="text-center my-3">
            <span class="badge bg-light text-dark">2024년 1월 15일</span>
          </div> -->


        </div>

        <!-- 메시지 입력 영역 -->
        <div class="chat-input-area p-3 border-top bg-white">
          <div class="d-flex align-items-center gap-2">
            <button class="btn btn-outline-secondary btn-sm" title="파일첨부">
              <i class="ti ti-paperclip"></i>
            </button>
            <!-- 숨은 파일 입력 -->
		<input type="file" id="chatFileInput" class="d-none" multiple
       			accept="image/*,application/pdf,.zip,.7z,.doc,.docx,.xls,.xlsx,.ppt,.pptx" />
            <div class="flex-grow-1">
              <div class="input-group">
                <input type="text" class="form-control border-0 bg-light" 
                       placeholder="메시지를 입력하세요..." id="messageInput">
                <button class="btn btn-primary" type="submit" id="sendMessageBtn">
                  <i class="ti ti-send"></i>
                </button>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</div>

<!-- 새 채팅 만들기 모달 (기존 코드와 동일하게 사용) -->
<div class="modal fade" id="newChatModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">새 채팅</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- 탭 전환 -->
        <ul class="nav nav-pills mb-3" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#individual-chat">개인 채팅</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#group-chat">그룹 채팅</button>
          </li>
        </ul>

        <!-- 사용자 검색 -->
        <div class="input-group mb-3">
          <span class="input-group-text"><i class="ti ti-search"></i></span>
          <input type="text" class="form-control" placeholder="이름으로 검색...">
        </div>

        <!-- 탭 내용 -->
        <div class="tab-content">
          <div class="tab-pane fade show active" id="individual-chat">
            <!-- 개인 채팅용 사용자 목록 -->
            <div id="individualList" class="list-group" style="max-height:320px; overflow:auto;"></div>
          </div>
			<div class="tab-pane fade" id="group-chat">
			  <div id="groupList" class="list-group" style="max-height:320px; overflow:auto;"></div>
			  <div class="mt-3">
			    <input type="text" id="groupRoomName" class="form-control" placeholder="그룹 채팅방 이름">
			  </div>
			</div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" id="chatStart" class="btn btn-primary">채팅 시작</button>
      </div>
    </div>
  </div>
</div>

<!-- 커스텀 CSS -->
<style>
  /* 채팅 Offcanvas 스타일 */
  .chat-offcanvas {
    width: 400px !important;
  }
  
  @media (max-width: 768px) {
    .chat-offcanvas {
      width: 100% !important;
    }
  }

  /* 채팅방 목록 아이템 */
  .chat-room-item {
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .chat-room-item:hover {
    background-color: #f8f9fa;
  }

  .chat-room-item.active {
    background-color: #e3f2fd;
    border-left: 4px solid #2196f3;
  }

  /* 메시지 버블 */
.message-bubble{
  overflow-wrap:anywhere;   /* 최신 브라우저 */
  word-break:break-word;    /* 사파리/레거시 */
  word-wrap:break-word;     /* 레거시 */
  white-space:pre-wrap;     /* 개행 보존 + 줄바꿈 허용 */
}

.message-bubble{
  display: inline-block;           /* 핵심: 블록 → 인라인블록 */
  width: fit-content;              /* 내용 크기만큼 */
  max-width: 70%;                  /* 너무 길면 줄바꿈 (컨테이너의 70%) */
  min-width: 2.2rem;               /* 한 글자일 때 너무 작지 않게 */
  vertical-align: top;
}

.message-payload{
  display:inline-block;
  max-width:70%;
}

.message-time{ display:block; margin-top:.25rem; line-height:1; opacity:.75; }

  .message-bubble:first-child::before {
    content: '';
    position: absolute;
    top: 0;
    width: 0;
    height: 0;
  }

  /* 상대방 메시지 꼬리 */
  .message-group .message-bubble.bg-light:first-child::before {
    left: -8px;
    border-top: 8px solid #f8f9fa;
    border-right: 8px solid transparent;
  }

  /* 내 메시지 꼬리 */
  .message-group .message-bubble.bg-primary:first-child::before {
    right: -8px;
    border-top: 8px solid #0d6efd;
    border-left: 8px solid transparent;
  }

  /* 채팅 입력창 */
  .chat-input-area input:focus {
    box-shadow: none;
    border-color: transparent;
  }

  /* 온라인 상태 점 */
  .position-absolute.bg-success {
    border: 2px solid white !important;
  }

  /* 스크롤바 커스텀 */
  .chat-room-list::-webkit-scrollbar,
  .chat-messages::-webkit-scrollbar {
    width: 6px;
  }

  .chat-room-list::-webkit-scrollbar-track,
  .chat-messages::-webkit-scrollbar-track {
    background: #f1f1f1;
  }

  .chat-room-list::-webkit-scrollbar-thumb,
  .chat-messages::-webkit-scrollbar-thumb {
    background: #c1c1c1;
    border-radius: 3px;
  }


/* 목록의 오른쪽 텍스트 영역이 flex-grow-1인 경우 */
.chat-room-item .flex-grow-1{ min-width:0; }

/* “마지막 메시지” 한 줄 말줄임 강제 */
.chat-room-item .lastline{
  overflow:hidden;
  text-overflow:ellipsis;
  white-space:nowrap;
}

.chat-room-item .rounded-circle,
.chat-conversation-header .rounded-circle{
  display:flex; align-items:center; justify-content:center;
  line-height:1;                 /* 글자 위아래 여백 축 */
  font-weight:700;
}

/* Offcanvas 내부를 세로 레이아웃 + 자식 스크롤 허용 */
#chatDrawer .offcanvas-body { 
  display: flex; 
  flex-direction: column; 
  height: 100%; 
  min-height: 0;           /* ← 중요: 자식이 줄어들며 스크롤 가능 */
}

/* 대화 화면도 세로 레이아웃 + 스크롤 허용 */
#chatConversationView { 
  min-height: 0;           /* ← 중요 */
}

/* 메시지 영역: 남는 공간 전부 + 여기만 스크롤 */
.chat-messages { 
  flex: 1 1 auto; 
  overflow-y: auto; 
  min-height: 0;           /* ← 중요 */
}

/* 입력창: 항상 하단에 고정 느낌 (필수는 아니지만 안전빵) */
.chat-input-area { 
  flex: 0 0 auto; 
  position: sticky; 
  bottom: 0; 
  background: #fff; 
  z-index: 1;              /* 메시지 위로 떠서 경계선 가려지지 않게 */
}
.message-bubble a { text-decoration: underline; word-break: break-all; }
/* 이미지 링크는 딱 이미지 크기만 클릭되게 */
.message-bubble a.file-thumb-link{
  display: inline-block !important;  /* 블록 → 인라인블록 */
  line-height: 0;                    /* 유령 밑줄 방지 */
  vertical-align: middle;
  width: auto;
  max-width: 100%;
}

/* 링크 밑줄 커스텀 끄기(그대로 유지) */
.message-bubble a{ text-decoration:none !important; border:0 !important; }
.message-bubble a::before,
.message-bubble a::after{ content:none !important; }
.message-bubble a.file-thumb-link img{ display:block; border-radius:8px; }

/* 말풍선 + 시간 세로 스택 */
.msg-stack{ display:flex; flex-direction:column; max-width:260px; }
.msg-stack.end{ align-items:flex-end; }   /* 내 메시지 */
.msg-stack.start{ align-items:flex-start; } /* 상대 메시지 */

/* 말풍선은 내용 길이에 맞게 */
.message-bubble{ display:inline-block; max-width:100%; }

/* 시간은 항상 아래 줄 */
.message-time{ display:block; margin-top:.25rem; line-height:1; white-space:nowrap; opacity:.75; }

/* 파일 썸네일/링크가 말풍선 폭을 안 벌리게 */
.file-thumb, .file-link{ display:inline-block; max-width:100%; }
.file-thumb img{ display:block; max-width:220px; height:auto; border-radius:8px; }

.system-tile { display:block; }
.system-card {
  background: var(--bs-body-bg, #fff);
  border: 1px solid var(--bs-border-color, #e9ecef);
  border-radius: .75rem;
  padding: .75rem .9rem;
  max-width: 420px;
  margin: 0 auto;              /* 가운데 정렬 */
  box-shadow: 0 1px 2px rgba(0,0,0,.04);
}
[data-bs-theme="dark"] .system-card {
  background: #1f1f1f;
  border-color: #2a2a2a;
}


/* ===== 회의 알림 카드 강조 ===== */
.system-card { 
  background: var(--bs-body-bg, #fff);
  border: 1px solid var(--bs-border-color, #e9ecef);
  border-radius: .75rem;
  padding: .75rem .9rem;
  box-shadow: 0 1px 2px rgba(0,0,0,.04);
}

/* (기본 강조) 연한-빨강 배경 + 빨강 글씨 */
.system-card--alert {
  background: var(--bs-danger-bg-subtle, #f8d7da);
  border-color: var(--bs-danger-border-subtle, #f1aeb5);
}
.system-card--alert .title {
  color: var(--bs-danger-text-emphasis, #842029);
  font-weight: 700;
}

/* (옵션) 왼쪽 포인트 스트라이프 */
.system-card--stripe { position: relative; }
.system-card--stripe::before{
  content:"";
  position:absolute; left:6px; top:8px; bottom:8px; width:4px;
  background: var(--bs-danger, #dc3545); border-radius: 2px;
}

/* (옵션) 강한 강조: 진한 빨강 배경 + 흰 글씨 */
.system-card--solid {
  background: var(--bs-danger, #dc3545);
  border-color: var(--bs-danger, #dc3545);
  color: #fff;
}
.system-card--solid .title { color:#fff; }
.system-card--solid .text-muted { color: rgba(255,255,255,.8) !important; }

[data-bs-theme="dark"] .system-card--alert {
  /* 다크모드에서도 대비 유지 */
  background: color-mix(in srgb, var(--bs-danger), transparent 85%);
  border-color: color-mix(in srgb, var(--bs-danger), transparent 70%);
}
</style>

<!-- JavaScript for Chat Functionality -->
<!-- SockJS -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>

<!-- STOMP -->
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<!-- 채팅 JS -->
<script src="${pageContext.request.contextPath }/resources/assets/js/chat-common.js"
        data-cpath="${pageContext.request.contextPath}"
        data-myempno="${sessionScope.empVO.empNo}"
        defer></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/vendor.min.js"></script>
  <!-- Import Js Files -->
  <script src="${pageContext.request.contextPath }/resources/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/libs/simplebar/dist/simplebar.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/app.minisidebar.init.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/theme.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/app.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/sidebarmenu.js"></script>
  <!-- 알림 -->
  <script src="${pageContext.request.contextPath }/resources/assets/js/notification-comm.js" data-cpath="${pageContext.request.contextPath}" defer></script>

  <!-- solar icons -->
  <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

  <!-- tabler icon css -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css" />

  <!-- highlight.js (code view) -->
  <script src="${pageContext.request.contextPath }/resources/assets/js/highlights/highlight.min.js"></script>
  <script>
  hljs.initHighlightingOnLoad();


  document.querySelectorAll("pre.code-view > code").forEach((codeBlock) => {
    codeBlock.textContent = codeBlock.innerHTML;
  });
</script>
  <script src="${pageContext.request.contextPath }/resources/assets/libs/owl.carousel/dist/owl.carousel.min.js"></script>

  
