<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare | 프로젝트 사진 수정</title>
  <%@ include file="/module/headPart.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/dropzone/dist/min/dropzone.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css" />
  <style>
    .category-row .btn { min-width: 96px; }
    .dz-preview .dz-image { border-radius: .5rem; overflow: hidden; }
    .dz-message { padding: 24px; border: 2px dashed var(--bs-border-color); border-radius: .75rem; }
    .photo-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:16px}
    @media (max-width:1400px){.photo-grid{grid-template-columns:repeat(4,1fr)}}
    @media (max-width:992px){.photo-grid{grid-template-columns:repeat(3,1fr)}}
    @media (max-width:768px){.photo-grid{grid-template-columns:repeat(2,1fr)}}
    @media (max-width:480px){.photo-grid{grid-template-columns:repeat(1,1fr)}}
    .photo-item{position:relative;border-radius:.75rem;overflow:hidden;box-shadow:0 1px 2px rgba(16,24,40,.06)}
    .photo-item img{width:100%;height:180px;object-fit:cover;display:block}
    .photo-check{position:absolute;top:8px;left:8px;background:rgba(255,255,255,.9);border-radius:.5rem;padding:6px 8px}
     .photo-item.selected { outline: 3px solid rgba(220,53,69,.5); }
  </style>
</head>
<body>
<%@ include file="/module/header.jsp" %>
<%@ include file="/module/aside.jsp" %>

<div class="body-wrapper">
  <div class="container-fluid">
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 사진 수정</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${project.prjctNo}">Photo</a></li>
                <li class="breadcrumb-item" aria-current="page">Update</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-body">
        <h4 class="fw-semibold mb-4">사진 수정</h4>

        <form id="photoUpdateForm" action="${pageContext.request.contextPath}/project/photos/update" method="post" class="needs-validation" novalidate>
          <input type="hidden" name="prjctNo" value="${project.prjctNo}">
          <input type="hidden" name="sptPhotoNo" value="${photo.sptPhotoNo}">

          <div class="row g-4">
            <div class="col-12">
              <label for="sptPhotoTitle" class="form-label">제목 <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="sptPhotoTitle" name="sptPhotoTitle" maxlength="100"
                     placeholder="YYYY년 MM월 DD일로 입력해주세요" required
                     value="${fn:escapeXml(photo.sptPhotoTitle)}"/>
              <div class="invalid-feedback">제목을 입력해 주세요.</div>
            </div>

            <div class="col-12">
              <label class="form-label d-block mb-2">공정유형</label>
              <div class="d-flex flex-wrap gap-2" id="category-group">
                <c:forEach var="cat" items="${categoryCodes}">
                  <c:set var="checked" value="false"/>
                  <c:forEach var="sel" items="${selectedCodes}">
                    <c:if test="${sel eq cat.cmmnCdId}">
                      <c:set var="checked" value="true"/>
                    </c:if>
                  </c:forEach>
                  <label class="btn bg-primary-subtle text-primary <c:if test='${checked}'>active</c:if>">
                    <div class="form-check m-0">
                      <input type="checkbox" class="form-check-input" name="category" value="${cat.cmmnCdId}" autocomplete="off"
                             <c:if test="${checked}">checked</c:if>>
                      <span class="form-check-label">${cat.cmmnCdNm}</span>
                    </div>
                  </label>
                </c:forEach>
              </div>
            </div>

            <!-- 새 사진 첨부 -->
            <div class="col-12">
              <label class="form-label d-flex align-items-center gap-2 mb-2">
                사진 첨부 <span class="text-muted">(여러 장 가능 · 첫 번째가 썸네일)</span>
              </label>
              <div id="photoDropzone" class="dropzone border-0 p-0">
                <div class="dz-message needsclick">
                  <i class="ti ti-upload fs-4 d-block mb-2"></i>
                  <p class="mb-1">여기로 파일을 끌어다 놓거나 클릭하여 선택</p>
                  <span class="text-muted">이미지 파일만 업로드하세요.</span>
                </div>
              </div>
              <div class="form-text mt-2">가장 먼저 업로드된 이미지가 썸네일로 사용됩니다.</div>
            </div>

            <!-- 기존 업로드된 사진들 -->
            <div class="col-12">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <h5 class="mb-0">업로드된 사진들</h5>
                <button type="button" class="btn btn-outline-danger btn-sm" id="deleteSelectedBtn">
                  <i class="ti ti-trash"></i> 선택 삭제(표시만)
                </button>
              </div>
              <div class="photo-grid" id="existingGrid">
                <c:forEach var="f" items="${photo.fileList}">
                  <div class="photo-item" data-file-no="${f.fileNo}">
                    <label class="photo-check d-flex align-items-center gap-2">
                      <input type="checkbox" class="form-check-input delete-check" value="${f.fileNo}">
                      <span class="small">삭제</span>
                    </label>
                    <img src="${pageContext.request.contextPath}/upload/${f.savedNm}" alt="${fn:escapeXml(f.originalNm)}">
                  </div>
                </c:forEach>
                <c:if test="${empty photo.fileList}">
                  <div class="text-muted py-5" style="grid-column:1/-1;">등록된 사진이 없습니다.</div>
                </c:if>
              </div>
            </div>
          </div>

          <hr class="my-4" />
          <div class="d-flex justify-content-end gap-2">
            <a href="${pageContext.request.contextPath}/project/photos/detail/${photo.sptPhotoNo}?prjctNo=${project.prjctNo}" class="btn btn-light">취소</a>
            <button type="submit" class="btn btn-primary" id="submitBtn">수정 완료</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/dropzone/dist/min/dropzone.min.js"></script>
