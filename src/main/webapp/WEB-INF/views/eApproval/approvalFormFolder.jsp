<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">

<head>
<!-- Required meta tags -->
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>
<%@ include file="/module/headPart.jsp"%>
</head>
<%@ include file="/module/header.jsp"%>

<body>
	<%@ include file="/module/aside.jsp"%>
	<div class="body-wrapper">
		<div class="container-fluid">
			<div class="body-wrapper">
				<div class="container">
					<div
						class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">전자결재 양식</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a
												class="text-muted text-decoration-none" href="../main/index">Home</a>
											</li>
											<li class="breadcrumb-item" aria-current="page"><a
												class="text-muted text-decoration-none"
												href="/eApproval/dashBoard">Approval</a></li>
											<li class="breadcrumb-item" aria-current="page">approvalForm</li>
										</ol>
									</nav>
								</div>
								<div class="col-3"></div>
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

							<div class="d-flex w-100 right-part">
								<div class="w-100 ps-0 ps-xl-5">
									<div
										class="card bg-light-info shadow-none position-relative overflow-hidden mb-4">
										<div class="card-body">
											<div class="row">
												<div
													class="col-12 d-flex justify-content-between align-items-center">
													<h5 class="text-dark">전체 ${cnt }건</h5>
													<div class="d-flex flex-wrap gap-2 align-items-center">
														<form id="searchForm"
															action="${pageContext.request.contextPath}/eApproval/approvalFormFolder"
															method="get" class="d-flex">
															<input type="hidden" name="page" id="page" />
															<div class="btn-group">
																<div class="dropdown">
																	<select class="form-select me-2" name="searchType"
																		style="width: auto; display: inline-block;">
																		<option value="title"
																			<c:if test="${searchType == 'title' }">selected</c:if>>제목</option>
																	</select>
																</div>
															</div>
															<div class="input-group w-80">
																<input type="text" name="searchWord"
																	class="form-control" value="${searchWord }"
																	placeholder="검색어를 입력하세요.">
																<button class="btn btn-outline-secondary" type="submit">
																	<i class="ti ti-search"></i> 검색
																</button>
															</div>
														</form>
													</div>
												</div>
												<hr class="mt-3">

												<div class="row row-cols-1 row-cols-md-3">
													<c:forEach items="${sanctnFormFolderList }" var="folder">
														<div class="col">
															<div class="card h-100 position-relative">

																<div class="card-body">
																	<h5 class="card-title fw-semibold">
																		<a
																			href="${pageContext.request.contextPath}/eApprovalForm/approvalFormList/${folder.formNo}">
																			${folder.formNm } </a>
																	</h5>
																	<c:if test="${loginEmpNo eq '202508001' }">
																		<div
																			class="d-flex justify-content-between align-items-start">

																			<div class="btn-group" data-form-no=${folder.formNo }>
																				<button type="button"
																					class="btn btn-sm btn-outline-secondary mdfBtn">수정</button>
																				<button type="button"
																					class="btn btn-sm btn-outline-danger delBtn">삭제</button>
																			</div>
																		</div>
																	</c:if>
																	<div
																		class="d-flex justify-content-between align-items-center mt-2">
																		<small class="text-muted">${folder.formDc }</small> 
																		<i class="bi bi-star-fill text-warning fs-4"></i>
																	</div>
																	<div
																		class="d-flex justify-content-between align-items-end mt-3">
																		<div>
																			<small class="text-muted d-block">최근 수정: <c:choose>
																					<c:when test="${empty folder.mdfcnYmd }">
																				${fn:substring(folder.regYmd, 0, 4)}-
															                    ${fn:substring(folder.regYmd, 4, 6)}-
															                    ${fn:substring(folder.regYmd, 6, 8)}
																			</c:when>
																					<c:otherwise>
																				${fn:substring(folder.mdfcnYmd, 0, 4)}-
															                    ${fn:substring(folder.mdfcnYmd, 4, 6)}-
															                    ${fn:substring(folder.mdfcnYmd, 6, 8)}
																			</c:otherwise>
																				</c:choose>
																			</small>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</c:forEach>
												</div>
											</div>
										</div>

										<div
											class="d-flex justify-content-between align-items-center mt-3">
											<div class="d-flex justify-content-center flex-grow-1">
												${pagingVO.pagingHTML2 }</div>
											<c:if test="${loginEmpNo eq '202508001' }">
												<div>
													<button type="button" id="newFormRegister"
														class="btn bg-primary-subtle text-primary ms-3">
														새 양식 폴더 등록</button>
												</div>
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
		<!-- <div class="container-fluid"> -->
	</div>
	<!-- <div class="body-wrapper"> -->


	<script type="text/javascript">
document.addEventListener("DOMContentLoaded", () => {
	
	// 새 양식 폴더 등록하기 버튼
	document.querySelector("#newFormRegister").addEventListener("click", function() {
		console.log("newFormRegister 클릭");
		location.href = "${pageContext.request.contextPath}/eApprovalForm/registerFolder";
	});
	
	// 수정 버튼 클릭
	document.querySelectorAll(".mdfBtn").forEach(btn => {
		btn.addEventListener("click", function(){
			let formNo = this.closest(".btn-group").dataset.formNo;
			console.log("수정 formNo: ", formNo);
			
			location.href = "${pageContext.request.contextPath}/eApprovalForm/modifyFolder/" + formNo;
		});
	});
	
	// 삭제 버튼 클릭
	document.querySelectorAll(".delBtn").forEach(btn => {
		btn.addEventListener("click", function(){
			let formNo = this.closest(".btn-group").dataset.formNo;
			console.log("삭제 formNo: ", formNo);

			Swal.fire({
				title: "정말로 삭제하시겠습니까?",
				html: "하위 양식까지 강제 삭제됩니다.",
				icon:"warning",
				showCancelButton: true,
				confirmButtonText: "네",
				cancelButtonText: "취소"
			}).then((res) => {
				console.log(res);
				if(res.isConfirmed){
					fetch("${pageContext.request.contextPath}/eApprovalForm/deleteFolder/" + formNo, {
						method: "post"
					}).then((res) => {
						console.log("요청 후", res);
						if(res.status == 200){
							deleteSuccessAlert();
							this.closest(".col").remove();
						}else{
							deleteErrorAlert();
						}
					});
				}
			});
			
		})
	});
	
});

//////////////////////////////
// sweetAlert
function deleteSuccessAlert(){
	Swal.fire({
		title: "삭제가 완료되었습니다.",
		icon: "success",
		confirmButtonText: "확인"
	});
}

function deleteErrorAlert(){
	Swal.fire({
		title: "삭제 실패하였습니다.",
		icon: "error",
		confirmButtonText: "확인"
	});
}
</script>

	<%@ include file="/module/footerPart.jsp"%>
</body>
</html>
