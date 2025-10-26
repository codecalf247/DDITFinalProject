<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib uri ="http://www.springframework.org/security/tags" prefix="sec" %>
  <%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>GroupWare - Estimate Detail</title>
  <!-- SweetAlert2 (modernize 경로) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
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
              <h4 class="fw-semibold mb-8">자료 상세</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard?prjctNo=${prjctNo}">Project</a></li>
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/estimate?prjctNo=${prjctNo}">Estimate</a></li>
                  <li class="breadcrumb-item active" aria-current="page">Detail</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>




    <!-- 상단 캐러셀 영역 -->
    <%@ include file="/WEB-INF/views/project/carousels.jsp"%>
  
  
    <sec:authentication property="principal.member" var="member"/>

    <!-- ===== 상세 본문 ===== -->
    <div class="row g-3 mt-3">

      <!-- 견적서 상세 정보 -->
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <!-- 제목 + 금액 (같은 줄) -->
            <div class="d-flex align-items-start justify-content-between">
              <h3 class="mb-0 lh-sm pe-3"><c:out value="${prjct.prqudoTitle}" /></h3>
              <div class="ms-3 text-end">
                <div class="fs-4 fw-semibold">
                  ₩<fmt:formatNumber value="${prjct.estmtAmount}" type="number" groupingUsed="true"/>
                </div>
                <div class="text-muted small">견적 금액</div>
              </div>
            </div>

            <!-- 메타: 등록일, 작성자 -->
            <div class="mt-2 small text-muted">
              <div>등록일: <c:out value="${fn:substring(prjct.regDt, 0, 10)}" /></div>
              <div>작성자: <c:out value="${prjct.empNm}" /></div>
            </div>
            <hr class="my-3"/>

            <!-- 등록한 첨부파일 -->
            <h6 class="mb-2 fw-semibold">등록한 첨부파일</h6>
            <c:choose>
              <c:when test="${not empty prjct.fileList}">
                <c:forEach var="fileVO" items="${prjct.fileList}">
                  <a class="btn btn-outline-secondary btn-sm"
                     href="${pageContext.request.contextPath}/project/estimate/download/${fileVO.savedNm}">
                    <i class="ti ti-download me-1"></i>
                    <c:out value="${fileVO.originalNm}" />
                    <span class="text-muted small">(<c:out value="${fileVO.fileFancysize}"/>)</span>
                  </a>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <span class="text-muted">첨부 없음</span>
              </c:otherwise>
            </c:choose>

            <!-- 상세 내용 -->
            <h6 class="mt-4 mb-2 fw-semibold">상세 내용</h6>
            <div class="p-3 rounded border bg-light-subtle text-start" style="font-size: 1rem;">
              <c:out value="${prjct.prqudoCn}" default="내용이 없습니다."/>
            </div>
            
            <hr class="my-3" />

            <!-- 액션 버튼들 -->
         <!-- 액션 버튼들 -->
		<div class="d-flex justify-content-end gap-2">
		    <c:if test="${prjct.empNo eq member.empNo}">
		        <a class="btn btn-primary"
		           href="${pageContext.request.contextPath}/project/estimateUpdate?prqudoNo=${prjct.prqudoNo}">
		            <i class="ti ti-edit me-1"></i> 수정
		        </a>
		
		        <button type="button" class="btn btn-outline-danger js-delete-estimate"
		                data-id="${prjct.prqudoNo}">
		            <i class="ti ti-trash me-1"></i> 삭제
		        </button>
		    </c:if>
		
		    <a class="btn btn-light" href="${pageContext.request.contextPath}/project/estimate?prjctNo=${prjct.prjctNo}">
		        목록으로
		    </a>
            </div>
          </div>
        </div> <!-- /card -->
      </div> <!-- /col-lg-12 -->

    </div>
    <!-- ===== 상세 본문 끝 ===== -->

  </div>
  </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<!-- SweetAlert2 -->
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
	
    const message = '${msg}';
    
    console.log(message);
    console.log("여기옴 --------------------------");
    if (message && message.trim() !== '') {
        Swal.fire({
            title: message,
            icon: 'success',
            confirmButtonText: '확인'
        });
    }
});

  $(function(){
    const ctx = '${pageContext.request.contextPath}';
    // 상세 페이지에서 삭제
    $(document).on('click', '.js-delete-estimate', function(){
      const id = $(this).data('id');
      Swal.fire({
        title: '삭제하시겠습니까?',
        text: '삭제 후에는 복구할 수 없습니다.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
      }).then(res => {
        if(!res.isConfirmed) return;

        // 실제 삭제 요청 (연동 시 주석 해제)
        $.post(ctx + '/project/estimate/delete?prqudoNo=' + id, { prqudoNo: id })
         .done(() => {
           Swal.fire('삭제 완료', '견적이 삭제되었습니다.', 'success').then(()=>{
             window.location.href=ctx + '/project/estimate?prjctNo=${prjct.prjctNo}';
           });
         })
         .fail(() => Swal.fire('실패', '삭제 중 오류가 발생했습니다.', 'error'));

        // 데모
        // Swal.fire('삭제 완료', '견적이 삭제되었습니다. (데모)', 'success').then(()=>{
        //   window.location.href=ctx + '/project/estimate?prjctNo=${prjct.prjctNo}';
        // });
      });
    });
  });
</script>

</body>
</html>
