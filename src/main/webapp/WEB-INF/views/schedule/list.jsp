<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <!-- Required meta tags -->
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
	<!-- FullCalendar CSS (headPart.jsp에 이미 포함되어 있으면 중복하지 마세요) -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/fullcalendar/main.min.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/schedule.css" />
</head>
  <%@ include file="/module/header.jsp" %>
<style>
/* 테두리 없애는 건 유지해도 됨 */
.fc .fc-daygrid-event,
.fc .fc-timegrid-event { border: 0 !important; }
</style>
<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 
<div class="body-wrapper">
  <div class="container-fluid">
<!-- 기존 위치에 바로 대체하세요 -->
<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
  <!-- padding을 데스크탑에서는 약간, 모바일에서는 더 작게 적용 -->
  <div class="card-body px-3 py-md-2 py-1 d-flex align-items-center">
    <div class="flex-grow-1">
      <!-- 제목 크기 축소: fs-5 또는 fs-6 사용 -->
      <h4 class="fw-semibold mb-0 fs-5">캘린더</h4>

      <!-- breadcrumb 간격 축소 -->
      <nav aria-label="breadcrumb" class="mt-0">
        <ol class="breadcrumb mb-0 small">
          <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="/">홈</a></li>
          <li class="breadcrumb-item active" aria-current="page">캘린더</li>
        </ol>
      </nav>
    </div>

    <!-- 오른쪽 데코 이미지: 크기와 여백 축소 (필요시 숨김) -->
    <div class="text-end d-none d-md-block ms-3">
      <img src="${pageContext.request.contextPath}/resources/assets/images/breadcrumb/ChatBc.png"
           alt="decor"
           class="img-fluid"
           style="max-width:70px;">
    </div>
  </div>
</div>

    <!-- 필터(왼쪽) + 캘린더(오른쪽) 영역 -->
    <div class="card">
      <div class="card-body p-3">
        <div class="row g-3">
          <!-- 왼쪽 필터 박스: 매우 좁게 (col-lg-2 -> 필요하면 col-lg-1) -->
          <div class="col-lg-2 col-md-3">
            <aside class="calendar-filter-box" aria-label="일정 필터" style="padding:12px;">
              <header class="calendar-filter-title mb-3" style="font-weight:600;">일정 유형</header>

              <ul class="list-unstyled mb-0" style="line-height:2;">
                <li><span class="filter-dot filter-dot-primary" aria-hidden="true"></span>개인 일정</li>
                <li><span class="filter-dot filter-dot-success" aria-hidden="true"></span>팀 일정</li>
                <li><span class="filter-dot filter-dot-warning" aria-hidden="true"></span>전사 일정</li>
              </ul>

              <p class="small text-muted mt-3 mb-0">· 점 색상은 일정 색상과 동일합니다.</p>
            </aside>
          </div>

          <!-- 오른쪽 캘린더: 좌측 좁힌만큼 넓게 차지 -->
          <div class="col-lg-10 col-md-9">
            <div id="calendar" class="app-calendar" role="region" aria-label="캘린더"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 일정 모달 (기존 JS가 참조하는 id/클래스 유지) -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="eventModalLabel">일정 추가 / 수정</h5>
            <input type="hidden" id="schdulNo">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-12">
                <label class="form-label">일정명</label>
                <input id="event-title" type="text" class="form-control" />
              </div>

              <div class="col-12">
                <label class="form-label" for="event-cn">내용</label>
                <textarea id="event-cn" class="form-control" rows="3" placeholder="내용을 입력하세요"></textarea>
              </div>
                <div class="col-12">
                  <label class="form-label">일정 종류</label>
                  <div class="d-flex gap-2 flex-wrap">
                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="event-ty" value="11001" id="tyPers" />
                      <label class="form-check-label" for="tyPers">개인 일정</label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="event-ty" value="11002" id="tyDept" />
                      <label class="form-check-label" for="tyDept">부서 일정</label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="event-ty" value="11003" id="tyCorp" />
                      <label class="form-check-label" for="tyCorp">전사 일정</label>
                    </div>
                  </div>
                </div>

              <div class="col-md-6">
                <label class="form-label">시작일</label>
                <input id="event-start-date" type="date" class="form-control" />
              </div>
              <div class="col-md-6">
                <label class="form-label">종료일</label>
                <input id="event-end-date" type="date" class="form-control" />
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-primary btn-add-event">추가</button>
            <button type="button" class="btn btn-primary btn-update-event">수정</button>
            <button type="button" class="btn btn-danger"  id="btnDelete">삭제</button>
            <button type="button" class="btn bg-danger-subtle text-danger" data-bs-dismiss="modal">닫기</button>
          </div>
        </div>
      </div>
    </div>

  </div> <!-- /.container -->
