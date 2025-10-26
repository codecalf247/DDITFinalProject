<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
  <%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/magnific-popup.css"/>

  <style>
  /* ====== 캘린더 컴팩트 타이포 ====== */
  .fc-compact .fc-toolbar-title { font-size: 1rem; }
  .fc-compact .fc-header-toolbar { margin-bottom: .5rem; }
  .fc .fc-daygrid-day-number { font-size: .85rem; }
  .fc .fc-daygrid-event { font-size: .75rem; padding: 0 .25rem; }

  /* ====== 내부 스크롤 제거 + 사이즈 ====== */
  #calendar .fc-daygrid-day-frame { min-height: 160px; } /* 140~180px로 취향 조절 */

  /* ★ FullCalendar 내부 스크롤 통째로 비활성화 */
  #calendar .fc-scroller,
  #calendar .fc-scroller-harness,
  #calendar .fc-view-harness,
  #calendar .fc-scrollgrid,
  #calendar .fc-timegrid-body,
  #calendar .fc-timegrid-slots {
    max-height: none !important;
    overflow: visible !important;
  }

  /* 색상 팔레트 스와치 */
  .color-swatch {
    width: 28px; height: 28px;
    border-radius: 9999px; display: inline-block;
    border: 2px solid #fff; box-shadow: 0 0 0 1px rgba(0,0,0,.15);
    cursor: pointer;
  }
  .color-swatch[data-hex] { background-color: var(--swatch, #ddd); }
  .btn-check:checked + .color-swatch {
    box-shadow: 0 0 0 2px var(--bs-primary), 0 0 0 1px rgba(0,0,0,.15);
  }
  .btn-check:focus + .color-swatch {
    outline: 2px solid var(--bs-primary);
    outline-offset: 2px;
  }
</style>


</head>

<%@ include file="/module/header.jsp" %>

<body>

<div class="body-wrapper">
  <div class="container-fluid">

    <div class="body-wrapper">
      <div class="container">
      
      
 <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
  <div class="card-body px-4 py-3">
    <div class="row align-items-center">
      <div class="col-9">
        <h4 class="fw-semibold mb-8">프로젝트</h4>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a class="text-muted text-decoration-none" href="/project/dashboard">Home</a>
            </li>
            <li class="breadcrumb-item" aria-current="page">Project</li>
          </ol>
        </nav>
      </div>

      

    </div>
  </div>
</div>
        <%@ include file="/WEB-INF/views/project/carousels.jsp" %>
      </div>
    </div>

    <div class="row g-3 mt-3 align-items-stretch">

      <div class="col-12 col-lg-8">
        <div class="card shadow-sm h-100">
          <div class="card-header py-2 d-flex align-items-center justify-content-between">
            <h6 class="mb-0">프로젝트 캘린더</h6>
          </div>
          <div class="card-body py-2 app-calendar">
            <div id="calendar" class="fc-compact"></div>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-4">
    <div class="card shadow-sm h-100">
        <div class="card-header py-2 d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2">
                <i class="ti ti-camera"></i><span class="fw-semibold">현장사진</span>
            </div>
            <div class="btn-group">
                <a class="btn btn-sm btn-outline-primary" href="<c:url value='/project/photos/insert'/>?prjctNo=${project.prjctNo}">업로드</a>
                <a class="btn btn-sm btn-outline-secondary" href="<c:url value='/project/photos/list'/>?prjctNo=${project.prjctNo}">더보기</a>
            </div>
        </div>

        <div class="card-body">
            <div class="row g-2 el-element-overlay">
                <c:choose>
                    <%-- 1) 실제 데이터가 있을 때 --%>
                    <c:when test="${not empty photoList}">
                        <c:forEach var="p" items="${photoList}" end="7">
                            <div class="col-6">
                                <div class="card overflow-hidden shadow-none border-0">
                                    <div class="el-card-item pb-2">
                                        <div class="el-card-avatar el-overlay-1 w-100 overflow-hidden position-relative text-center mb-2">
                                            <a class="image-popup-vertical-fit" href="${p.thumbnailPath}" title="${fn:escapeXml(p.sptPhotoTitle)}">
                                                <img src="${p.thumbnailPath}" alt="${fn:escapeXml(p.sptPhotoTitle)}" class="d-block w-100" style="aspect-ratio:1/1; object-fit:cover;" />
                                            </a>
                                            <div class="el-overlay w-100 overflow-hidden">
                                                <ul class="list-style-none el-info text-white text-uppercase d-inline-block p-0">
                                                    <li class="el-item d-inline-block my-0 mx-1">
                                                        <a class="btn default btn-outline image-popup-vertical-fit el-link text-white border-white"
                                                           href="${p.thumbnailPath}" title="${fn:escapeXml(p.sptPhotoTitle)}">
                                                            <i class="ti ti-search"></i>
                                                        </a>
                                                    </li>
                                                    <li class="el-item d-inline-block my-0 mx-1">
                                                        <a class="btn default btn-outline el-link text-white border-white"
                                                           href="<c:url value='/project/photos/detail/${p.sptPhotoNo}'><c:param name='prjctNo' value='${p.prjctNo}' /></c:url>" title="자세히 보기">
                                                            <i class="ti ti-link"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="el-card-content text-center">
                                            <h6 class="mb-0 card-title text-truncate" title="${fn:escapeXml(p.sptPhotoTitle)}">${p.sptPhotoTitle}</h6>
                                            <p class="card-subtitle small text-muted mb-0">${p.sptPhotoYmd}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <%-- 2) 데이터가 없을 때: 메시지 표시 --%>
                    <c:otherwise>
                        <div class="col-12">
                            <div class="alert alert-info mb-0 text-center">등록된 사진이 없습니다.</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div></div></div>
