<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

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
												<h4 class="fw-semibold mb-8">전사 연차 현황</h4>
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
															CompanyYearVacation</li>
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
														<div class="row px-6 pt-2">${empVO.empNm} (${empVO.deptNm})</div>
													</div>
												</div>
											</div>

											<%@ include file="/WEB-INF/views/attendance/attdMenu.jsp" %>
										</div>

										<!-- Main content -->
										<div class="d-flex w-100">
											<div class="w-100 p-3">

												<!-- 검색영역 -->
												<form class="mb-3 align-items-center" id="searchForm">
													
													<!-- 페이지 번호 -->
													<input type="hidden" id="currentPage" name="currentPage" value="1">
													
													<!-- 날짜 영역 -->
													<div class="row align-items-center mb-3 ms-2">
													  <!-- 1번째 칸: 입사일 -->
													  <div class="col-4">
							  								<select class="form-select w-auto" name="deptNo" id="deptNo">
																<option value="" selected>부서선택</option>
																<!-- 검색 조건 select -->
																<c:if test="${not empty deptList}">
																	<c:forEach items="${deptList }" var="dept">
																		<option value="${dept.deptNo}">${dept.deptNm}</option>
																	</c:forEach>
																</c:if>
															</select>
													  </div>
													
													  <!-- 2번째 칸: 날짜 영역 -->
													  <div class="col-4 text-center">
													    <div class="d-inline-flex align-items-center px-3 py-2 border rounded">
													      <button type="button" class="btn btn-sm border-0" id="prevBtn">◀</button>
													      <input type="hidden" value="${year}" id="year" name="year">
													      <span class="mx-2" id="rangeDisplay" style="display:inline-block; width:100px;" data-baseyear="${year}">${year}</span>
													      <button type="button" class="btn btn-sm border-0" id="nextBtn">▶</button>
													    </div>
													  </div>
													
													  <!-- 3번째 칸: 내보내기 버튼 영역 -->
													  	<div class="col-4 d-flex justify-content-end align-items-center gap-2">
							
				
															<!-- 검색어 입력 -->
															<input type="text" class="form-control w-auto" style="min-width:180px;" 
																   name="empNm" id="empNm" placeholder="이름입력"/>
				
															<!-- 버튼 -->
															<button type="button" class="btn bg-secondary-subtle text-secondary" id="searchBtn">
																<i class="ti ti-search"></i> 검색
															</button>
														</div>
													</div>
												</form>
												<!-- 날짜 영역 끝 -->

												<!-- 4가지 정보 -->
												<c:if test="${not empty result}">
													<c:set value="${result.headCount}" var="headCount" />
													<c:set value="${result.pagingVO}" var="pagingVO" />
													<c:set value="${pagingVO.dataList}" var="vacationList" />
												</c:if>
												<div class="row">
													<div class="col-md-6 col-lg-3">
														<div class="card rounded-3 card-hover">
															<div class="card-body">
																<div class="d-flex align-items-center">
																	<span class="flex-shrink-0"> <i
																			class="ti ti-users text-primary display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6" id="headCountCard">${headCount}명</h2>
																		<h3 class="mb-1 fs-3">직원 수</h3>
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
																			class="ti ti-calendar-smile text-info display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6" id="totYrycCoCard">${vacationList[0].companyTotYrycCo}일</h2>
																		<h3 class="mb-1 fs-3">전체 연차</h3>
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
																			class="ti ti-calendar-check text-danger display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6" id="useCoCard">${vacationList[0].companyUseCo }일</h2>
																		<h3 class="mb-1 fs-3">사용 연차</h3>
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
																			class="ti ti-calendar-stats text-success display-6"></i>
																	</span>
																	<div class="ms-4">
																		<h2 class="fw-bolder fs-6" id="remainCoCard">${vacationList[0].companyTotYrycCo - vacationList[0].companyUseCo }일</h2>
																		<h3 class="mb-1 fs-3">남은 연차</h3>
																	</div>
																</div>
															</div>
														</div>
													</div>

												</div>
												<!-- 4가지 정보 끝 -->

												<div class="table-responsive">
													<table class="table table-hover align-middle mb-0"
														style="table-layout: fixed;" id="companyTable">
														<thead class="bg-body-tertiary text-center">
															<tr>
																<th>이름</th>
																<th>부서</th>
																<th>직급</th>
																<th>총 연차</th>
																<th>사용</th>
															</tr>
														</thead>
														<tbody class="text-center">
															<c:if test="${not empty vacationList }">
																<c:forEach items="${vacationList }" var="v">
																	<tr data-emp-no="${v.empNo}">
																		<td>${v.empNm }</td>
																		<td>${v.deptNm }</td>
																		<td>${v.jdbcNm }</td>
																		<td>${v.totYrycCo }</td>
																		<td>${v.useCo }</td>
																	</tr>
																</c:forEach>
															</c:if>
														</tbody>
													</table>
												</div>

												<!-- 페이징 처리-->
												
												<!-- 2번째 칸: 페이징 중앙 -->
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
	
				<!-- 근태 상세 내역 모달 -->
				<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
				  <div class="modal-dialog modal-lg modal-dialog-centered">
				    <div class="modal-content">
				
				      <!-- 헤더 -->
				      <div class="modal-header">
				        <h5 class="modal-title fw-bold">연차 내역</h5>
				      </div>
				
				      <!-- 바디 -->
				      <div class="modal-body">
						<table class="table table-hover align-middle mb-0"
							style="table-layout: fixed;" id="detailTable">
							<thead class="bg-body-tertiary text-center">
								<tr>
									<th>기준연도</th>
									<th>연차시작일</th>
									<th>연차종료일</th>
									<th>사용연차</th>
								</tr>
							</thead>
							<tbody class="text-center"></tbody>
						</table>
				      </div>
				
				      <!-- 푸터 -->
				      <div class="modal-footer">
				        <button type="button" id="cancel" data-bs-dismiss="modal" class="btn btn-danger">닫기</button>
				      </div>
				
				    </div>
				  </div>
				</div>
				
				<%@ include file="/module/footerPart.jsp" %>
				
				
		<!-- axios -->
		<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
			   
		<script type="text/javascript">
			const today = new Date();
	
			const prevBtn = document.querySelector("#prevBtn"); // 이전 버튼
			const nextBtn = document.querySelector("#nextBtn"); // 다음 버튼
	
			const headCountCard = document.querySelector("#headCountCard"); // 직원수
			const totYrycCoCard = document.querySelector("#totYrycCoCard"); // 전체일
			const useCoCard = document.querySelector("#useCoCard"); // 사용일
			const remainCoCard = document.querySelector("#remainCoCard"); // 남은일
			
			const searchBtn = document.querySelector("#searchBtn");
			let isPagingClick = true;
			let lastSearchData = new FormData(document.querySelector("#searchForm")); // 최근 검색 조건 저장
			
			// 테이블 행 클릭 시
			const tbody = document.querySelector("#companyTable tbody");

			tbody.addEventListener("click", function(event){
			    // 클릭한 요소가 td이면 부모 tr을 찾음
			    const tr = event.target.closest("tr");
			    if(!tr) return;
			
			    const empNo = tr.dataset.empNo;
			    const year = parseInt(document.querySelector("#year").value);
			
			    axios.post("/attendance/getCompanyVacationByEmp", {
			        year: year,
			        empNo: empNo
			    }).then(res => {
			        const data = res.data;
			        const empNm = tr.querySelector("td").textContent; // 첫 번째 td가 이름

			        updateModalVacationTable(data.vacationList, empNm);
			    });
			
			    $("#detailModal").modal("show");
			});
			
			// 버튼 클릭 이벤트
			prevBtn.addEventListener("click", 
					function(){
					isPagingClick = false;
					fetchData(-1);
				}
			);
			
			nextBtn.addEventListener("click", 
					function(){
					isPagingClick = false;
					fetchData(1);
				}
			);

			// 폼 제출 이벤트
			document.querySelector("#searchForm").addEventListener("submit", function(event){
			    event.preventDefault(); // 엔터로 폼 제출 막기
			    searchBtn.click();      // 대신 검색 버튼 클릭 트리거
			});

			
			// 버튼 상태 갱신 함수
			function updateButtonState() {
			    const baseyear = parseInt(rangeDisplay.dataset.baseyear);
	
			    // next 버튼 제어
			    if (baseyear >= today.getFullYear()) {
			        nextBtn.disabled = true;
			    } else {
			        nextBtn.disabled = false;
			    }
			    
			}
	
			// 비동기로 데이터를 가져옴
			async function fetchData(offset){
				
				// form 가져오기
			    const searchFormEl = document.querySelector("#searchForm");
			    let formData = null;
				
			    // event.isSearchBtn 플래그가 없으면 검색 버튼에서 직접 클릭된 경우로 간주
			    if (!event.isPagingClick) {
			        searchFormEl.querySelector("#currentPage").value = 1; // 페이지 초기화
				    formData = new FormData(searchFormEl);
				    let year = parseInt(formData.get("year")); // 기존 값
			        if(offset > 0){
			        	 formData.set("year", year + 1);
			        }else if(offset < 0){
			        	 formData.set("year", year - 1);
			        }
				    lastSearchData = formData;
			    }else{
				    // form 데이터를 FormData 객체로 변환
				    formData = lastSearchData;
			    }
			    
			    await axios.post("/attendance/changeCompanyVacation", formData)
			    	.then(res => {
						console.log(res);
						const data = res.data;
						// 테이블 갱신
				    	updateVacationTable(data.pagingVO.dataList);
						
						// 요약카드 갱신
				    	updateSummaryCards(data.pagingVO.dataList[0], data.headCount);
						
				    	// 날짜 갱신
				    	document.querySelector("#year").value = data.pagingVO.year
				    	rangeDisplay.textContent = data.pagingVO.year;
				    	rangeDisplay.dataset.baseyear = data.pagingVO.year;
						
				    	// 버튼 갱신
						updateButtonState();
			    	});
				}
			
			function updateVacationTable(vacationList){
				
			    const tbody = document.querySelector("#companyTable tbody");
			    tbody.innerHTML = "";
			    
				vacationList.forEach(record => {
			    	console.log(record);
			        const tr = document.createElement("tr");
				        tr.innerHTML = `
				            <td>\${record.empNm}</td>
				            <td>\${record.deptNm}</td>
				            <td>\${record.jdbcNm}</td>
				            <td>\${record.totYrycCo}</td>
				            <td>\${record.useCo}</td>
				        `;
				        tr.dataset.empNo = record.empNo;
				        tbody.appendChild(tr);
			    });
			    
			}
			
			function updateModalVacationTable(vacationList, empNm){
				
			    const tbody = document.querySelector("#detailTable tbody");
			    const header = document.querySelector("#detailModal .modal-header");
			    
			    tbody.innerHTML = "";
			    
			    const head = '<h5 class="modal-title fw-bold">' + empNm + '님의 연차내역</h5>';
			    header.innerHTML = head;
			    
				vacationList.forEach(record => {
			    	console.log(record);
			        const tr = document.createElement("tr");
			        if(record.useCo != null && record.useCo != 0){
				        tr.innerHTML = `
				            <td>\${record.issuYr}</td>
				            <td>\${record.startDt}</td>
				            <td>\${record.endDt}</td>
				            <td>\${record.useCo}</td>
				        `;
				        tbody.appendChild(tr);
			        }
			    });
			    
			}
			
			function updateSummaryCards(data, headCount){
				headCountCard.textContent = headCount + "명";
				if(data != null){
					totYrycCoCard.textContent = data.companyTotYrycCo + "일";
					useCoCard.textContent = data.companyUseCo  + "일";
					remainCoCard.textContent = data.companyTotYrycCo - data.companyUseCo+ "일";
				}else{
					totYrycCoCard.textContent = "0일";
					useCoCard.textContent ="0일";
					remainCoCard.textContent = "0일";
				}
				
			}
			updateButtonState();
			
			$(document).ready(function(){
			    $("#pagingArea").on("click", "a", function(event){
			        event.preventDefault();
			        const pageNo = $(this).data("page");
			        lastSearchData.set("currentPage", pageNo); // currentPage 값을 바꾼다
			        
			        isPagingClick = true;
			        fetchData(0);
			    });
			});
			
			searchBtn.addEventListener("click", function(event){
				isPagingClick = false;
			    console.log("버튼");
				fetchData(0);
			});
			
// 			document.querySelector("#searchForm").addEventListener("submit", function(event){
// 			    event.preventDefault();
// 			    console.log("폼");
// 			    searchBtn.click();
// 			});
		</script>	
		</body>
</html>