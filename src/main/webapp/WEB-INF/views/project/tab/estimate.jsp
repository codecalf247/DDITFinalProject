<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
.table-hover tbody tr:hover {
  background-color: #f5f9fc;
  cursor: pointer;
}
</style>


</head>
  <%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 
<div class="body-wrapper">
	<div class="container">
	
	
	
<!-- 상단 브레드크럼 -->
<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 견적서</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a>
                </li>
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard?prjctNo=${prjctNo}">Project</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Estimate</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

        
		<%@ include file="/WEB-INF/views/project/carousels.jsp"%>
		
	

<div class="row align-items-center mb-3">
  <!-- 좌측: Total Income 카드 -->
  <div class="col-md-6">
    <div class="card text-bg-success">
      <div class="card-body text-white">
        <div class="d-flex flex-row align-items-center">
          <div class="round-40 rounded-circle d-flex align-items-center justify-content-center bg-white">
            <i class="ti ti-credit-card fs-6 text-success"></i>
          </div>
          <div class="ms-3">
            <h4 class="mb-0 text-white fs-6">총 견적금액</h4>
            <span class="text-white-50">Income</span>
          </div>
         <div class="ms-auto">
	<h2 id="totalIncome" class="fs-7 mb-0 text-white d-flex align-items-center">
    <!-- SVG 아이콘 -->

    <!-- 숫자 -->
  <h2 id="totalIncome" class="fs-7 mb-0 text-white">
    
    ₩ <fmt:formatNumber value="${totalAmount}" type="number" pattern="#,##0"/>
     
</h2>
</div>

        </div>
      </div>
    </div>
  </div>

  <!-- 우측: 자료 등록 버튼 -->
  <div class="col-md-6 d-flex justify-content-end">
    <button type="button" class="btn btn-secondary" id="uploadBtn" value="upload">견적 등록</button>
  </div>
</div>

<!-- 테이블 목록 래퍼 -->
<div class="tab-content border rounded-3 p-3">

  <table class="table table-hover text-nowrap mb-0 align-middle">
    <thead class="text-dark fs-4">
      <tr>
        <th><h6 class="fs-4 fw-semibold mb-0">File Name</h6></th>
        <th><h6 class="fs-4 fw-semibold mb-0">User</h6></th>
        <th><h6 class="fs-4 fw-semibold mb-0">Date</h6></th>
        <th class="text-end"><h6 class="fs-4 fw-semibold mb-0">Cost</h6></th>
     	<th class="text-end"><h6 class="fs-4 fw-semibold mb-0">Download</h6></th>
      </tr>
    </thead>


		<tbody>
		  <c:forEach var="est" items="${prqudoList}">
		    <tr class="js-row-link" data-estimate-id="${est.prqudoNo}">
		      <td>
		        <h6 class="fs-4 fw-semibold mb-0">
		          <a class="link-dark text-decoration-none"
		             href="${pageContext.request.contextPath}/project/estimateDetail?prqudoNo=${est.prqudoNo}">
		            ${est.prqudoTitle}
		          </a>
		        </h6>
		      </td>
		      <td>
		        <div class="d-flex align-items-center">
		          <div class="ms-2">
		            <div class="fw-semibold">${est.empNm}</div>
		          </div>
		        </div>
		      </td>
		      <td><div class="fw-semibold">${fn:substring(est.regDt, 0, 10)}</div></td>
		      <td class="text-end">
		        <h6 class="fs-4 fw-semibold mb-0">
		          <fmt:formatNumber value="${est.estmtAmount}" type="number" pattern="#,##0"/>
		        </h6>
		      </td>
		      <td class="text-end">
		        <div class="btn-group">
		        <c:if test="${not empty est.fileList}">
		          <a href="${pageContext.request.contextPath}/project/estimate/download/${est.fileList[0].savedNm}" class="btn btn-outline-secondary px-3 py-1" title="다운로드">
		              <i class="ti ti-download fs-5"></i>
		          </a>
		        </c:if>
		        </div>
		      </td>
		    </tr>
		  </c:forEach>
    </tbody>
  </table>
  
  <c:if test="${empty prqudoList}">
    <div class="text-center py-5 text-muted">
      <p>등록된 견적서가 없습니다.</p>
    </div>
  </c:if>

</div>

		
  </div>
</div>

        </div>
      </div>    


<%@ include file="/module/footerPart.jsp" %>


<!-- 견적 등록 모달 삭제 -->
<!-- 견적 등록 모달 스크립트 삭제 -->

<script>
// 리다이렉트로 받은 메시지 표시
document.addEventListener('DOMContentLoaded', function() {
	
    const message = '${msg}';
    
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
    
    // 행 클릭 시 상세 페이지로 이동
    $(document).on('click', '.js-row-link', function(e){
      // 버튼/아이콘 영역은 제외
      if ($(e.target).closest('.btn, .btn-group, a').length) return;
      
      const no = $(this).data('estimate-id');
      if (no) {
        window.location.href = ctx + '/project/estimateDetail?prqudoNo=' + no;
      }
    });

    $(document).on("click", ".js-delete-estimate", function (e) {
    	  e.preventDefault();
    	  const prqudoNo = $(this).data("id");
    	  Swal.fire({
    	    title: "삭제하시겠습니까?",
    	    text: "삭제 후에는 복구할 수 없습니다.",
    	    icon: "warning",
    	    showCancelButton: true,
    	    confirmButtonColor: "#d33",
    	    cancelButtonColor: "#6c757d",
    	    confirmButtonText: "삭제",
    	    cancelButtonText: "취소"
    	  }).then((result) => {
    	    if (result.isConfirmed) {
    	      $.post(ctx + "/project/estimate/delete", { prqudoNo: prqudoNo })
    	        .done(() => {
    	          Swal.fire("삭제 완료!", "", "success").then(() => {
    	            location.reload();
    	          });
    	        })
    	        .fail(() => {
    	          Swal.fire("삭제 실패!", "", "error");
    	        });
    	    }
    	  });
    	});

    $('#uploadBtn').on('click', function () {
      window.location.href = ctx + '/project/estimateInsert?prjctNo=${prjctNo}';
    });
});
</script>
</body>
</html>