</div> <!-- /.body-wrapper -->

        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    


<!-- 스크립트: FullCalendar core + 사용하시는 init JS (JS는 따로 주신 파일 사용) -->
<!-- FullCalendar는 먼저 로드 -->
<script src="${pageContext.request.contextPath}/resources/assets/libs/fullcalendar/index.global.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
  // ===== 경로 =====
  const CPATH        = '${pageContext.request.contextPath}';
  const API_LIST     = CPATH + '/schedule/getData';
  const API_REGISTER = CPATH + '/schedule/register';
  const API_UPDATE   = CPATH + '/schedule/update';

  // ===== 모달/폼 요소 =====
  const elModal = document.getElementById('eventModal');

  // 숨은 id 없으면 생성
  let elId = document.getElementById('event-id');
  if (!elId) {
    elId = document.createElement('input');
    elId.type = 'hidden'; elId.id = 'event-id';
    elModal.querySelector('.modal-body').prepend(elId);
  }

  const elTitle = document.getElementById('event-title');
  const elCn    = document.getElementById('event-cn'); // ✅ textarea
  const elStart = document.getElementById('event-start') || document.getElementById('event-start-date');
  const elEnd   = document.getElementById('event-end')   || document.getElementById('event-end-date');

  // 코드값 라디오
  const radiosTy = Array.from(document.querySelectorAll('input[name="event-ty"]'));

  // 버튼
  const btnAdd    = document.querySelector('.btn-add-event');
  const btnUpdate = document.querySelector('.btn-update-event');
  const btnDelete = document.querySelector("#btnDelete");
  // ===== 유틸 =====
  const toBool  = v => v===true || v==='true' || v===1 || v==='1';
  const toIso   = s => s ? String(s).trim().replace(' ','T') : null;
  const toYmd   = s => s ? String(s).trim().split(' ')[0] : null;
  const addDays = (ymd, n) => { const d=new Date(ymd+'T00:00:00'); d.setDate(d.getDate()+n); return d.toISOString().slice(0,10); };

  // === (1) 색상 매핑 교체 ===
  const TYPE_COLOR = {
  '11001': { bg: '#eef3ff', text: '#5d87ff' }, // 개인
  '11002': { bg: '#e6fffa', text: '#13deb9' }, // 부서(팀)
  '11003': { bg: '#fff7e5', text: '#ffb51f' }, // 전사
    // '11004': 프로젝트 → 색상 없음 (기본 테마 사용)
  };


  // 현재 선택된 유형 코드
  function getSelectedTypeCode() {
    const r = radiosTy.find(x => x.checked);
    return r ? r.value : '11001';
  }

  // 코드로 라디오 체크
  function checkRadioTy(tyCode) {
    radiosTy.forEach(r => r.checked = (String(r.value) === String(tyCode)));
  }

  // 모달 모드 + 버튼 토글
  function setMode(mode){ // 'add' | 'edit'
    elModal.dataset.mode = mode;
    if (btnAdd)    btnAdd.style.display    = (mode === 'add')  ? '' : 'none';
    if (btnUpdate) btnUpdate.style.display = (mode === 'edit') ? '' : 'none';
    if (btnDelete) btnDelete.style.display = (mode === 'edit') ? '' : 'none'; // ← 이 한 줄!
  }

  // 모달 열고 닫기
  let modalInstance = null;
  function openModal(){ modalInstance = bootstrap.Modal.getOrCreateInstance(elModal); modalInstance.show(); }
  function closeModal(){ if (modalInstance) modalInstance.hide(); }

  // 폼 초기화
  function resetForm(){
    elId.value = '';
    elTitle && (elTitle.value = '');
    elCn && (elCn.value = '');                // ✅ 내용 비우기
    elStart && (elStart.value = '');
    elEnd   && (elEnd.value   = '');
    checkRadioTy('11001'); // 기본: 개인
  }

  // POST JSON
  function postJSON(url, body){
    return fetch(url, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(body) })
      .then(res => { if(!res.ok) throw new Error('HTTP '+res.status); return res.json(); });
  }

  // 폼 → 서버 바디 (코드값 그대로)
  function payloadFromForm(){
    const ty     = getSelectedTypeCode(); // 코드값
    const allDay = true;                  // 시간 입력 없으니 종일 처리
    const sYmd   = elStart ? elStart.value : '';
    const eYmd   = (elEnd && elEnd.value) ? elEnd.value : sYmd;

    const dbFmt = (ymd) => ymd ? (ymd + ' 00:00:00') : null;
    const colors = TYPE_COLOR[ty] || { bg:null, text:null };

    return {
      schdulNo: elId.value ? Number(elId.value) : null,
      schdulTitle: elTitle ? elTitle.value : '',
      schdulCn: elCn ? elCn.value : '',     // ✅ 내용 포함
      schdulTy: ty,
      alldayAt: allDay,
      startDt: dbFmt(sYmd),
      endDt:   dbFmt(eYmd),
      backgroundColor: colors.bg,
      textColor: colors.text
    };
  }

  // 서버 → FullCalendar 이벤트
  function toFCEvent(s){
    const allDay = toBool(s.alldayAt);
    const start  = allDay ? toYmd(s.startDt) : toIso(s.startDt);
    let   end    = allDay ? (s.endDt ? toYmd(s.endDt) : null) : toIso(s.endDt);
    if (allDay && start && (!end || end===start)) end = addDays(start, 1);
    return {
      id: String(s.schdulNo),
      title: s.schdulTitle,
      start, end, allDay,
      backgroundColor: s.backgroundColor || undefined,
      textColor: s.textColor || undefined,
      extendedProps: {
        schdulCn: s.schdulCn,         // ✅ 모달에서 다시 채움
        schdulTy: s.schdulTy,         // 코드값 유지
        backgroundColor: s.backgroundColor,
        textColor: s.textColor
      }
    };
  }

