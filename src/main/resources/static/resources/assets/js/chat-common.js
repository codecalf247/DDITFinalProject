/* chat-js.js — 서버 에코만 렌더(중복 없음), MY_EMP_NO 보정, 구독/스크립트 중복 방지 */
if (window.__CHAT_JS_ACTIVE__) { console.warn('chat-js already active'); }
else { window.__CHAT_JS_ACTIVE__ = true; (function(){
  "use strict";

  // HTML 이스케이프 + URL/라벨+URL 링크화
  function escapeHtml(s){
    return String(s || '').replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
  }

  function linkify(text){
    // 1) 전체를 먼저 escape
    let html = escapeHtml(text);

    // 2) [라벨] URL  →  <a href="URL">[라벨]</a>  (URL은 따로 출력 안 함)
    html = html.replace(/\[([^\]]+)\]\s*(https?:\/\/[^\s<>"']+)/g,
      (m, label, url) => `<a href="${url}" target="_blank" rel="noopener noreferrer">[${escapeHtml(label)}]</a>`
    );

    // 3) 남은 맨몸 URL들 → 앵커
    html = html.replace(/(?<!["'>])(https?:\/\/[^\s<>"']+)/g,
      (url) => `<a href="${url}" target="_blank" rel="noopener noreferrer">${url}</a>`
    );

    return html;
  }
  
  // JSON/레거시 텍스트 모두 인식하는 메타 파서
  function parseMeetingMeta(raw){
    try{
      const s = String(raw ?? '').trim();
      if (!s) return null;

      // JSON 형태: {"text": "...", "roomId": "...", "roomUrlId": "...", "createdAt": "..."}
      if (s.startsWith('{') && s.endsWith('}')){
        const j = JSON.parse(s);
        if (j && j.roomId){
          return {
            isMeeting: true,
            text: j.text || '구루미 회의를 시작했어요',
            roomId: j.roomId,
            roomUrlId: j.roomUrlId || null,
            createdAt: j.createdAt || null
          };
        }
      }
      // 레거시 텍스트도 지원
      if (s.startsWith('[화상회의 시작]')){
        return { isMeeting: true, text: '구루미 회의를 시작했어요', roomId: null, roomUrlId: null, createdAt: null };
      }
      return null;
    }catch{ return null; }
  }

  
  
  /* ========== script meta / config ========== */
  function getThisScript(){
    if (document.currentScript) return document.currentScript;
    const scripts = Array.from(document.getElementsByTagName('script'));
    return scripts.reverse().find(s =>
      (s.dataset && (s.dataset.cpath!==undefined || s.dataset.myempno!==undefined)) ||
      (s.src && s.src.indexOf('chat-js.js')>=0)
    );
  }
  const _script = getThisScript() || {};
  const CPATH = (_script.dataset && _script.dataset.cpath) ? _script.dataset.cpath : "";

  // 내 사번: data-myempno > window.MY_EMP_NO > (fallback) STOMP header
  let MY_EMP_NO =
    (_script.dataset && _script.dataset.myempno ? String(_script.dataset.myempno) : null) ||
    (window.MY_EMP_NO ? String(window.MY_EMP_NO) : null);

  /* ========== state ========== */
  let stompClient = null;
  let roomSub = null;
  let currentRoomNo = null;
  let lastRenderedMsgNo = 0;
  let roomsPoller = null;
  let unreadPoller = null;
  const roomTitleCache = Object.create(null);

  // ★ 추가: 총 안읽음 구독 핸들
  let unreadSub = null;

  /* ========== dom helpers / utils ========== */
  const $  = (sel, root=document)=> root.querySelector(sel);
  const $$ = (sel, root=document)=> Array.from(root.querySelectorAll(sel));

  const BG = ['bg-primary','bg-success','bg-info','bg-warning','bg-danger','bg-secondary'];
  function roomTopic(n){ return '/sub/rooms' + n; }
  function initialOf(name){ const t=(name||'').trim(); return t? t[0]:'?'; }
  function colorClassFor(name){ let h=0; const s=String(name||''); for(let i=0;i<s.length;i++) h=(h*31+s.charCodeAt(i))>>>0; return BG[h%BG.length]; }
  function textColorFor(bg){ return bg==='bg-warning' ? 'text-dark':'text-white'; }
  function isAtBottom(){ 
	const el = $('.chat-messages'); 
	if(!el) return false; 
	return (el.scrollHeight - el.clientHeight - el.scrollTop) <= 20;
	}
  function scrollToBottom(){ const box=$('.chat-messages'); if (box) box.scrollTop = box.scrollHeight; }
  function clearMessagesUI(){ const box=$('.chat-messages'); if (box) box.innerHTML=''; }
  function leaveRoom(clear=true){
    if (roomSub){ try{ roomSub.unsubscribe(); }catch(e){} roomSub = null; }
    currentRoomNo = null;
    lastRenderedMsgNo = 0;
    if (clear) clearMessagesUI();
  }
  function formatMsgTime(v){
    try{
      const d = (v instanceof Date) ? v : new Date(v);
      if (isNaN(d.getTime())) return '';
      return d.toLocaleString('ko-KR',{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit'});
    }catch{ return ''; }
  }

  function prettySize(bytes){
    if (!Number.isFinite(bytes)) return '';
    const u = ['B','KB','MB','GB','TB'];
    let i = 0, n = bytes;
    while (n >= 1024 && i < u.length - 1){ n /= 1024; i++; }
    return (i === 0 ? n.toFixed(0) : n.toFixed(1)) + ' ' + u[i];
  }
  
  function getMsgNo(m){
    return Number(m?.chatMsgNo ?? m?.msgNo ?? m?.MSG_NO ?? 0);
  }
  
  function throttle(fn, wait){ 
    let t = 0; 
    return function(...a){ 
      const n = Date.now(); 
      if(n - t >= wait){ t = n; fn.apply(this, a); } 
    };
  }
  
  /* ========== STOMP ========== */
  function connectStomp(){
    const sock = new SockJS(CPATH + '/ws-stomp');
    stompClient = Stomp.over(sock);
    // stompClient.debug = null; // 필요 시 주석 해제
    stompClient.connect({}, (frame) => {
      // header로 내 사번 보정
      const hdrEmp = frame && frame.headers ? (frame.headers['user-name'] || frame.headers['user-name']) : null;
      if (!MY_EMP_NO && hdrEmp) MY_EMP_NO = String(hdrEmp);
      console.log('[CHAT] connected. myEmpNo=', MY_EMP_NO);
	  
	  // ★ 여기서 총 안읽음 푸시 구독 (중복 방지)
	  if (unreadSub){ try{ unreadSub.unsubscribe(); }catch(e){} unreadSub = null; }
	  unreadSub = stompClient.subscribe('/user/queue/unread-total', function(message){
	    try{
	      var p = JSON.parse(message.body || '{}');
	      var n = (typeof p.unreadTotal === 'number') ? p.unreadTotal : 0;
	      updateChatTotalBadge(n);
	    }catch(e){}
	  });
	  // 초기 1회 서버 상태로 맞춰주기 (푸시가 바로 안 오더라도 표시)
	  fetchUnreadTotal();
    }, (e) => console.error('[CHAT] STOMP error', e));
  }

  /* ========== render ========== */
  
  function isFileMsg(m){
		return String(m.msgTy) === '03003'; // ← 파일은 오직 03003만
  }

  function renderFileMsg(m, isMine){
    const box = $('.chat-messages'); if(!box) return;
    const when = formatMsgTime(m.msgWrtDt || new Date());
    const fileUrl   = m.fileUrl   || m.url;
    const fileNm    = m.fileNm    || m.msgCn || '첨부파일';
    const fileSize  = m.fileSize  || m.size || 0;
    const mimeType  = m.mimeType  || m.contentType || '';
    const imageYn   = (m.imageYn || '').toString().toUpperCase() === 'Y' || (mimeType.startsWith('image/'));
    const thumbUrl  = m.thumbUrl  || null;

    let inner;
	 if (imageYn){
	   const src = thumbUrl || fileUrl;
	   inner =
	     `<a href="${fileUrl}" target="_blank" rel="noopener noreferrer" class="file-thumb text-decoration-none">
	        <img src="${src}" alt="${escapeHtml(fileNm)}">
	      </a>
	      <div class="small mt-1">${escapeHtml(fileNm)} · ${prettySize(Number(fileSize)||0)}</div>`;
	 } else {
	   inner =
	     `<a href="${fileUrl}" target="_blank" rel="noopener noreferrer"
	         class="file-link d-inline-flex align-items-center text-decoration-none p-2 rounded-3">
	        <i class="ti ti-paperclip me-2"></i>
	        <span class="text-truncate" style="max-width:180px">${escapeHtml(fileNm)}</span>
	        <span class="text-muted small ms-2">${prettySize(Number(fileSize)||0)}</span>
	      </a>`;
	 }

	 const wrap = document.createElement('div');
	 wrap.className = 'message-group mb-3';
	 if (isMine){
	   wrap.innerHTML =
	     '<div class="d-flex justify-content-end">'+
	       '<div class="msg-stack end text-end">'+
	         '<div class="message-bubble bg-primary text-white p-2 rounded-3 mb-1"></div>'+
	         `<small class="message-time text-muted">${when}</small>`+
	       '</div>'+
	     '</div>';
	 } else {
	   const initial = (m.empNm || '?').slice(-2);
	   wrap.innerHTML =
	     '<div class="d-flex align-items-start">'+
	       '<div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;"></div>'+
	       '<div class="msg-stack start">'+
	         '<div class="fw-semibold small text-muted mb-1"></div>'+
	         '<div class="message-bubble bg-light p-2 rounded-3 mb-1"></div>'+
	         `<small class="message-time text-muted">${when}</small>`+
	       '</div>'+
	     '</div>';
	   wrap.querySelector('.rounded-circle').textContent = initial;
	   wrap.querySelector('.fw-semibold').textContent = m.empNm || '상대';
	 }
    wrap.querySelector('.message-bubble').innerHTML = inner;
    box.appendChild(wrap);
    scrollToBottom();
  }
  
  
  
  
  function renderMine(text, when){
	const meta = parseMeetingMeta(text);
	if (meta && meta.isMeeting){
	  // JSON의 createdAt 우선, 없으면 서버시간 when 사용
	  return renderGooroomeeSystemTile(null, formatMsgTime(meta.createdAt || when));
	}
	const box = $('.chat-messages'); if(!box) return;
	const wrap = document.createElement('div');
	wrap.className='message-group mb-3';
	wrap.innerHTML =
	  '<div class="d-flex justify-content-end">'+
	    '<div class="msg-stack end text-end">'+
	      '<div class="message-bubble bg-primary text-white p-2 rounded-3 mb-1"></div>'+
	      `<small class="message-time text-muted">${when||''}</small>`+
	    '</div>'+
	  '</div>';
	wrap.querySelector('.message-bubble').innerHTML = linkify(text || '');
	box.appendChild(wrap);
	scrollToBottom();
  }

  function renderOther(m){
	const meta = parseMeetingMeta(m.msgCn);
	if (meta && meta.isMeeting){
	  return renderGooroomeeSystemTile(m.empNm || '상대', formatMsgTime(meta.createdAt || m.msgWrtDt));
	}
	const box = $('.chat-messages'); if(!box) return;
	const wrap = document.createElement('div');
	wrap.className='message-group mb-3';
	const initial = (m.empNm || '?').slice(-2);
	wrap.innerHTML =
	  '<div class="d-flex align-items-start">'+
	    '<div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;"></div>'+
	    '<div class="msg-stack start">'+
	      '<div class="fw-semibold small text-muted mb-1"></div>'+
	      '<div class="message-bubble bg-light p-2 rounded-3 mb-1"></div>'+
	      `<small class="message-time text-muted">${formatMsgTime(m.msgWrtDt)}</small>`+
	    '</div>'+
	  '</div>';
	wrap.querySelector('.rounded-circle').textContent = initial;
	wrap.querySelector('.fw-semibold').textContent = m.empNm || '상대';
	wrap.querySelector('.message-bubble').innerHTML = linkify(m.msgCn || '');
	box.appendChild(wrap);
	scrollToBottom();
  }

  /* ========== subscribe / history ========== */
  function subscribeRoom(roomNo){
    if (roomSub){ try{ roomSub.unsubscribe(); }catch(e){} roomSub=null; }

    if (!stompClient || !stompClient.connected){
      let tries=0; const t=setInterval(()=>{
        tries++;
        if (stompClient && stompClient.connected){ clearInterval(t); subscribeRoom(roomNo); }
        else if (tries>20){ clearInterval(t); console.error('[CHAT] STOMP not connected'); }
      },100);
      return;
    }

    clearMessagesUI();
    currentRoomNo = roomNo;

    // 1) 먼저 히스토리 로딩 → maxNo 계산 → lastRenderedMsgNo 설정
    fetch(`${CPATH}/chat/messages/${encodeURIComponent(roomNo)}`)
      .then(r=>r.json())
      .then(list=>{
        // ★ 히스토리 렌더 전에 maxNo 먼저 세팅
        const maxNo = (list||[]).reduce((mx, m)=> Math.max(mx, getMsgNo(m)), 0);
        lastRenderedMsgNo = maxNo;

        // 이제 히스토리 렌더
        (list||[]).slice().reverse().forEach(m=>{
          const isMine = (MY_EMP_NO && m.empNo && String(m.empNo) === String(MY_EMP_NO));
          if (isFileMsg(m)) renderFileMsg(m, isMine);
          else if (isMine)  renderMine(m.msgCn, formatMsgTime(m.msgWrtDt));
          else              renderOther(m);
        });

        scrollToBottom();
        if (isAtBottom() && lastRenderedMsgNo > 0){
          markRead(currentRoomNo, lastRenderedMsgNo);
        }

        // 2) ★ 히스토리 끝난 다음에 구독 시작
        roomSub = stompClient.subscribe(roomTopic(roomNo), (frame) => {
          const p = JSON.parse(frame.body);
          const no = getMsgNo(p);

          // ★ 이미 본 메시지는 무시
          if (no && no <= lastRenderedMsgNo) return;

          const isMine = (MY_EMP_NO && p.empNo && String(p.empNo) === String(MY_EMP_NO));
          if (isFileMsg(p)) renderFileMsg(p, isMine);
          else if (isMine)  renderMine(p.msgCn, formatMsgTime(p.msgWrtDt || new Date()));
          else              renderOther(p);

          if (no) lastRenderedMsgNo = Math.max(lastRenderedMsgNo, no);

          if (isAtBottom() && lastRenderedMsgNo>0) markRead(currentRoomNo, lastRenderedMsgNo);
          else loadChatRooms();
        });
      })
      .catch(err=> console.error('[CHAT] history load error', err));
  }
  /* ========== send ========== */
  
  async function uploadAndSend(files){
    if (!files || !files.length || !currentRoomNo) return;

    const fd = new FormData();
    Array.from(files).forEach(f => fd.append('files', f));

    // 필요 시 CSRF 헤더 추가:
    // const token = document.querySelector('meta[name="_csrf"]')?.content;
    // const header = document.querySelector('meta[name="_csrf_header"]')?.content;

    const res = await fetch(`${CPATH}/chat/upload?roomNo=${encodeURIComponent(currentRoomNo)}`, {
      method: 'POST',
      body: fd,
      // headers: header && token ? { [header]: token } : undefined
    });
    if (!res.ok){ alert('파일 업로드 실패'); return; }

    const list = await res.json(); // [{fileName,size,contentType,url,thumbUrl?,image}]
    // 업로드한 각 파일에 대해 파일 메시지 전송 (서버 에코만 렌더)
    list.forEach(att => {
      stompClient.send('/pub/send/rooms', {}, JSON.stringify({
        chatRoomNo: currentRoomNo,
        msgTy: '03003',               // 파일
        msgCn: att.fileName,          // 표시용 이름
        fileUrl: att.url,
        fileNm: att.fileName,
        fileSize: att.size,
        mimeType: att.contentType,
        imageYn: att.image ? 'Y' : 'N',
        thumbUrl: att.thumbUrl || null,
		fileGroupNo: att.fileGroupNo   // ★★ 반드시 포함
      }));
    });
  }

  function bindFileUI(){
    // 1) 클립 버튼 → 숨은 input 클릭
    const attachBtn = document.querySelector('.chat-input-area button[title="파일첨부"]');
    attachBtn && attachBtn.addEventListener('click', function(e){
      e.preventDefault();
      document.getElementById('chatFileInput')?.click();
    });

    // 2) 파일 선택 시 업로드
    const fileInput = document.getElementById('chatFileInput');
    fileInput && fileInput.addEventListener('change', function(){
      if (this.files && this.files.length){
        uploadAndSend(this.files).catch(console.error);
        this.value = ''; // 같은 파일 재선택 허용
      }
    });
  }
  
  function sendMessage(){
    const input = $('#messageInput');
    const text  = (input?.value || '').trim();
    if (!text || !currentRoomNo || !stompClient || !stompClient.connected) return;

    // 낙관 렌더 제거: 서버 에코만 렌더 → 중복 표시 없음
    stompClient.send('/pub/send/rooms', {}, JSON.stringify({
      chatRoomNo: currentRoomNo,
      msgCn: text,
      msgTy: '03001'
    }));
    input.value = '';
  }

  /* ========== rooms/read/list ========== */
  function markRead(roomNo, lastMsgNo){
    fetch(`${CPATH}/chat/rooms/${roomNo}/read?lastMsgNo=${lastMsgNo}`, { method:'POST' })
      .then(()=> {
		loadChatRooms();
		fetchUnreadTotal();
	  })
      .catch(()=>{});
  }

  function loadChatRooms(){
    fetch(`${CPATH}/chat/roomsList?t=${Date.now()}`, { cache:'no-store' })
      .then(r=>r.json())
      .then(list=>{
        const container = $('.chat-room-list'); if(!container) return;
        container.innerHTML='';
        (list||[]).forEach(room=>{
          let title = roomTitleCache[room.chatRoomNo] || room.displayName || room.chatRoomNm;
		  
		  if (!title && (room.chatRoomTy === 'G' || room.chatRoomTy === 'GROUP')) {
		    // (옵션) 서버가 멤버 이름 배열/인원수를 준다면 보기 좋게 구성
		    const names = Array.isArray(room.memberNames) ? room.memberNames : [];
		    if (names.length > 0) {
		      title = (names.length <= 3) ? names.join(', ') : `${names.slice(0,2).join(', ')} 외 ${names.length-2}명`;
		    } else if (typeof room.memberCnt === 'number' && room.memberCnt > 0) {
		      title = `그룹 채팅 (${room.memberCnt}명)`;
		    }
		  }
		  title = title || String(room.chatRoomNo);		  
		  
          const init  = initialOf(title);
          const bg    = colorClassFor(title);
          const tc    = textColorFor(bg);
          const lastDt= (room.lastMsgDt ? new Date(room.lastMsgDt).toLocaleTimeString('ko-KR',{hour:'numeric',minute:'2-digit'}) : '');

          const item = document.createElement('div');
		  const previewText = (() => {
		    const meta = parseMeetingMeta(room.lastMsg);
		    return meta ? meta.text : (room.lastMsg || '');
		  })();
          item.className='chat-room-item d-flex align-items-center p-3 border-bottom';
          item.dataset.roomId = room.chatRoomNo;
          item.dataset.roomName = title;
          item.dataset.roomType = (room.chatRoomTy === 'P' || room.chatRoomTy === 'PRIVATE') ? 'private' : 'group';
          item.innerHTML = `
            <div class="rounded-circle ${bg} ${tc} d-flex align-items-center justify-content-center me-2"
                 style="width:32px;height:32px;font-size:14px;">${init}</div>
            <div class="flex-grow-1">
              <div class="d-flex justify-content-between align-items-start">
                <h6 class="mb-1 fw-semibold">${title}</h6>
                <small class="text-muted">${lastDt}</small>
              </div>
              <div class="d-flex justify-content-between align-items-center">


			  <p class="mb-0 text-muted small lastline pe-2">${escapeHtml(previewText)}</p>
                ${room.unreadCnt>0 ? `<span class="badge bg-danger rounded-pill">${room.unreadCnt}</span>` : ``}
              </div>
            </div>`;
          container.appendChild(item);
        });
		
		const totalUnread = (list || []).reduce((s, r) => s + (r.unreadCnt || 0), 0);
		updateChatTotalBadge(totalUnread);
      })
      .catch(()=>{});
  }

  /* ========== view switch & bindings ========== */
  function switchToChatConversation(roomId, roomType, roomName){
    $('#chatListView')?.classList.add('d-none');
    $('#chatConversationView')?.classList.remove('d-none');
    $('#chatTitleConv') && ($('#chatTitleConv').textContent = roomName || String(roomId));
    $('#chatAvatarConv') && ($('#chatAvatarConv').textContent = initialOf(roomName || String(roomId)));
    $('#chatStatusConv') && ($('#chatStatusConv').textContent = (roomType==='group'?'그룹 채팅':'온라인'));
    currentRoomNo = roomId;
	document.querySelectorAll('.js-gooroomee-call').forEach(b => b.dataset.chatRoomNo = String(roomId));
    $('#messageInput')?.focus();
  }
  function switchToChatList(){
    $('#chatConversationView')?.classList.add('d-none');
    $('#chatListView')?.classList.remove('d-none');
	document.querySelectorAll('.js-gooroomee-call').forEach(b => b.dataset.chatRoomNo = '');
  }

  function bindUI(){
    const list = $('.chat-room-list');
    if (list && !list.dataset.bound){
      list.addEventListener('click', e=>{
        const item = e.target.closest('.chat-room-item'); if(!item) return;
        $$('.chat-room-item.active').forEach(i=>i.classList.remove('active'));
        item.classList.add('active');
        const roomId   = item.dataset.roomId;
        const roomType = item.dataset.roomType || 'private';
        const roomName = item.dataset.roomName || `Room ${roomId}`;
        switchToChatConversation(roomId, roomType, roomName);
        subscribeRoom(roomId);
      });
      list.dataset.bound='1';
    }

    $('#backToChatList')?.addEventListener('click', ()=>{ 
		switchToChatList(); 
		loadChatRooms();
		leaveRoom(true);   
	 });
    $('#sendMessageBtn')?.addEventListener('click', e=>{ e.preventDefault?.(); sendMessage(); });
    $('#messageInput')?.addEventListener('keydown', e=>{ if(e.key==='Enter'){ e.preventDefault?.(); sendMessage(); } });

    $('#chatSearchInput')?.addEventListener('input', function(){
      const term=(this.value||'').toLowerCase();
      $$('.chat-room-item').forEach(item=>{
        const nm=(item.dataset.roomName||'').toLowerCase();
        item.style.display = nm.includes(term) ? 'flex' : 'none';
      });
    });

    // 새 채팅 모달(있을 때만 동작)
    const newChatModal = $('#newChatModal');
    const chatStartBtn = $('#chatStart');
    if (newChatModal){
      newChatModal.addEventListener('show.bs.modal', ()=>{
        const il = $('#individualList'); const gl = $('#groupList');
        if (il) il.innerHTML=''; if (gl) gl.innerHTML='';
        fetch(`${CPATH}/chat/users?page=0`).then(r=>r.json()).then(res=>{
          res.forEach(u=>{
            if (il){
              const row = document.createElement('div');
              row.className='list-group-item d-flex align-items-center';
              row.innerHTML =
                `<input type="radio" name="individualUser" class="form-check-input me-3" value="${u.empNo}">`+
                `<input type="hidden" name="individualUserName" value="${u.empNm}">`+
                `<div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px;">${(u.empNm||'?').charAt(0)}</div>`+
                `<div><div class="fw-semibold">${u.empNm||''}</div>`+
                `<small class="text-muted">${(u.deptNm||'')} · ${(u.title||'')}</small></div>`;
              il.appendChild(row);
            }
			if (gl){
			  const checkRow = document.createElement('div');
			  checkRow.className = 'list-group-item d-flex align-items-center';
			  checkRow.innerHTML =
			    '<input type="checkbox" class="form-check-input me-3" value="'+u.empNo+'">' +   // ★ empNo 사용
			    '<div class="rounded-circle bg-warning text-white d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px;">'+ (u.empNm||'?').charAt(0) +'</div>' +
			    '<div><div class="fw-semibold">'+ (u.empNm||'') +'</div>' +
			    '<small class="text-muted">'+ ((u.deptNm||"") +' · '+ (u.title||"")) +'</small></div>';
			  gl.appendChild(checkRow);
			}
          });
        });
      });

	  
	  
	    // "채팅 시작" 클릭: 탭에 따라 개인/그룹 분기  ★ 여기!
	    if (chatStartBtn){
	      chatStartBtn.addEventListener('click', async function(){
	        const activeTab = document.querySelector('.nav-pills .nav-link.active')?.getAttribute('data-bs-target');

			// ===== 그룹 채팅 생성 =====
			if (activeTab === '#group-chat') {
			  // 선택된 체크박스들
			  const checkedEls = Array.from(document.querySelectorAll('#groupList input[type="checkbox"]:checked'));
			  const memberEmpNos = checkedEls.map(el => el.value);
			  if (memberEmpNos.length === 0) { alert('그룹에 초대할 직원을 선택하세요.'); return; }

			  // 체크박스 행에서 이름 텍스트 추출
			  const memberNames = checkedEls.map(el => {
			    const row = el.closest('.list-group-item');
			    return (row?.querySelector('.fw-semibold')?.textContent || '').trim();
			  }).filter(Boolean);

			  // 방 이름 입력값이 있으면 우선, 없으면 사람 이름으로 계산
			  const custom = (document.getElementById('groupRoomName')?.value || '').trim();
			  const computedTitle = custom
			    ? custom
			    : (memberNames.length <= 3
			        ? memberNames.join(', ')
			        : `${memberNames.slice(0,2).join(', ')} 외 ${memberNames.length-2}명`);

			  chatStartBtn.disabled = true;

			  try{
			    // ← 백엔드에도 사람이름 제목을 저장하고 싶으면 computedTitle을 보냅니다.
			    const res = await fetch(`${CPATH}/chat/roomCreateG`, {
			      method: 'POST',
			      headers: {'Content-Type':'application/json'},
			      body: JSON.stringify({ roomNm: computedTitle, memberEmpNos })
			    });
			    if (!res.ok) throw new Error('그룹 생성 실패');
			    const data = await res.json(); // { result:roomNo, ... }

			    const modal = bootstrap.Modal.getInstance(newChatModal);
			    if (modal) modal.hide();

			    const roomNo = String(data.result || data.chatRoomNo || '');
			    // ★ 캐시에 사람이름 타이틀 저장
			    roomTitleCache[roomNo] = computedTitle;

			    // ★ 헤더 즉시 반영
			    switchToChatConversation(roomNo, 'group', computedTitle);
			    subscribeRoom(roomNo);
			  } catch(e){
			    alert(e.message);
			  } finally{
			    chatStartBtn.disabled = false;
			  }
			  return;
			}

	        // ===== 개인 채팅 생성 (기존 로직) =====
	        const selected = document.querySelector('#individualList input[type="radio"]:checked');
	        if(!selected){ alert('대화할 상대를 선택해 주세요.'); return; }
	        const targetUserNm = selected.parentElement.querySelector('input[type="hidden"]').value;
	        const targetUserId = selected.value;

	        chatStartBtn.disabled = true;
	        try{
	          const res = await fetch(`${CPATH}/chat/roomCreateP`, {
	            method : 'POST',
	            headers : {'Content-Type': 'application/json'},
	            body : JSON.stringify({ empNo:String(targetUserId), empNm:targetUserNm, chatRoomTy:'P' })
	          });
	          if (!res.ok) throw new Error('개인 채팅방 생성 실패');
	          const data = await res.json();

	          const modal = bootstrap.Modal.getInstance(newChatModal);
	          if (modal) modal.hide();

	          const roomNo = data.result || data.chatRoomNo || data;
	          switchToChatConversation(roomNo, 'private', targetUserNm);
	          subscribeRoom(roomNo);
	        } catch(e){
	          alert(e.message);
	        } finally{
	          chatStartBtn.disabled = false;
	        }
	      });
	    }
	  }

    // Offcanvas 열리면 목록 폴링
    const drawer = $('#chatDrawer');
    if (drawer){
      drawer.addEventListener('shown.bs.offcanvas', ()=>{
        loadChatRooms();
        roomsPoller = setInterval(loadChatRooms, 60000);
		fetchUnreadTotal();
      });
      drawer.addEventListener('hidden.bs.offcanvas', ()=>{
        if (roomsPoller){ clearInterval(roomsPoller); roomsPoller=null; }
        if (roomSub){ try{ roomSub.unsubscribe(); }catch(e){} roomSub=null; }
        currentRoomNo=null; lastRenderedMsgNo=0; // 상태 초기화
		fetchUnreadTotal();
      });
    }

	
	// ✅ [추가] 구루미 화상회의 버튼(footer.jsp)에 대한 전역 클릭 핸들러
/*	if (!document.__gooroomeeBound__) {
	  document.addEventListener('click', async function(e){
	    const btn = e.target.closest('.js-gooroomee-call');
	    if (!btn) return;

	    // 1) 방 번호 결정: 버튼 data > 현재 대화방(currentRoomNo) > 마지막 수단(알림)
	    const roomNo =
	      btn.dataset.chatRoomNo ||
	      currentRoomNo ||
	      (document.querySelector('.chat-room-item.active')?.dataset.roomId) ||
	      null;

	    if (!roomNo) {
	      alert('먼저 채팅방을 선택하거나 들어가 주세요.');
	      return;
	    }

	    // 2) 표시 이름
	    const username = btn.dataset.username || 'Guest';

	    // 3) 서버에 OTP URL 요청 → 새 창 오픈
	    btn.disabled = true;
	    try {
	      const res = await fetch(`${CPATH}/api/gooroomee/start`, {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/json' },
	        body: JSON.stringify({ chatRoomNo: String(roomNo), username: String(username) })
	      });
	      if (!res.ok) throw new Error('회의 생성/연결에 실패했어요.');

	      const data = await res.json(); // { roomId, joinUrl }
	      if (!data.joinUrl) throw new Error('참가 URL이 비어있어요.');

	      window.open(data.joinUrl, '_blank', 'noopener');
	    } catch (err) {
	      alert('[구루미] ' + err.message);
	      console.error(err);
	    } finally {
	      btn.disabled = false;
	    }
	  });
	  document.__gooroomeeBound__ = true; // 중복 바인딩 방지
	}*/
	
	
	
    loadChatRooms(); // 초기 1회
	
	// 페이지 로드 시 1회
	fetchUnreadTotal();
	
	// 오프캔버스 상태와 무관하게 60초마다 총 안읽음 갱신
	if (!unreadPoller) unreadPoller = setInterval(fetchUnreadTotal, 60000);
	
  
	const msgBox = document.querySelector('.chat-messages');
	if (msgBox && !msgBox.dataset.readBound){
	  msgBox.addEventListener('scroll', throttle(function(){
	    if (isAtBottom() && currentRoomNo && lastRenderedMsgNo > 0){
	      markRead(currentRoomNo, lastRenderedMsgNo);
	    }
	  }, 250));
	  msgBox.dataset.readBound = '1';
	}
	
}

  /* ========== start ========== */
  function start(){ connectStomp(); bindUI(); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start);
  else start();

  // 디버그 도우미(선택)
  window.Chat = Object.freeze({ subscribeRoom, switchToChatConversation });
  
  // 총 뱃지 개수
  function updateChatTotalBadge(n){
	const b = document.getElementById('chatTotalBadge');
	if (!b) return;
	if (n > 0){
	  b.textContent = (n > 99 ? '99+' : n);
	  b.classList.remove('d-none');
	} else {
	  b.textContent = '0';        // 0일 땐 감추고 싶으면 이 줄은 남겨두고
	  b.classList.add('d-none');  // 이 줄만 유지
	}
  }
  

  function humanSize(n){
    if (!n && n!==0) return '';
    const u=['B','KB','MB','GB','TB']; let i=0, x=n;
    while (x>=1024 && i<u.length-1){ x/=1024; i++; }
    return (i===0? Math.round(x): x.toFixed(1))+' '+u[i];
  }

  function renderFileMine(m){
    const box = $('.chat-messages'); if(!box) return;
    const wrap = document.createElement('div');
    wrap.className='message-group mb-3';
    const isImg = (m.imageYn==='Y' || (m.mimeType||'').startsWith('image/'));
    wrap.innerHTML =
      '<div class="d-flex justify-content-end"><div class="text-end" style="max-width:260px;">'+
        (isImg
          ? `<a href="${m.fileUrl}" target="_blank" class="d-inline-block mb-1 text-decoration-none file-thumb-link">
               <img src="${m.thumbUrl||m.fileUrl}" alt="${(m.fileNm||'file')}" class="img-fluid rounded-3">
             </a>`
          : `<a href="${m.fileUrl}" target="_blank" class="d-inline-flex align-items-center gap-2 bg-primary text-white p-2 rounded-3 text-decoration-none">
               <i class="ti ti-paperclip"></i><span class="text-truncate" style="max-width:180px;">${m.fileNm||'파일'}</span>
               <small class="opacity-75">${humanSize(m.fileSize)}</small>
             </a>`
        ) +
        `<div class="small text-muted mt-1">${formatMsgTime(m.msgWrtDt||new Date())}</div>`+
      '</div></div>';
    box.appendChild(wrap); scrollToBottom();
  }

  function renderFileOther(m){
    const box = $('.chat-messages'); if(!box) return;
    const wrap = document.createElement('div');
    wrap.className='message-group mb-3';
    const initial = (m.empNm || '?').slice(-2);
    const isImg = (m.imageYn==='Y' || (m.mimeType||'').startsWith('image/'));
    wrap.innerHTML =
      '<div class="d-flex align-items-start">'+
        '<div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;"></div>'+
        '<div style="max-width:260px;">'+
          `<div class="fw-semibold small text-muted mb-1">${m.empNm||'상대'}</div>`+
          (isImg
            ? `<a href="${m.fileUrl}" target="_blank" class="d-inline-block mb-1 text-decoration-none file-thumb-link">
                 <img src="${m.thumbUrl||m.fileUrl}" alt="${(m.fileNm||'file')}" class="img-fluid rounded-3">
               </a>`
            : `<a href="${m.fileUrl}" target="_blank" class="d-inline-flex align-items-center gap-2 bg-light p-2 rounded-3 text-decoration-none">
                 <i class="ti ti-paperclip"></i><span class="text-truncate" style="max-width:180px;">${m.fileNm||'파일'}</span>
                 <small class="text-muted">${humanSize(m.fileSize)}</small>
               </a>`
          ) +
          `<div class="small text-muted mt-1">${formatMsgTime(m.msgWrtDt)}</div>`+
        '</div>'+
      '</div>';
    wrap.querySelector('.rounded-circle').textContent = initial;
    box.appendChild(wrap); scrollToBottom();
  }

  
  
  // 총 안읽음 수 가져오기 (Promise 반환)
  function fetchUnreadTotal(){
    var base = (typeof CPATH !== 'undefined' ? CPATH : '');
    return fetch(base + '/chat/roomsList?t=' + Date.now(), { cache: 'no-store' })
      .then(function(res){ return res.ok ? res.json() : []; })
      .then(function(list){
        var total = (Array.isArray(list) ? list : []).reduce(function(sum, r){
          var n = (r && typeof r.unreadCnt === 'number') ? r.unreadCnt : 0;
          return sum + n;
        }, 0);
        updateChatTotalBadge(total);
        return total;
      })
      .catch(function(){
        updateChatTotalBadge(0);
        return 0;
      });
  }
  
  function isGooroomeeInvite(m){
    return String((m?.msgCn ?? m)?.toString() || '').trim().startsWith('[화상회의 시작]');
  }
  
  function renderGooroomeeSystemTile(senderName, when){
    const box = document.querySelector('.chat-messages'); if(!box) return;
    const wrap = document.createElement('div');
    wrap.className = 'system-tile mb-3';  // ✅ 말풍선 아님

    wrap.innerHTML = `
      <div class="system-card system-card--alert system-card--stripe">
        <div class="d-flex align-items-center gap-2">
          <i class="ti ti-video"></i>
          <div class="flex-grow-1">
            <div class="title">구루미 회의를 시작했어요</div>
            <small class="text-muted">${when || ''}</small>
          </div>
          <button class="btn btn-sm btn-primary js-gooroomee-call" data-chat-room-no="${currentRoomNo}">
            참여
          </button>
        </div>
      </div>
    `;
    box.appendChild(wrap);
    scrollToBottom();
  }
  
  function renderGooroomeeInvite(isMine, when, senderName){
    const box = $('.chat-messages'); if(!box) return;
    const wrap = document.createElement('div');
    wrap.className = 'message-group mb-3';

    const body = `
      <div class="d-flex align-items-center gap-2">
        <i class="ti ti-video"></i>
        <div class="me-auto">구루미 회의가 시작됐어요</div>
        <button class="btn btn-sm btn-primary js-gooroomee-call"
                data-chat-room-no="${currentRoomNo}">
          참여
        </button>
      </div>`;

    if (isMine){
      wrap.innerHTML =
        '<div class="d-flex justify-content-end">'+
          '<div class="msg-stack end text-end">'+
            '<div class="message-bubble bg-primary text-white p-2 rounded-3 mb-1"></div>'+
            `<small class="message-time text-muted">${when||''}</small>`+
          '</div>'+
        '</div>';
    } else {
      const initial = (senderName || '?').slice(-2);
      wrap.innerHTML =
        '<div class="d-flex align-items-start">'+
          '<div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;"></div>'+
          '<div class="msg-stack start">'+
            '<div class="fw-semibold small text-muted mb-1"></div>'+
            '<div class="message-bubble bg-light p-2 rounded-3 mb-1"></div>'+
            `<small class="message-time text-muted">${when||''}</small>`+
          '</div>'+
        '</div>';
      wrap.querySelector('.rounded-circle').textContent = initial;
      wrap.querySelector('.fw-semibold').textContent = senderName || '상대';
    }
    wrap.querySelector('.message-bubble').innerHTML = body;
    box.appendChild(wrap); scrollToBottom();
  }
  
  
   window.openChatRoom = function(roomNo, roomNm){
     // 외부에서 강제로 방 열어야 할 때는 기존 통일된 로직만 호출
     switchToChatConversation(roomNo, 'group', roomNm || ('Room ' + roomNo));
     subscribeRoom(roomNo);
   };

  // (이벤트 방식도 지원)
  window.addEventListener('open-chat-room', function(ev){
    var d = ev.detail || {};
    if (d.roomNo){ window.openChatRoom(String(d.roomNo), String(d.roomNm || '')); }
  });
  bindFileUI();
  
  
  // ===== CPATH 추출(기존에 있으면 생략 가능)
  (function(){
    if (window.CPATH) return;
    const s = document.querySelector('script[src*="chat-common.js"][data-cpath]') || document.currentScript;
    window.CPATH = s?.dataset?.cpath || '';
  })();

  // ===== 구루미 시작/재사용 호출 공통 함수
  async function startGooroomee(roomNo){
    const res = await fetch(`${CPATH}/api/gooroomee/start`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // ❗️username 안 보냄: 서버가 principal 기준으로 이름을 결정
      body: JSON.stringify({ chatRoomNo: String(roomNo) })
    });

    if (!res.ok) {
      let detail = '';
      try { const j = await res.json(); detail = j?.detail || j?.error || ''; } catch {}
      throw new Error('회의 생성/연결에 실패했어요.' + (detail ? `\n↳ ${detail}` : ''));
    }

    const data = await res.json(); // { roomId, joinUrl, shareUrl? }
    if (!data.joinUrl) throw new Error('OTP URL이 비어있어요.');
    window.open(data.joinUrl, '_blank', 'noopener'); // 개인 OTP로 입장
  }

  // ===== 전역 클릭 핸들러(버튼 하나만 사용)
  document.addEventListener('click', async function(e){
    const btn = e.target.closest('.js-gooroomee-call');
    if (!btn) return;

    e.preventDefault();
    const roomNo =
      btn.dataset.chatRoomNo ||
      (typeof currentRoomNo !== 'undefined' ? currentRoomNo : null) ||
      document.querySelector('.chat-room-item.active')?.dataset.roomId;

    if (!roomNo) { alert('먼저 채팅방을 선택하거나 들어가 주세요.'); return; }

    btn.disabled = true;
    try {
      await startGooroomee(roomNo);   // 서버가 “있으면 재사용/없으면 생성” 판단
    } catch(err){
      alert(err.message);
      console.error(err);
    } finally {
      btn.disabled = false;
    }
  });

})(); }
