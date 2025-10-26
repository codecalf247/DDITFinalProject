<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
	<head>
		<!-- Required meta tags -->
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>GroupWare</title>
		<%@ include file="/module/headPart.jsp" %>
	</head>
	<%@ include file="/module/header.jsp" %>

		<body>
			<%@ include file="/module/aside.jsp" %>
				<div class="body-wrapper">
					<div class="container-fluid">

						<div class="body-wrapper">
							<div class="container">
								<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
									<div class="card-body px-4 py-3">
										<div class="row align-items-center">
											<div class="col-9">
												<h4 class="fw-semibold mb-8">근태 수정 요청</h4>
												<nav aria-label="breadcrumb">
													<ol class="breadcrumb">
														<li class="breadcrumb-item">
															<a class="text-muted text-decoration-none"
																href="${pageContext.request.contextPath}/main/index">Home</a>
														</li>
														<li class="breadcrumb-item" aria-current="page">
															<a class="text-muted text-decoration-none"
																href="${pageContext.request.contextPath}/attendance">Attendance</a>
														</li>
														<li class="breadcrumb-item" aria-current="page">
															AttendanceUpdateRequest</li>
													</ol>
												</nav>
											</div>
										</div>
									</div>
								</div>

								<div class="card overflow-hidden chat-application">
									<div class="d-flex align-items-center justify-content-between gap-6 m-3 d-lg-none">
										<button class="btn btn-primary d-flex" type="button" data-bs-toggle="offcanvas"
											data-bs-target="#chat-sidebar" aria-controls="chat-sidebar">
											<i class="ti ti-menu-2 fs-5"></i>
										</button>
										<form class="position-relative w-100">
											<input type="text" class="form-control search-chat py-2 ps-5" id="text-srh"
												placeholder="Search Contact" /> <i
												class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
										</form>
									</div>

									<div class="d-flex w-100">
										<!-- Left rail -->
										<div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
											<div class="px-6 pt-4">
												<div class="card">
													<div class="card-header">
														<div class="d-flex align-items-center">
															<h6 class="card-title 1h-base mb-0">근태</h6>
														</div>
														<div class="row px-6 pt-2">${empVO.empNm } (${empVO.deptNm })</div>
													</div>
												</div>
											</div>

											<%@ include file="/WEB-INF/views/attendance/attdMenu.jsp" %>
										</div>

										<!-- Main content -->
										<div class="d-flex w-100">
											<div class="w-100 p-3">

												<sec:authorize access="hasRole('ROLE_MANAGER')">
													<!-- 필터 및 날짜 영역 -->
													<form class="mb-3 align-items-center" action="/attendance/attdUpdateReq">
														<!-- 오른쪽 정렬 영역 -->
														<div class="d-flex justify-content-end gap-2 ms-auto">
															<select class="form-select w-auto" name="deptNo" id="deptNo">
																<option value="" selected>부서선택</option>
																<!-- 검색 조건 select -->
																<c:if test="${not empty deptList}">
																	<c:forEach items="${deptList }" var="dept">
																		<option value="${dept.deptNo}"
																			<c:if test="${dept.deptNo eq searchedDeptNo}">selected</c:if>
																		>${dept.deptNm}</option>
																	</c:forEach>
																</c:if>
															</select>
				
															<!-- 검색 조건 select -->
															<select class="form-select w-auto" name="status" id="status">
																<option value="" selected>상태선택</option>
																<c:if test="${not empty statusList}">
																	<c:forEach items="${statusList}" var="status">
																		<option value="${status.cmmnCdId}"
																			<c:if test="${status.cmmnCdId eq searchedStatus}">selected</c:if>
																		>${status.cmmnCdNm}</option>
																	</c:forEach>
																</c:if>
															</select>
	
															<!-- 검색어 입력 -->
															<input type="text" class="form-control w-auto" style="min-width:180px;" 
																   name="empNm" id="empNm" placeholder="이름입력" value="${searchedEmpNm }"/>
	
															<!-- 버튼 -->
															<button type="submit" class="btn bg-secondary-subtle text-secondary" id="searchBtn">
																<i class="ti ti-search"></i> 검색
															</button>
														</div>
													</form>
												</sec:authorize>
												<!-- 날짜 영역 끝 -->

												<!-- 4가지 정보 -->
												<div class="row">
													<div class="col-md-6 col-lg-3">
														<div class="card rounded-3 card-hover">
															<div class="card-body">
																<div class="d-flex align-items-center">
																	<span class="flex-shrink-0"> <i
																			class="ti ti-file-import display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6">${countRequestVO.totalCount}</h2>
																		<h3 class="mb-1 fs-3">전체 요청</h3>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<div class="col-md-6 col-lg-3">
														<div class="card rounded-3 card-hover">
															<div class="card-body">
																<div class="d-flex align-items-center">
																	<span class="flex-shrink-0"> <i
																			class="ti ti-clock text-warning display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6">${countRequestVO.pendingCount}</h2>
																		<h3 class="mb-1 fs-3">처리중</h3>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<div class="col-md-6 col-lg-3">
														<div class="card rounded-3 card-hover">
															<div class="card-body">
																<div class="d-flex align-items-center">
																	<span class="flex-shrink-0"> <i
																			class="ti ti-check text-success display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6">${countRequestVO.approvedCount}</h2>
																		<h3 class="mb-1 fs-3">승인</h3>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<div class="col-md-6 col-lg-3">
														<div class="card rounded-3 card-hover">
															<div class="card-body">
																<div class="d-flex align-items-center">
																	<span class="flex-shrink-0"> <i
																			class="ti ti-x text-danger display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6">${countRequestVO.rejectCount}</h2>
																		<h3 class="mb-1 fs-3">반려</h3>
																	</div>
																</div>
															</div>
														</div>
													</div>

												</div>
												<!-- 4가지 정보 끝 -->

												<!-- 근태 수정 요청 데이터 -->
												<div class="table-responsive">
													<table class="table table-hover align-middle mb-0"
														style="table-layout: fixed;" id="requestTable">
														<thead class="bg-body-tertiary text-center">
															<tr>
																<sec:authorize access="hasRole('ROLE_MANAGER')">
																<th>사원명</th>
																<th>부서</th>
																</sec:authorize>
																<th>요청일</th>
																<th>대상일</th>
																<th>요청유형</th>
																<th>기존시간</th>
																<th>요청시간</th>
																<th>처리상태</th>
															</tr>
														</thead>
														
														<tbody class="text-center">
															<c:if test="${not empty requestList }">
																<c:forEach items="${requestList }" var="r">
																	<c:choose>
																		
																		<c:when test="${r.requstSttus eq '처리중' }">
																			<c:set value="bg-warning-subtle text-warning" var="badgeStyle" />
																		</c:when>
																		<c:when test="${r.requstSttus eq '승인' }">
																			<c:set value="bg-success-subtle text-success" var="badgeStyle"/>
																		</c:when>
																		<c:when test="${r.requstSttus eq '반려' }">
																			<c:set value="bg-danger-subtle text-danger" var="badgeStyle"/>
																		</c:when>
																	</c:choose>
																
																	<tr data-request-no="${r.workHistMdfncRequstNo}">
																	<sec:authorize access="hasRole('ROLE_MANAGER')">
																		<td>${r.empNm }</td>
																		<td>${r.deptNm }</td>
																	</sec:authorize>
																		<td>${r.requstRegYmd }</td>
																		<td>${r.workYmd }</td>
																		<td>${r.requstTy }</td>
																		<td>${r.defaultTime }</td>
																		<td>${r.requstTime }</td>
																		<td>
																			<span class="mb-1 badge rounded-pill ${badgeStyle }">${r.requstSttus }</span>
																		</td>
																	</tr>
																</c:forEach>
															</c:if>
														</tbody>
													</table>
												</div>
												<!-- 근태 현황 데이터 끝  -->

												<!-- 페이징 처리-->
												<div class="d-flex justify-content-center mb-3 mt-3" id="pagingArea">
													${pagingVO.getPagingHTML() }
												</div>

												<!-- 페이징 처리 및 내보내기 버튼 끝-->
											</div>
										</div>

									</div>
								</div>

							</div>
						</div>

					</div> <!-- <div class="container-fluid"> -->
				</div> <!-- <div class="body-wrapper"> -->

				<!-- 모달 2 -->
				<div class="modal fade" id="modal" tabindex="-1">
					<div class="modal-dialog modal-lg modal-dialog-centered">
						<div class="modal-content">
							<!-- 헤더 -->
							<div class="modal-header">
								<h5 class="modal-title fw-bold" id="attdEditModalLabel">
									근태 수정 요청
								</h5>
							</div>

							<!-- 바디 -->
							<div class="modal-body">
							
							<sec:authorize access="hasRole('ROLE_MANAGER')">
								<div class="row mb-3">
									<div class="col-md-6">
										<label class="form-label">이름</label>
										<input class="form-control" type="text" id="modalEmpNm"
											disabled>
									</div>
									<div class="col-md-6">
										<label class="form-label">부서</label>
										<input class="form-control" type="text" id="modalDeptNm"
											disabled>
									</div>
								</div>
							</sec:authorize>

								<!-- 근태 목록 -->
								<div class="row mb-3">
									<div class="col-md-6">
										<label class="form-label">대상 날짜</label>
										<input class="form-control" type="text" id="workYmd"
											disabled>
									</div>
									<div class="col-md-6">
										<label class="form-label">상태</label>
										<input class="form-control" type="text" id="modalStatus"
											disabled>
									</div>
								</div>

								<div class="mb-3">
									<label class="form-label">요청 유형</label>
									<input class="form-control" type="text" id="requestTy" 
										disabled>
								</div>

								<!-- 요청 시간 -->
								<div class="form-group mb-3">
									<label class="form-label">요청 시간</label>
									<input type="time" class="form-control" id="requestTime"
										disabled>
								</div>

								<!-- 사유 -->
								<div class="mb-3">
									<label class="form-label">사유</label>
									<textarea class="form-control" rows="3" style="resize: none;" id="reasonReq" disabled></textarea>
								</div>

								<!-- 반려사유 -->
								<div class="mb-3">
									<label class="form-label">반려사유</label>
									<input class="form-control" type="text" id="returnReq"
									 <sec:authorize access="!hasRole('ROLE_MANAGER')">disabled</sec:authorize> >
									 <div class="invalid-feedback"></div>
								</div>

								<!-- 첨부파일 -->
								<div class="mb-3">
									<label for="fileArea" class="form-label">첨부파일</label>
									<div id="fileArea"></div>
								</div>

							</div>

							<!-- 푸터 -->
							<sec:authorize access="hasRole('ROLE_MANAGER')">
								<div class="modal-footer">
									<button type="button" class="btn btn-success" id="approveBtn">승인</button>
									<button type="button" class="btn btn-danger" id="rejectBtn">거절</button>
								</div>
							</sec:authorize>
						</div>
					</div>
				</div>
				
				

				<%@ include file="/module/footerPart.jsp" %>
				
				<!-- SweetAlert -->
        		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        		
				<script>
					// 테이블 행 클릭 시
					const tbody = document.querySelector("#requestTable tbody");
					let currentRequestNo = null;	// 요청을 보낼 번호
					
					tbody.addEventListener("click", function(event){
					    // 클릭한 요소가 td이면 부모 tr을 찾음
					    const tr = event.target.closest("tr");
					    if(!tr) return;
					
					    const requestNo = tr.dataset.requestNo;
					    currentRequestNo = requestNo;	// 누른 요청 번호 기억
					    
					    axios.post("/attendance/getRequestDetail", {
					    	requestNo: requestNo
					    }).then(res => {
					        const data = res.data;
	
					        updateModal(data);
					    });
					
					    $("#modal").modal("show");
					});
					
					function updateModal(data){
						
						// 이름
					    const modalEmpNm = document.getElementById("modalEmpNm");
					    if (modalEmpNm) modalEmpNm.value = data.empNm || "";

					    // 부서
					    const modalDeptNm = document.getElementById("modalDeptNm");
					    if (modalDeptNm) modalDeptNm.value = data.deptNm || "";
					    
					    // 대상 날짜
					    document.getElementById("workYmd").value = data.workYmd || "";

					    // 상태
					    document.getElementById("modalStatus").value = data.requstSttus || "";

					    // 요청 유형
					    document.getElementById("requestTy").value = data.requstTy || "";

					    // 요청 시간
					    document.getElementById("requestTime").value = data.requstTime || "";

					    // 사유
					    document.getElementById("reasonReq").value = data.requstResn || "";

					    // 반려 사유
					    document.getElementById("returnReq").value = data.returnResn || "";

					    // 첨부파일 영역 업데이트
					    const fileArea = document.querySelector("#fileArea");
					    if (fileArea) {
					    	console.log(fileArea);
					    	console.log(data.savedNm);
					    	 if (data.savedNm) {
					             fileArea.innerHTML = `
					            	 <ul class="list-group list-group-flush rounded-3 border attach-list mb-2">
					            	    <li class="list-group-item d-flex align-items-center justify-content-between">
					            	      <div class="d-flex align-items-center" style="cursor: pointer;">
					            	        <i class="ti ti-file-text fs-5 me-2 text-primary"></i>
					            	        <div class="d-flex flex-column">
					            	          <a href="/attendance/downloadFile?fileName=\${data.savedNm}"
					            	             download="\${data.originalNm}"
					            	             class="fw-medium text-decoration-underline text-primary">
					            	            \${data.originalNm}
					            	          </a>
					            	        </div>
					            	      </div>
					            	      <div class="ms-auto">
					            	        <a href="/attendance/downloadFile?fileName=\${data.savedNm}" 
					            	           class="btn btn-sm btn-outline-secondary"
					            	           download="\${data.originalNm}">
					            	          <i class="ti ti-download"></i> 다운로드
					            	        </a>
					            	      </div>
					            	    </li>
					            	  </ul>
					             `;
					         } else {
					             fileArea.innerHTML = `<span class="text-muted mb-2">첨부파일 없음</span>`;
					         }
					    }
					}
					
					// 승인 버튼
					document.getElementById("approveBtn").addEventListener("click", function(){
					    if(!currentRequestNo) return;
					    axios.post("/attendance/updateRequestStatus", {
					        requestNo: currentRequestNo, 
					        status: "approve"
					    }).then(res => {
					        if(res.data === "OK"){
					        	Swal.fire("알림", "승인 완료되었습니다.", "success");
							    $("#modal").modal("hide");
					            updateModalStatus(currentRequestNo, "승인"); // 테이블 업데이트
					            // location.reload(); // 테이블 새로고침
					        }else{
					        	Swal.fire("알림", "요청 승인 실패", "warning");
					        }
					    }).catch(err => console.error(err));
					});

					// 거절 버튼
					document.getElementById("rejectBtn").addEventListener("click", function(){
					    if(!currentRequestNo) return;
					    const returnReason = document.getElementById("returnReq").value;
					    
						
						if(returnReason == ""){
							document.querySelector("#returnReq").classList.add('is-invalid');
							document.querySelector("#returnReq").nextElementSibling.textContent = "반려사유를 입력해주세요!"; // 메시지 동적 설정
							return
						}else{
							document.querySelector("#returnReq").classList.remove('is-invalid');
							document.querySelector("#returnReq").nextElementSibling.textContent = ""; // 메시지 초기화
						}
						
					    axios.post("/attendance/updateRequestStatus", {
					        requestNo: currentRequestNo,
					        status: "reject",
					        returnResn: returnReason
					    }).then(res => {
					        if(res.data === "OK"){
					        	Swal.fire("알림", "반려 완료되었습니다.", "success");
							    $("#modal").modal("hide");
					            updateModalStatus(currentRequestNo, "반려"); // 테이블 업데이트
					        	// location.reload();
					        }else{
					        	Swal.fire("알림", "요청 반려 실패", "warning");
					        }
					    }).catch(err => console.error(err));
					});
					
					// 테이블 상태 업데이트 함수
					function updateModalStatus(requestNo, status){
					    const tr = document.querySelector(`#requestTable tbody tr[data-request-no="\${requestNo}"]`);
					    if(!tr) return;

					    const statusTd = tr.querySelector("td:last-child span"); // 마지막 컬럼 span
					    if(!statusTd) return;

					    statusTd.textContent = status;

					    // badge 색상 변경
					    statusTd.className = "mb-1 badge rounded-pill"; // 기존 클래스 초기화
					    if(status === "승인"){
					        statusTd.classList.add("bg-success-subtle", "text-success");
					    } else if(status === "반려"){
					        statusTd.classList.add("bg-danger-subtle", "text-danger");
					    } else if(status === "처리중"){
					        statusTd.classList.add("bg-warning-subtle", "text-warning");
					    }
					}
				</script>
		</body>