</div>
      </div><div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="eventModalLabel">일정 등록</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>

          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">제목</label>
              <input id="event-title" type="text" class="form-control" />
            </div>

            <div class="mb-3">
              <label class="form-label d-block">프로젝트 색상 (메인대시보드용)</label>
              <div id="event-color-palette" class="d-flex flex-wrap gap-2">
                <input class="btn-check" type="radio" name="event-color" id="col-red" value="red" autocomplete="off" checked>
               		 <label class="color-swatch" for="col-red" data-hex="#F8D7DA" title="Red"></label>
                
                <input class="btn-check" type="radio" name="event-color" id="col-orange" value="orange" autocomplete="off">
                		<label class="color-swatch" for="col-orange" data-hex="#FFE5D0" title="Orange"></label>
                <input class="btn-check" type="radio" name="event-color" id="col-yellow" value="yellow" autocomplete="off">
               		 <label class="color-swatch" for="col-yellow" data-hex="#FFF3CD" title="Yellow"></label>
               
                <input class="btn-check" type="radio" name="event-color" id="col-green" value="green" autocomplete="off">
               		 <label class="color-swatch" for="col-green" data-hex="#D1E7DD" title="Green"></label>
               
                <input class="btn-check" type="radio" name="event-color" id="col-blue" value="blue" autocomplete="off">
               		 <label class="color-swatch" for="col-blue" data-hex="#CFE2FF" title="Blue"></label>
               
                <input class="btn-check" type="radio" name="event-color" id="col-indigo" value="indigo" autocomplete="off">
               		 <label class="color-swatch" for="col-indigo" data-hex="#E0E7FF" title="Indigo"></label>
              
                <input class="btn-check" type="radio" name="event-color" id="col-violet" value="violet" autocomplete="off">
               		 <label class="color-swatch" for="col-violet" data-hex="#F3E8FF" title="Violet"></label>
              </div>

              <input type="hidden" id="event-color-key" value="red">
              <input type="hidden" id="event-color-hex" value="#F8D7DA">
            </div>

            <div class="mb-3 mt-2">
              <label class="form-label">공정 선택 (프로젝트 대시보드용)</label>
              <div class="d-flex flex-wrap gap-2" id="category-group">
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25001" autocomplete="off">
                            <label class="form-check-label">철거</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25002" autocomplete="off">
                            <label class="form-check-label">설비</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25003" autocomplete="off">
                            <label class="form-check-label">전기</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25004" autocomplete="off">
                            <label class="form-check-label">목공</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25005" autocomplete="off">
                            <label class="form-check-label">타일</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25006" autocomplete="off">
                            <label class="form-check-label">도배</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25007" autocomplete="off">
                            <label class="form-check-label">필름</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25008" autocomplete="off">
                            <label class="form-check-label">도장</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25009" autocomplete="off">
                            <label class="form-check-label">가구</label>
                        </div>
                    </label>
                
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="25010" autocomplete="off">
                            <label class="form-check-label">마감</label>
                        </div>
                    </label>
                
              </div>
            </div>
			
			</br>
			
            <div class="row g-2">
              <div class="col-md-6">
                <label class="form-label">착공 날짜</label>



                <input id="event-start-date" type="date" class="form-control" />
              </div>
              <div class="col-md-6">
                <label class="form-label">마감 날짜</label>
                <input id="event-end-date" type="date" class="form-control" />
              </div>
            </div>

			</br>
            <div class="mb-3">
              <label class="form-label">내용</label>
              <textarea id="event-desc" class="form-control" rows="4"></textarea>
            </div>
          </div>

          <div class="modal-footer d-flex align-items-center">
			  <!-- 왼쪽: 삭제 버튼 -->
			  <button type="button" class="btn btn-outline-danger btn-delete-event me-auto" data-fc-event-public-id="">
			    삭제
			  </button>
			
			  <!-- 오른쪽: 수정/취소/등록 -->
			  <button type="button" class="btn btn-success btn-update-event me-2" data-fc-event-public-id="">
			    수정
			  </button>
			  <button type="button" class="btn bg-danger-subtle text-danger me-2" data-bs-dismiss="modal">
			    취소
			  </button>
			  <button type="button" class="btn btn-primary btn-add-event">
			    일정 등록
			  </button>
			</div>
        </div>
      </div>
    </div>

  </div>
  </div>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/fullcalendar/index.global.min.js"></script> 
