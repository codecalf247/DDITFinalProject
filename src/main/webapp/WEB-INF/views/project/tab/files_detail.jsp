<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 자료 상세</title>
 
  <style>
    .text-pre-line { white-space: pre-line; }
  
    .max-w-720 { max-width: 720px; }
    /* 썸네일 카드 스타일 */
    .file-card {
        border: 1px solid #444;
        border-radius: 8px;
        background-color: #2a2a2a;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        cursor: pointer;
        overflow: hidden;
        height: 100%;
    }
    .file-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
    }
    .file-card .card-img-top {
        height: 150px;
        object-fit: cover;
    }
    .file-icon {
        width: 100%;
        height: 150px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 4rem;
        background-color: #3b3b3b;
        color: #999;
    }
    .file-card .card-body {
        padding: 12px;
    }
    .file-card .card-title {
        font-size: 1rem;
        font-weight: bold;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .file-card .card-text {
        font-size: 0.85rem;
        color: #bbb;
    }
    /* 모달 공통 스타일 */
    .modal-common {
        display: none;
        position: fixed;
        z-index: 10000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.9);
        justify-content: center;
        align-items: center;
    }
    .modal-close {
        position: absolute;
        top: 20px;
        right: 30px;
        color: #fff;
        font-size: 40px;
        font-weight: bold;
        cursor: pointer;
        transition: color 0.3s;
    }
    .modal-close:hover {
        color: #ff4d4d;
    }
    /* 이미지 모달 스타일 */
    .image-modal-content {
        max-width: 90%;
        max-height: 90%;
        border-radius: 10px;
    }
    /* 파일 정보 모달 스타일 */
    .file-info-modal-content {
        background-color: #1f1f1f;
        padding: 30px;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
        text-align: center;
        color: white;
    }
    .file-info-modal-content .modal-header {
        font-size: 1.6rem;
        font-weight: bold;
        color: #ff4d4d;
        margin-bottom: 20px;
    }
    .file-info-modal-content .modal-footer {
        margin-top: 30px;
        display: flex;
        justify-content: center;
        gap: 15px;
    }
    
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

/* 첨부 패널은 내부 스크롤 사용하지 않음 */
.attachments { 
  overflow: visible !important; 
  max-height: none !important; 
  padding-right: 0 !important;
}

