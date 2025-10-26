<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <meta charset="UTF-8" />
  <title>견적서 수정</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
<body>
  <%@ include file="/module/header.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <div class="body-wrapper">
    <div class="container-fluid">

      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-9">
              <h4 class="fw-semibold mb-8">견적서 수정</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item">
                    <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a>
                  </li>
                  <li class="breadcrumb-item">
                    <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a>
                  </li>
                  <li class="breadcrumb-item" aria-current="page">Estimate Update</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-body">
          <form id="updateForm" action="${pageContext.request.contextPath}/project/estimateUpdate" 
                method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="prqudoNo" value="${prq.prqudoNo}">
            <input type="hidden" name="prjctNo" value="${prq.prjctNo}">
            <input type="hidden" name="fileGroupNo" value="${prq.fileGroupNo}">

            <div class="mb-3">
              <label for="estTitle" class="form-label">제목</label>
              <input type="text" class="form-control" id="estTitle" name="prqudoTitle" 
                     placeholder="예) 2025-3분기 인테리어 공사 견적" required value="${prq.prqudoTitle}">
            </div>

		    <div class="mb-3">
			  <label for="estPriceDisplay" class="form-label">견적비용</label>
			  <div class="input-group">
			    <span class="input-group-text">₩</span>
			    <input type="text" class="form-control" id="estPriceDisplay" inputmode="numeric" 
			           placeholder="예) 40,500,000" required value="<fmt:formatNumber value="${prq.estmtAmount}" type="number" groupingUsed="true"/>">
			    <input type="hidden" id="estPrice" name="estmtAmount" value="${prq.estmtAmount}">
			  </div>
			  <div class="form-text">숫자만 입력해도 자동으로 천단위로 표시됩니다.</div>
			</div>

            <div class="mb-3">
              <label for="estFile" class="form-label d-block">현재 파일</label>
              <c:choose>
                <c:when test="${not empty prq.fileList}">
                  <div class="mb-2">
                    <c:forEach var="fileVO" items="${prq.fileList}">
                      <div class="d-inline-flex align-items-center me-2 mb-2 p-1 border rounded" id="file-item-${fileVO.fileNo}">
                          <a class="btn btn-outline-secondary btn-sm me-1"
                             href="${pageContext.request.contextPath}/project/estimate/download/${fileVO.savedNm}">
                            <i class="ti ti-download me-1"></i>
                            <c:out value="${fileVO.originalNm}" />
                            <span class="text-muted small">(<c:out value="${fileVO.fileFancysize}"/>)</span>
                          </a>
                          <button type="button" class="btn btn-danger btn-sm js-delete-file" 
                                  data-file-no="${fileVO.fileNo}" aria-label="파일 삭제">
                              <i class="ti ti-trash"></i>
                          </button>
                      </div>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="text-muted mb-2">첨부된 파일이 없습니다.</div>
                </c:otherwise>
              </c:choose>
            
              
              <label for="newFile" class="form-label d-block">새로운 파일</label>
              <input class="form-control" type="file" id="newFile" name="uploadFiles" 
                     accept=".xlsx,.xls,.pdf,.doc,.docx,.hwp,.hwpx">
			<div class="form-text" style="color:red;">*파일을 등록해주세요.</div>
            </div>

            <div class="mb-3">
              <label for="estContent" class="form-label">내용</label>
              <textarea class="form-control" id="estContent" name="prqudoCn" rows="6"
                        placeholder="견적 상세 내용을 입력하세요." required><c:out value="${prq.prqudoCn}"/></textarea>
            </div>

            <div class="d-flex justify-content-end">
              <a href="${pageContext.request.contextPath}/project/estimateDetail?prqudoNo=${prq.prqudoNo}" 
                 class="btn btn-light me-2">취소</a>
              <button type="submit" class="btn btn-primary">수정</button>
            </div>

          </form>
        </div>
      </div>

    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>
  
  <script type="text/javascript">
  const ctx = '${pageContext.request.contextPath}';

  document.addEventListener('DOMContentLoaded', function() {
	
    const message = '${msg}';
    
    if (message && message.trim() !== '') {
        Swal.fire({
            title: message,
            icon: 'success',
            confirmButtonText: '확인'
        });
    }

    // 견적비용 천단위 포맷팅
    const displayEl = document.getElementById("estPriceDisplay");
    const hiddenEl  = document.getElementById("estPrice");

    function onlyDigits(value) {
      return (value || "").replace(/[^\d]/g, "");
    }

    displayEl.addEventListener("input", () => {
      const digits = onlyDigits(displayEl.value);
      displayEl.value = digits ? Number(digits).toLocaleString("ko-KR") : "";
      hiddenEl.value = digits || "";
    });
  });
  
  $(document).on('click', '.js-delete-file', function(e) {
	  e.preventDefault();
	  const fileNo = $(this).data('file-no');  // 파일 번호 가져오기
	  const $fileItem = $(this).closest('[id^="file-item"]'); // DOM 요소 캐싱

	  Swal.fire({
	    title: '파일을 삭제하시겠습니까?',
	    text: '삭제된 파일은 복구할 수 없습니다.',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonColor: '#d33',
	    cancelButtonColor: '#6c757d',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.isConfirmed) {
	      $.ajax({
	       url: ctx + '/project/estimate/deleteFile',
	        type: 'POST',
	        data: { fileNo: fileNo },
	        success: function(res) {
	          if (res === "OK") {
	            $fileItem.remove(); // 화면에서 제거
	            Swal.fire('삭제 완료!', '파일이 삭제되었습니다.', 'success');
	          } else {
	            Swal.fire('실패', '파일 삭제에 실패했습니다.', 'error');
	          }
	        },
	        error: function() {
	          Swal.fire('에러', '서버 요청 중 오류가 발생했습니다.', 'error');
	        }
	      });
	    }
	  });
	});
  </script>
</body>
</html>