<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>실시간 채팅 시스템 - 테스트</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Tabler Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons@latest/icons-sprite.svg">
    
    <style>
        /* 아이콘 폰트 대신 이모지 사용 */
        .ti { font-style: normal; }
        .ti-search:before { content: "🔍"; }
        .ti-plus:before { content: "➕"; }
        .ti-menu-2:before { content: "☰"; }
        .ti-users:before { content: "👥"; }
        .ti-mood-smile:before { content: "😊"; }
        .ti-send:before { content: "📤"; }
        .ti-message-circle:before { content: "💬"; }
        
        /* 채팅 전용 스타일 */
        .chat-container { height: 100vh; overflow: hidden; }
        .chat-sidebar { 
            width: 320px; 
            background: #f8f9fa; 
            border-right: 1px solid #dee2e6;
            transition: transform 0.3s ease;
        }
        .chat-main { flex: 1; display: flex; flex-direction: column; }
        .messages-area { 
            flex: 1; 
            overflow-y: auto; 
            padding: 1rem; 
            background: #ffffff;
            max-height: calc(100vh - 140px);
        }
        
        /* 메시지 스타일 */
        .message-item { margin-bottom: 1rem; }
        .message-bubble { 
            max-width: 70%; 
            padding: 0.75rem 1rem; 
            border-radius: 1rem; 
            word-wrap: break-word;
        }
        .message-own { 
            margin-left: auto; 
            background: #0d6efd; 
            color: white; 
            border-bottom-right-radius: 0.3rem;
        }
        .message-other { 
            background: #f8f9fa;
            border-bottom-left-radius: 0.3rem;
        }
        .message-system { 
            text-align: center; 
            font-size: 0.875rem; 
            color: #6c757d;
            background: #e3f2fd;
            padding: 0.5rem 1rem;
            border-radius: 1rem;
            margin: 0 auto;
            display: inline-block;
        }
        
        /* 상태 표시 */
        .user-status-online { color: #198754; }
        .user-status-offline { color: #6c757d; }
        .status-dot { 
            width: 8px; 
            height: 8px; 
            border-radius: 50%; 
            display: inline-block; 
            margin-right: 0.5rem;
        }
        .status-dot.online { background-color: #198754; }
        .status-dot.offline { background-color: #6c757d; }
        
        .unread-badge { 
            background: #dc3545; 
            color: white; 
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.75rem;
            min-width: 18px;
            text-align: center;
        }
        
        .chat-input-area { 
            border-top: 1px solid #dee2e6; 
            padding: 1rem; 
            background: white;
        }
        
        /* 모달 전용 스타일 */
        .nc-user { 
            border: 1px solid var(--bs-border-color); 
            transition: 0.15s ease; 
            cursor: pointer; 
        }
        .nc-user.active { 
            border-color: var(--bs-primary); 
            box-shadow: 0 0 0 0.15rem rgba(13,110,253,0.15); 
        }
        .nc-chip { 
            display: inline-flex; 
            align-items: center; 
            gap: 0.35rem; 
            padding: 0.25rem 0.5rem; 
            border-radius: 999px; 
            background: var(--bs-light); 
            border: 1px solid var(--bs-border-color); 
        }
        .nc-chip .rm { 
            cursor: pointer; 
            color: #dc3545; 
            font-weight: bold;
        }
        
        /* 반응형 */
        @media (max-width: 991px) {
            .chat-sidebar { 
                position: fixed; 
                top: 0; 
                left: -320px; 
                height: 100vh; 
                z-index: 1050; 
                box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            }
            .chat-sidebar.is-open { 
                transform: translateX(320px); 
            }
            .chat-overlay { 
                position: fixed; 
                top: 0; 
                left: 0; 
                width: 100%; 
                height: 100%; 
                background: rgba(0,0,0,0.5); 
                z-index: 1040; 
            }
        }
        
        .room-item, .user-item {
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .room-item:hover, .user-item:hover {
            background-color: #f8f9fa;
        }
        .room-item.active {
            background-color: #e7f3ff;
            border-left: 3px solid #0d6efd;
        }
        
        /* 스크롤바 스타일 */
        .messages-area::-webkit-scrollbar {
            width: 6px;
        }
        .messages-area::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .messages-area::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
        
        /* 애니메이션 */
        .message-item {
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="chat-container d-flex">
        <!-- 채팅 사이드바 -->
        <div id="chatSidebar" class="chat-sidebar d-flex flex-column">
            <!-- 사용자 정보 -->
            <div class="p-3 border-bottom bg-white">
                <div class="d-flex align-items-center">
                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px;height:48px; font-weight: bold;">
                        김
                    </div>
                    <div>
                        <div class="fw-semibold">김테스트</div>
                        <small class="text-success">
                            <span class="status-dot online"></span>온라인
                        </small>
                    </div>
                    <button class="btn btn-sm btn-outline-primary ms-auto" data-bs-toggle="modal" data-bs-target="#newChatModal">
                        <span class="ti ti-plus"></span>
                    </button>
                </div>
            </div>

            <!-- 채팅방 검색 -->
            <div class="p-3 bg-white border-bottom">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0">
                        <span class="ti ti-search"></span>
                    </span>
                    <input type="text" id="chatSearch" class="form-control border-start-0" 
                           placeholder="채팅방 검색..." autocomplete="off">
                </div>
            </div>

            <!-- 채팅방 목록 -->
            <div class="flex-grow-1 overflow-auto" id="chatRoomList">
                <!-- 그룹 채팅방 -->
                <div class="room-item p-3 border-bottom" data-room-id="group1" data-room-type="group" data-room-name="개발팀 채팅">
                    <div class="d-flex align-items-center">
                        <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px; font-weight: bold;">
                            개
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">개발팀 채팅</div>
                            <small class="text-muted">안녕하세요! 새로운 프로젝트 시작해볼까요?</small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">14:30</small>
                            <span class="unread-badge">3</span>
                        </div>
                    </div>
                </div>
                
                <!-- 디자인팀 채팅 -->
                <div class="room-item p-3 border-bottom" data-room-id="group2" data-room-type="group" data-room-name="디자인팀 채팅">
                    <div class="d-flex align-items-center">
                        <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px; font-weight: bold;">
                            디
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">디자인팀 채팅</div>
                            <small class="text-muted">UI 시안 검토 부탁드립니다</small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">12:15</small>
                        </div>
                    </div>
                </div>
                
                <!-- 개인 채팅들 -->
                <div class="room-item p-3 border-bottom" data-room-id="user2" data-room-type="private" data-room-name="이유진">
                    <div class="d-flex align-items-center">
                        <div class="bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px; font-weight: bold;">
                            이
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">
                                이유진
                                <span class="status-dot online"></span>
                            </div>
                            <small class="text-muted">네, 확인했습니다!</small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">11:45</small>
                            <span class="unread-badge">1</span>
                        </div>
                    </div>
                </div>
                
                <div class="room-item p-3 border-bottom" data-room-id="user3" data-room-type="private" data-room-name="박민수">
                    <div class="d-flex align-items-center">
                        <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px; font-weight: bold;">
                            박
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">
                                박민수
                                <span class="status-dot offline"></span>
                            </div>
                            <small class="text-muted">내일 회의 시간 조율해주세요</small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">어제</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 메인 채팅 영역 -->
        <div class="chat-main">
            <!-- 채팅방 헤더 -->
            <div id="chatHeader" class="p-3 border-bottom bg-white d-none">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <button class="btn btn-sm me-3 d-lg-none" id="toggleSidebar">
                            <span class="ti ti-menu-2"></span>
                        </button>
                        <div>
                            <h6 class="mb-0" id="currentRoomName">채팅방 이름</h6>
                            <small class="text-muted" id="currentRoomInfo">정보</small>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-secondary" id="roomMembersBtn">
                            <span class="ti ti-users"></span> <span id="memberCount">0</span>명
                        </button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="alert('이모지 패널 기능')">
                            <span class="ti ti-mood-smile"></span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- 메시지 영역 -->
            <div class="messages-area" id="messagesArea">
                <!-- 초기 상태 -->
                <div class="d-flex align-items-center justify-content-center h-100" id="welcomeScreen">
                    <div class="text-center">
                        <div style="font-size: 4rem;">💬</div>
                        <h5 class="mt-3 text-muted">채팅방을 선택하세요</h5>
                        <p class="text-muted">좌측에서 채팅방을 선택하거나 새로운 채팅을 시작해보세요.</p>
                    </div>
                </div>
                <!-- 메시지 목록 -->
                <div id="messagesList" class="d-none"></div>
            </div>

            <!-- 메시지 입력 영역 -->
            <div id="chatInputArea" class="chat-input-area d-none">
                <form id="messageForm">
                    <div class="input-group">
                        <input type="text" id="chatInput" class="form-control" 
                               placeholder="메시지를 입력하세요..." autocomplete="off">
                        <button type="submit" class="btn btn-primary" id="sendButton" disabled>
                            <span class="ti ti-send"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 모바일용 오버레이 -->
    <div id="chatOverlay" class="chat-overlay d-none"></div>

    <!-- 새 채팅 만들기 모달 -->
    <div class="modal fade" id="newChatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable modal-lg">
            <div class="modal-content rounded-2">
                <div class="modal-header">
                    <h5 class="modal-title">채팅방 만들기</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- 탭: 개인 / 단체 -->
                    <ul class="nav nav-pills mb-3" id="newChatTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="tab-private" data-bs-toggle="pill" 
                                    data-bs-target="#pane-private" type="button" role="tab">
                                개인 채팅
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tab-group" data-bs-toggle="pill" 
                                    data-bs-target="#pane-group" type="button" role="tab">
                                단체 채팅
                            </button>
                        </li>
                    </ul>

                    <!-- 검색 -->
                    <div class="input-group mb-3">
                        <span class="input-group-text bg-transparent border-end-0">
                            <span class="ti ti-search"></span>
                        </span>
                        <input type="text" id="memberSearch" class="form-control border-start-0" 
                               placeholder="이름/부서로 검색..." autocomplete="off">
                    </div>

                    <!-- 탭 내용 -->
                    <div class="tab-content">
                        <!-- 개인 채팅 -->
                        <div class="tab-pane fade show active" id="pane-private" role="tabpanel">
                            <div id="privateUserList" class="row g-3">
                                <!-- 샘플 사용자들 -->
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="101" data-name="김지후" data-role="개발팀 · 팀장">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">김</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">김지후</div>
                                                <small class="text-muted">개발팀 · 팀장</small>
                                            </div>
                                            <input type="radio" name="privateUser" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="102" data-name="이유진" data-role="디자인팀 · 디자이너">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-info text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">이</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">이유진</div>
                                                <small class="text-muted">디자인팀 · 디자이너</small>
                                            </div>
                                            <input type="radio" name="privateUser" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="103" data-name="박민수" data-role="기획팀 · 사원">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">박</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">박민수</div>
                                                <small class="text-muted">기획팀 · 사원</small>
                                            </div>
                                            <input type="radio" name="privateUser" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 단체 채팅 -->
                        <div class="tab-pane fade" id="pane-group" role="tabpanel">
                            <div id="groupUserList" class="row g-3">
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="201" data-name="김형준" data-role="대표">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">김</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">김형준</div>
                                                <small class="text-muted">대표</small>
                                            </div>
                                            <input type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="202" data-name="안철호" data-role="인사팀 · 팀장">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">안</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">안철호</div>
                                                <small class="text-muted">인사팀 · 팀장</small>
                                            </div>
                                            <input type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="203" data-name="정수현" data-role="마케팅팀 · 사원">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">정</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">정수현</div>
                                                <small class="text-muted">마케팅팀 · 사원</small>
                                            </div>
                                            <input type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card nc-user" data-id="204" data-name="최영희" data-role="총무팀 · 대리">
                                        <div class="card-body d-flex align-items-center gap-3">
                                            <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px; font-weight: bold;">최</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold">최영희</div>
                                                <small class="text-muted">총무팀 · 대리</small>
                                            </div>
                                            <input type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 선택 요약 -->
                    <div class="border-top pt-3 mt-3">
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-3" id="selectedChips"></div>
                        <div class="d-flex align-items-center gap-2">
                            <input type="text" id="roomNameInput" class="form-control" 
                                   placeholder="채팅방 이름 (그룹 채팅 권장)">
                            <button id="createChatBtn" class="btn btn-primary" disabled>
                                만들기 <span class="badge text-bg-light ms-1" id="selectedCount">0</span>
                            </button>
                        </div>
                        <small class="text-muted d-block mt-1">
                            개인: 1명 선택 시 활성화 · 단체: 2명 이상 선택 시 활성화
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 연결 상태 토스트 -->
    <div class="toast-container position-fixed bottom-0 start-0 p-3">
        <div id="connectionToast" class="toast" role="alert">
            <div class="toast-body d-flex align-items-center">
                <span id="statusIndicator" class="me-2">🔗</span>
                <span id="statusText">연결 중...</span>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        /**
         * 실시간 채팅 시스템 - 테스트용 클래스
         * 실제 WebSocket 없이 UI 동작 테스트 가능
         */
        class ChatSystemTest {
            constructor() {
                // 가상 사용자 정보
                this.currentUser = {
                    id: 'test-user',
                    name: '김테스트'
                };
                
                // 현재 채팅방
                this.currentRoom = {
                    id: null,
                    type: null,
                    name: null
                };
                
                // 모달 상태
                this.modalState = {
                    mode: 'private',
                    selectedUsers: []
                };
                
                // 가상 메시지 데이터
                this.sampleMessages = {
                    'group1': [
                        { id: 1, senderId: 'user1', senderName: '이유진', content: '안녕하세요! 새 프로젝트 관련해서 논의해볼까요?', timestamp: new Date(Date.now() - 3600000), type: 'CHAT' },
                        { id: 2, senderId: 'user2', senderName: '박민수', content: '좋습니다! 어떤 부분부터 시작할까요?', timestamp: new Date(Date.now() - 3000000), type: 'CHAT' },
                        { id: 3, senderId: 'test-user', senderName: '김테스트', content: 'UI/UX 디자인부터 시작하는게 어떨까요?', timestamp: new Date(Date.now() - 1800000), type: 'CHAT' }
                    ],
                    'group2': [
                        { id: 4, senderId: 'user3', senderName: '정수현', content: '시안 검토 완료했습니다!', timestamp: new Date(Date.now() - 7200000), type: 'CHAT' },
                        { id: 5, senderId: 'user4', senderName: '최영희', content: '컬러 조합이 정말 좋네요', timestamp: new Date(Date.now() - 5400000), type: 'CHAT' }
                    ],
                    'user2': [
                        { id: 6, senderId: 'user2', senderName: '이유진', content: '네, 확인했습니다!', timestamp: new Date(Date.now() - 900000), type: 'CHAT' },
                        { id: 7, senderId: 'test-user', senderName: '김테스트', content: '감사합니다 😊', timestamp: new Date(Date.now() - 600000), type: 'CHAT' }
                    ]
                };
                
                this.init();
            }

            init() {
                console.log('채팅 시스템 테스트 모드 시작');
                this.setupEventListeners();
                this.setupModalListeners();
                this.setupResponsive();
                this.showConnectionStatus('연결됨', 'success');
            }

            setupEventListeners() {
                // 채팅방 선택
                document.querySelectorAll('.room-item').forEach(item => {
                    item.addEventListener('click', () => {
                        const roomId = item.dataset.roomId;
                        const roomType = item.dataset.roomType;
                        const roomName = item.dataset.roomName;
                        this.joinRoom(roomId, roomType, roomName);
                    });
                });

                // 메시지 전송
                document.getElementById('messageForm').addEventListener('submit', (e) => {
                    e.preventDefault();
                    this.sendMessage();
                });

                // 입력창 변화 감지
                document.getElementById('chatInput').addEventListener('input', (e) => {
                    this.toggleSendButton(e.target.value.trim().length > 0);
                });

                // 사이드바 토글 (모바일)
                document.getElementById('toggleSidebar').addEventListener('click', () => {
                    this.toggleSidebar();
                });

                // 오버레이 클릭 시 사이드바 닫기
                document.getElementById('chatOverlay').addEventListener('click', () => {
                    this.closeSidebar();
                });

                // 채팅방 검색
                document.getElementById('chatSearch').addEventListener('input', (e) => {
                    this.filterRooms(e.target.value);
                });
            }

            setupModalListeners() {
                // 탭 전환
                document.getElementById('tab-private').addEventListener('shown.bs.tab', () => {
                    this.modalState.mode = 'private';
                    this.renderSelectedUsers();
                });
                
                document.getElementById('tab-group').addEventListener('shown.bs.tab', () => {
                    this.modalState.mode = 'group';
                    this.renderSelectedUsers();
                });

                // 개인 채팅 사용자 선택
                document.querySelectorAll('#pane-private .nc-user').forEach(card => {
                    card.addEventListener('click', () => {
                        // 기존 선택 해제
                        document.querySelectorAll('#pane-private .nc-user').forEach(c => {
                            c.classList.remove('active');
                            c.querySelector('input[type="radio"]').checked = false;
                        });
                        
                        // 새 선택
                        card.classList.add('active');
                        card.querySelector('input[type="radio"]').checked = true;
                        
                        this.modalState.selectedUsers = [{
                            id: card.dataset.id,
                            name: card.dataset.name,
                            role: card.dataset.role
                        }];
                        
                        this.renderSelectedUsers();
                    });
                });

                // 그룹 채팅 사용자 선택
                document.querySelectorAll('#pane-group .nc-user').forEach(card => {
                    card.addEventListener('click', (e) => {
                        const checkbox = card.querySelector('input[type="checkbox"]');
                        checkbox.checked = !checkbox.checked;
                        card.classList.toggle('active', checkbox.checked);
                        
                        this.updateGroupSelection();
                        e.preventDefault();
                    });
                });

                // 채팅방 생성
                document.getElementById('createChatBtn').addEventListener('click', () => {
                    this.createNewChat();
                });

                // 모달 초기화
                document.getElementById('newChatModal').addEventListener('show.bs.modal', () => {
                    this.resetModal();
                });

                // 사용자 검색
                document.getElementById('memberSearch').addEventListener('input', (e) => {
                    this.filterModalUsers(e.target.value);
                });
            }

            setupResponsive() {
                const handleResize = () => {
                    if (window.innerWidth >= 992) {
                        this.closeSidebar();
                    }
                };
                
                window.addEventListener('resize', handleResize);
            }

            joinRoom(roomId, roomType, roomName) {
                console.log(`채팅방 입장: \${roomName} (\${roomType})`);
                
                // 이전 선택 해제
                document.querySelectorAll('.room-item').forEach(item => {
                    item.classList.remove('active');
                });
                
                // 새 선택 활성화
                document.querySelector(`[data-room-id="\${roomId}"]`).classList.add('active');
                
                // 현재 채팅방 설정
                this.currentRoom = { id: roomId, type: roomType, name: roomName };
                
                // UI 업데이트
                this.showChatInterface();
                this.updateChatHeader(roomName, roomType);
                this.loadMessages(roomId);
                this.clearUnreadBadge(roomId);
                
                // 모바일에서는 사이드바 닫기
                if (window.innerWidth < 992) {
                    this.closeSidebar();
                }
            }

            sendMessage() {
                const input = document.getElementById('chatInput');
                const content = input.value.trim();
                
                if (!content || !this.currentRoom.id) return;

                // 가상 메시지 생성
                const message = {
                    id: Date.now(),
                    senderId: this.currentUser.id,
                    senderName: this.currentUser.name,
                    content: content,
                    timestamp: new Date(),
                    type: 'CHAT'
                };

                // 메시지 표시
                this.displayMessage(message, true);
                
                // 입력창 초기화
                input.value = '';
                this.toggleSendButton(false);
                
                // 가상 응답 시뮬레이션 (2초 후)
                setTimeout(() => {
                    this.simulateResponse();
                }, 2000);
            }

            simulateResponse() {
                const responses = [
                    '네, 알겠습니다!',
                    '좋은 아이디어네요 👍',
                    '확인했습니다.',
                    '진행해보겠습니다.',
                    '감사합니다!',
                    '내일까지 완료하겠습니다.',
                    '회의실에서 논의해볼까요?',
                    '첨부파일 확인 부탁드려요.',
                ];
                
                const senderNames = ['이유진', '박민수', '정수현', '최영희'];
                const randomResponse = responses[Math.floor(Math.random() * responses.length)];
                const randomSender = senderNames[Math.floor(Math.random() * senderNames.length)];
                
                const responseMessage = {
                    id: Date.now(),
                    senderId: 'virtual-user',
                    senderName: randomSender,
                    content: randomResponse,
                    timestamp: new Date(),
                    type: 'CHAT'
                };
                
                this.displayMessage(responseMessage, false);
            }

            displayMessage(message, isOwnMessage = false) {
                const messagesList = document.getElementById('messagesList');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message-item';
                
                const timeString = message.timestamp.toLocaleTimeString('ko-KR', { 
                    hour: '2-digit', 
                    minute: '2-digit' 
                });

                if (message.type === 'JOIN' || message.type === 'LEAVE') {
                    messageDiv.innerHTML = `
                        <div class="message-system">
                            \${message.content || (message.senderName + (message.type === 'JOIN' ? '님이 입장했습니다.' : '님이 나갔습니다.'))}
                        </div>
                    `;
                } else {
                    const isOwn = isOwnMessage || message.senderId === this.currentUser.id;
                    messageDiv.innerHTML = `
                        <div class="d-flex \${isOwn ? 'justify-content-end' : ''}">
                            <div class="message-bubble \${isOwn ? 'message-own' : 'message-other'}">
                                \${!isOwn ? `<div class="fw-semibold mb-1" style="font-size: 0.875rem;">\${this.escapeHtml(message.senderName)}</div>` : ''}
                                <div>\${this.escapeHtml(message.content)}</div>
                                <div class="mt-1" style="font-size: 0.75rem; opacity: 0.8;">\${timeString}</div>
                            </div>
                        </div>
                    `;
                }

                messagesList.appendChild(messageDiv);
                this.scrollToBottom();
            }

            loadMessages(roomId) {
                const messagesList = document.getElementById('messagesList');
                messagesList.innerHTML = '';
                
                const messages = this.sampleMessages[roomId] || [];
                messages.forEach(message => {
                    this.displayMessage(message, message.senderId === this.currentUser.id);
                });
                
                if (messages.length === 0) {
                    messagesList.innerHTML = `
                        <div class="text-center text-muted py-4">
                            <div style="font-size: 2rem; margin-bottom: 1rem;">💬</div>
                            <p>새로운 대화를 시작해보세요!</p>
                        </div>
                    `;
                }
            }

            updateGroupSelection() {
                this.modalState.selectedUsers = [];
                document.querySelectorAll('#pane-group .nc-user input[type="checkbox"]:checked').forEach(checkbox => {
                    const card = checkbox.closest('.nc-user');
                    this.modalState.selectedUsers.push({
                        id: card.dataset.id,
                        name: card.dataset.name,
                        role: card.dataset.role
                    });
                });
                
                this.renderSelectedUsers();
            }

            renderSelectedUsers() {
                const chipsContainer = document.getElementById('selectedChips');
                const countElement = document.getElementById('selectedCount');
                const createButton = document.getElementById('createChatBtn');
                
                chipsContainer.innerHTML = '';
                
                this.modalState.selectedUsers.forEach(user => {
                    const chip = document.createElement('span');
                    chip.className = 'nc-chip';
                    chip.innerHTML = `
                        \${user.name} 
                        <span class="rm" data-user-id="\${user.id}">&times;</span>
                    `;
                    
                    // 칩 제거 이벤트
                    chip.querySelector('.rm').addEventListener('click', () => {
                        this.removeUserSelection(user.id);
                    });
                    
                    chipsContainer.appendChild(chip);
                });
                
                countElement.textContent = this.modalState.selectedUsers.length;
                
                // 버튼 활성화 조건
                if (this.modalState.mode === 'private') {
                    createButton.disabled = this.modalState.selectedUsers.length !== 1;
                } else {
                    createButton.disabled = this.modalState.selectedUsers.length < 2;
                }
            }

            removeUserSelection(userId) {
                this.modalState.selectedUsers = this.modalState.selectedUsers.filter(user => user.id !== userId);
                
                // UI에서도 선택 해제
                if (this.modalState.mode === 'private') {
                    document.querySelector(`#pane-private .nc-user[data-id="\${userId}"]`).classList.remove('active');
                    document.querySelector(`#pane-private .nc-user[data-id="\${userId}"] input`).checked = false;
                } else {
                    document.querySelector(`#pane-group .nc-user[data-id="\${userId}"]`).classList.remove('active');
                    document.querySelector(`#pane-group .nc-user[data-id="\${userId}"] input`).checked = false;
                }
                
                this.renderSelectedUsers();
            }

            createNewChat() {
                const roomName = document.getElementById('roomNameInput').value.trim();
                const chatType = this.modalState.mode;
                const selectedUsers = this.modalState.selectedUsers;
                
                if (selectedUsers.length === 0) return;
                
                // 가상 채팅방 생성
                const newRoomId = 'new-' + Date.now();
                const newRoomName = roomName || (chatType === 'private' ? selectedUsers[0].name : '새 그룹 채팅');
                
                console.log('새 채팅방 생성:', {
                    id: newRoomId,
                    type: chatType,
                    name: newRoomName,
                    members: selectedUsers
                });
                
                // 채팅방 목록에 추가
                this.addNewRoomToList(newRoomId, chatType, newRoomName);
                
                // 모달 닫기
                bootstrap.Modal.getInstance(document.getElementById('newChatModal')).hide();
                
                // 새 채팅방으로 이동
                this.joinRoom(newRoomId, chatType, newRoomName);
                
                // 성공 메시지
                this.showConnectionStatus(`\${newRoomName} 채팅방이 생성되었습니다.`, 'success');
            }

            addNewRoomToList(roomId, roomType, roomName) {
                const chatRoomList = document.getElementById('chatRoomList');
                const roomItem = document.createElement('div');
                roomItem.className = 'room-item p-3 border-bottom';
                roomItem.dataset.roomId = roomId;
                roomItem.dataset.roomType = roomType;
                roomItem.dataset.roomName = roomName;
                
                const avatarColors = ['bg-primary', 'bg-success', 'bg-info', 'bg-warning', 'bg-danger'];
                const randomColor = avatarColors[Math.floor(Math.random() * avatarColors.length)];
                
                roomItem.innerHTML = `
                    <div class="d-flex align-items-center">
                        <div class="\${randomColor} text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px; font-weight: bold;">
                            \${roomName.charAt(0)}
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">\${roomName}</div>
                            <small class="text-muted">새로운 채팅방입니다</small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">방금</small>
                        </div>
                    </div>
                `;
                
                // 클릭 이벤트 추가
                roomItem.addEventListener('click', () => {
                    this.joinRoom(roomId, roomType, roomName);
                });
                
                // 목록 맨 위에 추가
                chatRoomList.insertBefore(roomItem, chatRoomList.firstChild);
            }

            resetModal() {
                this.modalState = {
                    mode: 'private',
                    selectedUsers: []
                };
                
                // 탭 초기화
                document.getElementById('tab-private').click();
                
                // 입력 필드 초기화
                document.getElementById('roomNameInput').value = '';
                document.getElementById('memberSearch').value = '';
                
                // 선택 상태 초기화
                document.querySelectorAll('#newChatModal .nc-user').forEach(card => {
                    card.classList.remove('active');
                });
                document.querySelectorAll('#newChatModal input[type="radio"]').forEach(input => {
                    input.checked = false;
                });
                document.querySelectorAll('#newChatModal input[type="checkbox"]').forEach(input => {
                    input.checked = false;
                });
                
                this.renderSelectedUsers();
            }

            filterModalUsers(query) {
                const searchTerm = query.toLowerCase();
                document.querySelectorAll('#newChatModal .nc-user').forEach(card => {
                    const name = card.dataset.name.toLowerCase();
                    const role = (card.dataset.role || '').toLowerCase();
                    const matches = name.includes(searchTerm) || role.includes(searchTerm);
                    card.parentElement.style.display = matches ? '' : 'none';
                });
            }

            filterRooms(query) {
                const searchTerm = query.toLowerCase();
                document.querySelectorAll('.room-item').forEach(item => {
                    const roomName = item.dataset.roomName.toLowerCase();
                    const matches = roomName.includes(searchTerm);
                    item.style.display = matches ? '' : 'none';
                });
            }

            // UI 유틸리티 메서드들
            showChatInterface() {
                document.getElementById('welcomeScreen').classList.add('d-none');
                document.getElementById('messagesList').classList.remove('d-none');
                document.getElementById('chatHeader').classList.remove('d-none');
                document.getElementById('chatInputArea').classList.remove('d-none');
            }

            updateChatHeader(roomName, roomType) {
                document.getElementById('currentRoomName').textContent = roomName;
                document.getElementById('currentRoomInfo').textContent = 
                    roomType === 'group' ? '그룹 채팅' : '개인 채팅';
                
                // 멤버 수 업데이트 (가상)
                const memberCount = roomType === 'group' ? Math.floor(Math.random() * 8) + 3 : 2;
                document.getElementById('memberCount').textContent = memberCount;
            }

            toggleSendButton(enabled) {
                document.getElementById('sendButton').disabled = !enabled;
            }

            toggleSidebar() {
                const sidebar = document.getElementById('chatSidebar');
                const overlay = document.getElementById('chatOverlay');
                
                if (sidebar.classList.contains('is-open')) {
                    this.closeSidebar();
                } else {
                    sidebar.classList.add('is-open');
                    overlay.classList.remove('d-none');
                }
            }

            closeSidebar() {
                document.getElementById('chatSidebar').classList.remove('is-open');
                document.getElementById('chatOverlay').classList.add('d-none');
            }

            clearUnreadBadge(roomId) {
                const badge = document.querySelector(`[data-room-id="\${roomId}"] .unread-badge`);
                if (badge) {
                    badge.style.display = 'none';
                }
            }

            scrollToBottom() {
                const messagesArea = document.getElementById('messagesArea');
                messagesArea.scrollTop = messagesArea.scrollHeight;
            }

            escapeHtml(text) {
                const div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            showConnectionStatus(message, type = 'info') {
                const toast = document.getElementById('connectionToast');
                const statusText = document.getElementById('statusText');
                const statusIndicator = document.getElementById('statusIndicator');
                
                statusText.textContent = message;
                statusIndicator.textContent = type === 'success' ? '✅' : 
                                            type === 'error' ? '❌' : '🔗';
                
                const bsToast = new bootstrap.Toast(toast);
                bsToast.show();
            }
        }

        // 채팅 시스템 초기화
        document.addEventListener('DOMContentLoaded', () => {
            window.chatSystem = new ChatSystemTest();
            
            // 데모용 환영 메시지
            setTimeout(() => {
                window.chatSystem.showConnectionStatus('채팅 시스템 테스트 모드가 시작되었습니다!', 'success');
            }, 1000);
        });
    </script>
</body>
</html>