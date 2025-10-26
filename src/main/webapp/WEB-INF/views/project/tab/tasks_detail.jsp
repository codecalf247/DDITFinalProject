<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - Task Detail</title>

  <style>
  
  /* ===== 기본정보 카드 리디자인 ===== */
.info-card-title{
  font-weight: 700; letter-spacing:.2px; margin-bottom:.75rem;
}

.badge-deck{
  display:flex; flex-wrap:wrap; gap:.4rem .5rem; margin-bottom: .75rem;
}

.kv-grid{
  display:grid;
  grid-template-columns: 140px 1fr; /* 키/값 너비 */
  row-gap:.35rem;
  column-gap:1rem;
}
@media (max-width: 576px){
  .kv-grid{ grid-template-columns: 120px 1fr; }
}

.kv-row{
  display:contents; /* 그리드의 두 칸을 한 줄로 쓰기 */
}
.kv-key{
  display:flex; align-items:center; gap:.5rem;
  color: var(--bs-secondary-color); font-weight:600;
  padding:.35rem 0;
}
.kv-key .ti{ font-size:1.05rem; opacity:.9; }
.kv-val{
  padding:.35rem 0; color: var(--bs-body-color);
  word-break:break-word;
}
.kv-divider{
  grid-column:1 / -1; height:1px; background:var(--bs-border-color);
  margin:.25rem 0 .35rem;
}

/* 상태 배지 톤 보정(가독성↑) */
.badge.rounded-pill{
  padding:.45rem .7rem; font-weight:600; letter-spacing:.2px;
}

/* “진행률” 작은 강조 */
.kv-val .progress-chip{
  display:inline-flex; align-items:center; gap:.35rem;
  padding:.2rem .55rem; border-radius:999px;
  background: var(--bs-success-bg-subtle);
  color: var(--bs-success-text-emphasis);
  font-weight:600; font-variant-numeric: tabular-nums;
}
.kv-val .progress-chip .dot{
  width:.45rem; height:.45rem; border-radius:50%;
  background: currentColor; opacity:.6;
}
/* ========== Photo tile 기본 ========== */
.photo-grid{
  display:grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap:12px;
}
.photo-grid-item{
  position:relative;
  display:block;
  overflow:hidden;
  border-radius:.75rem;
  background:var(--bs-body-bg);
}
.photo-grid-img{
  display:block;
  width:100%;
  height:160px;          /* 필요 시 높이 조정 */
  object-fit:cover;
  transition:transform .25s ease;
}
.photo-grid-item:hover .photo-grid-img{ transform:scale(1.03); }

/* ========== 중앙 오버레이 ========== */
.photo-grid-item .el-overlay{
  position:absolute;
  inset:0;                               /* top/right/bottom/left:0 */
  background:rgba(0,0,0,.38);            /* 살짝 어둡게 */
  border-radius:.75rem;
  padding:0 !important;                   /* Bootstrap 클래스 영향 제거 */
  margin:0 !important;
  opacity:0;
  transition:opacity .2s ease;
  z-index:1;
}
.photo-grid-item:hover .el-overlay{ opacity:1; }

/* 오버레이 내부 버튼 리스트를 정확히 '정중앙 + 가로' 배치 */
.photo-grid-item .el-overlay .el-info{
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  display: flex !important;           /* Bootstrap의 d-inline-block 무시 */
  flex-direction: row !important;     /* 세로로 서는 문제 방지 */
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 0;
  margin: 0;
  list-style: none;
}


/* li 간격 초기화 */
.photo-grid-item .el-overlay .el-item{
  margin:0;
}

/* ========== 버튼 스타일 ========== */
.photo-grid-item .el-overlay .el-info .btn{
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius:.6rem;
  border:2px solid rgba(255,255,255,.85); /* 선 또렷하게 */
  background:rgba(255,255,255,.15);
  color:#fff !important;
  box-shadow:0 6px 16px rgba(0,0,0,.25);
  backdrop-filter:blur(2px);              /* 유리질감(지원 브라우저) */
  -webkit-backdrop-filter:blur(2px);
  transition:transform .15s ease, background .15s ease;
}
.photo-grid-item .el-overlay .el-info .btn:hover{
  background:rgba(255,255,255,.25);
  transform:translateY(-1px);
}
.photo-grid-item .el-overlay .el-info .ti{
  font-size:1.25rem;
  line-height:1;
}

