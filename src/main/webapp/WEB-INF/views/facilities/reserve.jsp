<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
<%@ include file="/module/header.jsp" %>

<style>
  /* ===== 캘린더 컴팩트 ===== */
  .fc-compact .fc-toolbar-title{font-size:1rem}
  .fc-compact .fc-header-toolbar{margin-bottom:.5rem}
  .fc .fc-daygrid-day-number{font-size:.85rem}
  .fc .fc-daygrid-event{font-size:.75rem;padding:0 .25rem}

  /* 내부 스크롤 제거 + 높이 */
  #calendar{min-height:560px}
  @media (max-width:1199.98px){ #calendar{min-height:480px} }
  #calendar .fc-scroller,#calendar .fc-scroller-harness{max-height:none!important;overflow:visible!important}

  /* ===== Modernize 탭형 토글 - 양쪽 모서리 둥글게 ===== */
  .fc .fc-button-group{
    border-radius:.6rem;
    overflow:hidden;
    box-shadow:0 0 0 1px var(--bs-border-color) inset;
  }
  .fc .fc-button-group .fc-button{
    border:none;
    border-radius:0;
    padding:.45rem 1rem;
    background:var(--bs-body-bg);
    color:var(--bs-body-color);
  }
  .fc .fc-button-group .fc-button.fc-button-active{
    background:#1f2937;
    color:#fff;
  }

  /* ===== 요구사항: Add Event(툴바) / Day 보기 제거 ===== */
  .fc-addEvent-button,
  .fc-addEventButton-button,
  .fc-add-event-button { display:none!important; }
  .fc-timeGridDay-button,
  .fc-dayGridDay-button,
  .fc-listDay-button{display:none!important}

  /* ===== 회의실정보 카드 ===== */
  .room-hero{width:100%;aspect-ratio:16/9;object-fit:cover;border:none;border-radius:.5rem}
  .room-section-title{font-weight:700}
  .room-details .room-section-title{font-size:1.15rem}
  .room-details .text-muted{font-size:1.15rem}
  .room-details .equip-line{display:inline-flex;flex-wrap:wrap;gap:16px;color:var(--bs-secondary-color);font-size:1.05rem}
  .room-details .equip-item{display:inline-flex;align-items:center;gap:6px}
  .room-details .equip-item i{font-size:1.1rem;line-height:1;opacity:.95}
  .room-details .fw-bold.text-danger{font-size:1.05rem}
  .room-details ol{font-size:1rem}

  /* 이벤트 색 */
  .fc .fc-daygrid-event.bg-success-subtle{background:rgba(16,185,129,.14)!important;border-color:transparent}
  .fc .fc-daygrid-event.bg-primary-subtle{background:rgba(59,130,246,.14)!important;border-color:transparent}
  .fc .fc-daygrid-event.bg-warning-subtle{background:rgba(245,158,11,.18)!important;border-color:transparent}
  .fc .fc-daygrid-event.bg-danger-subtle{background:rgba(239,68,68,.14)!important;border-color:transparent}
  .fc .fc-daygrid-event.text-success{color:#10b981!important}
  .fc .fc-daygrid-event.text-primary{color:#3b82f6!important}
  .fc .fc-daygrid-event.text-warning{color:#f59e0b!important}
  .fc .fc-daygrid-event.text-danger{color:#ef4444!important}

  /* ✅ 배너 잘림 방지 (배너 카드에만 적용) */
  .page-banner{overflow:visible!important;}
</style>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid">
  
  		<div class="body-wrapper">
				<div class="container">

    <!-- 배너 (overflow-hidden 제거, page-banner 클래스 추가) -->
    <div class="card bg-info-subtle shadow-none position-relative mb-3 page-banner">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-2">회의실 예약</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Facilities</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- 본문 -->
    <div class="row g-3 mt-3 align-items-stretch">
      <!-- 캘린더 -->
      <div class="col-12 col-lg-8">
        <div class="card shadow-sm h-100">
          <div class="card-header py-2 d-flex align-items-center justify-content-between">
            <h6 class="mb-0">회의실 캘린더</h6>
          </div>
          <div class="card-body py-2 app-calendar">
            <div id="calendar" class="fc-compact"></div>
          </div>
        </div>
      </div>

      <!-- 회의실정보 -->
      <div class="col-12 col-lg-4">
        <div class="card shadow-sm h-100">
          <div class="card-header py-2 d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2">
              <i class="ti ti-camera"></i><span class="fw-semibold">회의실정보</span>
            </div>
          </div>
          <div class="card-body room-details">
            <%
              String room = request.getParameter("room");
              String img  = request.getParameter("img");
              String ctx  = request.getContextPath();
              if (img == null || img.trim().isEmpty()) {
                if ("2".equals(room)) {
                  img = ctx + "/resources/assets/images/meeting/room2.jpg";
                } else if ("1".equals(room)) {
                  img = ctx + "/resources/assets/images/meetingroom/회의실1.jpg";
                } else {
                  img = ctx + "/resources/assets/images/meeting/room_default.jpg";
                }
              }
            %>
            <img src="<%= img %>" alt="회의실 이미지" class="room-hero mb-3">

            <h6 class="room-section-title mb-2">회의실 정보</h6>
            <div class="text-muted mb-2">인원 : 최대 8명</div>
            <div class="text-muted mb-3">
              비품 :
              <span class="equip-line ms-2">
                <span class="equip-item"><i class="ti ti-armchair-2"></i>의자</span>
                <span class="equip-item"><i class="ti ti-table"></i>책상</span>
                <span class="equip-item"><i class="ti ti-device-projector"></i>프로젝터</span>
                <span class="equip-item"><i class="ti ti-presentation"></i>화이트보드</span>
                <span class="equip-item"><i class="ti ti-device-tv"></i>스크린</span>
                <span class="equip-item"><i class="ti ti-fire-extinguisher"></i>소화기</span>
              </span>
            </div>

            <div class="d-flex align-items-center gap-2 mb-2">
              <i class="ti ti-circle-check text-success"></i>
              <span class="fw-bold text-danger">회의실 이용 시 주의사항</span>
            </div>
            <ol class="text-danger ps-3 mb-0">
              <li>회의시간을 준수해주세요!</li>
              <li>사용한 비품은 제자리에 갖다주세요!</li>
              <li>음식물은 반입을 금지합니다!</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== 예약 모달 ===== -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="eventModalLabel">예약하기</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>

          <div class="modal-body">
            <!-- 예약자명 -->
            <div class="mb-2">
              <label class="form-label" for="event-title">예약자명</label>
              <input id="event-title" type="text" class="form-control" />
              <div class="form-text">예약자와 예약시간을 작성해주세요.</div>
            </div>

            <!-- 사용목적 -->
            <div class="mb-3">
              <label class="form-label d-block">사용목적</label>
              <div class="d-flex flex-wrap gap-4">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="purpose" id="purposeClient" value="CLIENT" checked>
                  <label class="form-check-label" for="purposeClient">고객미팅</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="purpose" id="purposeExec" value="EXEC">
                  <label class="form-check-label" for="purposeExec">임원미팅</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="purpose" id="purposeDept" value="DEPT">
                  <label class="form-check-label" for="purposeDept">부서미팅</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="purpose" id="purposeOther" value="OTHER">
                  <label class="form-check-label" for="purposeOther">기타미팅</label>
                </div>
              </div>
            </div>

            <!-- calendar-init.js가 읽는 색상 레벨 -->
            <input type="hidden" id="event-level" name="event-level" value="Success">

            <!-- 기간(날짜만) -->
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label" for="event-start-date">예약 시작일</label>
                <input id="event-start-date" type="date" class="form-control" />
              </div>
              <div class="col-md-6">
                <label class="form-label" for="event-end-date">예약 종료일</label>
                <input id="event-end-date" type="date" class="form-control" />
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn bg-danger-subtle text-danger" data-bs-dismiss="modal">닫기</button>
            <button type="button" class="btn btn-success btn-update-event" data-fc-event-public-id="">변경 저장</button>
            <button type="button" class="btn btn-primary btn-add-event">예약하기</button>
          </div>
        </div>
      </div>
    </div>
    <!-- /예약 모달 -->
	
		</div>
	</div>
  </div>
</div>

<!-- FullCalendar -->
<script src="${pageContext.request.contextPath}/resources/assets/libs/fullcalendar/index.global.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/apps/meet.js"></script>

<script>
  // 목적 → 색상 레벨 매핑
  (function(){
    const levelInput = document.getElementById('event-level');
    const radios = document.querySelectorAll('input[name="purpose"]');
    const map = { CLIENT:'Success', EXEC:'Primary', DEPT:'Warning', OTHER:'Danger' };
    function apply(){ const r = Array.from(radios).find(x=>x.checked); if(r) levelInput.value = map[r.value] || 'Primary'; }
    radios.forEach(r=>r.addEventListener('change', apply)); apply();
  })();

  // 툴바에 동적으로 생기는 Add Event 버튼만 제거 (모달은 그대로)
  (function(){
    const removeToolbarAdds = () => {
      document.querySelectorAll('.fc-toolbar button, .card-header button').forEach(btn=>{
        const txt = (btn.textContent||'').trim().toLowerCase();
        if (/add\s*event|이벤트\s*추가/.test(txt)) btn.remove();
      });
    };
    removeToolbarAdds();
    const obs = new MutationObserver(removeToolbarAdds);
    obs.observe(document.body, {childList:true, subtree:true});
  })();
</script>

<%@ include file="/module/footerPart.jsp" %>
</body>
</html>
