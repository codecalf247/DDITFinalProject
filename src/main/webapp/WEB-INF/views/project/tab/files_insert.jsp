<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%-- 필요 시 스프링시큐리티 CSRF 사용 시 주석 해제
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
--%>
<%@ include file="/module/header.jsp" %>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 자료 등록</title>
  <%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>
  <style>
    /* 페이지 전용 보조 스타일 */
    .max-w-720 { max-width: 720px; }
  
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
              <h4 class="fw-semibold mb-8">
              	<c:choose>
              		<c:when test="${not empty files.fileNo}">자료 수정</c:when>
				        <c:otherwise> 자료 등록 </c:otherwise>
              	</c:choose>
              </h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/files">Project Library</a></li>
                  <li class="breadcrumb-item active" aria-current="page">Insert</li>
                   <c:choose>
                      <c:when test="${not empty files.fileNo}">Edit</c:when>
                      <c:otherwise>Insert</c:otherwise>
                    </c:choose>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-body">
          <form id="uploadForm" class="needs-validation" novalidate
                method="post" enctype="multipart/form-data">

   			<%--    			<c:if test="${not empty files.fileNo }"> --%>
<%--    				<input type="hidden" name="prjctNo" value="${prjctNo}"> --%>
<%--    			</c:if> --%>
   			
            <div class="mb-3">
              <label for="uploadTitle" class="form-label">제목 <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="fileTitle" name="fileTitle" value="${files.fileTitle}"
                     placeholder="예: 목공편면동_20250909" required>
              <div class="invalid-feedback">제목을 입력하세요.</div>
            </div>
            
            <div class="mb-3">
			  <label for="writerNm" class="form-label">작성자</label>
			  <input type="text" class="form-control" id="empNm" name="empNm" value="${emp.empNm }" readonly>
			</div>

            <div class="mb-3">
			  <label for="uploadCategory" class="form-label">자료 유형 <span class="text-danger">*</span></label>
			  <select class="form-select" id="uploadCategory" name="fileTy" required>
			    <option value="">선택하세요</option>
			    <option value="2D">2D 자료</option>
			    <option value="3D">3D 자료</option>
			    <option value="FIELD">현장 자료</option>
			    <option value="ETC">참고 자료</option>
			  </select>
			  <div class="invalid-feedback">자료 유형을 선택하세요.</div>
			</div>


            <div class="mb-3">
              <label for="fileUpload" class="form-label">첨부파일 
              <span class="text-danger">*</span></label>
              <input class="form-control" type="file" id="fileUpload" name="fileUpload" multiple required>
              <div class="invalid-feedback">업로드할 파일을 선택하세요.</div>
            </div>
            
            <%-- 기존 첨부파일 목록 표시 --%>
            <c:if test="${not empty files.fileList}">
                <div class="mb-4">
                    <label class="fs-5 form-label fw-bold">기존 첨부파일</label>
                    <div class="border p-3 rounded">
                        <c:forEach var="fileVO" items="${files.fileList}">
                            <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                <span class="text-truncate">${fileVO.originalNm} (${fileVO.fileFancysize})</span>
                                <button type="button" class="btn btn-sm btn-danger" onclick="deleteFile(${fileVO.fileNo}, this)">삭제</button>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <div class="mb-1">
			  <label for="fileCn" class="form-label">내용</label>
			  <textarea class="form-control" id="fileCn" name="fileCn"
			            rows="5" maxlength="500" placeholder="자료에 대한 설명을 입력하세요(선택)">${files.fileCn}</textarea>
			</div>
			<div class="form-text text-end"><span id="contentCount">0</span> / 500</div>

			
            <div class="d-flex justify-content-between mt-4">
              <a href="${pageContext.request.contextPath}/project/files?prjctNo=${prjctNo}" class="btn btn-outline-secondary">
                목록으로
              </a>
              <div>
                <button type="button" class="btn btn-light me-2" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-primary" id="btnUploadSubmit">
                	<c:choose>
                		<c:when test="${not empty files.fileNo}">수정</c:when>
                		<c:otherwise>등록</c:otherwise>
                	</c:choose>
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
      </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(function () {
        'use strict';

        // Bootstrap 유효성 검사
        $('#uploadForm').on('submit', function (e) {
            const newFiles = document.getElementById('fileUpload').files;

            if (newFiles.length === 0) {
                e.preventDefault(); 
                e.stopPropagation();

                Swal.fire({
                    icon: 'warning',
                    title: '첨부파일 경고',
                    text: '첨부파일은 1개 이상 등록해야 합니다.',
                    confirmButtonText: '확인'
                });
                
                $(this).addClass('was-validated');
            }
            
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
        });

        // textarea 글자수 카운트
        const $ta  = $('#fileCn');
        const $cnt = $('#contentCount');

        function updateCount() {
            $cnt.text(($ta.val().trim() || '').length);
        }

        $ta.on('input', updateCount);
        updateCount();
    });
</script>

</body>
</html>