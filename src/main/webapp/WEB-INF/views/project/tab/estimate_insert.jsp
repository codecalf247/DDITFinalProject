<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <title>견적 등록</title>
</head>
<body>
  <%@ include file="/module/header.jsp" %>

  <div class="body-wrapper">
    <div class="container-fluid">
     <div class="body-wrapper">
        <div class="container">

      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 견적서 등록</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/estimate?prjctNo=${prjctNo}">Estimate</a></li>
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
          <form action="${pageContext.request.contextPath}/project/estimateInsert" 
                method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="prjctNo" value="${prjctNo}">

            <div class="mb-3">
              <label for="estTitle" class="form-label">제목</label>
              <input type="text" class="form-control" id="estTitle" name="prqudoTitle" 
                     placeholder="예) 2025-3분기 인테리어 공사 견적" required>
            </div>

            <div class="mb-3">
              <label for="estPriceDisplay" class="form-label">견적비용</label>
              <div class="input-group">
                <span class="input-group-text">₩</span>
                <input type="text" class="form-control" id="estPriceDisplay" inputmode="numeric" 
                       placeholder="예) 40,500,000" required>
                <input type="hidden" id="estPrice" name="estmtAmount">
              </div>
              <div class="form-text">숫자만 입력해도 자동으로 천단위로 표시됩니다.</div>
            </div>

            <div class="mb-3">
              <label for="estFile" class="form-label">파일 업로드</label>
              <input class="form-control" type="file" id="estFile" name="uploadFiles" 
                     accept=".xlsx,.xls,.pdf,.doc,.docx,.hwp,.hwpx">
              <div class="form-text">엑셀/문서/PDF 업로드 가능</div>
            </div>

            <div class="mb-3">
              <label for="estContent" class="form-label">내용</label>
              <textarea class="form-control" id="estContent" name="prqudoCn" rows="6"
                        placeholder="견적 상세 내용을 입력하세요." required></textarea>
            </div>

            <div class="d-flex justify-content-end">
              <button type="button" class="btn btn-warning me-auto" id="dummyDataBtn">더미 데이터 채우기</button>
              <a href="${pageContext.request.contextPath}/project/estimate?prjctNo=${prjctNo}" 
                 class="btn btn-light me-2">취소</a>
              <button type="submit" class="btn btn-primary">등록</button>
            </div>

          </form>
        </div>
      </div>

    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>
  
  <script type="text/javascript">
  document.addEventListener("DOMContentLoaded", () => {
      const displayEl = document.getElementById("estPriceDisplay");
      const hiddenEl  = document.getElementById("estPrice");
      const dummyDataBtn = document.getElementById("dummyDataBtn"); // 더미 데이터 버튼 요소

      function onlyDigits(value) {
        return (value || "").replace(/[^\d]/g, "");
      }

      // 견적비용 입력 시 포맷팅 및 Hidden 필드 업데이트 로직
      displayEl.addEventListener("input", () => {
        const digits = onlyDigits(displayEl.value);
        displayEl.value = digits ? Number(digits).toLocaleString("ko-KR") : "";
        hiddenEl.value = digits || "";
      });

   // 더미 데이터 채우기 기능
      if (dummyDataBtn) {
        dummyDataBtn.addEventListener("click", () => {
          // 1. 제목 설정
          document.getElementById("estTitle").value = "추가 견적서_ 최종견적";
          
          // 2. 견적비용 설정 (86,000,000)
          const dummyPrice = "86000000";
          displayEl.value = Number(dummyPrice).toLocaleString("ko-KR"); // 화면 표시용 (콤마 적용)
          hiddenEl.value = dummyPrice; // 서버 전송용 (순수 숫자)
          
          // 3. 내용 설정 (템플릿 리터럴 + trim으로 불필요 공백 제거)
          document.getElementById("estContent").value = `
      대표님께 최종 승인 받은 추가 견적서 송부합니다!
      프로젝트 담당자 인원들은 퇴근 후 한번씩 견적서 조회 부탁드리겠습니다.
      현장 소장님들도 현장 출근하시면 필참 부탁드리겠습니다!
          `.trim();
        });
      }

    });
  </script>
</body>
</html>
