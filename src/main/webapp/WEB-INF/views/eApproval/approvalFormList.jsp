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
<!-- Bootstrap Icons CDN -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

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
											<li class="breadcrumb-item" aria-current="page"><a
												class="text-muted text-decoration-none"
												href="/eApproval/approvalFormFolder">approvalForm</a></li>
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
														<c:if test="${not empty sanctnFormList}">
															<form id="searchForm"
																action="${pageContext.request.contextPath}/eApprovalForm/approvalFormList/${sanctnFormList[0].upperFormNo}"
																method="get" class="d-flex">
																<input type="hidden" name="page" id="page" />
																<div class="btn-group">
																	<div class="dropdown">
																		<select class="form-select me-2" name="searchType"
																			style="width: auto; display: inline-block;">
																			<option value="title"
																				<c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
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
														</c:if>
													</div>
												</div>
												<hr class="mt-3">

												<div class="row row-cols-1 row-cols-md-3">
													<c:choose>
														<c:when test="${empty sanctnFormList }">
															<h5 class="card-title fw-semibold">하위 문서가 없습니다.</h5>
														</c:when>
														<c:otherwise>
															<c:forEach items="${sanctnFormList }" var="form">
																<div class="col">
																	<div class="card h-100 position-relative">

																		<div class="card-body">
																			<h5 class="card-title fw-semibold">
																				<a
																					href="${pageContext.request.contextPath}/eApprovalForm/approvalFormDetail/${form.formNo}">
																					${form.formNm} </a>

																				<c:set var="isFavorite" value="false" />
																				<c:forEach items="${sanctnFormBkmkList }" var="bkmk">
																					<c:if test="${bkmk.formNo == form.formNo }">
																						<c:set var="isFavorite" value="true" />
																					</c:if>
																				</c:forEach>

																				<i class="bi ${isFavorite ? 'bi-star-fill text-warning' : 'bi-star text-secondary' } 
																			       fs-4 ms-2 favorite-icon"
																					style="cursor: pointer;"
																					data-formno="${form.formNo }"></i>
																			</h5>

																			<div
																				class="d-flex justify-content-between align-items-center mt-2">
																				<small class="text-muted">- ${form.formDc }</small>
																			</div>
																			<div
																				class="d-flex justify-content-between align-items-end mt-3">
																				<div>
																					<small class="text-muted d-block">최근 수정: <c:choose>
																							<c:when test="${empty form.mdfcnYmd }">
																						${fn:substring(form.regYmd, 0, 4)}-
																	                    ${fn:substring(form.regYmd, 4, 6)}-
																	                    ${fn:substring(form.regYmd, 6, 8)}
																					</c:when>
																							<c:otherwise>
																						${fn:substring(form.mdfcnYmd, 0, 4)}-
																	                    ${fn:substring(form.mdfcnYmd, 4, 6)}-
																	                    ${fn:substring(form.mdfcnYmd, 6, 8)}
																					</c:otherwise>
																						</c:choose>
																					</small>
																				</div>
																			</div>
																		</div>

																	</div>
																</div>
															</c:forEach>
														</c:otherwise>
													</c:choose>
												</div>
											</div>
										</div>

										<div
											class="d-flex justify-content-between align-items-center mt-3">
											<div class="d-flex justify-content-center flex-grow-1">
												${pagingVO.pagingHTML2 }</div>
											<div>
												<button type="button" id="newFormRegister"
													class="btn bg-primary-subtle text-primary">새 양식 등록
												</button>
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
	</div>


	<script type="text/javascript">
document.addEventListener("DOMContentLoaded", () => {
	
		// 새 양식 등록 버튼 등록
		document.querySelector("#newFormRegister").addEventListener("click", function() {
			console.log("newFormRegister 클릭");
			location.href = "${pageContext.request.contextPath}/eApprovalForm/registerForm/${formNo}";
		});
		
		
		// 즐겨찾기 버튼 클릭
	    document.querySelectorAll(".favorite-icon").forEach(star => {
	        star.addEventListener("click", function () {
	        	console.log("즐겨찾기 클릭");
	        	
	        	let empNo = "${empNo }"; 
	        	let formNo = this.dataset.formno;
	            let isBkmk = this.classList.contains("bi-star-fill");
	        	
	            if (isBkmk) {
	            	// 즐겨찾기 해제
	                this.classList.remove("bi-star-fill", "text-warning");
	                this.classList.add("bi-star", "text-secondary");
	                isBkmk = 'N';
	            } else {
	            	// 즐겨찾기 등록
	                this.classList.remove("bi-star", "text-secondary");
	                this.classList.add("bi-star-fill", "text-warning");
	                isBkmk = 'Y';
	            }
	            
	            let data = {
	            	empNo : empNo,
                    formNo : formNo,
                    isBkmk : isBkmk
	            };

	            console.log("즐겨찾기 data: ", data);
	            
	            fetch("/eApprovalForm/approvalFormBkmk", {
	                method : "post",
	                headers : {
	                    "Content-Type" : "application/json"
	                },
	                body : JSON.stringify(data)
	            }).then(res => res.text())
	            .then((res) => {
	            	if(res === "SUCCESS"){
		                console.log("즐겨찾기 변경 완료:", data);
	            	}else if(res === "즐겨찾기는 4개까지만 가능합니다."){
		            	Swal.fire({
		            		title : "즐겨찾기는 4개까지만 가능합니다.",
		            		icon : "error",
	            			confirmButtonText : "네"
		            	}).then((res)=>{
		            		if(res.isConfirmed){
		    	                this.classList.remove("bi-star-fill", "text-warning");
		    	                this.classList.add("bi-star", "text-secondary");
		            		}
		            	});
	            	}
	            });
	            
	        
	        });
	    });
		
		
});
</script>

	<%@ include file="/module/footerPart.jsp"%>
</body>
</html>
