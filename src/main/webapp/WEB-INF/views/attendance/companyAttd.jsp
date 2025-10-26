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
									<h4 class="fw-semibold mb-8">전사 근태 현황</h4>
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
											<li class="breadcrumb-item" aria-current="page">CompanyAttd</li>
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

									<!-- 필터 및 날짜 영역 -->
									<form class="row g-2 mb-3 align-items-center" method="post" id="searchForm">
											
										<!-- 페이지 번호 -->
										<input type="hidden" id="currentPage" name="currentPage" value="1">
											
										<!-- 시작일 -->
										<div class="col-md-2">
											<input type="date" class="form-control" name="startDay" id="startDay" value="${startDay }" />
										</div>

										<!-- ~ 표시 -->
										<div class="col-auto text-center">
											~
										</div>

										<!-- 종료일 -->
										<div class="col-md-2">
											<input type="date" class="form-control" name="endDay" id="endDay" value="${endDay}" />
										</div>

										<!-- 오른쪽 정렬 영역 -->
										<div class="col d-flex justify-content-end gap-2 ms-auto">
											
											<select class="form-select w-auto" name="deptNo" id="deptNo">
												<option value="" selected>부서선택</option>
												<!-- 검색 조건 select -->
												<c:if test="${not empty deptList}">
													<c:forEach items="${deptList }" var="dept">
														<option value="${dept.deptNo}">${dept.deptNm}</option>
													</c:forEach>
												</c:if>
											</select>

											<!-- 검색 조건 select -->
											<select class="form-select w-auto" name="status" id="status">
												<option value="" selected>상태선택</option>
												<c:if test="${not empty statusList}">
													<c:forEach items="${statusList}" var="status">
														<option value="${status.cmmnCdId}">${status.cmmnCdNm}</option>
													</c:forEach>
												</c:if>
											</select>
										
											<!-- 검색어 입력 -->
											<input type="text" class="form-control w-auto" style="min-width:180px;" 
												   name="empNm" id="empNm" placeholder="이름입력"/>

											<!-- 버튼 -->
											<button type="button" class="btn bg-secondary-subtle text-secondary" id="searchBtn">
												<i class="ti ti-search"></i> 검색
											</button>
										</div>
									</form>
									<!-- 날짜 영역 끝 -->

									<!-- 4가지 정보 -->
									<div class="row">
										<div class="col-md-6 col-lg-3">
											<div class="card rounded-3 card-hover">
												<div class="card-body">
													<div class="d-flex align-items-center">
														<span class="flex-shrink-0"> <i
																class="ti ti-users text-primary display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="headCountCard">${headCount}</h2>
															<h3 class="mb-1 fs-3">전체 직원</h3>
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
																class="ti ti-clock-check text-success display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="countWorkCard">${not empty pagingVO.dataList[0] ? pagingVO.dataList[0].countWork : '0'}</h2>
															<h3 class="mb-1 fs-3">출근</h3>
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
																class="ti ti-alert-triangle text-danger display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="countLateCard">${not empty pagingVO.dataList[0] ? pagingVO.dataList[0].countLate : '0'}</h2>
															<h3 class="mb-1 fs-3">지각</h3>
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
																class="ti ti-calendar text-warning display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="countAnnualLeaveCard">${not empty pagingVO.dataList[0] ? pagingVO.dataList[0].countAnnualLeave : '0'}</h2>
															<h3 class="mb-1 fs-3">연차</h3>
														</div>
													</div>
												</div>
											</div>
										</div>

									</div>
									<!-- 4가지 정보 끝 -->

									<!-- 근태 현황 데이터 -->
									<div class="table-responsive">
										<table class="table table-hover align-middle mb-0" style="table-layout: fixed;">
											<thead class="bg-body-tertiary text-center">
												<tr>
													<th>이름</th>
													<th>부서</th>
													<th>근무유형</th>
													<th style="width: 130px">날짜</th>
													<th>출근시간</th>
													<th>퇴근시간</th>
													<th>근무시간</th>
													<th>연장근무</th>
													<th>상태</th>
												</tr>
											</thead>
											<tbody class="text-center">
												<c:if test="${not empty pagingVO.dataList }">
													<c:forEach items="${pagingVO.dataList }" var="record">
														<tr>
															<td>${record.empNm}</td>
															<td>${record.deptNm}</td>
															<td>${record.workTyNm}</td>
															<td>${record.workYmd}</td>
															<td>${record.beginTime}</td>
															<td>${record.endTime}</td>
															<td>${record.formatWorkTime}</td>
															<td>${record.formatOverTime}</td>
															<td>
																<c:choose>
																	<c:when test="${record.workSttus == '정상출근'}">
																		<span class="mb-1 badge rounded-pill  bg-success-subtle text-success">${record.workSttus} </span>
																	</c:when>
																	<c:when test="${record.workSttus == '지각'}">
																		<span class="mb-1 badge rounded-pill  bg-danger-subtle text-danger">${record.workSttus} </span>
																	</c:when>
																	<c:otherwise>
																		<span class="mb-1 badge rounded-pill  bg-info-subtle text-info">${record.workSttus} </span>
																	</c:otherwise>
																</c:choose>
															</td>
														</tr>
													</c:forEach>
												</c:if>
												<c:if test="${empty pagingVO.dataList }">
													<tr>
														<td colspan="8" class="text-center">데이터가 없습니다.</td>
													</tr>
												</c:if>
												<!-- 가데이터 -->
									
												
											</tbody>
										</table>
									</div>
									<!-- 근태 현황 데이터 끝  -->

									<!-- 페이징 처리 및 내보내기 버튼-->
									<div class="row align-items-center mb-3 mt-3">
										<!-- 1번째 칸: 빈 공간 -->
										<div class="col"></div>

										<!-- 2번째 칸: 페이징 중앙 -->
										<div class="col d-flex justify-content-center" id="pagingArea">
											${pagingVO.getPagingHTML() }
										</div>

										<!-- 3번째 칸: 내보내기 버튼 오른쪽 -->
										<div class="col d-flex justify-content-end">
											<button type="button"
												class="btn btn-info btn-rounded d-flex align-items-center" id="excelDownloadBtn">
												<i class="ti ti-download fs-4 me-2"></i>
												다운로드
											</button>
										</div>
									</div>

									<!-- 페이징 처리 및 내보내기 버튼 끝-->
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
       </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>