/* 접근성: 키보드 포커스 테두리 */
.photo-grid-item .el-overlay .el-info .btn:focus{
  outline:3px solid rgba(255,255,255,.7);
  outline-offset:2px;
}


/* 섹션 헤더(아이콘+제목+우측 보조정보) */
.section-header{
  display:flex; align-items:center; justify-content:space-between;
  margin-bottom:.5rem;
}
.section-header .title{
  display:flex; align-items:center; gap:.5rem;
  font-weight:700; letter-spacing:.2px;
}
.section-header .title .ti{ font-size:1.15rem; opacity:.85; }

/* 설명 박스(텍스트에어리어 느낌) */
.desc-box{
  white-space: pre-line;            /* 엔터 그대로 표시 */
  min-height:120px;
  background:var(--bs-body-bg);
  border:1px solid var(--bs-border-color);
  border-radius:.75rem;
  padding:.9rem 1rem;
  line-height:1.6;
  font-size:1rem;
}

/* 빈 상태 박스 (사진 없을 때) */
.empty-state{
  display:flex; align-items:center; gap:.6rem;
  background:var(--bs-light-bg-subtle, #f8f9fa);
  border:1px dashed var(--bs-border-color);
  color:var(--bs-secondary-color);
  border-radius:.75rem;
  padding:.9rem 1rem;
}
.empty-state .ti{ font-size:1.2rem; opacity:.9; }

/* 사진 섹션 작은 툴바 느낌 */
.section-meta{
  display:flex; align-items:center; gap:.5rem;
}
.section-meta .badge{ font-weight:600; }
.section-meta .hint{ color:var(--bs-secondary-color); font-size:.85rem; }
	</style>
</head>



<body>
<%@ include file="/module/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />



<%-- [수정된 부분] 최종 권한 플래그 계산 --%>
<sec:authentication property="principal.member" var="loginUser"/>
<c:set var="ADMIN_EMP_NO" value="202508001" />

<%-- 1. 관리자 여부 확인 --%>
<c:set var="isAdmin" value="${loginUser.empNo eq ADMIN_EMP_NO}" />

<%-- 2. Controller에서 넘겨준 권한 플래그 (작성자 OR 일감 담당자) --%>
<c:set var="canTaskEdit" value="${canEdit}" />
<c:set var="canTaskDelete" value="${canDelete}" />

<%-- 최종 수정/삭제 권한: (작성자 OR 일감 담당자) OR 관리자 --%>
<c:set var="hasFinalEditAuth" value="${canTaskEdit or isAdmin}" />
<c:set var="hasFinalDeleteAuth" value="${canTaskDelete or isAdmin}" />
<%-- [수정 끝] 최종 권한 플래그 계산 --%>





<div class="body-wrapper">
  <div class="container-fluid">
	<div class="body-wrapper">
        <div class="container">

<%--  여기 카드가 이제 정상 출력됨 --%>
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
                      <a class="text-muted text-decoration-none" href="/project/dashboard?prjctNo=${prjctNo}">Project</a>
                    </li>
                    <li class="breadcrumb-item">
                      <%-- ✅ 이중 슬래시 제거 --%>
                      <a class="text-muted text-decoration-none" href="/project/tasks?prjctNo=${prjctNo}">Tasks</a>
                    </li>
                    <li class="breadcrumb-item" aria-current="page">Tasks Detail</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </div>



    <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

    <!-- 상단 타이틀 -->
    <div class="mt-3 mb-2">
      <h3 class="mb-1 d-flex align-items-center gap-2">
        <c:out value="${task.taskTitle}" />
        <c:if test="${task.emrgncyYn eq 'Y'}">
          <span class="badge bg-danger">긴급</span>
        </c:if>
      </h3>
      <div class="text-muted small">
        일감번호: <strong><c:out value="${task.taskNo}"/></strong>
        · 등록일: <c:out value="${task.taskRegYmd}"/>
        <c:if test="${not empty task.taskMdfcnYmd}"> · 수정일: <c:out value="${task.taskMdfcnYmd}"/></c:if>
      </div>
    </div>

    <div class="row g-3">
      <!-- 좌측: 상세설명 + 첨부파일 + 액션 버튼 -->
      <div class="col-12 col-lg-8">
        <div class="card mb-3">
          <div class="card-body">
           
           <!-- 상세설명 -->
<div class="mb-4">
  <div class="section-header">
    <div class="title">
      <i class="ti ti-notes"></i>
      <span>상세 설명</span>
    </div>
    <div class="section-meta">
      <span class="hint">줄바꿈/공백 보존</span>
    </div>
  </div>

  <div class="desc-box">
    <c:choose>
      <c:when test="${not empty task.taskCn}">
        ${fn:escapeXml(task.taskCn)}
      </c:when>
      <c:otherwise>(내용 없음)</c:otherwise>
    </c:choose>
  </div>
</div>

<%-- ===== 파일 존재/유형/카운트 계산 ===== --%>
<c:set var="hasAnyFiles" value="${not empty files}"/>
<c:set var="hasImage" value="false"/>
<c:set var="hasOther" value="false"/>
<c:set var="imgCount" value="0"/>

<c:if test="${hasAnyFiles}">
  <c:forEach var="f" items="${files}">
    <c:choose>
      <c:when test="${not empty f.fileMime and fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
        <c:set var="hasImage" value="true"/>
        <c:set var="imgCount" value="${imgCount + 1}"/>
      </c:when>
      <c:otherwise>
        <c:set var="hasOther" value="true"/>
      </c:otherwise>
    </c:choose>
  </c:forEach>
</c:if>

<!-- 사진 섹션 -->
<div class="mb-4">
  <div class="section-header">
    <div class="title">
      <i class="ti ti-photo"></i>
      <span>사진</span>
    </div>
    <div class="section-meta">
      <span class="badge rounded-pill text-bg-secondary">${imgCount}장</span>
      <span class="hint">썸네일을 눌러 크게 보기</span>
    </div>
  </div>

  <c:choose>
    <c:when test="${hasImage}">
      <div class="photo-grid" id="photoGrid">
        <c:set var="imgIdx" value="0"/>
        <c:forEach var="f" items="${files}">
          <c:if test="${not empty f.fileMime and fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
            <div class="photo-grid-item" data-index="${imgIdx}">
              <img class="photo-grid-img" src="${ctx}${f.filePath}" alt="${f.originalNm}">
              <!-- 오버레이: 미리보기 / 다운로드 -->
              <div class="el-overlay w-100 overflow-hidden">
                <ul class="list-style-none el-info text-white text-uppercase d-inline-block p-0">
                  <li class="el-item d-inline-block my-0 mx-1">
                    <a class="btn default btn-outline text-white border-white js-preview"
                       href="javascript:void(0)"
                       data-src="${ctx}/upload/${f.savedNm}">
                      <i class="ti ti-search"></i>
                    </a>
                  </li>
                  <li class="el-item d-inline-block my-0 mx-1">
                    <a class="btn default btn-outline text-white border-white"
                       href="${ctx}/project/photos/download/${f.savedNm}">
                      <i class="ti ti-download"></i>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <c:set var="imgIdx" value="${imgIdx + 1}"/>
          </c:if>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <i class="ti ti-photo-off"></i>
        <span>업로드된 사진이 없습니다.</span>
      </div>
    </c:otherwise>
  </c:choose>
</div>

            <!-- ===== 비이미지 첨부 섹션 ===== -->
            <c:if test="${hasOther}">
              <div class="form-section-title">첨부 파일</div>
              <div class="list-group mb-2">
                <c:forEach var="f" items="${files}">
                  <c:if test="${empty f.fileMime or not fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
                    <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                       href="${ctx}${f.filePath}" download>
                      <span class="d-inline-flex align-items-center gap-2">
                        <i class="ti ti-file-text"></i>
                        <span class="text-truncate" style="max-width: 420px;">
                          <c:out value="${f.originalNm}"/>
                        </span>
                      </span>
                      <small class="text-muted"><c:out value="${f.fileFancysize}"/></small>
                    </a>
                  </c:if>
                </c:forEach>
              </div>
            </c:if>

            <!-- ===== 액션 버튼 (목록/수정/삭제) : card-body 맨 아래 ===== -->
            <div class="d-flex justify-content-between mt-4">
              <a href="${ctx}/project/tasks?prjctNo=${prjctNo}" class="btn btn-outline-secondary">
                <i class="ti ti-list"></i> 목록으로
              </a>

              <%-- [수정된 부분] 최종 권한 플래그 적용 --%>
              <c:if test="${hasFinalEditAuth or hasFinalDeleteAuth}">
                <div>
                   <c:if test="${hasFinalEditAuth}">
                    <%-- 수정: tasks/insert로 경로 지정 및 status=u, taskNo 전달 --%>
                    <a href="${ctx}/project/tasks/insert?prjctNo=${prjctNo}&taskNo=${task.taskNo}&status=u"
                       class="btn btn-warning me-2">
                      <i class="ti ti-edit"></i> 수정
                    </a>
                  </c:if>
                  <c:if test="${hasFinalDeleteAuth}">
                    <button type="button" class="btn btn-danger" id="btnDelete"
                            data-task-no="${task.taskNo}" data-prjct-no="${prjctNo}">
                      <i class="ti ti-trash"></i> 삭제
                    </button>
                  </c:if>
                </div>
              </c:if>
              <%-- [수정 끝] 최종 권한 플래그 적용 --%>
            </div>
          </div>
        </div>
      </div>

      <!-- 우측: 진행률 + 기본정보 -->
      <div class="col-12 col-lg-4">
        <!-- 진행률 -->
        <div class="card mb-3">
          <div class="card-body">
           <div class="form-section-title fw-bold mb-2">진행률</div>
			<div class="progress" style="height: 26px;">
			  <div class="progress-bar bg-success" role="progressbar"
			       style="width: ${task.taskProgrs}%;"
			       aria-valuenow="${task.taskProgrs}" aria-valuemin="0" aria-valuemax="100">
			       ${task.taskProgrs}%
			  </div>
			</div>
            <div class="small text-muted mt-2">진행률 변경은 <strong>수정</strong> 화면에서 가능합니다.</div>
          </div>
        </div>

<!-- 기본 정보  -->
<div class="card mb-3">
  <div class="card-body">
    <div class="info-card-title form-section-title">기본 정보</div>

    <!-- 상태/유형/긴급 배지 -->
    <div class="badge-deck">
      <span class="badge text-bg-primary text-white
        <c:choose>
          <c:when test="${task.taskProgrs == 0}">badge text-bg-secondary</c:when>
          <c:when test="${task.taskProgrs == 90}">badge text-bg-primary</c:when>
          <c:when test="${task.taskProgrs == 100}">badge text-bg-success</c:when>
          <c:otherwise>badge text-bg-info</c:otherwise>
        </c:choose>">
        ${task.taskSttus}
      </span>

       <!-- 유형 -->
		  <c:if test="${not empty task.procsTy}">
		    <span class="badge text-bg-warning text-white">
		      ${task.procsTy}
		    </span>
		  </c:if>
    </div>

    <!-- Key-Value Grid -->
    <div class="kv-grid">
      <div class="kv-row">
        <div class="kv-key"><i class="ti ti-user"></i><span>담당자</span></div>
        <div class="kv-val text-truncate">
          ${task.taskChargerNm}
          <c:if test="${not empty task.taskCharger}">(${task.taskCharger})</c:if>
        </div>
      </div>

      <div class="kv-divider"></div>

      <div class="kv-row">
        <div class="kv-key"><i class="ti ti-calendar-event"></i><span>시작일</span></div>
        <div class="kv-val">${task.taskBeginYmd}</div>
      </div>

      <div class="kv-row">
        <div class="kv-key"><i class="ti ti-calendar-check"></i><span>마감일</span></div>
        <div class="kv-val">${task.taskDdlnYmd}</div>
      </div>

      <div class="kv-divider"></div>

      <div class="kv-row">
        <div class="kv-key"><i class="ti ti-progress-check"></i><span>진행률</span></div>
        <div class="kv-val">
          <span class="progress-chip"><span class="dot"></span>${task.taskProgrs}%</span>
        </div>
      </div>
    </div>
  </div>
</div>

  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<!-- 미리보기 모달 -->
<div class="modal fade" id="photoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl">
    <div class="modal-content bg-dark">
      <div class="modal-body p-0 position-relative">
        <button type="button" class="btn-close btn-close-white position-absolute end-0 m-3 z-3"
                data-bs-dismiss="modal" aria-label="Close"></button>
        <img id="modalImg" src="" class="w-100 h-100 object-fit-contain" style="max-height:85vh;">
        <button type="button" id="modalPrev"
                class="btn btn-light btn-lg rounded-circle shadow position-absolute top-50 start-0 translate-middle-y ms-2 z-3">&#10094;</button>
        <button type="button" id="modalNext"
                class="btn btn-light btn-lg rounded-circle shadow position-absolute top-50 end-0 translate-middle-y me-2 z-3">&#10095;</button>
      </div>
    </div>
  </div>
</div>

<script>
$(function () {
	  // ===== SweetAlert2 삭제 플로우 =====
	  $("#btnDelete").on("click", function () {
	    const taskNo  = $(this).data("task-no");
	    const prjctNo = $(this).data("prjct-no");
	    if (!taskNo || !prjctNo) return;

	    Swal.fire({
	      title: '삭제하시겠어요?',
	      text: '삭제 후에는 복구할 수 없습니다.',
	      icon: 'warning',
	      showCancelButton: true,
	      confirmButtonText: '삭제',
	      cancelButtonText: '취소',
	      reverseButtons: true,
	      buttonsStyling: false,
	      customClass: {
	        confirmButton: 'btn btn-danger me-2',
	        cancelButton:  'btn btn-secondary'
	      }
	    }).then(function (result) {
	      if (!result.isConfirmed) return;

	      $.ajax({
	        url: "${ctx}/project/tasks/delete",
	        type: "POST",
	        data: { taskNo: taskNo, prjctNo: prjctNo },
	        success: function (res) {
	          if (res === "SUCCESS") {
	            Swal.fire({
	              icon: 'success',
	              title: '삭제 완료',
	              text: '일감이 삭제되었습니다.',
	              confirmButtonText: '확인',
	              buttonsStyling: false,
	              customClass: { confirmButton: 'btn btn-primary' }
	            }).then(function () {
	              window.location.href = "${ctx}/project/tasks?prjctNo=" + prjctNo;
	            });
	          } else {
	            Swal.fire({
	              icon: 'error',
	              title: '삭제 실패',
	              text: '삭제에 실패했습니다.',
	              confirmButtonText: '확인',
	              buttonsStyling: false,
	              customClass: { confirmButton: 'btn btn-danger' }
	            });
	          }
	        },
	        error: function () {
	          Swal.fire({
	            icon: 'error',
	            title: '오류',
	            text: '삭제 중 오류가 발생했습니다.',
	            confirmButtonText: '확인',
	            buttonsStyling: false,
	            customClass: { confirmButton: 'btn btn-danger' }
	          });
	        }
	      });
	    });
	  });


  // ===== 사진 미리보기 모달 =====
  var $grid = $("#photoGrid");
  var imgSrcList = [];
  // 수집
  $grid.find(".js-preview").each(function(){
    imgSrcList.push($(this).data("src"));
  });

  var cur = 0;
  var $modal = $("#photoModal");
  var $modalImg = $("#modalImg");
  var $prev = $("#modalPrev");
  var $next = $("#modalNext");

  function renderModal(){
    if (!imgSrcList.length) return;
    $modalImg.attr("src", imgSrcList[cur]);
    if (imgSrcList.length <= 1){
      $prev.hide(); $next.hide();
    } else {
      $prev.show(); $next.show();
    }
  }

  // 썸네일 클릭 → 모달 오픈
  $grid.on("click", ".js-preview", function(){
    var src = $(this).data("src");
    cur = imgSrcList.indexOf(src);
    if (cur < 0) cur = 0;
    renderModal();
    var bsModal = new bootstrap.Modal(document.getElementById('photoModal'));
    bsModal.show();
  });

  // Prev/Next
  $prev.on("click", function(){
    if (!imgSrcList.length) return;
    cur = (cur - 1 + imgSrcList.length) % imgSrcList.length;
    renderModal();
  });
  $next.on("click", function(){
    if (!imgSrcList.length) return;
    cur = (cur + 1) % imgSrcList.length;
    renderModal();
  });

  // 키보드 네비게이션 (모달 열려 있을 때만)
  $(document).on("keydown", function(e){
    if (!$modal.hasClass("show")) return;
    if (e.key === "ArrowLeft") { $prev.click(); }
    else if (e.key === "ArrowRight") { $next.click(); }
  });
});
</script>

</body>
</html>
