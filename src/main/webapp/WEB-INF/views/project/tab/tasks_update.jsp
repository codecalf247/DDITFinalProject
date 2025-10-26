<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - Task Modify</title>
  <%@ include file="/module/headPart.jsp" %>

  <style>
    .file-thumb{width:100%;height:140px;object-fit:cover;border-radius:.5rem;}
    .file-tile{height:140px;border-radius:.5rem;}
    .form-section-title{font-weight:600;font-size:.95rem;text-transform:uppercase;color:var(--bs-secondary-color);margin-bottom:.75rem;}
    .progress-lg{height:26px;}
    /* 삭제 토글 표시 */
    .existing-attachment{position:relative}
    .overlay-deleted{
      display:none; position:absolute; inset:0;
      background:rgba(220,53,69,.12); border:2px dashed #dc3545; border-radius:.5rem;
      align-items:center; justify-content:center; font-weight:600; color:#dc3545;
    }
    .existing-attachment.deleted .overlay-deleted{display:flex}
    .existing-attachment.deleted img{filter:grayscale(1) opacity(.55)}
    .btn-mark-delete{position:absolute; top:.5rem; right:.5rem; z-index:2}
  </style>
</head>

<%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>

<div class="body-wrapper">
  <div class="container mt-4">

    <%-- [고정] 캐러셀 --%>
    <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

    <%-- 상단 우측 버튼 그룹만 표시 --%>
    <div class="d-flex justify-content-end align-items-start mt-4 mb-3">
      <div class="btn-group">
        <a href="/project/tasks" class="btn btn-outline-secondary" id="listBtn">목록</a>
        <!-- 폼 바깥에서 submit하려면 form 속성으로 연결 -->
        <button type="submit" class="btn btn-outline-success" id="updateBtn" form="taskForm">수정</button>
        <button type="button" class="btn btn-outline-danger" id="cancelBtn">취소</button>
      </div>
    </div>

    <form id="taskForm" class="row g-3" method="post" action="/project/tasks/update" enctype="multipart/form-data" novalidate>
      <input type="hidden" name="taskId" value="101"><!-- 실제: ${task.id} -->
      <input type="hidden" id="progressValue" name="progress" value="30"><!-- 실제: ${task.progress} -->

      <!-- ===== 좌측: 제목 + 상세설명 + 첨부파일 ===== -->
      <div class="col-12 col-lg-8">
        <div class="card mb-3">
          <div class="card-body">
            <!-- 제목 + 긴급 -->
            <div class="mb-3">
              <label for="title" class="form-label">제목</label>
              <input type="text" id="title" name="title" class="form-control" required value="옥실 타일 색상 불일치"><!-- ${task.title} -->
              <div class="invalid-feedback">제목을 입력하세요.</div>
              <div class="form-check mt-2">
                <input class="form-check-input" type="checkbox" value="Y" id="urgent" name="urgent" checked><!-- ${task.priority eq '긴급' ? 'checked' : ''} -->
                <label class="form-check-label" for="urgent">긴급</label>
              </div>
            </div>

            <!-- 상세설명 (크게) -->
            <div class="mb-3">
              <label for="description" class="form-label">상세 설명</label>
              <textarea id="description" name="description" class="form-control fs-5" rows="6" required>욕실 벽면 타일 색상이 발주된 색상과 다릅니다.