<%-- <script src="${pageContext.request.contextPath}/resources/assets/js/apps/calendar-project.js"></script> --%>

<%@ include file="/module/footerPart.jsp" %>

<script src="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>

<script>
  $(function () {
    /* ===== 기본 상수/요소 ===== */
    const ctx = '${pageContext.request.contextPath}';
    const base = ctx + '/project/schedule';
    const prjctNo = '${project.prjctNo}';
    const canEdit = true;


    const modal = $('#eventModal');
    const title = $('#event-title');
    const desc  = $('#event-desc');
    const start = $('#event-start-date');
    const end   = $('#event-end-date');

    const palette = $('#event-color-palette');
    const key = $('#event-color-key');
    const hex = $('#event-color-hex');
    const btnAdd = $('.btn-add-event');
    const btnUpdate = $('.btn-update-event');
    const btnDelete = $('.btn-delete-event'); // 추가
    
    
    

    /* ===== 공정 색 팔레트(대시보드 표시용) ===== */
    const TYPE_COLOR = {
      '철거': { bgColor: '#FDE2E4', text: '#000000' },
      '설비': { bgColor: '#E2ECE9', text: '#000000' },
      '전기': { bgColor: '#E1F0FF', text: '#000000' },
      '목공': { bgColor: '#FFE5B4', text: '#000000' },
      '타일': { bgColor: '#EAF4F4', text: '#000000' },
      '도배': { bgColor: '#F3E8FF', text: '#000000' },
      '필름': { bgColor: '#FFF3CD', text: '#000000' },
      '도장': { bgColor: '#E8F0FE', text: '#000000' },
      '가구': { bgColor: '#EDE7F6', text: '#000000' },
      '마감': { bgColor: '#D1E7DD', text: '#000000' }
    };

    /* ===== 색상 팔레트 초기화 ===== */
    palette.find('.color-swatch').each(function () {
      const hexVal = $(this).data('hex');
      $(this).css({'--swatch': hexVal, 'background-color': hexVal});
    });
    function setFromRadio(radio) {
      if (!radio || radio.length === 0) return;
      const keyVal = radio.val();
      const hexVal = palette.find('label[for="'+radio.attr('id')+'"]').data('hex');
      key.val(keyVal);
      hex.val(hexVal);
    }
    setFromRadio(palette.find('input[name="event-color"]:checked'));
    palette.on('change', 'input[name="event-color"]', function () {
      setFromRadio($(this));
    });

    /* ===== 현장사진 라이트박스 ===== */
    if ($.fn.magnificPopup) {
      $('.image-popup-vertical-fit').magnificPopup({
        type: 'image',
        closeOnContentClick: true,
        mainClass: 'mfp-img-mobile',
        image: { verticalFit: true }
      });
    }

    /* ===== 유틸: 날짜 변환 ===== */
    	function ymdToIso(v) {
    		  if (!v) return null;
    		  const s = String(v).trim().replace(/\//g, '-');

    		  // 앞부분 날짜만 남기기: 'T' 또는 공백 전까지
    		  const datePart = s.split(/[T\s]/)[0];

    		  if (/^\d{8}$/.test(datePart)) {
    		    return datePart.slice(0,4) + '-' + datePart.slice(4,6) + '-' + datePart.slice(6,8);
    		  }
    		  // 이미 YYYY-MM-DD면 그대로
    		  if (/^\d{4}-\d{2}-\d{2}$/.test(datePart)) return datePart;

    		  // 혹시 모를 케이스용 안전장치
    		  const d = new Date(datePart);
    		  return isNaN(d) ? null : d.toISOString().slice(0,10);
    		}
    function isoToYmd(v) { if (!v) return ''; return (v + '').split('T')[0]; }
    
    function addDaysISO(iso, days) {
      if (!iso) return null;
      const parts = iso.split('-').map(Number);
      const dt = new Date(Date.UTC(parts[0], parts[1] - 1, parts[2]));
      dt.setUTCDate(dt.getUTCDate() + days);
      const y2 = dt.getUTCFullYear();
      const m2 = String(dt.getUTCMonth() + 1).padStart(2, '0');
      const d2 = String(dt.getUTCDate()).padStart(2, '0');
      return y2 + '-' + m2 + '-' + d2;
    }

    /* ===== 공정 체크박스: 단일 선택 강제 + 문자값 얻기 ===== */
    $('#category-group').on('change', 'input[name="category"]', function () {
      if (this.checked) {
        $('#category-group input[name="category"]').not(this).prop('checked', false);
      }
    });
    function getSelectedProcsText() {
      const chk = $('#category-group input[name="category"]:checked');
      if (chk.length === 0) return '';
      return chk.closest('.form-check').find('.form-check-label').text();
    }
    function setSelectedProcsByText(txt) {
      $('#category-group input[name="category"]').prop('checked', false);
      $('#category-group .form-check-label').each(function () {
        if ($(this).text() === txt) {
          $(this).closest('.form-check').find('input[name="category"]').prop('checked', true);
        }
      });
    }

 // mapServerToEvent는 이렇게 유지/보강
    function mapServerToEvent(row) {
      const procs = row.procsTy || '';
      const pal = TYPE_COLOR[procs] || { bgColor: '#CFE2FF', text: '#000000' };

      const startIso = ymdToIso(row.startDt);   // '2025-09-11'
      const endIso   = ymdToIso(row.endDt);     // '2025-09-13' (꼬리시간 제거됨)
      const endExcl  = endIso ? addDaysISO(endIso, 1) : null; // 포함 → +1일(배타)

      return {
        id: row.schdulNo,
        title: row.schdulTitle,
        start: startIso,
        end:   endExcl,       // 시간 없이 날짜만 (allDay 전용, 가장 안전)
        allDay: true,
        backgroundColor: pal.bgColor,
        textColor: pal.text,
        extendedProps: {
          schdulCn: row.schdulCn,
          procsTy: procs,
          prjctNo: row.prjctNo,
          bgColor: pal.bgColor,
          fgColor: pal.text
        }
      };
    }

    /* ===== FullCalendar ===== */
    const calendarEl = document.getElementById('calendar');
    const calendar = new FullCalendar.Calendar(calendarEl, {
    	  initialView: 'dayGridMonth',
    	  height: 'auto',
    	  selectable: true,
    	  contentHeight: 'auto',
    	  expandRows: false,
    	  handleWindowResize: true,
    	  fixedWeekCount: false,
    	  dayMaxEventRows: false,
    	  headerToolbar: { 
    		    left: 'prev,next today', 
    		    center: 'title', 
    		    right: 'dayGridMonth'   
    		  },
    		  eventContent: function(arg) {
    			    const main = document.createElement('div');
    			    main.className = 'fc-event-main';
    			    const frame = document.createElement('div');
    			    frame.className = 'fc-event-main-frame';
    			    const container = document.createElement('div');
    			    container.className = 'fc-event-title-container';
    			    const title = document.createElement('div');
    			    title.className = 'fc-event-title fc-sticky';
    			    title.textContent = arg.event.title || '';
    			    container.appendChild(title);
    			    frame.appendChild(container);
    			    main.appendChild(frame);
    			    return { domNodes: [main] };
    			  },
    			 
    			  eventDidMount: function(info) {
    				    const el = info.el;
    				    const bg = (info.event.extendedProps && info.event.extendedProps.bgColor) || info.event.backgroundColor || '#CFE2FF';
    				    const fg = (info.event.extendedProps && info.event.extendedProps.fgColor) || info.event.textColor || '#000';

    				    el.style.backgroundColor = 'transparent';
    				    el.style.border = '0';
    				    el.classList.add('event-fc-color');

    				    const titleContainer = el.querySelector('.fc-event-title-container');
    				    if (titleContainer) {
    				      titleContainer.style.backgroundColor = bg;
    				      titleContainer.style.color = fg;
    				      titleContainer.style.borderRadius = '6px';
    				      titleContainer.style.padding = '0 6px';
    				      titleContainer.style.fontWeight = '600';
    				      titleContainer.style.lineHeight = '1.6';
    				      titleContainer.style.display = 'inline-block';
    				      titleContainer.style.margin = '0 0 1px 0';
    				    }
    				  },
    				  
    				  select: function(info) {
    					  // FullCalendar select의 end는 '배타'이므로 하루 빼서 포함 범위로 보정
    					  const startStr = info.startStr;            // 'YYYY-MM-DD'
    					  const endStr   = addDaysISO(info.endStr, -1);

    					  openModalForCreate(startStr, endStr);
    					  calendar.unselect();
    					},
    			  
    			  
    		  events: function(fetchInfo, success, failure) {
    			    $.ajax({
    			      url: base + '/list',
    			      method: 'GET',
    			      data: { prjctNo: prjctNo },
    			      success: function(list) {
    			        const mapped = (list || []).map(function(item){ return mapServerToEvent(item); });
    			        success(mapped);
    			      },
    			      error: function() { failure(); }
    			    });
    			  },
    			  dateClick: function(info) { openModalForCreate(info.dateStr, info.dateStr); },
    			  eventClick: function(info) { openModalForDetail(info.event.id); }
    			});
    			calendar.render();
    			
    			

    /* ===== 모달 모드 전환 ===== */
    function setModalMode(mode) {
      if (mode === 'create') {
        $('#eventModalLabel').text('일정 등록');
        
        // 버튼 보이기 / 숨기기 
        btnAdd.show();
        btnUpdate.hide().attr('data-fc-event-public-id','');
        btnDelete.hide().attr('data-fc-event-public-id','');
        
        //입력 활성화
        setInputsEnable(true);
      } else {
        $('#eventModalLabel').text('일정 상세');
        
        // 등록 버튼은 상세 모드에서 숨김
        btnAdd.hide();
        
     // 수정 / 삭제 버튼은 권한에 따라 보이게 함 (canEdit이 true이므로 항상 보임)
        if(canEdit){
        	btnUpdate.show();
        	btnDelete.show();
        }else{
        	btnUpdate.hide();
        	btnDelete.hide();
        }
        
        setInputsEnable(canEdit);
        if (!canEdit) { 
        	btnUpdate.hide(); 
        	}
      }
    }
    
    function setInputsEnable(flag) {
      title.prop('readonly', !flag);
      desc.prop('readonly', !flag);
      start.prop('disabled', !flag);
      end.prop('disabled', !flag);
      $('input[name="event-color"]').prop('disabled', !flag);
      $('#category-group input[name="category"]').prop('disabled', !flag);
    }

    /* ===== 등록 모드 열기 ===== */
    function openModalForCreate(startStr, endStr) {
      setModalMode('create');
      title.val('');
      desc.val('');
      
      start.val(isoToYmd(startStr));
      end.val(isoToYmd(endStr || startStr)); // end가 없으면 start로 대체
      
      setSelectedProcsByText('');
      btnUpdate.attr('data-fc-event-public-id',''); // 안전 초기화
      btnDelete.attr('data-fc-event-public-id',''); // 안전 초기화
      modal.modal('show');
    }

    /* ===== 상세 모드 열기 ===== */
    function openModalForDetail(id) {
      setModalMode('update');
      $.ajax({
        url: base + '/detail',
        method: 'GET',
        data: { schdulNo: id },
        success: function(row) {
          btnUpdate.attr('data-fc-event-public-id', row.schdulNo);
          btnDelete.attr('data-fc-event-public-id', row.schdulNo);
          
          title.val(row.schdulTitle || '');
          desc.val(row.schdulCn || '');
          start.val(isoToYmd(ymdToIso(row.startDt)));
          end.val(isoToYmd(ymdToIso(row.endDt)));
          setSelectedProcsByText(row.procsTy || '');

          if (row.backgroundColor) { hex.val(row.backgroundColor); }
          modal.modal('show');
        },
        error: function() { alert('상세 조회에 실패했습니다.'); }
      });
    }

    /* ===== 등록 ===== */
    $('.btn-add-event').on('click', function () {
      const procsTy = getSelectedProcsText();
      if (!procsTy) {
          Swal.fire({
              icon: 'warning',
              title: '경고',
              text: '공정을 선택하세요.',
              confirmButtonText: '확인'
          });
          return;
      }
      
      const payload = {
        schdulTitle: title.val().trim(),
        schdulCn: desc.val().trim(),
        startDt: start.val(),
        endDt: end.val(),
        backgroundColor: hex.val(),
        textColor: '#000000',
        alldayAt: 'true',
        prjctNo: prjctNo,
        procsTy: procsTy
      };
      if (!payload.schdulTitle) { 
    	  alert('제목을 입력하세요.'); return; }
      if (!payload.startDt) { alert('착공 날짜를 선택하세요.'); return; }

      $.ajax({
        url: base + '/create',
        method: 'POST',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify(payload),
        success: function(res) {
          if (res === 'SUCCESS') {
            modal.modal('hide');
            calendar.refetchEvents();
          } else { alert('등록에 실패했습니다.'); }
        },
        error: function(xhr) {
          alert(xhr.responseText || '등록 중 오류가 발생했습니다.');
        }
      });
    });

    /* ===== 수정 ===== */
    $('.btn-update-event').on('click', function () {
      const id = $(this).attr('data-fc-event-public-id');
      if (!id) { alert('이벤트 식별자가 없습니다.'); return; }
      const procsTy = getSelectedProcsText();
      if (!procsTy) { alert('공정을 선택하세요.'); return; }

      const payload = {
        schdulNo: parseInt(id, 10),
        schdulTitle: title.val().trim(),
        schdulCn: desc.val().trim(),
        startDt: start.val(),
        endDt: end.val(),
        backgroundColor: hex.val(),
        textColor: '#000000',
        alldayAt: 'true',
        procsTy: procsTy
      };

      $.ajax({
        url: base + '/update',
        method: 'POST',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify(payload),
        success: function(res) {
          if (res === 'SUCCESS') {
            modal.modal('hide');
            calendar.refetchEvents();
          } else { alert('수정에 실패했습니다.'); }
        },
        error: function() { alert('수정 중 오류가 발생했습니다.'); }
        
      });
    });

    /* ===== 삭제 ===== */
 // ===== 삭제 버튼 클릭 처리 =====
    $('.btn-delete-event').on('click', function () {
      if (!canEdit) return; // 권한 가드

      // 모달 열릴 때 openModalForDetail에서 두 버튼에 id를 세팅했음
      const idFromBtn = $(this).attr('data-fc-event-public-id');
      // 혹시 누락 대비: 업데이트 버튼에 달린 id도 예비로 조회
      const idFallback = btnUpdate.attr('data-fc-event-public-id');
      const id = idFromBtn || idFallback;

      if (!id) {
        alert('이벤트 식별자가 없습니다.');
        return;
      }
      if (!confirm('이 일정을 삭제할까요?')) return;

      $.ajax({
        url: base + '/delete',
        method: 'POST',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify({ schdulNo: parseInt(id, 10) }),
        success: function (res) {
          if (res === 'SUCCESS') {
            modal.modal('hide');
            calendar.refetchEvents(); // 새로고침 없이 일정 목록 갱신
          } else {
            alert('삭제에 실패했습니다.');
          }
        },
        error: function () {
          alert('삭제 중 오류가 발생했습니다.');
        }
      });
    });

  });
</script>
</body>
</html>