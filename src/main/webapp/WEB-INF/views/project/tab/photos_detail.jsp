<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <style type="text/css">
/* 썸네일 공통 */
.photo-thumb {
  position: relative;
  display: block;
  border-radius: .75rem;
  overflow: hidden;
  box-shadow: 0 1px 2px rgba(16, 24, 40, .06);
}

.photo-thumb img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
  transition: transform .25s ease;
  border-radius: .75rem; /* 추가 */
}

.photo-thumb:hover img {
  transform: scale(1.03);
}

.photo-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1400px) { .photo-grid { grid-template-columns: repeat(4, 1fr); } }
@media (max-width: 992px)  { .photo-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 768px)  { .photo-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 480px)  { .photo-grid { grid-template-columns: repeat(1, 1fr); } }


.photo-item { position: relative; border-radius: .75rem; overflow: hidden; box-shadow: 0 1px 2px rgba(16,24,40,.06); }
.el-overlay { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; background: rgba(17,24,39,.45); opacity: 0; visibility: hidden; transition: .2s; }
.photo-item:hover .el-overlay { opacity: 1; visibility: visible; }
.el-info .btn { border-width: 2px; }
</style>
  
  
  
  
  

</head>
<%@ include file="/module/header.jsp" %>


<%-- [수정 시작] 권한 체크 로직 추가 --%>
<sec:authentication property="principal.member" var="loginUser"/>
<c:set var="ADMIN_EMP_NO" value="202508001" />

<%-- 1. 관리자 여부 확인 --%>
<c:set var="isAdmin" value="${loginUser.empNo eq ADMIN_EMP_NO}" />

<%-- 2. 작성자 여부 확인 (photo.empNo에 작성자 사번이 담겨있다고 가정) --%>
<c:set var="isWriter" value="${loginUser.empNo eq photo.empNo}" />

<%-- 최종 수정/삭제 권한 플래그: 관리자 OR 작성자 --%>
<c:set var="hasEditDeleteAuth" value="${isAdmin or isWriter}" />
<%-- [수정 끝] 권한 체크 로직 추가 --%>


<div class="body-wrapper">
  <div class="container-fluid">
  <div class="body-wrapper">
        <div class="container">
        
       <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-12">
              <h4 class="fw-semibold mb-8">현장사진</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item">
                  	<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a>
                  	</li>
                  <li class="breadcrumb-item">
                  	<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard?prjctNo=${project.prjctNo}">Project</a>
                  	</li>
                  <li class="breadcrumb-item">
                  	<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${project.prjctNo}">Project Photos</a>
                  	</li>
                  <li class="breadcrumb-item active" aria-current="page">PhotoDetail</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>
        
          <%@ include file="/WEB-INF/views/project/carousels.jsp" %>
  
  <div class="card">
     <div class="card-body">
	   <div class="d-flex justify-content-between align-items-center mb-3">
	     <h4 class="fw-semibold mb-0">${photo.sptPhotoTitle}</h4>
	    <%--  <a class="btn btn-outline-secondary"
	        href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${prjctNo}">
	       목록
	     </a> --%>
	   </div>

	<div class="card-body px-0 pt-0">
  <!-- row/col 제거, photo-grid로만 구성 -->
  <div class="photo-grid" id="detailGrid">
    <c:set var="ctx" value="${pageContext.request.contextPath}" />
		<c:forEach var="f" items="${photo.fileList}">
		  <div class="photo-item">
		    <!-- 썸네일(클릭 시 미리보기) -->
		    <a href="javascript:void(0)"
		       class="photo-thumb"
		       data-src="${ctx}/upload/${f.savedNm}">
		      <img src="${ctx}/upload/${f.savedNm}"
		           alt="${fn:escapeXml(f.originalNm)}" loading="lazy" />
		    </a>

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
    
    
    </c:forEach>

    <c:if test="${empty photo.fileList}">
      <div class="text-center text-muted py-5" style="grid-column: 1 / -1;">
        업로드된 사진이 없습니다.
      </div>
    </c:if>
  </div>
</div>

  
  
  
 <div class="d-flex justify-content-between mt-4">
  <a href="${pageContext.request.contextPath}/project/photos/list?prjctNo=${project.prjctNo}"
     class="btn btn-outline-secondary">
    <i class="ti ti-list"></i> 목록으로
  </a>



  <div>
    <!-- 수정: update/{photoNo}?prjctNo=... -->
    <a href="${pageContext.request.contextPath}/project/photos/update/${photo.sptPhotoNo}?prjctNo=${project.prjctNo}"
       class="btn btn-warning me-2">
      <i class="ti ti-edit"></i> 수정
    </a>

    <!-- 삭제: GET 사용(프로젝트 정책: CSRF 미사용) -->
    <button type="button" class="btn btn-danger me-2" id="btnDelete"
            data-delete-url="${pageContext.request.contextPath}/project/photos/delete/${photo.sptPhotoNo}?prjctNo=${project.prjctNo}">
      <i class="ti ti-trash"></i> 삭제
    </button>
  </div>
</div>
</div>

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
</div>
</div>
</div>
 
</div>
</div>

<%@ include file="/module/footerPart.jsp" %>\
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/magnific-popup.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<script>
$(function(){
  const $grid = $('#detailGrid');
  const $modalImg = $('#modalImg');
  const modalEl = document.getElementById('photoModal');
  const modal = new bootstrap.Modal(modalEl);
  let order = [], idx = -1;

  function rebuild(){
    order = $grid.find('.photo-thumb').map(function(){
      return $(this).data('src');
    }).get();
  }
  function showAt(i){
    if (!order.length) return;
    if (i<0) i = order.length-1;
    if (i>=order.length) i = 0;
    idx = i;
    $modalImg.attr('src', order[idx]);
    modal.show();
  }

  rebuild();
  $grid.on('click','.photo-thumb', function(){
    rebuild();
    const src = $(this).data('src');
    const i = order.indexOf(src);
    showAt(i>=0?i:0);
  });
  $('#modalPrev').on('click', () => showAt(idx-1));
  $('#modalNext').on('click', () => showAt(idx+1));
  
  
  
  // 삭제 버튼 클릭 이벤트
  $('#btnDelete').on('click', function(){
    const deleteUrl = $(this).data('delete-url'); // data-delete-url 속성에서 삭제 URL 가져오기

    if(!deleteUrl){
      console.error('삭제 URL이 지정되지 않았습니다. data-delete-url 속성을 확인하세요.');
      return;
    }

    Swal.fire({
      title: '정말로 삭제하시겠습니까?',
      text: '삭제 후에는 되돌릴 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: '네, 삭제합니다',
      cancelButtonText: '취소',
      reverseButtons: true,
      focusCancel: true
    }).then((result) => {
      if (result.isConfirmed) {
        // 단순 페이지 이동 방식
        window.location.href = deleteUrl;

        // 만약 AJAX 삭제 처리 원하면 이 부분을 $.ajax()로 교체 가능
      }
    });
  });
  
  
  $grid.on('click', '.js-preview', function (e) {
	  e.stopPropagation();
	  const src = $(this).data('src');
	  const i = order.indexOf(src);
	  showAt(i >= 0 ? i : 0);
	});
  
});
</script>