/* 그리드 아이템이 긴 파일명 때문에 가로로 밀리지 않도록 */
.attachments .col { min-width: 0; }
.attachments .card-title { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

/* 이미지/아이콘이 너비를 넘지 않도록 */
.attachments img { display: block; width: 100%; height: auto; }

.col-divider {
  border-left: 1px solid rgba(0,0,0,0.1); /* 밝은 회색 */
}
  </style>
</head>
<%@ include file="/module/header.jsp" %>
<body>





<sec:authentication property="principal.member" var="loginUser"/>

<%-- 권한 변수 설정 --%>
<c:set var="ADMIN_EMP_NO" value="202508001" />
<c:set var="loginEmpNo" value="${loginUser.empNo}" />

<c:set var="isAdmin" value="${loginEmpNo eq ADMIN_EMP_NO}" />
<c:set var="isWriter" value="${loginEmpNo eq files.fileUploader}" /> 
<%-- 자료 작성자 사번이 ${files.fileUploader}에 담겨 있다고 가정 --%>


<%-- 최종 수정/삭제 권한 플래그: 관리자이거나 OR 게시물 작성자일 경우 true --%>
<c:set var="hasEditDeleteAuth" value="${isAdmin or isWriter}" />


 <div class="body-wrapper">
    <div class="container-fluid"> 
      <div class="body-wrapper">
        <div class="container">
        

      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-12">
              <h4 class="fw-semibold mb-8">자료 상세</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/files">Project Library</a></li>
                  <li class="breadcrumb-item active" aria-current="page">Detail</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>

  <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

    <div class="card">
  <div class="card-body">
    <form>
      <input type="hidden" id="prjctFileNo" value="${files.prjctFileNo}">

      <!-- 50:50 레이아웃 -->
      <div class="row g-4">
        <!-- LEFT: 메타 + 내용 -->
        <div class="col-12 col-lg-6">
          <div class="mb-3">
            <label for="fileTitle" class="form-label">제목</label>
            <input type="text" class="form-control" id="fileTitle" name="fileTitle"
                   value="${files.fileTitle}" readonly disabled>
          </div>

          <div class="mb-3">
            <label for="empNm" class="form-label">작성자</label>
           <input type="text" class="form-control" id="empNm" name="empNm" value="${files.empNm}" readonly disabled>
          </div>

          <div class="mb-3">
            <label for="fileTy" class="form-label">자료 유형</label>
            <input type="text" class="form-control" id="fileTy" name="fileTy"
                   value="<c:choose><c:when test='${files.fileTy eq "2D"}'>2D 자료</c:when><c:when test='${files.fileTy eq "3D"}'>3D 자료</c:when><c:when test='${files.fileTy eq "FIELD"}'>현장 자료</c:when><c:when test='${files.fileTy eq "ETC"}'>참고 자료</c:when><c:otherwise>기타</c:otherwise></c:choose>"
                   readonly disabled>
          </div>

          <div class="mb-1">
            <label class="form-label">내용</label>
            <div class="form-control text-pre-line" style="min-height: 10rem;">
              <c:out value="${files.fileCn}" />
            </div>
          </div>
        </div>

        <!-- RIGHT: 첨부파일 (스티키 + 스크롤) -->
         <div class="col-12 col-lg-6 border-start ps-4">
          <div class="d-flex align-items-center justify-content-between">
            <label class="fs-5 form-label fw-bold mb-0">첨부파일</label>
            <!-- 개수/상태 뱃지(옵션) -->
            <span class="badge bg-primary-subtle text-primary">
              <c:out value="${fn:length(files.fileList)}" /> 개
            </span>
          </div>

          <div class="attachments mt-3" style="position: sticky; top: 1rem;">
            <c:if test="${empty files.fileList}">
              <div class="text-center text-muted py-4 border rounded-3">첨부된 파일이 없습니다.</div>
            </c:if>

            <c:if test="${not empty files.fileList}">
              <!-- row-cols로 반응형 카드 개수 제어: xs 2, md 3, lg 3, xl 4~5 효과 -->
              <div class="row g-3 row-cols-2 row-cols-md-3 row-cols-lg-3 row-cols-xl-4">
                <c:forEach var="fileVO" items="${files.fileList}">
                  <c:if test="${fileVO.fileNo > 0}">
                    <c:set var="isImage" value="${fn:startsWith(fileVO.fileMime, 'image')}" />
                    <c:set var="imgUrl" value="${pageContext.request.contextPath}/upload/${fileVO.savedNm}" />
                    <c:set var="downloadUrl" value="${pageContext.request.contextPath}/project/file/download/${fileVO.fileNo}" />

                    <div class="col">
                      <div class="card overflow-hidden h-100 el-card-item pb-3 d-flex flex-column">
                        <div class="el-card-avatar mb-3 el-overlay-1 w-100 overflow-hidden position-relative text-center">
                          <c:choose>
                            <c:when test="${isImage}">
                              <a class="image-popup-vertical-fit" href="${imgUrl}" title="${fileVO.originalNm}" target="_blank">
                                <img src="${imgUrl}" class="d-block position-relative w-100" alt="${fileVO.originalNm}"
                                     style="aspect-ratio:1/1; object-fit:cover;">
                              </a>
                            </c:when>
                            <c:otherwise>
                              <div class="d-flex justify-content-center align-items-center bg-light-info text-info"
                                   style="aspect-ratio:1/1;">
                                <i class="ti ti-file fs-8"></i>
                              </div>
                            </c:otherwise>
                          </c:choose>

                          <!-- Hover Overlay -->
                          <div class="el-overlay w-100 overflow-hidden">
                            <ul class="list-style-none el-info text-white text-uppercase d-inline-block p-0">
                              <li class="el-item d-inline-block my-0 mx-1">
                                <a class="btn default btn-outline el-link text-white border-white preview-link"
                                   href="<c:out value='${isImage ? imgUrl : "javascript:void(0);"}'/>"
                                   data-is-image="${isImage}"
                                   data-file-no="${fileVO.fileNo}"
                                   data-original-nm="${fileVO.originalNm}"
                                   data-file-size="${fileVO.fileSize}" target="_blank" title="미리보기">
                                  <i class="ti ti-search"></i>
                                </a>
                              </li>
                              <li class="el-item d-inline-block my-0 mx-1">
                                <a class="btn default btn-outline el-link text-white border-white"
                                   href="${downloadUrl}" title="다운로드">
                                  <i class="ti ti-download"></i>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </div>

                        <div class="el-card-content text-center mt-auto px-2">
                          <h6 class="mb-1 card-title text-truncate" title="${fileVO.originalNm}">
                            ${fileVO.originalNm}
                          </h6>
                          <p class="card-subtitle small text-muted mb-0">${fileVO.fileFancysize}</p>
                        </div>
                      </div>
                    </div>
                  </c:if>
                </c:forEach>
              </div>
            </c:if>
          </div>
        </div>

        <!-- 버튼 영역: 전체 폭 -->
        <div class="col-12">
          <div class="d-flex justify-content-between pt-2">
            <a href="${pageContext.request.contextPath}/project/files?prjctNo=${files.prjctNo}" class="btn btn-outline-secondary">
              <i class="ti ti-list"></i> 목록으로
            </a>

          <%-- [수정 시작] 수정/삭제 버튼 권한 제어 로직 --%>
            <c:if test="${hasEditDeleteAuth}">
              <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/project/filesUpdate?prjctFileNo=${files.prjctFileNo}" class="btn btn-warning">
                  <i class="ti ti-edit"></i> 수정
                </a>
                <button type="button" class="btn btn-danger" id="btnDelete">
                  <i class="ti ti-trash"></i> 삭제
                </button>
              </div>
            </c:if>
            <%-- [수정 끝] 수정/삭제 버튼 권한 제어 로직 --%>
          </div>
        </div>
      </div>
    </form>
  </div>
</div>

      </div>
      </div>
  </div>
</div>

<div id="imageModal" class="modal-common">
  <span class="modal-close" onclick="closeModal('imageModal')">&times;</span>
  <img class="image-modal-content" id="modalImage">
</div>

<div id="fileInfoModal" class="modal-common">
    <div class="file-info-modal-content">
        <div class="modal-header">파일 정보</div>
        <div>
            <p><strong>파일명:</strong> <span id="infoFileName"></span></p>
            <p><strong>파일 크기:</strong> <span id="infoFileSize"></span> Bytes</p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeModal('fileInfoModal')">닫기</button>
            <a id="downloadLink" class="btn btn-primary" href="#">다운로드</a>
        </div>
    </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/magnific-popup.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<script>
$(function() {
    // 삭제
    const btnDelete = $('#btnDelete'); // const 사용
    btnDelete.on('click', function() {
      const prjctFileNo = $('#prjctFileNo').val(); // const 사용
      Swal.fire({
        title: '정말 삭제하시겠어요?',
        text: '삭제된 자료는 복구할 수 없습니다.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
      }).then((result) => {
        if (result.isConfirmed) {
            // 사용자가 '삭제'를 눌렀을 경우, AJAX 요청으로 삭제 처리
            // jQuery를 사용한 POST 요청
            $.ajax({
                url: '${pageContext.request.contextPath}/project/fileDelete',
                type: 'POST',
                data: {
                    fileNo: prjctFileNo
                },
                success: function(response) {
                    if(response === "SUCCESS") {
                        Swal.fire({
                            title: '삭제 완료!',
                            text: '자료가 성공적으로 삭제되었습니다.',
                            icon: 'success'
                        }).then(() => {
                             // 성공적으로 삭제 후 목록 페이지로 리다이렉트
                            window.location.href = '${pageContext.request.contextPath}/project/files?prjctNo=${files.prjctNo}';
                        });
                    } else {
                        Swal.fire({
                            title: '삭제 실패',
                            text: '자료 삭제에 실패했습니다.',
                            icon: 'error'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        title: '오류 발생',
                        text: '삭제 처리 중 오류가 발생했습니다.',
                        icon: 'error'
                    });
                }
            });
        }
      });
    });

    // 이미지 라이트박스 (Modernize gallery와 동일 패턴)
    // .attachments 아래의 a.image-popup-vertical-fit 을 위임 초기화
    $('.attachments').magnificPopup({
      delegate: 'a.image-popup-vertical-fit',
      type: 'image',
      closeOnContentClick: true,
      mainClass: 'mfp-img-mobile',
      image: {
        verticalFit: true
      },
      gallery: {
        enabled: true // 같은 섹션에서 다음/이전 탐색
      }
    });

    // "돋보기" 클릭: 이미지면 라이트박스(기본 a 동작), 비이미지는 파일정보 모달
    $('.attachments').on('click', '.preview-link', function(e) {
      const $btn = $(this); // const 사용
      const isImage = String($btn.data('is-image')) === 'true'; // const 사용
      if (isImage) {
        // a.image-popup-vertical-fit 로 라이트박스가 처리하므로 별도 로직 불필요
        return; // 기본 동작 통과
      }
      e.preventDefault();

      const originalNm = $btn.data('original-nm'); // const 사용
      const fileSize   = Number($btn.data('file-size')) || 0; // const 사용
      const fileNo     = $btn.data('file-no'); // const 사용

      $('#infoFileName').text(originalNm);
      $('#infoFileSize').text(fileSize.toLocaleString('ko-KR'));
      $('#downloadLink').attr('href', '${pageContext.request.contextPath}/project/file/download/' + fileNo);

      $('#fileInfoModal').css('display', 'flex');
    });

    // 공통 모달 닫기
    window.closeModal = function(modalId) {
      document.getElementById(modalId).style.display = 'none';
    };

    // 모달 바깥 클릭 닫기
    $(window).on('click', function(e) {
      if (e.target.classList && e.target.classList.contains('modal-common')) {
        $(e.target).hide();
      }
    });
  });
</script>

</body>
</html>