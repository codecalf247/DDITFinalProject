(function(){                                               // [1] 전역 오염 방지용 IIFE(즉시실행함수) 스코프 시작
  // === 0) 환경 ===
  var cpath = (document.currentScript &&                 // [2] 현재 <script> 태그를 기준으로
               document.currentScript.dataset.cpath)     //     data-cpath="/앱컨텍스트" 속성값을 읽고
            || '';                                       //     없으면 빈 문자열로(상대경로 대응)

  var API   = cpath + '/api/ntcn';
  var READ_METHOD = 'POST';
  // ✅ 초기 SSE가 과거 알림(백로그)을 밀어줄 때, 배지 이중집계를 막기 위한 플래그/타이머
  var baselineMode = true;        // 초기 하이드레이션 모드: 이때는 inc() 금지
  var hydrateTimer = null;        // NOTI가 잠잠해지면 모드 종료시키는 디바운스 타이머


  // === 1) 엘리먼트 ===
  var notiDot   = document.getElementById('notiDot');     // [10] 종 아이콘 옆 파란 점
  var headerCnt = document.getElementById('notiHeaderCount'); // [11] "N new" 배지
  var listRoot  = document.getElementById('notiItems');   // [12] 드롭다운 내부 리스트 컨테이너
  if (!listRoot) return;                                  // [13] 안전장치: 없으면 스크립트 종료

  function getListEl(){                                   // [14] SimpleBar 사용 시 내부 .simplebar-content로 접근
    return listRoot.querySelector('.simplebar-content') || listRoot;
  }

  // === 2) 카운트 유틸 ===
  function parseCountText(text){                          // [15] "3 new"처럼 섞인 텍스트에서 숫자만 추출
    return parseInt((text || '0').replace(/\D/g,''), 10) || 0;
  }
  function getCount(){ return parseCountText(headerCnt?.textContent); }   // [16] 현재 배지 숫자 반환
  function setCount(n){                                   // [17] 배지를 "N new"로 세팅하고 점 보이기/숨기기
    if (headerCnt) headerCnt.textContent = String(n) + ' new';
    if (notiDot)   notiDot.style.display = n > 0 ? 'block' : 'none';
  }
  function inc(){ setCount(getCount() + 1); }             // [18] 카운트 +1
  function dec(){ setCount(Math.max(0, getCount() - 1)); }// [19] 카운트 -1(0 아래로는 안내려가게)

  // === 3) 안전 유틸 ===
  function esc(s){                                        // [20] XSS 방지용 HTML 이스케이프
    return (s ?? '').toString().replace(/[&<>"']/g, function(m){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]);
    });
  }
  function toLocalText(dt){                               // [21] 안전한 날짜 문자열 변환
    try{
      if(!dt) return '';
      var d = (typeof dt==='number') ? new Date(dt) : new Date(String(dt));
      return isNaN(d) ? '' : d.toLocaleString();
    }catch(_){ return ''; }
  }

  // === 4) 중복 방지용 ID Set (초기 DOM 항목도 등록) ===
  var seen = new Set();                                   // [22] 이미 출력한 알림ID 저장(SSE 중복푸시 대비 핵심)
  getListEl().querySelectorAll('.noti-item[data-id]').forEach(function(el){ // [23] 서버 사이드 렌더된 기존 항목도 중복표시 방지
	seen.add(String(el.dataset.id));
	if (!('read' in el.dataset)){
	  el.dataset.read = el.classList.contains('is-unread') ? 'N' : 'Y';
	}
  });

  // === 5) 아이템 그리기 (중복·카운트 관리 포함) ===
  function addItem(n){                                    // [24] SSE/초기 로딩으로 받은 알림 1건을 DOM에 그리는 함수
    var id = n.ntcnNo ?? n.id ?? n.notiId;                // [25] 백엔드 필드명이 다를 수 있어 3가지 키 중 하나를 사용
    if (id == null) return;                               // [26] 식별자 없으면 무시
    id = String(id);

    if (seen.has(id)) return;                             // [27] 이미 본 알림이면(중복푸시) 무시
    seen.add(id);                                         // [28] 처음보는 알림이면 집합에 추가

    var a = document.createElement('a');                  // [29] <a>로 한 항목 생성(부트스트랩 드롭다운 스타일)
    a.href = n.ntcnPath || 'javascript:void(0)';          // [30] 클릭 시 이동할 목적지(없으면 이동 안 함)
    a.className = 'dropdown-item d-block py-3 px-7 noti-item'; // [31] 디자인 클래스 + 식별용 .noti-item
    a.dataset.id = id;                                    // [32] 클릭 핸들러에서 읽음 처리에 사용할 PK 저장
    a.style.whiteSpace = 'normal';                        // [33] 긴 내용 줄바꿈 허용

    var title  = n.ntcnTyNm                               // [34] 제목은 타입명 우선
              || ({'12001':'프로젝트 생성','12002':'채팅방 생성', // [35] 타입코드→라벨 매핑 보조
                   '12003':'공지사항','12004':'댓글','12005':'메일',
                   '12006':'결재','12007':'설문','12008':'일감'}[n.ntcnTy])
              || '알림';                                  // [36] 그래도 없으면 기본 '알림'
    var sentAt = toLocalText(n.ntcnTrnsmitDt);            // [37] 전송시각 포맷

    var unread = (n.readYn || 'N') === 'N';               // [38] 미읽음 여부
    if (unread) a.classList.add('is-unread');             // [39] 미읽음 시 강조 클래스 추가(스타일은 CSS에서)
	a.dataset.read = unread ? 'N' : 'Y';

    a.innerHTML =
      '<div class="fw-semibold mb-1">'+esc(title)+'</div>' +           // [40] 제목
      '<div class="text-muted small mb-1">'+esc(sentAt)+'</div>' +     // [41] 시간
      '<div class="text-body-secondary">'+esc(n.ntcnCn || '')+'</div>'; // [42] 내용

    //getListEl().prepend(a);                                // [43] 최신 항목이 위로 오도록 prepend
	insertOrdered(a);        // [43]
	console.log("unread",unread);
    if (unread && !baselineMode) inc();                               // [44] **미읽음인 새 항목일 때만** 카운트 증가(중복증가 방지 핵심)
  }

  // === 6) 초기 미읽음 카운트 동기화 (서버 값을 신뢰) ===
  fetch(API + '/unread-count')          // [45] 서버의 진짜 미읽음 개수로 배지 초기화
    .then(function(res){ return res.ok ? res.json() : {count:0}; })  // [46] 200이면 JSON, 아니면 0으로
    .then(function(data){ setCount(typeof data.count==='number' ? data.count : 0); }) // [47] setCount 호출
    .catch(function(){ /* 무시 */ });                      // [48] 실패해도 UI만 초기값 0 유지

	
	
  // === 7) 클릭 → 읽음처리 → 이동 (then 체인) ===
  function requestRead(id){                                 // [49] 읽음 REST 호출 유틸
    return fetch(API + '/' + encodeURIComponent(id) + '/read', {
      method : READ_METHOD                                 // [50] PATCH/POST 전환 1곳만 바꾸면 끝
    });
  }

  getListEl().addEventListener('click', function(e){        // [52] 드롭다운 영역 전체에 이벤트 위임
    var item = e.target.closest('a.noti-item');             // [53] 알림 항목 클릭만 처리
    if (!item) return;

    var id   = item.dataset.id;                             // [54] 읽음 API에 보낼 PK
    var href = item.getAttribute('href');                   // [55] 이동 목적지

    e.preventDefault();                                     // [56] 기본 이동을 막고(드롭다운 닫힘 방지), 우리가 제어

    var wasUnread = item.classList.contains('is-unread');   // [57] 기존에 미읽음이었는지 체크
    if (wasUnread){                                         // [58] 낙관적 UI: 먼저 읽음 표시로 바꾼 후
      item.classList.remove('is-unread');
      dec();                                                // [59] 배지 1 감소
	  item.dataset.read = 'Y';     // ← 클릭으로 읽으면 상태도 Y로
    }

    if (!id){                                               // [60] 혹시 id가 없으면 API 생략하고 바로 이동
      if (href && href!=='javascript:void(0)') location.href = href;
      return;
    }

    requestRead(id)                                         // [61] 서버에 읽음 요청
      .then(function(res){
        if (!res.ok){                                       // [62] 실패하면(403/404 등)
          if (wasUnread){ item.classList.add('is-unread'); inc(); } // [63] UI 원복 + 카운트 되돌림
          console.error('read API 실패:', res.status);
        }
      })
      .catch(function(err){                                  // [64] 네트워크 오류 등
        if (wasUnread){ item.classList.add('is-unread'); inc(); } // [65] UI/카운트 원복
        console.error('read API 오류:', err);
      })
      .finally(function(){                                   // [66] 성공/실패와 무관하게 최종적으로 이동
        if (href && href!=='javascript:void(0)') location.href = href;
      });
  }, false);

  // === 4-2) "전체 읽음" 버튼 이벤트 바인딩 ===
  document.getElementById('btnNotiReadAll')?.addEventListener('click', function(){
    var btn = this;
    btn.disabled = true;

    // 4-1의 markAllRead() 유틸을 이미 추가했다면 그걸 호출하고,
    // 없다면 아래 fetch(...) 분기만 사용해도 됩니다.
    var p = (typeof markAllRead === 'function')
      ? markAllRead()
      : fetch(API + '/readAll', { method: 'POST' }).then(function(res){
          return res.ok ? res.json() : Promise.reject(res);
        });

    p.then(function(data){
        // 1) 리스트의 미읽음 표시 제거
		Array.from(getListEl().querySelectorAll('.noti-item')).forEach(function(el){
		  let isUnread = el.classList.contains('is-unread') || el.dataset.read === 'N';
		  if (isUnread){
		    el.classList.remove('is-unread');
		    el.dataset.read = 'Y';
		    el.classList.add('is-hidden');  // ← CSS로 확실히 숨김
		  }
		});
        // 2) 배지 동기화 (서버 응답 우선)
        var n = (typeof data.unread === 'number') ? data.unread : 0;
        setCount(n);
        if (window.showToast) showToast('알림이 모두 읽음 처리되었습니다.');
      })
      .catch(function(err){
        console.error('readAll 실패', err);
        alert('전체 읽음 처리에 실패했습니다.');
      })
      .finally(function(){
        btn.disabled = false;
      });
  }, false);

  
  function markAllRead(){                                  // ✅ 전체 읽음 호출 유틸
    return fetch(API + '/readAll', { method: 'POST' })
           .then(function(res){ return res.ok ? res.json() : Promise.reject(res); });
  }
  
  function insertOrdered(a){
    var root = getListEl();
    var keyA = a.dataset.ts ? Number(a.dataset.ts) : Number(a.dataset.id); // 전송시각(ms) 또는 PK
    var items = root.querySelectorAll('.noti-item');
    var inserted = false;
    for (var i=0; i<items.length; i++){
      var it = items[i];
      var keyB = it.dataset.ts ? Number(it.dataset.ts) : Number(it.dataset.id);
      if (keyA >= keyB){            // 내림차순(큰 값이 위)
        root.insertBefore(a, it);
        inserted = true;
        break;
      }
    }
    if (!inserted) root.appendChild(a);
  }
  
  
  // === 8) SSE: NOTI만 처리(중복·카운트는 addItem에서 관리) ===
  var es = new EventSource(cpath + '/sse/notifications', { withCredentials: true }); // [67] SSE 연결(쿠키 유지)
  es.addEventListener('NOTI', function(e){                  // [68] 새 알림 이벤트
    try{ addItem(JSON.parse(e.data));                      // [69] 파싱 후 addItem -> seen으로 중복 제거 + 카운트 관리
	    // ✅ NOTI가 들어올 때마다 "조금 더 기다렸다가" 모드 종료
	    //    (백로그가 연속으로 들어오는 동안은 종료하지 않음)
	    clearTimeout(hydrateTimer);
	    hydrateTimer = setTimeout(function(){
	      baselineMode = false; // 이제부터 도착하는 건 신규 → inc() 허용
	      // (선택) 정확도 위해 한 번 더 서버 값으로 동기화
	      fetch(API + '/unread-count', { headers: CSRF })
	        .then(function(res){ return res.ok ? res.json() : {count:null}; })
	        .then(function(data){
	          if (typeof data.count === 'number') setCount(data.count);
	        })
	        .catch(function(){});
	    }, 500); // 백로그가 멈춘 뒤 0.5초 후 모드 종료
	  }catch(err){ console.error('SSE 파싱 실패', err); }
	 });   // [70] 안전하게 실패 로그
  es.addEventListener('KEEPALIVE', function(){});           // [71] 서버 ping 유지 시그널(화면 동작은 없음)
  es.onerror = function(){ /* 자동 재연결 */ };             // [72] 끊어져도 브라우저가 자동 재시도
})();                                                       // [73] IIFE 끝
