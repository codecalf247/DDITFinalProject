<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 현장 자료 수정</title>
  <%@ include file="/module/headPart.jsp" %>
  <style>
    .form-section-title{font-weight:600;}
    .file-thumb{width:100%;height:160px;object-fit:cover;border-radius:.5rem;background:#f8f9fa;}
    .file-tile{width:100%;height:160px;border-radius:.5rem;}
    .existing-attachment{position:relative;}
    .existing-attachment .overlay-deleted{
      position:absolute;inset:0;display:none;background:rgba(220,53,69,.12);
      border:2px dashed rgba(220,53,69,.65);color:#dc3545;font-weight:600;
      align-items:center;justify-content:center;text-align:center;padding:1rem;font-size:.95rem;
    }
    .existing-attachment.deleted .overlay-deleted{display:flex;}
    .btn-mark-delete.active{border-color:#dc3545!important;color:#dc3545!important;background:#fff!important;}
  </style>
</head>

<body>
<%@ include file="/module/header.jsp" %>
<%@ include file="/module/aside.jsp" %>

<div class="body-wrapper">
  <div class="container-fluid">
    <div class="container">

      <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

      <!-- ===== 상단: 제목 + 버튼 (폼 밖) ===== -->
      <div class="d-flex justify-content-between align-items-start mt-4 mb-3">
        <div>
          <h3 class="mb-1">현장 자료 수정</h3>
          <div class="text-muted small">
            이슈번호: <strong>${detail.issueId}</strong>
            · 작성일: ${detail.createdAt}
            · 최종수정: ${detail.updatedAt}
          </div>
        </div>
        <div class="btn-group">
          <a href="/site/issues" class="btn btn-outline-secondary" id="listBtn">목록</a>
          <button type="button" class="btn btn-outline-success" id="updateBtn">수정</button>
          <button type="button" class="btn btn-outline-danger" id="cancelBtn">취소</button>
        </div>
      </div>

      <!-- ===== 아래: 수정 폼 ===== -->
      <form id="editForm" class="needs-validation" novalidate enctype="multipart/form-data">
        <input type="hidden" name="issueId" value="${detail.issueId}"/>

        <!-- 기본 정보 -->
        <div class="card mb-3">
          <div class="card-body">
            <div class="row g-3">
              <!-- 제목 -->
              <div class="col-12">
                <label class="form-label">제목 <span class="text-danger">*</span></label>
                <input type="text" name="title" id="title" class="form-control" required
                       value="${detail.title}" placeholder="제목을 입력하세요."/>
                <div class="invalid-feedback">제목을 입력해주세요.</div>
              </div>

              <!-- 내용 -->
              <div class="col-12">
                <label class="form-label">내용</label>
                <textarea class="form-control" name="description" id="description" rows="5" maxlength="1000"
                          placeholder="상세 내용을 입력하세요. (최대 1000자)">${detail.description}</textarea>
                <div class="d-flex justify-content-between">
                  <div class="form-text">현장 관련 맥락/변경 사항을 간단히 남겨주세요.</div>
                  <div class="form-text"><span id="descCount">0</span> / 1000</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 첨부파일 -->
        <div class="card mb-4">
          <div class="card-body">
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
              <!-- 실제에선 서버에서 ${detail.attachments} 루프 -->
              <!-- 예시: 이미지 -->
              <div class="col-6 col-md-4 col-lg-3">
                <div class="existing-attachment rounded-3" data-file-id="501">
                  <input type="checkbox" class="delete-check d-none" name="deleteFileIds" value="501" id="del-501">
                  <button type="button" class="btn btn-sm btn-light border btn-mark-delete mb-2" data-file-id="501">
                    <i class="ti ti-trash me-1"></i>삭제
                  </button>
                  <a href="/uploads/site_photo1.jpg" class="text-decoration-none" download>
                    <div class="position-relative">
                      <img src="/uploads/site_photo1.jpg" alt="site_photo1.jpg" class="file-thumb shadow-sm">
                      <div class="overlay-deleted rounded-3">삭제 예정</div>
                    </div>
                    <div class="mt-2 small text-truncate text-dark text-center px-2">site_photo1.jpg</div>
                  </a>
                  <div class="mt-1 text-muted small text-center">1.2MB</div>
                </div>
              </div>

              <!-- 예시: 문서 -->
              <div class="col-6 col-md-4 col-lg-3">
                <div class="existing-attachment rounded-3" data-file-id="502">
                  <input type="checkbox" class="delete-check d-none" name="deleteFileIds" value="502" id="del-502">
                  <button type="button" class="btn btn-sm btn-light border btn-mark-delete mb-2" data-file-id="502">
                    <i class="ti ti-trash me-1"></i>삭제
                  </button>
                  <a href="/uploads/site-spec.pdf" class="text-decoration-none" download>
                    <div class="position-relative file-tile bg-light-subtle border d-flex justify-content-center align-items-center">
                      <i class="ti ti-file-text fs-1 text-muted"></i>
                      <div class="overlay-deleted rounded-3">삭제 예정</div>
                    </div>
                    <div class="mt-2 small text-muted text-center px-2 text-truncate">site-spec.pdf</div>
                  </a>
                  <div class="mt-1 text-muted small text-center">240KB</div>
                </div>
              </div>
            </div>
          </div>
        </div> <!-- /첨부 카드 -->

      </form> <!-- /editForm -->

    </div> <!-- /container -->
  </div> <!-- /container-fluid -->
</div> <!-- /body-wrapper -->

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<%@ include file="/module/footerPart.jsp" %>

<script>
(function(){
  const issueId = "${detail.issueId}" || "";

  // 상단 버튼
  document.getElementById("listBtn").addEventListener("click", function(e){
    e.preventDefault(); location.href = "/site/issues";
  });
  document.getElementById("cancelBtn").addEventListener("click", function(){
    location.href = "/site/issues/detail?issueId=" + encodeURIComponent(issueId);
  });
  document.getElementById("updateBtn").addEventListener("click", function(){
    document.getElementById("editForm").dispatchEvent(new Event("submit", {cancelable:true}));
  });

  // 글자수 카운트
  const desc = document.getElementById("description");
  const descCount = document.getElementById("descCount");
  const updateCount = ()=> { if(desc && descCount){ descCount.textContent = (desc.value||"").length; } };
  if(desc){ desc.addEventListener("input", updateCount); updateCount(); }

  // 부트스트랩 검증
  (function () {
    const form = document.getElementById('editForm');
    form.addEventListener('submit', function (event) {
      if (!form.checkValidity()) { event.preventDefault(); event.stopPropagation(); }
      form.classList.add('was-validated');
      if (form.checkValidity()) {
        saveForm(); // 유효하면 저장
      }
    }, false);
  })();

  // 기존 첨부 삭제 토글
  document.addEventListener("click", function(e){
    const btn = e.target.closest(".btn-mark-delete");
    if(!btn) return;
    const id = btn.getAttribute("data-file-id");
    const wrap = document.querySelector('.existing-attachment[data-file-id="'+id+'"]');
    const chk  = document.getElementById('del-'+id);
    if(!wrap || !chk) return;
    const willDelete = !chk.checked;
    chk.checked = willDelete;
    wrap.classList.toggle("deleted", willDelete);
    btn.classList.toggle("active", willDelete);
    btn.blur();
  });

  function saveForm(){
    const form = document.getElementById("editForm");
    const fd = new FormData(form);
    fd.append("issueId", issueId);

    const fileInput = document.getElementById("files");
    if(fileInput && fileInput.files && fileInput.files.length){
      for(const f of fileInput.files){ fd.append("files", f, f.name); }
    }

    fetch("/site/issues/update", {
      method: "POST",
      body: fd
    }).then(r=>{
      if(!r.ok) throw new Error("fail");
      return r.text();
    }).then(()=>{
      Swal.fire({icon:'success', title:'수정 완료', timer:1200, showConfirmButton:false});
      setTimeout(()=> location.href = "/site/issues/detail?issueId="+encodeURIComponent(issueId), 1200);
    }).catch(()=>{
      Swal.fire({icon:'error', title:'수정 실패', text:'잠시 후 다시 시도해주세요.'});
    });
  }
})();
</script>
</body>
</html>