// ====== 삭제 버튼: fetch(DELETE) - Promise 체인만 사용 ======
btnDelete.onclick = function(){
  let schdulId = elId.value;
  alert(schdulId);
  if (!schdulId) return;
  if (!confirm('정말 삭제할까요?')) return;

  fetch((window.CPATH || '') + '/schedule/delete/' + schdulId, { method: 'POST', headers:{ "Content-Type": "application/json" } })
    .then(function(res){
        return res.text();
      //setTimeout(function(){ location.reload(); }, 100); // 모달 애니 끝나고 리로드
    }).then((data) => {
      console.log(data);
      btnDelete.disabled = false;
    })
}; 
  
  // ===== 캘린더 로딩 & 렌더 =====
  fetch(API_LIST, { cache:'no-store' })
    .then(res => { if(!res.ok) throw new Error('HTTP '+res.status); return res.json(); })
    .then(json => {
      const list = Array.isArray(json) ? json : (json.list || json.data || []);
      const events = list.map(toFCEvent);

      const cal = new FullCalendar.Calendar(document.getElementById('calendar'), {
   	    initialView: "dayGridMonth",
   	    contentHeight: 630, // 내용에 맞게 조정
   	    // 사용자가 날짜 선택 시 실행할 함수
   	    // select: calendarSelect,
   	    dayMaxEventRows: 3, // 한 칸에 표시되는 최대 이벤트 줄 수    	  
        displayEventTime: false,
        eventDisplay: 'block',
        eventBorderColor: 'transparent',
        selectable: true,           // ✅ 드래그 선택 켜기
        selectMirror: true,         // 선택 미리보기
        unselectAuto: false,        // 모달 열어도 선택 유지(선택사항)

        eventDidMount(info){
          info.el.style.borderColor = 'transparent';
          if (info.event.backgroundColor)
            info.el.style.setProperty('background-color', info.event.backgroundColor, 'important');
          if (info.event.textColor)
            info.el.style.setProperty('color', info.event.textColor, 'important');
        },
        events,

        // ✅ 하루 클릭 → 단일일정 등록
        dateClick(info){
          resetForm();
          setMode('add');
          elStart && (elStart.value = info.dateStr);
          elEnd   && (elEnd.value   = info.dateStr);
          openModal();
        },

        // ✅ 드래그 선택 → 범위일정 등록 (end는 배타 → -1일)
        select(info){
          resetForm();
          setMode('add');
          elStart && (elStart.value = info.startStr);
          if (elEnd) {
            const endInc = addDays(info.endStr, -1);
            elEnd.value = endInc;
          }
          openModal();
        },

        // 기존 일정 클릭 → 수정
        eventClick(info){
          resetForm();
          setMode('edit');

          const ev  = info.event;
          const ext = ev.extendedProps || {};

          elId.value         = ev.id;
          elTitle.value      = ev.title || '';
          elCn && (elCn.value = ext.schdulCn || ''); // ✅ 내용 복원

          if (ev.allDay){
            const s = ev.startStr.slice(0,10);
            let   e = ev.end ? ev.end.toISOString().slice(0,10) : s;
            if (e) e = addDays(e, -1);
            elStart && (elStart.value = s);
            elEnd   && (elEnd.value   = e || s);
          } else {
            elStart && (elStart.value = ev.startStr.slice(0,10));
            elEnd   && (elEnd.value   = ev.end ? ev.end.toISOString().slice(0,10) : elStart.value);
          }

          if (ext.schdulTy) checkRadioTy(ext.schdulTy);
          openModal();
        }
      });

      cal.render();

      // ===== 버튼: 추가 =====
      btnAdd && btnAdd.addEventListener('click', function(){
        const mode = elModal.dataset.mode || (elId.value ? 'edit' : 'add');
        if (mode !== 'add') return;
        const p = payloadFromForm();
        if (!p.schdulTitle){ alert('일정명을 입력하세요.'); return; }
        if (!p.startDt){     alert('시작일을 선택하세요.'); return; }

        postJSON(API_REGISTER, p)
          .then(res => {
            p.schdulNo = res.schdulNo || p.schdulNo || Date.now();
            cal.addEvent(toFCEvent(p));
            closeModal();
          })
          .catch(err => { console.error('register 실패', err); alert('등록 실패'); });
      });

      // ===== 버튼: 수정 =====
      btnUpdate && btnUpdate.addEventListener('click', function(){
        const mode = elModal.dataset.mode || (elId.value ? 'edit' : 'add');
        if (mode !== 'edit') return;
        const p = payloadFromForm();
        if (!p.schdulNo){    alert('수정할 일정을 먼저 선택하세요.'); return; }
        if (!p.schdulTitle){ alert('일정명을 입력하세요.'); return; }

        postJSON(API_UPDATE, p)
          .then(() => {
            const ev = cal.getEventById(String(p.schdulNo));
            if (ev){
              const s = toYmd(p.startDt);
              const e = toYmd(p.endDt) || s;
              ev.setAllDay(true);
              ev.setDates(s, addDays(e, 1)); // end는 배타
              ev.setProp('title', p.schdulTitle);
              ev.setProp('backgroundColor', p.backgroundColor || null);
              ev.setProp('textColor',       p.textColor || null);
              ev.setExtendedProp('schdulCn', p.schdulCn); // ✅ 내용 반영
              ev.setExtendedProp('schdulTy', p.schdulTy);
            }
            closeModal();
          })
          .catch(err => { console.error('update 실패', err); alert('수정 실패'); });
      });

    })
    .catch(err => console.error('[schedule] 초기화 실패:', err));
});
</script>



<script src="${pageContext.request.contextPath}/resources/assets/libs/fullcalendar/index.global.min.js"></script>
<%@ include file="/module/footerPart.jsp" %>
</body>

