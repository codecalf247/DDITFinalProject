<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
 
  <link rel="stylesheet" href="https://unpkg.com/frappe-gantt/dist/frappe-gantt.css">
  <script src="https://unpkg.com/frappe-gantt/dist/frappe-gantt.umd.js"></script>
<style>
  #gantt { min-height: 420px; }
  /* 읽기 전용: 드래그/리사이즈/진행률 핸들 비활성화 */
  .gantt .bar-wrapper .handle,
  .gantt .bar-wrapper .bar-progress,
  .gantt .gantt-container svg .bar-wrapper { pointer-events: none; }

  /* 바탕(미진행) 막대는 항상 연회색 */
  #gantt svg.gantt .bar { fill:#e5e7eb; stroke:#e5e7eb; }
  /* 간트 내부 텍스트 가독성 */
  #gantt svg.gantt text { fill:#000!important; stroke:none!important; opacity:1!important; }

  /* 레전드 */
  .legend{display:flex; gap:10px; align-items:center; flex-wrap:wrap;}
  .legend-item{display:flex; align-items:center; gap:6px; font-size:12px; color:#6b7280;}
  .legend-dot{width:10px; height:10px; border-radius:9999px; display:inline-block;}
  .dot-wait{background:#e5e7eb;} .dot-doing{background:#9ec5ff;}
  .dot-review{background:#a78bfa;} .dot-done{background:#86efac;}
  
  /* 진행률 막대 색상(지속 적용) */
#gantt svg.gantt .bar-wrapper.p-100 .bar-progress { fill:#86efac !important; stroke:#86efac !important; } /* 완료 */
#gantt svg.gantt .bar-wrapper.p-90  .bar-progress { fill:#a78bfa !important; stroke:#a78bfa !important; } /* 검토중 */
#gantt svg.gantt .bar-wrapper.p-low .bar-progress { fill:#9ec5ff !important; stroke:#9ec5ff !important; } /* 진행중 */
#gantt svg.gantt .bar-wrapper:not(.p-100):not(.p-90):not(.p-low) .bar-progress { fill:#e5e7eb !important; stroke:#e5e7eb !important; } /* 대기 또는 0% */

/* 배경 바는 항상 연회색(유지) */
#gantt svg.gantt .bar { fill:#e5e7eb !important; stroke:#e5e7eb !important; }
</style>
    
</head>
  <%@ include file="/module/header.jsp" %>

<body>
  <div class="body-wrapper">
    <div class="container-fluid"> 
    
  <div class="body-wrapper">
        <div class="container">
        
                <!-- 상단 브레드크럼 (고정 텍스트) -->
<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
  <div class="card-body px-4 py-3">
    <div class="row align-items-center">
      <div class="col-9">
        <h4 class="fw-semibold mb-8">프로젝트</h4>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a class="text-muted text-decoration-none" href="/main/dashboard">Home</a>
            </li>
            <li class="breadcrumb-item">
              <a class="text-muted text-decoration-none" href="/project/dashboard">Project</a>
            </li>
            <li class="breadcrumb-item" aria-current="page">Gantt</li>
          </ol>
        </nav>
      </div>
    </div>
  </div>
</div>
        
      <%@ include file="/WEB-INF/views/project/carousels.jsp"%>

      <!-- =======================
           Gantt (Read-only) Card
           ======================= -->
      <div class="row">
        <div class="col-12">
          <div class="card">
            <div class="card-body">
              <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                <h5 class="card-title mb-0">프로젝트 간트 (조회 전용)</h5>

               <div class="toolbar-right" style="text-align:right">
				  <div class="btn-group" role="group" aria-label="View mode">
				    <button type="button" class="btn btn-outline-secondary btn-sm active" data-view="Day">Day</button>
				    <button type="button" class="btn btn-outline-secondary btn-sm" data-view="Month">Month</button>
				  </div>
				
				  <!-- 상태 레전드 -->
				  <div class="legend" style="margin-top:8px;">
				    <span class="legend-item"><i class="legend-dot dot-wait"></i>대기</span>
				    <span class="legend-item"><i class="legend-dot dot-doing"></i>진행중</span>
				    <span class="legend-item"><i class="legend-dot dot-review"></i>검토중</span>
				    <span class="legend-item"><i class="legend-dot dot-done"></i>완료</span>
				  </div>
				</div>
              </div>

              <div id="gantt" class="border rounded-3"></div>
            </div>
          </div>
        </div>
      </div>
      <!-- /Gantt Card -->

    </div><!-- /.container-fluid -->
  </div><!-- /.body-wrapper -->
  </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>

 
 
 <script>
$(function () {
  const ctx     = '${pageContext.request.contextPath}';
  const prjctNo =
    ('${prjctNo}' && '${prjctNo}'.trim() !== '' ? '${prjctNo}' : '${param.prjctNo}')
    || (new URLSearchParams(location.search).get('prjctNo') || '');

  let ganttInstance;
  let currentView = 'Day';

  // prjctNo 없으면 샘플 표시
  if (!prjctNo) {
    const mock = sampleTasks();
    render(mock);
    return;
  }

  // 1) 일감 리스트 Ajax로 받아와서 간트로 변환
  $.getJSON(ctx + '/project/tasks/listAjax', {
    prjctNo: prjctNo, status: 'all', currentPage: 1
  })
  .done(function(pagingVO){
    const list  = (pagingVO && pagingVO.dataList) ? pagingVO.dataList : [];
    const tasks = list.map(toGanttTask);
    render(tasks);
  })
  .fail(function(){
    render(sampleTasks());
  });

  // == 매핑 ==
  function toGanttTask(t){
    const start = normYmd(t.taskBeginYmd) || todayYmd();
    const end   = normYmd(t.taskDdlnYmd)  || plusDaysYmd(start, 7);
    const p     = toInt(t.taskProgrs, 0);
    return {
      id:   String(t.taskNo || t.taskTitle || ('issue-' + Math.random())),
      name: (t.taskTitle && String(t.taskTitle).trim()) || '(제목없음)',
      start, end,
      progress: clamp(p,0,100),
      assignee: t.taskChargerNm || t.taskCharger || '',
      status:   progressToStatus(p),
      dependencies: ''
    };
  }
  function progressToStatus(p){
    p = toInt(p,0);
    if (p === 0)   return '대기';
    if (p === 90)  return '검토중';
    if (p === 100) return '완료';
    return '진행중';
  }

  // == 렌더 ==
  function render(tasks){
    applyProgressClass(tasks);
    ganttInstance = new Gantt('#gantt', tasks, {
      view_mode: currentView,
      language: 'ko',
      bar_height: 24,
      padding: 28,
      on_date_change: function(){
        ganttInstance.refresh(ganttInstance.tasks);
        setTimeout(function(){ repaintBars(ganttInstance.tasks); }, 0);
      },
      on_progress_change: function(){
        ganttInstance.refresh(ganttInstance.tasks);
        setTimeout(function(){ repaintBars(ganttInstance.tasks); }, 0);
      },
      custom_popup_html: function(task) {
        const s = task.status ? ' | 상태: ' + task.status : '';
        const a = task.assignee ? ' | 담당: ' + task.assignee : '';
        return '<div class="details-container p-2">'
             + '<h6 class="mb-1">' + task.name + '</h6>'
             + '<p class="mb-1">기간: ' + task._start.toLocaleDateString()
             + ' ~ ' + task._end.toLocaleDateString() + '</p>'
             + '<p class="mb-0">진행률: ' + task.progress + '%' + s + a + '</p>'
             + '</div>';
      }
    });
    bindToolbar();
    setTimeout(function(){ repaintBars(tasks); }, 0);
  }

  // == 진행률별 class (바탕 회색, 진행률 막대만 색칠) ==
  function applyProgressClass(tasks){
    for (let i=0; i<tasks.length; i++){
      const p = toInt(tasks[i].progress, 0);
      if (p >= 100)              tasks[i].custom_class = 'p-100';
      else if (p >= 90)          tasks[i].custom_class = 'p-90';
      else if (p >= 1 && p <= 80) tasks[i].custom_class = 'p-low';
      else                       tasks[i].custom_class = '';
    }
  }
  function repaintBars(tasks){
    try{
      const svg = document.querySelector('#gantt svg.gantt');
      if (!svg) return;
      tasks.forEach(function(t){
        const id  = String(t.id);
        const esc = (window.CSS && CSS.escape) ? CSS.escape(id) : id.replace(/"/g,'\\"');
        const g   = svg.querySelector('g.bar-wrapper[data-id="'+esc+'"]');
        if (!g) return;
        const bar  = g.querySelector('rect.bar');          // 배경
        const prog = g.querySelector('rect.bar-progress'); // 진행률
        if (bar){
          setImp(bar,'fill','#e5e7eb'); setImp(bar,'stroke','#e5e7eb');
          setImp(bar,'opacity','1');   setImp(bar,'fill-opacity','1');
        }
        if (prog){
          const color = pickColor(toInt(t.progress,0));
          setImp(prog,'fill',color); setImp(prog,'stroke',color);
          setImp(prog,'opacity','1'); setImp(prog,'fill-opacity','1');
        }
      });
    }catch(e){ console.warn('repaintBars:', e); }
    function setImp(el, prop, val){
      try{ el.style.setProperty(prop,val,'important'); }catch(e){}
      try{ el.setAttribute(prop,val); }catch(e){}
    }
  }
  function pickColor(p){
    if (p >= 100)          return '#86efac'; // 완료(연초록)
    if (p >= 90)           return '#a78bfa'; // 검토중(연보라)
    if (p >= 1 && p <= 80) return '#9ec5ff'; // 진행중(연파랑)
    return '#e5e7eb';                       // 대기(연회색)
  }

  // == 툴바 ==
  function bindToolbar(){
    const btns = document.querySelectorAll('[data-view]');
    for (let i=0; i<btns.length; i++){
      btns[i].addEventListener('click', function(){
        for (let j=0; j<btns.length; j++) btns[j].classList.remove('active');
        this.classList.add('active');
        currentView = this.getAttribute('data-view');
        ganttInstance.change_view_mode(currentView);
        setTimeout(function(){ repaintBars(ganttInstance.tasks); }, 0);
      });
    }
  }

  // == 샘플/유틸 ==
  function sampleTasks(){
    return [
      { id:'101', name:'옥실 타일 색상 불일치', start:'2025-09-01', end:'2025-10-02', progress:30,  assignee:'김현장', status:'진행중' },
      { id:'102', name:'거실 조명 교체',       start:'2025-07-28', end:'2025-08-29', progress:90,  assignee:'박소장', status:'검토중' },
      { id:'103', name:'현관 문짝 교체',       start:'2025-08-20', end:'2025-09-12', progress:100, assignee:'이반장', status:'완료' }
    ];
  }
  function normYmd(v){
    if (!v) return null;
    const s = String(v).trim();
    const m = s.match(/^(\d{4})(\d{2})(\d{2})$/);
    if (m) return m[1]+'-'+m[2]+'-'+m[3];
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
    return null;
  }
  function todayYmd(){
    const d=new Date(); const m=('0'+(d.getMonth()+1)).slice(-2); const day=('0'+d.getDate()).slice(-2);
    return d.getFullYear()+'-'+m+'-'+day;
  }
  function plusDaysYmd(ymd, days){
    const d=new Date(ymd); d.setDate(d.getDate()+(days||0));
    const m=('0'+(d.getMonth()+1)).slice(-2); const day=('0'+d.getDate()).slice(-2);
    return d.getFullYear()+'-'+m+'-'+day;
  }
  function toInt(v, def){ v=parseInt(v,10); return isFinite(v)?v:def; }
  function clamp(n,min,max){ return Math.max(min, Math.min(max, n)); }
});
</script>


</body>
</html>
