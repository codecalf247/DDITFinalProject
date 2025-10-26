<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light"
    data-color-theme="Blue_Theme" data-layout="vertical">

<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>
<%@ include file="/module/headPart.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<%@ include file="/module/header.jsp"%>

<body>
    <%@ include file="/module/aside.jsp"%>
    <div class="body-wrapper">
		<div class="container-fluid">
			<div class="body-wrapper">
				<div class="container">

					<!-- 상단 제목 -->
					<div
						class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">전자결재 양식 상세보기</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a
												class="text-muted text-decoration-none" href="../main/index">Home</a></li>
											<li class="breadcrumb-item" aria-current="page"><a
												class="text-muted text-decoration-none"
												href="/eApproval/dashBoard">Approval</a></li>
											<li class="breadcrumb-item" aria-current="page">approvalForm</li>
										</ol>
									</nav>
								</div>

							</div>
						</div>
					</div>
					<div class="card overflow-hidden chat-application">
						<div
							class="d-flex align-items-center justify-content-between gap-6 m-3 d-lg-none">
							<button class="btn btn-primary d-flex" type="button"
								data-bs-toggle="offcanvas" data-bs-target="#chat-sidebar"
								aria-controls="chat-sidebar">
								<i class="ti ti-menu-2 fs-5"></i>
							</button>
							<form class="position-relative w-100">
								<input type="text" class="form-control search-chat py-2 ps-5"
									id="text-srh" placeholder="Search Contact" /> <i
									class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
							</form>
						</div>

						<div class="d-flex w-100">
							<%@ include file="/WEB-INF/views/eApproval/approvalAside.jsp"%>
							<div class="w-100">
								<!-- 상세보기 카드 -->
								<div class="card overflow-hidden">
									<div class="card-body">
										<h5 class="card-title fw-semibold mb-4">📝 ${form.formNm}</h5>

										<!-- 양식명 / 설명 / 최근 수정일 한 줄 배치 -->
										<div class="row mb-3">
											<div class="col-md-4">
												<label class="form-label fw-semibold">양식명</label>
												<p class="form-control-plaintext mb-0">${form.formNm}</p>
											</div>
											<div class="col-md-5">
												<label class="form-label fw-semibold">설명</label>
												<p class="form-control-plaintext mb-0">${form.formDc}</p>
											</div>
											<div class="col-md-3 text-muted">
												<label class="form-label fw-semibold">최근 수정일</label>
												<p class="form-control-plaintext mb-0">
													<c:choose>
														<c:when test="${not empty form.mdfcnYmd}">
															${fn:substring(form.mdfcnYmd,0,4)}-${fn:substring(form.mdfcnYmd,4,6)}-${fn:substring(form.mdfcnYmd,6,8)}
														</c:when>
														<c:otherwise>
															${fn:substring(form.regYmd,0,4)}-${fn:substring(form.regYmd,4,6)}-${fn:substring(form.regYmd,6,8)}
														</c:otherwise>
													</c:choose>
												</p>
											</div>
										</div>

										<div class="mb-3">
											<label class="form-label">내용</label>
											<div class="border rounded p-3" id="formCn" style="min-height: 150px;">
												${form.formCn}
											</div>
										</div>

										<div class="mb-3 text-muted">
											<small> 최근 수정일: <c:choose>
													<c:when test="${not empty form.mdfcnYmd}">
                                            ${fn:substring(form.mdfcnYmd,0,4)}-${fn:substring(form.mdfcnYmd,4,6)}-${fn:substring(form.mdfcnYmd,6,8)}
                                        </c:when>
													<c:otherwise>
                                            ${fn:substring(form.regYmd,0,4)}-${fn:substring(form.regYmd,4,6)}-${fn:substring(form.regYmd,6,8)}
                                        </c:otherwise>
												</c:choose>
											</small>
										</div>

										<!-- 버튼 -->
										<div class="d-flex justify-content-end gap-2 mt-4">
											<button type="button"
												class="btn bg-primary-subtle text-primary"
												onclick="location.href='${pageContext.request.contextPath}/eApprovalForm/approvalFormList/${form.upperFormNo }'">목록</button>
											<c:if test="${loginEmpNo eq '202508001' }">
												<button type="button"
													class="btn bg-warning-subtle text-warning"
													onclick="location.href='${pageContext.request.contextPath}/eApprovalForm/docDetailModify/${form.formNo}'">수정</button>
												<button type="button"
													class="btn bg-danger-subtle text-danger"
													onclick="deleteConfirm(${form.formNo})">삭제</button>
											</c:if>
										</div>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<script type="text/javascript">

document.addEventListener("DOMContentLoaded", function(){
	
	// 전자결재 cn 안에 속성 바꾸기
	document.querySelectorAll("#formCn input, #formCn textarea, #formCn select")
	  .forEach(el => {
	    if (el.tagName === "INPUT") {
	      let type = el.type; // input의 타입 체크
	      if (["text", "number", "date", "email", "password"].includes(type)) {
	        // 텍스트류는 readonly
	        el.readOnly = true;
	      } else {
	        // 체크박스, 라디오 등은 disabled
	        el.disabled = true;
	      }
	    } else {
	      // textarea, select는 disabled 처리
	      el.disabled = true;
	    }
	});
	
});

  
</script>

<%@ include file="/module/footerPart.jsp"%>
</body>
</html>