발주: 라이트그레이 / 시공: 화이트
현장 확인 후 교체 여부 협의 필요합니다.</textarea><!-- ${task.description} -->
              <div class="invalid-feedback">상세 설명을 입력하세요.</div>
            </div>

            <!-- 새 첨부 업로드 -->
            <div class="mb-2 d-flex align-items-center justify-content-between">
              <div class="form-section-title mb-0">새 첨부 파일</div>
              <small class="text-muted">이미지/문서 파일 업로드 가능</small>
            </div>
            <div class="mb-3">
              <input class="form-control" type="file" id="files" name="files" multiple>
              <div class="form-text">여러 개 선택 가능. (최대 20MB 권장)</div>
            </div>

            <!-- 기존 첨부 목록 + 삭제 토글 -->
            <div class="mb-2 d-flex align-items-center justify-content-between">
              <div class="form-section-title mb-0">기존 첨부 파일</div>
              <small class="text-muted">삭제할 항목을 표시하세요</small>
            </div>

            <div class="row g-3">
              <%-- 실제에선 forEach로 ${task.attachments} 루프 --%>
              <!-- 예시: 이미지(파일ID=501) -->
              <div class="col-6 col-md-4 col-lg-3">
                <div class="existing-attachment" data-file-id="501">
                  <input type="checkbox" class="delete-check d-none" name="deleteFileIds" value="501" id="del-501">
                  <button type="button" class="btn btn-sm btn-light border btn-mark-delete" data-file-id="501">
                    <i class="ti ti-trash me-1"></i>삭제
                  </button>
                  <a href="/uploads/bathroom1.jpg" class="text-decoration-none" download>
                    <div class="position-relative">
                      <img src="/uploads/bathroom1.jpg" alt="bathroom1.jpg" class="file-thumb shadow-sm">
                      <div class="overlay-deleted rounded-3">삭제 예정</div>
                    </div>
                    <div class="mt-2 small text-truncate text-dark">
                      <i class="ti ti-photo me-1"></i>bathroom1.jpg
                    </div>
                  </a>
                  <div class="mt-1 text-muted small">1.2MB</div>
                </div>
              </div>

              <!-- 예시: 문서(파일ID=502) -->
              <div class="col-6 col-md-4 col-lg-3">
                <div class="existing-attachment" data-file-id="502">
                  <input type="checkbox" class="delete-check d-none" name="deleteFileIds" value="502" id="del-502">
                  <button type="button" class="btn btn-sm btn-light border btn-mark-delete" data-file-id="502">
                    <i class="ti ti-trash me-1"></i>삭제
                  </button>
                  <a href="/uploads/spec.pdf" class="text-decoration-none" download>
                    <div class="position-relative file-tile bg-light-subtle border d-flex justify-content-center align-items-center">
                      <i class="ti ti-file-text fs-1 text-muted"></i>
                      <div class="overlay-deleted rounded-3">삭제 예정</div>
                    </div>
                    <div class="mt-2 small text-muted text-center px-2 text-truncate">spec.pdf</div>
                  </a>
                  <div class="mt-1 text-muted small">240KB</div>
                </div>
              </div>
            </div>
            <!-- /기존 첨부 -->
          </div>
        </div>
      </div>

      <!-- ===== 우측: 진행률(±10%) + 기본정보(드롭다운) ===== -->
      <div class="col-12 col-lg-4">
        <!-- 진행률 -->
        <div class="card mb-3">
          <div class="card-body">
            <div class="form-section-title">진행률</div>
            <div class="d-flex align-items-center gap-2 mb-2">
              <button type="button" class="btn btn-outline-secondary btn-sm" id="btnDec">-10%</button>
              <div class="progress flex-grow-1 progress-lg">
                <div class="progress-bar bg-success" id="progressBar"
                     role="progressbar" style="width: 30%;" aria-valuenow="30"
                     aria-valuemin="0" aria-valuemax="100">30%</div>
              </div>
              <button type="button" class="btn btn-outline-secondary btn-sm" id="btnInc">+10%</button>
            </div>
            <small class="text-muted">상태를 바꾸면 진행률이 자동으로 맞춰집니다.</small>
          </div>
        </div>

        <!-- 기본 정보 (드롭다운) -->
        <div class="card mb-3">
          <div class="card-body">
            <div class="form-section-title">기본 정보</div>

            <div class="row g-3">
              <!-- 1) 담당자: 프로젝트 참여 인원 드롭다운 -->
              <div class="col-12">
                <label for="assignee" class="form-label">담당자</label>
                <select id="assignee" name="assigneeId" class="form-select" required>
                  <c:choose>
                    <c:when test="${not empty participants}">
                      <c:forEach var="p" items="${participants}">
                        <option value="${p.id}" <c:if test="${p.id eq task.assigneeId}">selected</c:if>>
                          ${p.name}<c:if test="${not empty p.role}"> (${p.role})</c:if>
                        </option>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <!-- 데모 옵션 -->
                      <option value="u1" selected>김현장 (현장소장)</option>
                      <option value="u2">이대리 (설비)</option>
                      <option value="u3">박기사 (전기)</option>
                    </c:otherwise>
                  </c:choose>
                </select>
                <div class="invalid-feedback">담당자를 선택하세요.</div>
              </div>

              <!-- 2) 공정 유형 -->
              <div class="col-12">
                <label for="processType" class="form-label">공정 유형</label>
                <select id="processType" name="type" class="form-select" required>
                  <c:set var="curType" value="${empty task.type ? '타일' : task.type}" />
                  <c:forEach var="t" items="${fn:split('철거,설비,전기,목공,타일,도배,필름,가구,마감', ',')}">
                    <option value="${t}" <c:if test="${t eq curType}">selected</c:if>>${t}</option>
                  </c:forEach>
                </select>
                <div class="invalid-feedback">공정 유형을 선택하세요.</div>
              </div>

              <!-- 3) 상태 -->
              <div class="col-12">
                <label for="status" class="form-label">상태</label>
                <select id="status" name="status" class="form-select" required>
                  <c:set var="curStatus" value="${empty task.status ? '진행중' : task.status}" />
                  <c:forEach var="s" items="${fn:split('대기,진행중,검토중,완료', ',')}">
                    <option value="${s}" <c:if test="${s eq curStatus}">selected</c:if>>${s}</option>
                  </c:forEach>
                </select>
                <div class="invalid-feedback">상태를 선택하세요.</div>
              </div>

              <!-- 4) 시작일 -->
              <div class="col-12">
                <label for="startDate" class="form-label">시작일</label>
                <input type="date" id="startDate" name="startDate" class="form-control" required value="2025-03-04"><!-- ${task.startDate} -->
                <div class="invalid-feedback">시작일을 선택하세요.</div>
              </div>

              <!-- 5) 마감일 -->
              <div class="col-12">
                <label for="dueDate" class="form-label">마감일</label>
                <input type="date" id="dueDate" name="dueDate" class="form-control" required value="2025-04-15"><!-- ${task.dueDate} -->
                <div class="invalid-feedback">마감일을 선택하세요.</div>
              </div>
            </div>
          </div>
        </div>
      </div> <!-- /우측 -->
    </form>

  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<script>
