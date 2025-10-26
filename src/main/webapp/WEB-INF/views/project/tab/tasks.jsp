<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - Tasks</title>
  
  <style>
    .bg-purple-subtle { background-color: #f3e8ff !important; }
    .text-purple { color: #6f42c1 !important; }
    .text-bg-purple { background-color: #6f42c1 !important; color: #fff !important; }
    .summary-btn.active { outline: 2px solid var(--bs-primary); outline-offset: 2px; }
    .issue-card:hover { border-color: rgba(13,110,253,.35); box-shadow: 0 0.25rem 0.8rem rgba(13,110,253,.08); }
    .pagination-container { display:flex; justify-content:center; margin-top:1rem; }
    
    /* ===== Card Hover 강화 ===== */
.issue-card {
  transition: transform .15s ease, box-shadow .2s ease, border-color .2s ease, background-color .2s ease;
}
.issue-card:hover {
  transform: translateY(-2px);
  border-color: rgba(13,110,253,.35);
  box-shadow: 0 .5rem 1rem rgba(13,110,253,.12);
  background-color: rgba(13,110,253,.02); /* 살짝 밝아지는 느낌 */
}
.issue-card:active {
  transform: translateY(0);
}

/* 키보드 내비게이션 대비 (드롭다운/링크 등 포커스 들어오면 카드 윤곽 살짝 표시) */
.issue-card:focus-within {
  outline: 2px solid rgba(13,110,253,.25);
  outline-offset: 2px;
}

/* ===== 드롭다운 트리거 버튼(점 3개) 호버/열림 상태 표시 ===== */
.issue-card [data-bs-toggle="dropdown"] {
  transition: background-color .15s ease, box-shadow .15s ease, transform .1s ease;
}
.issue-card [data-bs-toggle="dropdown"]:hover {
  background-color: rgba(0,0,0,.04);
  box-shadow: inset 0 0 0 1px rgba(0,0,0,.06);
}
.issue-card [data-bs-toggle="dropdown"]:active {
  transform: scale(.98);
}
/* 드롭다운 펼쳐진 상태 */
.issue-card .dropdown.show [data-bs-toggle="dropdown"],
.issue-card [data-bs-toggle="dropdown"][aria-expanded="true"] {
  background-color: rgba(13,110,253,.12);
  box-shadow: inset 0 0 0 1px rgba(13,110,253,.25);
}

/* ===== 드롭다운 메뉴 항목 Hover/Active (아주 살짝 흐리게 강조) ===== */
.issue-card .dropdown-menu {
  padding: .25rem .25rem;
  border-radius: .5rem;
}
.issue-card .dropdown-menu .dropdown-item {
  border-radius: .375rem;
  margin: 2px 6px;
  transition: background-color .12s ease;
}
.issue-card .dropdown-menu .dropdown-item:hover,
.issue-card .dropdown-menu .dropdown-item:focus {
  background-color: rgba(13,110,253,.08); /* hover 시 살짝 흐림 */
}
.issue-card .dropdown-menu .dropdown-item:active {
  background-color: rgba(13,110,253,.14); /* 클릭 순간 조금 더 진하게 */
  color: inherit;
}

.bg-purple { background-color: #941FF2 !important; } /* 진행바/배경용 */
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
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="/main/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="/project/dashboard?prjctNo=${prjctNo}">Project</a></li>
                <li class="breadcrumb-item" aria-current="page">Tasks</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="/WEB-INF/views/project/carousels.jsp"%>

    <!-- ===== [요약 카운트 버튼 행] ===== -->
    <div class="row row-cols-5 g-2" id="summaryRow">
      <div class="col">
        <button type="button" class="summary-btn btn w-100 d-flex align-items-center justify-content-between bg-secondary-subtle text-secondary rounded-3 px-3 py-2 active"
                data-filter="all" aria-pressed="true">
          <span>전체</span>
          <span id="count-all" class="badge rounded-pill text-bg-secondary">0</span>
        </button>
      </div>
      <div class="col">
        <button type="button" class="summary-btn btn w-100 d-flex align-items-center justify-content-between bg-light-subtle text-dark rounded-3 px-3 py-2"
                data-filter="wait" aria-pressed="false">
          <span>대기</span>
          <span id="count-wait" class="badge rounded-pill text-bg-light text-dark">0</span>
        </button>
      </div>
      <div class="col">
        <button type="button" class="summary-btn btn w-100 d-flex align-items-center justify-content-between bg-info-subtle text-info rounded-3 px-3 py-2"
                data-filter="progress" aria-pressed="false">
          <span>진행중</span>
          <span id="count-progress" class="badge rounded-pill text-bg-info">0</span>
        </button>
      </div>
      <div class="col">
        <button type="button" class="summary-btn btn w-100 d-flex align-items-center justify-content-between bg-purple-subtle text-purple rounded-3 px-3 py-2"
                data-filter="review" aria-pressed="false">
          <span>검토중</span>
          <span id="count-review" class="badge rounded-pill text-bg-purple">0</span>
        </button>
      </div>
      <div class="col">
        <button type="button" class="summary-btn btn w-100 d-flex align-items-center justify-content-between bg-success-subtle text-success rounded-3 px-3 py-2"
                data-filter="done" aria-pressed="false">
          <span>완료</span>
          <span id="count-done" class="badge rounded-pill text-bg-success">0</span>
        </button>
      </div>
    </div>

    <!-- ===== [검색 + 일감 등록 툴바] ===== -->
    <div class="d-flex justify-content-end align-items-center my-3" id="taskToolbar">
      <div class="input-group me-2" style="max-width: 500px; min-width: 280px;">
        <select id="taskTypeFilter" class="form-select" style="max-width: 140px;">
          <option value="">일감 유형(전체)</option>
          <c:forEach var="t" items="${fn:split('철거,설비,목공,전기,타일,도배,필름,도장,마루,가구,마감', ',')}">
            <option value="${t}">${t}</option>
          </c:forEach>
        </select>
        <input type="text" class="form-control" id="fileSearchInput" placeholder="검색어를 입력하세요">
        <button class="btn btn-outline-secondary" type="button" id="btnDoSearch">검색</button>
      </div>

       <%-- [수정된 부분] 일감 등록 버튼 권한 제어 로직 --%>
      <sec:authentication property="principal.member" var="loginUser"/>
      <c:set var="ADMIN_EMP_NO" value="202508001" />
      <c:set var="loginEmpNo" value="${loginUser.empNo}" />
      
      <%-- 1. 관리자 여부 확인 --%>
      <c:set var="isAdmin" value="${loginEmpNo eq ADMIN_EMP_NO}" />

      <%-- 2. 프로젝트 참여자 여부 확인 (${project} 객체에 participantsList가 있다고 가정) --%>
      <c:set var="isProjectParticipant" value="false" />
      <c:forEach var="ptcpnt" items="${project.participantsList}">
          <c:if test="${ptcpnt.empNo eq loginEmpNo}">
              <c:set var="isProjectParticipant" value="true" />
          </c:if>
      </c:forEach>

      <%-- 관리자이거나 프로젝트 참여자일 경우에만 일감 등록 버튼 표시 --%>
      <c:if test="${isAdmin or isProjectParticipant}">
          <a href="${pageContext.request.contextPath}/project/tasks/insert?prjctNo=${project.prjctNo}"
             class="btn btn-success" id="uploadBtn">일감 등록</a>
      </c:if>
      <%-- [수정 끝] 일감 등록 버튼 권한 제어 로직 --%>
    </div>

    <!-- ===== [일감 리스트] ===== -->
    <div class="mt-3">
      <div class="row row-cols-1 row-cols-lg-2 g-3" id="issueList">
        <!-- Ajax 렌더링 영역 -->
      </div>
      <div class="text-center text-muted py-5 d-none" id="emptyBox">등록된 일감이 없습니다.</div>
    </div>

 <div class="d-flex align-items-center justify-content-between mt-4 mb-3">
  <!-- 가운데 페이지네이션 -->
  <div class="flex-grow-1 d-flex justify-content-center">
    <nav aria-label="Page navigation" class="m-0">
      <ul id="taskPaging" class="pagination justify-content-center mb-0">
        ${pagingVO.pagingHTML2}
      </ul>
    </nav>
  </div>
</div>


</div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<c:if test="${not empty message}">
  <div id="flash-message" class="d-none"><c:out value="${message}"/></div>
</c:if>
<c:if test="${not empty error}">
  <div id="flash-error" class="d-none"><c:out value="${error}"/></div>
</c:if>


<script>
$(function() {
  /* ================= 공통 상태 → 배지색/텍스트 ================= */
  function statusBadgeHtml(progress) {
  var p = parseInt(progress||0,10);
  if (p === 0)   return '<span class="badge bg-light text-dark">대기</span>';
  if (p === 90)  return '<span class="badge" style="background-color:#941FF2;color:#fff;">검토중</span>';
  if (p === 100) return '<span class="badge bg-success">완료</span>';
  if (p >= 10 && p <= 80) return '<span class="badge bg-secondary">진행중</span>';
  return '<span class="badge bg-secondary">진행중</span>';
}


  function classifyProgress(p) {
    p = parseInt(p||0,10);
    if (p === 0) return "wait";
    if (p >= 10 && p <= 80) return "progress";
    if (p === 90) return "review";
    if (p === 100) return "done";
    return "progress";
  }

  /* ================= 상태/검색/유형 선택값 ================= */
  const ctx         = "${pageContext.request.contextPath}";
  const prjctNo     = "${project.prjctNo}";
  let currentFilter = "all"; // all|wait|progress|review|done
  let currentKeyword= "";
  let currentType   = "";    // 공정 유형
  let currentPage   = 1;

  /* ================= 상단 요약 카운트 업데이트 ================= */
  function updateCounts(counts) {
    $("#count-all").text(counts.all||0);
    $("#count-wait").text(counts.wait||0);
    $("#count-progress").text(counts.progress||0);
    $("#count-review").text(counts.review||0);
    $("#count-done").text(counts.done||0);
  }

  /* ================= 카드 렌더 ================= */
function renderList(list) {
  const $wrap = $("#issueList");
  $wrap.empty();
  if (!list || !list.length) {
    $("#emptyBox").removeClass("d-none");
    return;
  }
  $("#emptyBox").addClass("d-none");

  $.each(list, function(i, t){
    const urgent = (t.emrgncyYn === 'Y') ? '<span class="badge bg-danger ms-2">긴급</span>' : '';
    const badge  = statusBadgeHtml(t.taskProgrs);
    const type   = t.procsTy ? '<span class="badge bg-warning text-white">'+ t.procsTy +'</span>' : '';
    const charger= t.taskChargerNm ? t.taskChargerNm : (t.taskCharger||'-');

    // === 진행바 색상: 검토중=보라, 진행중=secondary, 완료=success, (대기=0%라 색상 영향 없음)
    let barClass = 'bg-secondary';
    const prog = parseInt(t.taskProgrs||0,10);
    if (prog === 90)       barClass = 'bg-purple';
    else if (prog === 100) barClass = 'bg-success';
    else if (prog === 0)   barClass = 'bg-light'; // 0% 표시용(사실상 보이지 않음)

    const progressBar =
    	  '<div class="progress" style="height:20px;">'
    	  + '  <div class="progress-bar ' + barClass + '" role="progressbar"'
    	  + '       style="width:' + prog + '%;' + (prog===90?'background-color:#E3C8FA;color:#fff;':'') + '"'
    	  + '       aria-valuenow="' + prog + '" aria-valuemin="0" aria-valuemax="100">'
    	  +        prog + '%'
    	  + '  </div>'
    	  + '</div>';

    // === 카드 상단: 제목(좌) - 상태배지(우) - 드롭다운(우)
    let menuHtml = '';
    if (t.canEdit === 'Y') {
      menuHtml += '<li><a class="dropdown-item" href="'+ctx+'/project/tasks/update?prjctNo='+ prjctNo +'&taskNo='+ t.taskNo +'">수정</a></li>';
    }
    if (t.canDelete === 'Y') {
      menuHtml += '<li><button class="dropdown-item text-danger btn-delete" type="button" data-task-no="'+ t.taskNo +'">삭제</button></li>';
    }
    if (!menuHtml) {
      menuHtml = '<li><span class="dropdown-item text-muted">권한 없음</span></li>';
    }

    const html = ''
    	  + '<div class="col-12 col-lg-6 issue-item" data-task-no="'+ t.taskNo +'">'
    	  + '  <div class="card h-100 issue-card cursor-pointer">'
    	  + '    <div class="card-body user-select-none">'
    	  + '      <div class="d-flex align-items-start gap-2">'
    	  + '        <h5 class="card-title mb-2 d-flex align-items-center gap-2 flex-grow-1">'
    	  + '          <a href="'+ctx+'/project/tasks/detail?prjctNo='+ prjctNo +'&taskNo='+ t.taskNo +'" class="link-dark text-decoration-none">'
    	  +              (t.taskTitle||'(제목없음)') + '</a>'
    	  +              urgent
    	  + '        </h5>'
    	  + '        <div class="ms-auto d-flex align-items-center gap-2">'
    	  + '          <div class="dropdown flex-shrink-0">'
    	  + '            <button type="button" class="btn btn-sm bg-light-subtle rounded-circle d-inline-flex align-items-center justify-content-center border-0"'
    	  + '                    data-bs-toggle="dropdown" aria-expanded="false" style="width:32px;height:32px;">'
    	  + '              <i class="ti ti-dots-vertical text-dark"></i>'
    	  + '            </button>'
    	  + '            <ul class="dropdown-menu dropdown-menu-end">'
    	  +                menuHtml
    	  + '            </ul>'
    	  + '          </div>'
    	  + '        </div>'
    	  + '      </div>'

    	  + '      <p class="mb-2">'
    	  + '        담당자: '+ charger +' <br>'
    	  + '        시작일: '+ (t.taskBeginYmd||'-') +' <br>'
    	  + '        마감일: '+ (t.taskDdlnYmd||'-') +'<br>'
    	  + '      </p>'

    	  // === 태그 라인: 왼쪽 type, 오른쪽 badge
    	  + '      <div class="mb-2 d-flex justify-content-between align-items-center">'
    	  + '        <div class="d-flex flex-wrap gap-1">'+ type +'</div>'
    	  + '        <div>'+ badge +'</div>'
    	  + '      </div>'

    	  + '      <div class="mt-3">'+ progressBar +'</div>'
    	  + '    </div>'
    	  + '  </div>'
    	  + '</div>';

    $wrap.append(html);
  });
  
  }

  /* ================= 페이지네이션 렌더 ================= */
  function renderPaging(pagingHTML) {
    $("#taskPaging").html(pagingHTML || "");
  }

  /* ================= 목록 로드 (핵심) ================= */
  function loadList(page) {
    currentPage = page || 1;
    $.ajax({
      url: ctx + "/project/tasks/listAjax",
      type: "GET",
      dataType: "json",
      data: {
        prjctNo: prjctNo,
        status: currentFilter,   // all|wait|progress|review|done
        procsTy: currentType,    // 공정(유형)
        currentPage: currentPage,
        searchWord: currentKeyword
      },
      success: function(pagingVO) {
        renderList(pagingVO.dataList);
        renderPaging(pagingVO.pagingHTML2);

        // 서버에서 내려주는 전역 카운트 반영
        if (pagingVO.data && pagingVO.data.counts) {
          updateCounts(pagingVO.data.counts);
        } else {
          // fallback (현재 페이지 기준 best-effort)
          const tmp = {all:0,wait:0,progress:0,review:0,done:0};
          $.each(pagingVO.dataList||[], function(_, t){
            tmp.all++;
            tmp[classifyProgress(t.taskProgrs)]++;
          });
          updateCounts(tmp);
        }
      },
      error: function() {
        alert("일감을 불러오는 중 오류가 발생했습니다.");
      }
    });
  }

  /* ================= 이벤트 바인딩 ================= */
  function setActiveFilterButton($btn) {
    $(".summary-btn").removeClass("active").attr("aria-pressed","false");
    $btn.addClass("active").attr("aria-pressed","true");
  }

  // 요약 버튼 클릭 → 상태 필터 변경 후 1페이지부터 로드
  $(document).on("click", ".summary-btn", function(){
    const $btn = $(this);
    currentFilter = $btn.data("filter");
    setActiveFilterButton($btn);
    loadList(1);
  });

  // 검색 버튼/엔터
  $("#btnDoSearch").on("click", function(){
    currentKeyword = ($.trim($("#fileSearchInput").val()) || "");
    loadList(1);
  });
  $("#fileSearchInput").on("keydown", function(e){
    if (e.key === "Enter") {
      e.preventDefault();
      currentKeyword = ($.trim($("#fileSearchInput").val()) || "");
      loadList(1);
    }
  });

  // 유형 변경
  $("#taskTypeFilter").on("change", function(){
    currentType = $(this).val() || "";
    loadList(1);
  });

  /* // 페이지네이션 클릭 (data-page)
  $(document).on("click", ".pagination .page-link", function(e){
    const p = $(this).data("page");
    if (p) {
      e.preventDefault();
      loadList(p);
    }
  }); */
  
  
//✅ 모든 형태의 페이징 링크를 가로채서 AJAX 로딩으로 전환
  $(document).on("click", "#taskPaging a", function (e) {
    e.preventDefault();

    // 1) data-page 속성이 있으면 최우선 사용
    const dp = $(this).data("page");
    if (dp) { loadList(parseInt(dp, 10)); return; }

    // 2) href에 ?currentPage=2 또는 ?page=2 같은 쿼리스트링이 있으면 추출
    const href = $(this).attr("href") || "";
    const m = href.match(/(?:currentPage|page)=(\d+)/);
    if (m) { loadList(parseInt(m[1], 10)); return; }

    // 3) onclick="fn_pagination(2)" 형태도 대응
    const oc = $(this).attr("onclick") || "";
    const m2 = oc.match(/fn_pagination\((\d+)\)/);
    if (m2) { loadList(parseInt(m2[1], 10)); return; }

    // 4) fallback: data-page가 li에 붙어있는 경우
    const lp = $(this).closest("li").data("page");
    if (lp) { loadList(parseInt(lp, 10)); return; }
  });

  // 카드 어디를 눌러도 상세로 이동 (단, 인터랙티브 요소 클릭은 제외)
  $(document).on("click", ".issue-card", function(e){
    if ($(e.target).closest(".dropdown, .dropdown-menu, .btn, a, input, textarea, select, label, .form-check, .form-switch").length) {
      return; // 드롭다운/버튼/링크 등은 카드 네비게이션 막기
    }
    const taskNo = $(this).closest(".issue-item").data("task-no");
    if (!taskNo) return;
   
    window.location.href ='${pageContext.request.contextPath}/project/tasks/detail?prjctNo=' + '${project.prjctNo}' + '&taskNo=' + taskNo;
  });

  $(function() {
	  // 삭제 이벤트
	  $(document).on("click", ".btn-delete", function(e){
	    e.stopPropagation();
	    const taskNo = $(this).data("task-no");
	    if (!taskNo) return;

	    Swal.fire({
	      title: '일감 삭제',
	      text: "정말 이 일감을 삭제하시겠습니까?",
	      icon: 'warning',
	      showCancelButton: true,
	      confirmButtonColor: '#d33',
	      cancelButtonColor: '#6c757d',
	      confirmButtonText: '삭제',
	      cancelButtonText: '취소',
	      reverseButtons: true
	    }).then((result) => {
	      if (result.isConfirmed) {
	        $.ajax({
	          url: ctx + "/project/tasks/delete",
	          type: "POST",
	          data: { taskNo: taskNo, prjctNo: prjctNo },
	          success: function(res){
	            if (res === "SUCCESS") {
	              Swal.fire({
	                icon: 'success',
	                title: '삭제 완료',
	                text: '일감이 삭제되었습니다.'
	              }).then(() => {
	                loadList(currentPage); // 현재 페이지 갱신
	              });
	            } else {
	              Swal.fire({
	                icon: 'error',
	                title: '삭제 실패',
	                text: '일감을 삭제하지 못했습니다.'
	              });
	            }
	          },
	          error: function(){
	            Swal.fire({
	              icon: 'error',
	              title: '오류 발생',
	              text: '삭제 처리 중 문제가 발생했습니다.'
	            });
	          }
	        });
	      }
	    });
	  });
	});

  
  window.fn_pagination = function(pageNo){
	  if (!pageNo || pageNo < 1) return;
	  loadList(pageNo);   // 폼 submit이 아니라 AJAX로 페이지 전환
	};
  /* ================= 초기 로드 ================= */
  loadList(1);
});

/* ===== SweetAlert 플래시 ===== */
$(function () {
  var msg = $.trim($("#flash-message").text());
  var err = $.trim($("#flash-error").text());

  if (msg) {
    Swal.fire({
      icon: 'success',
      title: '일감 등록',
      text: msg,
      confirmButtonText: '확인',
      buttonsStyling: false,
      customClass: { confirmButton: 'btn btn-primary' }
    });
  } else if (err) {
    Swal.fire({
      icon: 'error',
      title: '등록 실패',
      text: err,
      confirmButtonText: '확인',
      buttonsStyling: false,
      customClass: { confirmButton: 'btn btn-danger' }
    });
  }
  
  
  
});
</script>


</body>
</html>