<script>
// Dropzone 자동탐지 끄기
if (window.Dropzone) { Dropzone.autoDiscover = false; }

// 컨텍스트 경로 (절대경로 보장)
const contextPath = '${pageContext.request.contextPath}';

$(function () {
  const $form           = $('#photoUpdateForm');
  const $categoryGroup  = $('#category-group');
  const $existingGrid   = $('#existingGrid');
  const $deleteBtn      = $('#deleteSelectedBtn');
  const prjctNo         = $form.find('input[name="prjctNo"]').val();

  // 공정유형 버튼 클릭 → 체크 토글
  $categoryGroup.on('click', '.btn', function (e) {
    const $btn = $(this);
    const $chk = $btn.find('input[type="checkbox"]');
    if ($chk.length === 0) return;
    $chk.prop('checked', !$chk.prop('checked'));
    $btn.toggleClass('active', $chk.prop('checked'));
  });

  // 기존 사진: 아무곳이나 클릭해도 선택 토글 (체크박스 직접 클릭은 기본 동작)
  $existingGrid.on('click', '.photo-item', function (e) {
    if ($(e.target).is('input.delete-check')) return; // 체크박스 직접 클릭은 제외
    const $item = $(this);
    const $chk  = $item.find('.delete-check');
    const now   = !$chk.prop('checked');
    $chk.prop('checked', now);
    $item.toggleClass('selected', now);
  });

  // Dropzone (새 파일 큐만 관리, 전송은 우리가 FormData로)
  const dz = new Dropzone('#photoDropzone', {
    url: $form.attr('action'),   // 사용 안 하지만 필수 옵션이라 채움
    paramName: 'files',
    uploadMultiple: true,
    parallelUploads: 10,
    maxFilesize: 20,             // MB
    acceptedFiles: 'image/*',
    addRemoveLinks: true,
    autoProcessQueue: false
  });

  // ✅ 선택 삭제(즉시 서버 반영 + 화면 제거) — jQuery AJAX, CSRF 안 씀
  $deleteBtn.on('click', function () {
    const $checked = $existingGrid.find('.delete-check:checked');
    if ($checked.length === 0) {
      Swal.fire({ icon: 'info', title: '선택 없음', text: '삭제할 사진을 먼저 선택해 주세요.' });
      return;
    }
    const fileNos = $checked.map(function () { return this.value; }).get();

    Swal.fire({
      icon: 'warning',
      title: '선택 삭제',
      text: '선택한 사진을 바로 삭제합니다. 계속할까요?',
      showCancelButton: true,
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then(function (res) {
      if (!res.isConfirmed) return;

      $.ajax({
        url: contextPath + '/project/photos/delete-files', // ✅ 절대경로
        type: 'POST',
        dataType: 'json',
        data: {
          // sptPhotoNo 서버에서 안쓰면 제외해도 됨. 안전하게 같이 보냄
          sptPhotoNo: $form.find('input[name="sptPhotoNo"]').val(),
          'fileNos[]': fileNos            // 배열 전송
        },
        success: function (data) {
          if (!data || !data.success) {
            Swal.fire({ icon: 'error', title: '삭제 실패', text: (data && data.message) || '다시 시도해 주세요.' });
            return;
          }
          // 화면에서도 삭제
          data.deleted.forEach(function (no) {
            $existingGrid.find('.photo-item[data-file-no="' + no + '"]').remove();
          });
          Swal.fire({ icon: 'success', title: '삭제 완료', timer: 900, showConfirmButton: false });
        },
        error: function (xhr) {
          console.error(xhr);
          Swal.fire({ icon: 'error', title: '오류', text: '삭제 중 문제가 발생했습니다.' });
        }
      });
    });
  });

  // ✅ 수정 완료(제출): 제목/공정유형 업데이트 + (남아있다면) 삭제 + 새 파일 추가
  $('#submitBtn').on('click', function (e) {
    e.preventDefault();

    // 기본 검증
    if (!$form[0].checkValidity()) {
      $form.addClass('was-validated');
      return;
    }

    const fd = new FormData($form[0]); // prjctNo, sptPhotoNo, sptPhotoTitle 포함

    // 공정유형 (체크된 것만)
    $categoryGroup.find('input[name="category"]:checked').each(function () {
      fd.append('category', this.value);
    });

    // 혹시 즉시삭제 버튼을 누르지 않고 체크만 한 항목이 남아있다면, 제출 시 삭제 처리도 함께
    $existingGrid.find('.delete-check:checked').each(function () {
      fd.append('deleteFileNos[]', this.value);
    });

    // 새 파일 추가 (Dropzone 큐에서)
    dz.getQueuedFiles().forEach(function (file) {
      fd.append('files[]', file, file.name);
    });

    // (선택) 모든 기존 사진을 삭제했고 새 사진도 없으면 경고
    const remainingCount = $existingGrid.find('.photo-item').length;
    if (remainingCount === 0 && dz.getQueuedFiles().length === 0) {
      Swal.fire({ icon: 'warning', title: '사진 없음', text: '모든 사진을 삭제했습니다. 새 사진을 한 장 이상 추가해 주세요.' });
      return;
    }

    // jQuery AJAX로 FormData 전송
    $.ajax({
      url: $form.attr('action'), // /project/photos/update
      type: 'POST',
      data: fd,
      processData: false, // FormData 그대로
      contentType: false, // FormData 그대로
      dataType: 'json',
      success: function (data) {
        if (data && data.success) {
          Swal.fire({ icon: 'success', title: '수정 완료', text: data.message, timer: 1200, showConfirmButton: false })
            .then(function () {
              window.location.href = contextPath + '/project/photos/list?prjctNo=' + prjctNo;
            });
        } else {
          Swal.fire({ icon: 'error', title: '오류', text: (data && data.message) || '수정에 실패했습니다.' });
        }
      },
      error: function (xhr) {
        console.error(xhr);
        Swal.fire({ icon: 'error', title: '통신 오류', text: '잠시 후 다시 시도해 주세요.' });
      }
    });
  });
});
</script>
</body>
</html>