<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- XLSL 엑셀 다운 용 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script type="text/javascript">

const headCountCard = document.querySelector("#headCountCard");
const countWorkCard = document.querySelector("#countWorkCard");
const countLateCard = document.querySelector("#countLateCard");
const countAnnualLeaveCard = document.querySelector("#countAnnualLeaveCard");

const searchBtn = document.querySelector("#searchBtn");
let lastSearchData = new FormData(document.querySelector("#searchForm")); // 최근 검색 조건 저장

document.querySelector("#searchForm").addEventListener("submit", function(event){
    event.preventDefault(); // 엔터로 폼 제출 막기
    searchBtn.click();      // 대신 검색 버튼 클릭 트리거
});

searchBtn.addEventListener("click", function(event){
	
    // form 가져오기
    const searchFormEl = document.querySelector("#searchForm");
    let formData = null;
    
    // event.isSearchBtn 플래그가 없으면 검색 버튼에서 직접 클릭된 경우로 간주
    if (!event.isPagingClick) {
        searchFormEl.querySelector("#currentPage").value = 1; // 페이지 초기화
	    formData = new FormData(searchFormEl);
	    lastSearchData = formData;
    }else{
	    // form 데이터를 FormData 객체로 변환
	    formData = lastSearchData;
    }
    

    fetch("/attendance/changeCompanyAttend", {
        method: "POST",
        body: formData
    })
    .then(res => res.json())
    .then(data => {
    	// 테이블 데이터 삽입
        console.log(data);

        // ===== 카드 갱신 =====
        headCountCard.textContent = data.headCount;
        countWorkCard.textContent = data.pagingVO.dataList[0]?.countWork ?? 0;
        countLateCard.textContent = data.pagingVO.dataList[0]?.countLate ?? 0;
        countAnnualLeaveCard.textContent = data.pagingVO.dataList[0]?.countAnnualLeave ?? 0;

        // ===== 테이블 갱신 =====
        const tbody = document.querySelector("table tbody");
        tbody.innerHTML = ""; // 기존 내용 초기화
        
        if (data.pagingVO.dataList && data.pagingVO.dataList.length > 0) {
            data.pagingVO.dataList.forEach(record => {
                let badgeClass = "bg-info-subtle text-info";
                if (record.workSttus === "정상출근") {
                    badgeClass = "bg-success-subtle text-success";
                } else if (record.workSttus === "지각") {
                    badgeClass = "bg-danger-subtle text-danger";
                }

                const tr = `
                    <tr>
                        <td>\${record.empNm}</td>
                        <td>\${record.deptNm}</td>
                        <td>\${record.workTyNm}</td>
                        <td>\${record.workYmd}</td>
                        <td>\${record.beginTime ?? "" }</td>
                        <td>\${record.endTime ?? ""}</td>
                        <td>\${record.formatWorkTime ?? ""}</td>
                        <td>\${record.formatOverTime ?? ""}</td>
                        <td><span class="mb-1 badge rounded-pill \${badgeClass}">\${record.workSttus}</span></td>
                    </tr>
                `;
                tbody.insertAdjacentHTML("beforeend", tr);
            });
        } else {
            tbody.innerHTML = `<tr><td colspan="8" class="text-center">데이터가 없습니다.</td></tr>`;
        }

        // ===== 페이징 갱신 =====
	    const pagingArea = document.querySelector("#pagingArea");
	    pagingArea.innerHTML = data.pagingVO.pagingHTML;
	    
    })
    .catch(err => {
        console.error("검색 에러:", err);
        Swal.fire("알림", "검색 중 오류가 발생했습니다.", "error");
    });
    
});

