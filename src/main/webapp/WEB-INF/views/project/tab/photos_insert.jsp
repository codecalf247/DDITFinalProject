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
  <title>GroupWare | 프로젝트 사진 등록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/dropzone/dist/min/dropzone.min.css"/>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css" />
  <style>
    .category-row .btn { min-width: 96px; }
    .dz-preview .dz-image { border-radius: .5rem; overflow: hidden; }
    .dz-message { padding: 24px; border: 2px dashed var(--bs-border-color); border-radius: .75rem; }
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
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 사진 등록</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${prjctNo}">Photo</a></li>
                <li class="breadcrumb-item" aria-current="page">Insert</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>
    
      <%@ include file="/WEB-INF/views/project/carousels.jsp" %>
    
    <div class="card">
      <div class="card-body">
        <h4 class="fw-semibold mb-4">사진 등록</h4>
        <form id="photoInsertForm" action="${pageContext.request.contextPath}/project/photos/insert?prjctNo=${prjctNo}" method="post" class="needs-validation" novalidate>
          <div class="row g-4">
            <div class="col-12">
              <label for="sptPhotoTitle" class="form-label">제목 <span class="text-danger">*</span></label>
		          <input type="text" class="form-control" id="sptPhotoTitle" name="sptPhotoTitle" maxlength="100"
		       placeholder="YYYY년 MM월 DD일로 입력해주세요" required
		       value="${param.sptPhotoTitle}"/>
              <div class="invalid-feedback">제목을 입력해 주세요.</div>
            </div>
            <div class="col-12">
              <label class="form-label d-block mb-2">공정유형</label>
              <div class="d-flex flex-wrap gap-2" id="category-group">
                <c:forEach var="cat" items="${categoryCodes}">
                    <label class="btn bg-primary-subtle text-primary">
                        <div class="form-check m-0">
                            <input type="checkbox" class="form-check-input" name="category" value="${cat.cmmnCdId}" autocomplete="off">
                            <label class="form-check-label">${cat.cmmnCdNm}</label>
                        </div>
                    </label>
                </c:forEach>
              </div>
              <div class="text-danger mt-2 d-none" id="categoryError">공정유형을 한 개 이상 선택해 주세요.</div>
            </div>
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
              <div class="text-danger mt-2 d-none" id="filesError">사진 파일을 한 장 이상 첨부해 주세요.</div>
            </div>
          </div>
          <hr class="my-4" />
          <div class="d-flex justify-content-end gap-2">
            <a href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${prjctNo}" class="btn btn-light">취소</a>
            <button type="submit" class="btn btn-primary" id="submitBtn">등록</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  </div>
  </div>
</div>
<%@ include file="/module/footerPart.jsp" %>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/dropzone/dist/min/dropzone.min.js"></script>


<script>
  if (window.Dropzone) { Dropzone.autoDiscover = false; }

  // ✅ EL로 서버값 주입 (안전)
  var contextPath = '${pageContext.request.contextPath}';
  var prjctNo     = '${prjctNo}';

  document.addEventListener('DOMContentLoaded', function () {
    var form          = document.getElementById('photoInsertForm');
    var titleInput    = document.getElementById('sptPhotoTitle');
    var categoryGroup = document.getElementById('category-group');
    var filesError    = document.getElementById('filesError');

    function onCategoryClick(e) {
      var btn = e.target.closest('.btn');
      if (!btn) return;
      var checkbox = btn.querySelector('input[type="checkbox"]');
      if (!checkbox) return;
      checkbox.checked = !checkbox.checked;
      btn.classList.toggle('active', checkbox.checked);
    }
    categoryGroup.addEventListener('click', onCategoryClick);

    function getSelectedCategories() {
      var selected = [];
      var boxes = document.querySelectorAll('#category-group input[type="checkbox"]');
      boxes.forEach(function (box) { if (box.checked) selected.push(box.value); });
      return selected;
    }

    // ✅ Dropzone 기본 설정: autoProcessQueue는 false로 유지
    var dz = new Dropzone('#photoDropzone', {
      url: form.getAttribute('action'),
      paramName: 'files', // files[]가 아닌 files로 Dropzone에 설정
      uploadMultiple: true,
      parallelUploads: 10,
      maxFilesize: 20,
      acceptedFiles: 'image/*',
      addRemoveLinks: true,
      autoProcessQueue: false
    });
    
    // ✅ 등록 버튼 클릭 이벤트
    document.getElementById('submitBtn').addEventListener('click', function (e) {
      e.preventDefault();

      // HTML5 기본 검증
      if (!form.checkValidity()) {
        form.classList.add('was-validated');
        return;
      }

      // 공정유형 최소 1개
      var categories = getSelectedCategories();
      if (categories.length === 0) {
        if (window.Swal && Swal.fire) {
          Swal.fire({ icon: 'warning', title: '공정유형 선택', text: '공정유형을 한 개 이상 선택해 주세요.' });
        } else {
          alert('공정유형을 한 개 이상 선택해 주세요.');
        }
        return;
      }

      // Dropzone 큐에 있는 파일 가져오기
      var filesToUpload = dz.getQueuedFiles();
      if (filesToUpload.length === 0) {
        if (filesError) filesError.classList.remove('d-none');
        window.scrollTo({ top: (filesError ? filesError.offsetTop : 0) - 120, behavior: 'smooth' });
        return;
      } else {
        if (filesError) filesError.classList.add('d-none');
      }

      // ✅ FormData를 직접 구성
      var formData = new FormData();
      formData.append('prjctNo', prjctNo);
      formData.append('sptPhotoTitle', titleInput.value);
      categories.forEach(function(cat) {
        formData.append('category', cat);
      });
      // 💡 Dropzone 큐에 있는 파일을 직접 FormData에 추가합니다.
      filesToUpload.forEach(function(file) {
        formData.append('files[]', file, file.name); // 'files[]' 파라미터로 명시적으로 추가
      });
      
      // ✅ Fetch API를 사용하여 직접 POST 요청 전송
      fetch(form.action, {
        method: 'POST',
        body: formData
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          // 서버에서 400 Bad Request 등을 반환하면 여기서 처리
          throw new Error('Server returned an error: ' + response.statusText);
        }
      })
      .then(data => {
        if (data.success) {
          // 성공 시 리디렉션
          Swal.fire({
            icon: 'success',
            title: '등록 성공',
            text: data.message,
            showConfirmButton: false,
            timer: 1500
          }).then(() => {
            window.location.href = contextPath + '/project/photos/list?prjctNo=' + prjctNo;
          });
        } else {
          // 서버에서 실패 응답을 보낼 경우
          Swal.fire({
            icon: 'error',
            title: '등록 실패',
            text: data.message
          });
        }
      })
      .catch(error => {
        // 네트워크 오류 등 전반적인 예외 처리
        console.error('Fetch error:', error);
        Swal.fire({
          icon: 'error',
          title: '업로드 실패',
          text: '파일 업로드 중 오류가 발생했습니다. 다시 시도해 주세요.'
        });
      });
    });
  });
</script>
</body>
</html>