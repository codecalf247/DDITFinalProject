<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="/module/header.jsp" %>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 자료 수정</title>
  <%@ include file="/module/headPart.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/magnific-popup.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">

  <style>
    .max-w-720 { max-width: 720px; }

    /* Modernize overlay 보정(혹시 테마 css가 안먹을 때를 대비한 최소치) */
    .el-card-avatar { position: relative; }
    .el-overlay-1 .el-overlay {
      position: absolute; inset: 0;
      background: rgba(0,0,0,.45);
      transform: translateY(100%);
      transition: transform .35s ease;
    }
    .el-card-item:hover .el-overlay { transform: translateY(0); }
    .el-info {
      position: absolute; left:50%; top:50%;
      transform: translate(-50%,-50%);
      opacity: 0; transition: opacity .25s ease .05s;
    }
    .el-card-item:hover .el-info { opacity: 1; }

    .text-truncate-2 {
      display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
    }
  </style>
</head>

<body>
<sec:authentication property="principal.member" var="emp"/>
<div class="body-wrapper">
  <div class="container-fluid">
    <div class="container max-w-720">

      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-12">
              <h4 class="fw-semibold mb-8">자료 수정</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/files">Project Library</a></li>
                  <li class="breadcrumb-item active" aria-current="page">Edit</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-body">
          <form id="updateForm" class="needs-validation" novalidate
                method="post" action="${pageContext.request.contextPath}/project/filesUpdate" enctype="multipart/form-data">

            <input type="hidden" name="prjctFileNo" value="${files.prjctFileNo}">
            <input type="hidden" name="prjctNo" value="${files.prjctNo}">
            <input type="hidden" name="fileGroupNo" value="${files.fileGroupNo}">

            <div class="mb-3">
              <label for="fileTitle" class="form-label">제목 <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="fileTitle" name="fileTitle"
                     value="${files.fileTitle}" placeholder="예: 목공평면도_20250909" required>
              <div class="invalid-feedback">제목을 입력하세요.</div>
            </div>

            <div class="mb-3">
		  <label for="empNm" class="form-label">작성자</label>
		  <input type="text" class="form-control" id="empNm" name="empNm"
		         value="${emp.empNm}" readonly>
		</div>
		<input type="hidden" name="empNm" value="${files.empNm}">

            <div class="mb-3">
              <label for="fileTy" class="form-label">자료 유형 <span class="text-danger">*</span></label>
              <select class="form-select" id="fileTy" name="fileTy" required>
                <option value="">선택하세요</option>
                <option value="2D" <c:if test="${files.fileTy eq '2D'}">selected</c:if>>2D 자료</option>
                <option value="3D" <c:if test="${files.fileTy eq '3D'}">selected</c:if>>3D 자료</option>
                <option value="FIELD"  <c:if test="${files.fileTy eq 'FIELD'}">selected</c:if>>현장 자료</option>
                <option value="ETC"  <c:if test="${files.fileTy eq 'ETC'}">selected</c:if>>참고 자료</option>
              </select>
              <div class="invalid-feedback">자료 유형을 선택하세요.</div>
            </div>

            <c:if test="${not empty files.fileList}">
              <div class="mb-4">
                <label class="fs-5 form-label fw-bold">기존 첨부파일</label>
                <div class="row g-3 attachments">
                  <c:set value="${fn:length(files.fileList) }" var="fLength"/>
                  <c:forEach var="fileVO" items="${files.fileList}">
	      			<c:if test="${fileVO.fileNo > 0 }">
                  	
                  	
	                    <c:set var="isImage" value="${fn:startsWith(fileVO.fileMime, 'image')}" />
	                    <c:set var="imgUrl" value="${pageContext.request.contextPath}/upload/${fileVO.savedNm}" />
	                    <c:set var="downloadUrl" value="${pageContext.request.contextPath}/project/file/${fileVO.fileNo}/download" />
	
	                    <div class="col-6 col-md-4 col-lg-3" id="file-card-${fileVO.fileNo}">
	                      <div class="card overflow-hidden h-100">
	                        <div class="el-card-item pb-3 h-100 d-flex flex-column">
	                          <div class="el-card-avatar mb-3 el-overlay-1 w-100 overflow-hidden position-relative text-center">
	                            <c:choose>
	                              <c:when test="${isImage}">
	                                <a class="image-popup-vertical-fit" href="${imgUrl}" title="${fileVO.originalNm}">
	                                  <img src="${imgUrl}" class="d-block position-relative w-100"
	                                       alt="${fileVO.originalNm}" style="aspect-ratio:1/1; object-fit:cover;">
	                                </a>
	                              </c:when>
	                              <c:otherwise>
	                                <div class="d-flex justify-content-center align-items-center bg-light-info text-info"
	                                     style="aspect-ratio:1/1;">
	                                  <i class="ti ti-file fs-8"></i>
	                                </div>
	                              </c:otherwise>
	                            </c:choose>
	
	                            <div class="el-overlay w-100 overflow-hidden">
	                              <ul class="list-style-none el-info text-white text-uppercase d-inline-block p-0">
	                                <li class="el-item d-inline-block my-0 mx-1">
	                                  <a class="btn default btn-outline el-link text-white border-white preview-link"
	                                     href="<c:out value='${isImage ? imgUrl : "javascript:void(0);"}'/>"
	                                     data-is-image="${isImage}"
	                                     data-file-no="${fileVO.fileNo}"
	                                     data-original-nm="${fileVO.originalNm}"
	                                     data-file-size="${fileVO.fileSize}">
	                                    <i class="ti ti-search"></i>
	                                  </a>
	                                </li>
	                                <li class="el-item d-inline-block my-0 mx-1">
	                                  <a class="btn default btn-outline el-link text-white border-white"
	                                     href="${downloadUrl}" title="다운로드">
	                                    <i class="ti ti-download"></i>
	                                  </a>
	                                </li>
	                                <li class="el-item d-inline-block my-0 mx-1">
	                                  <button type="button" class="btn default btn-outline el-link text-white border-white btn-attach-delete"
	                                          data-file-no="${fileVO.fileNo}" title="삭제">
	                                    <i class="ti ti-trash"></i>
	                                  </button>
	                                </li>
	                              </ul>
	                            </div>
	                          </div>
	
	                          <div class="el-card-content text-center mt-auto">
	                            <h6 class="mb-0 card-title text-truncate" title="${fileVO.originalNm}">
	                              ${fileVO.originalNm}
	                            </h6>
	                            <p class="card-subtitle small text-muted mb-0">${fileVO.fileFancysize}</p>
	                          </div>
	                        </div>
	                      </div>
	                    </div>
                    </c:if>
                  </c:forEach>
                </div>
              </div>
            </c:if>

            <div class="mb-3">
              <label for="fileUpload" class="form-label">파일 추가 업로드</label>
              <input class="form-control" type="file" id="fileUpload" name="fileUpload" multiple>
              <div class="invalid-feedback">첨부파일은 1개 이상 꼭 업로드해주세요.</div>
            </div>

            <div class="mb-1">
              <label for="fileCn" class="form-label">내용</label>
              <textarea class="form-control" id="fileCn" name="fileCn"
                        rows="5" maxlength="500" placeholder="자료에 대한 설명을 입력하세요(선택)">${files.fileCn}</textarea>
            </div>
            <div class="form-text text-end"><span id="contentCount">0</span> / 500</div>

            <div class="d-flex justify-content-between mt-4">
              <a href="${pageContext.request.contextPath}/project/filesDetail?prjctFileNo=${files.prjctFileNo}" class="btn btn-outline-secondary">
                상세로
              </a>
              <div>
                <a href="${pageContext.request.contextPath}/project/files?prjctNo=${files.prjctNo}" class="btn btn-light me-2">목록</a>
                <button type="submit" class="btn btn-primary" id="btnUpdateSubmit">수정 저장</button>
              </div>
            </div>
            <%-- 삭제할 파일 번호를 담을 히든 필드 추가 --%>
			<input type="hidden" name="deleteFileNoList" id="deleteFileNoList">
          </form>
        </div>
      </div>
      </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/magnific-popup.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/plugins/meg.init.js"></script>