$(document).ready(function(){
    $("#pagingArea").on("click", "a", function(event){
        event.preventDefault();
        const pageNo = $(this).data("page");
        lastSearchData.set("currentPage", pageNo); // currentPage 값을 바꾼다
        
        // 플래그 지정 후 검색 버튼 클릭
        const btn = document.querySelector("#searchBtn");
        const clickEvent = new Event("click");
        clickEvent.isPagingClick = true;
        btn.dispatchEvent(clickEvent);
    });
});

document.querySelector("#excelDownloadBtn").addEventListener("click", function() {
	
    const tableBody = document.querySelector("table tbody");
    
	// 데이터가 없으면
    if (!tableBody || tableBody.rows.length === 0) {
        alert("다운로드할 데이터가 없습니다.");
        return; // 더 이상 진행하지 않음
    }
    
	const empNm = lastSearchData.get("empNm");
	const deptNo = lastSearchData.get("deptNo");
	const status = lastSearchData.get("status");
	const startDay = lastSearchData.get("startDay");
	const endDay = lastSearchData.get("endDay");
	
    const payload = {
        startDay: lastSearchData.get("startDay"),
        endDay: lastSearchData.get("endDay"),
        empNm: lastSearchData.get("empNm"),
        deptNo: lastSearchData.get("deptNo"),
        status: lastSearchData.get("status")
    };
	
    console.log(payload);
    fetch(`/attendance/getCompanyAttendanceExcelData`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
    })
    .then(res => res.json())
    .then(data => {
    	
    	console.log(data);
        // 헤더 배열
        const headers = ["이름", "부서", "근무유형", "날짜", "출근시간", "퇴근시간", "근무시간", "연장근무", "상태"];

        // 데이터 배열
        const rows = data.map(row => [
            row.empNm,
            row.deptNm,
            row.workTyNm,
            row.workYmd,
            row.beginTime,
            row.endTime,
            row.formatWorkTime,
            row.formatOverTime,
            row.workSttus
        ]);
		
        const fileName = `근태이력 (\${payload.startDay} ~ \${payload.endDay}).xlsx`;
        
        // SheetJS 배열 → 워크시트
        const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, '근태이력');

        // 엑셀 파일 다운로드
        XLSX.writeFile(wb, fileName);
    })
    .catch(err => {
        console.error("검색 에러:", err);
        Swal.fire("알림", "엑셀 다운로드 에러.", "error");
    });
});
</script>
</body>
</html>