$(function(){

  /* ================== 요소 캐시 ================== */
  let listBtn     = $("#listBtn");     // 목록 버튼
  let updateBtn   = $("#updateBtn");   // 저장(수정) 버튼
  let cancelBtn   = $("#cancelBtn");   // 취소 버튼
  let taskForm    = $("#taskForm");    // 수정 처리 폼

  // 진행률/상태
  let statusSel   = $("#status");
  let btnDec      = $("#btnDec");
  let btnInc      = $("#btnInc");
  let progressBar = $("#progressBar");
  let progressVal = $("#progressValue");

  // 날짜
  let startDate   = $("#startDate");
  let dueDate     = $("#dueDate");

  /* ================== 유틸/매핑 ================== */
  const statusToProgress = { "대기":0, "진행중":50, "검토중":90, "완료":100 };

  function clamp(v){
    v = parseInt(v || 0, 10);
    return Math.max(0, Math.min(100, v));
  }
  function progressToStatus(v){
    v = parseInt(v || 0, 10);
    if (v === 0)   return "대기";
    if (v === 100) return "완료";
    if (v >= 85 && v <= 95) return "검토중";
    return "진행중";
  }
  function refreshProgressUI(){
    let val = parseInt(progressVal.val() || 0, 10);
    progressBar.css("width", val + "%").attr("aria-valuenow", val).text(val + "%");
  }
  function setProgress(v){
    let val = clamp(v);
    progressVal.val(val);
    refreshProgressUI();
    statusSel.val(progressToStatus(val));
  }
  function validateDates(){
    let s = startDate.val();
    let d = dueDate.val();
    if (s && d && s > d){
      alert("마감일은 시작일 이후여야 합니다.");
      return false;
    }
    return true;
  }

  /* ================== 이벤트 ================== */
  // 목록
  listBtn.on("click", function(e){
    // a 링크이므로 기본 이동 사용. 필요 시 JS로: location.href="/project/tasks";
  });

  // 저장(수정)
  updateBtn.on("click", function(){
    if (!validateDates()) return false;
    taskForm.attr("action", "/project/tasks/update");
    taskForm.attr("method", "post");
    taskForm.submit();
  });

  // 취소
  cancelBtn.on("click", function(){
    let taskId = $("input[name='taskId']").val() || "101";
    location.href = "/project/tasks/detail?taskId=" + encodeURIComponent(taskId);
  });

  // 상태 → 진행률
  statusSel.on("change", function(){
    let sel = $(this).val();
    setProgress(statusToProgress[sel] || 0);
  });

  // 진행률 ±10%
  btnDec.on("click", function(){
    let cur = parseInt(progressVal.val() || 0, 10);
    setProgress(cur - 10);
  });
  btnInc.on("click", function(){
    let cur = parseInt(progressVal.val() || 0, 10);
    setProgress(cur + 10);
  });

  // 기존 첨부 삭제 토글(위임)
  $(document).on("click", ".btn-mark-delete", function(){
    let id   = $(this).data("file-id");
    let wrap = $(".existing-attachment[data-file-id='" + id + "']");
    let chk  = wrap.find(".delete-check");
    let willDelete = !chk.prop("checked");
    chk.prop("checked", willDelete);
    wrap.toggleClass("deleted", willDelete);
  });

  // 엔터 제출 등 폼 submit 시 날짜검증 보강
  taskForm.on("submit", function(e){
    if (!validateDates()){
      e.preventDefault(); e.stopPropagation();
    }
  });

  /* ================== 초기화 ================== */
  setProgress(parseInt(progressVal.val() || 0, 10)); // 진행률/상태 동기화

});
</script>

</body>
</html>