<script>
$(function () {
    'use strict';

    // textarea 글자수 카운트
    const $ta = $('#fileCn');
    const $cnt = $('#contentCount');
    function updateCount() { $cnt.text(($ta.val() || '').length); }
    $ta.on('input', updateCount); updateCount();

    // Magnific Popup (이미지 라이트박스)
    $('.attachments').magnificPopup({
        delegate: 'a.image-popup-vertical-fit',
        type: 'image',
        closeOnContentClick: true,
        mainClass: 'mfp-img-mobile',
        image: { verticalFit: true },
        gallery: { enabled: true }
    });

    // 비이미지 프리뷰 아이콘 동작 막기
    $('.attachments').on('click', '.preview-link', function(e){
        const isImage = String($(this).data('is-image')) === 'true';
        if (!isImage) e.preventDefault();
    });

    // 기존 첨부파일 개별 삭제(AJAX)
    $('.attachments').on('click', '.btn-attach-delete', function(){
        const fileNo = $(this).data('file-no');
        Swal.fire({
            title: '파일을 삭제 목록에 추가할까요?',
            text: '수정 버튼을 누르기 전까지는 완전히 삭제되지 않습니다.',
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                let deleteList = $('#deleteFileNoList').val();
                if (deleteList) {
                    deleteList += ',' + fileNo;
                } else {
                    deleteList = fileNo;
                }
                $('#deleteFileNoList').val(deleteList);
                $('#file-card-' + fileNo).remove();
                Swal.fire('삭제 목록에 추가됨', '수정 버튼을 누르면 파일이 완전히 삭제됩니다.', 'success');
            }
        });
    });
    
    // 폼 제출(submit) 이벤트 핸들러
    $('#updateForm').on('submit', function (e) {
        
        // 삭제 목록과 새로 업로드된 파일의 개수 확인
        const deleteFileNoList = $('#deleteFileNoList').val() ? $('#deleteFileNoList').val().split(',').map(Number) : [];
        const newFiles = document.getElementById('fileUpload').files;

        // 기존 파일 카드 개수 확인
//         const existingFileCards = $('.attachments').find('[data-file-no]').length;
        const existingFileCards = "${fLength}";
        
        // 최종적으로 남을 파일의 총 개수 계산
        const finalFileCount = existingFileCards - deleteFileNoList.length + newFiles.length;

        // 첨부파일이 0개인지 확인하는 핵심 로직
        if (finalFileCount  <= 0) {
            // 폼 제출을 즉시 중단
            e.preventDefault();
            e.stopPropagation();

            // SweetAlert 경고창 표시
            Swal.fire({
                icon: 'warning',
                title: '첨부파일 경고',
                text: '첨부파일은 1개 이상이어야 합니다.',
                confirmButtonText: '확인'
            });

            // 브라우저의 기본 유효성 검사 스타일 적용
            $(this).find("#fileUpload").addClass("is-invalid");
            return false; // 함수 종료
        }

        // 필수 입력 필드 유효성 검사
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }

        // 폼 제출을 진행
        $(this).addClass('was-validated');
    });
});
</script>

</body>
</html>