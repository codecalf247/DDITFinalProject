<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
		<div
			class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">연차 내역</h4>
						 <nav aria-label="breadcrumb">
		                    <ol class="breadcrumb">
		                      <li class="breadcrumb-item">
		                        <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
		                      </li>
		                      <li class="breadcrumb-item" aria-current="page">
		                        <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/attendance">Attendance</a>
		                      </li>
		                      <li class="breadcrumb-item" aria-current="page">YearVaction</li>
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
				<!-- Left rail -->
				<div
					class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
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
						
						<!-- 날짜 영역 -->
						<div class="row align-items-center mb-3 ms-2">
						  <!-- 1번째 칸: 입사일 -->
						  <div class="col-4">
						  	<span class="fw-semibold">입사일 : ${joinDate}</span>
						  </div>
						
						  <!-- 2번째 칸: 날짜 영역 -->
						  <div class="col-4 text-center">
						    <div class="d-inline-flex align-items-center px-3 py-2 border rounded">
						      <button class="btn btn-sm border-0" id="prevBtn">◀</button>
						      <span class="mx-2" id="rangeDisplay" style="display:inline-block; width:100px;" data-baseyear="${year}">${year}</span>
						      <button class="btn btn-sm border-0" id="nextBtn">▶</button>
						    </div>
						  </div>
						
						  <!-- 3번째 칸: 내보내기 버튼 영역 -->
						  	<div class="col d-flex justify-content-end text-right">
								<button type="button" class="btn btn-info btn-rounded d-flex align-items-center" id="excelDownloadBtn">
								<i class="ti ti-download fs-4 me-2"></i>
								다운로드
								</button>
							</div>
						</div>


						<!-- 날짜 영역 끝 -->
						
						<!-- 4가지 정보 -->
						<div class="row">
							<div class="col-md-6 col-lg-3">
								<div class="card rounded-3 card-hover">
									<div class="card-body">
										<div class="d-flex align-items-center">
											<span class="flex-shrink-0"> <i
												class="ti ti-calendar-smile text-primary display-6"></i>
											</span>
											<div class="ms-4">
												<h2 class="fw-bolder fs-6" id="totYrycCoCard">${empty vacationList[0].totYrycCo ? 0 : vacationList[0].totYrycCo}일</h2>
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
												<h2 class="fw-bolder fs-6" id="useCoCard">${empty vacationList[0].allUseCo ? 0 : vacationList[0].allUseCo}일</h2>
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
												<h2 class="fw-bolder fs-6" id="remainCoCard">${empty vacationList[0].totYrycCo ? 0 : vacationList[0].totYrycCo - vacationList[0].allUseCo}일</h2>
												<h3 class="mb-1 fs-3">남은 연차</h3>
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
												class="ti ti-calendar-plus text-warning display-6"></i>
											</span>
											<div class="ms-4">
												<h2 class="fw-bolder fs-6">${dDay}</h2>
												<h3 class="mb-1 fs-3">새로운 연차까지</h3>
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
										<th>기준연도</th>
										<th>연차시작일</th>
										<th>연차종료일</th>
										<th>사용연차</th>
									</tr>
								</thead>
								<tbody class="text-center">
									<c:if test="${not empty vacationList}">
										<c:forEach items="${vacationList}" var="vacation">
											<c:if test="${vacation.useCo ne 0}">
												<tr>
			     									<td>${vacation.issuYr}</td>
			     									<td>${vacation.startDt}</td>
			     									<td>${vacation.endDt}</td>
			     									<td>${vacation.useCo}</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>


        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>

<!-- XLSL 엑셀 다운 용 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script type="text/javascript">
	
	const hireDate = new Date("${joinDate}"); // DB에서 가져온 입사일
	const today = new Date();

	const prevBtn = document.querySelector("#prevBtn"); // 이전 버튼
	const nextBtn = document.querySelector("#nextBtn"); // 다음 버튼

	const totYrycCoCard = document.querySelector("#totYrycCoCard"); // 사용일
	const useCoCard = document.querySelector("#useCoCard"); // 사용일
	const remainCoCard = document.querySelector("#remainCoCard"); // 남은일
	
 	// 오늘의 입사 월/일 기준 날짜
	const thisYearHireAnniversary = new Date(today.getFullYear(), hireDate.getMonth(), hireDate.getDate());
	
	// 버튼 클릭 이벤트
	prevBtn.addEventListener("click", () => fetchData(-1));
	nextBtn.addEventListener("click", () => fetchData(1));
	
	// 버튼 상태 갱신 함수
	function updateButtonState() {
	    const baseyear = parseInt(rangeDisplay.dataset.baseyear);
		
	    // prev 버튼: 입사년도보다 작은 연도는 막기
	    if (baseyear <= hireDate.getFullYear()) {
	        prevBtn.disabled = true;
	    } else {
	        prevBtn.disabled = false;
	    }

	    // 기준: 오늘이 입사 월/일 지났으면 올해, 아니면 작년
	    let lastAvailableYear;
	    if (today >= thisYearHireAnniversary) {
	        lastAvailableYear = today.getFullYear();
	    } else {
	        lastAvailableYear = today.getFullYear() - 1;
	    }

	    // next 버튼 제어
	    if (baseyear >= lastAvailableYear) {
	        nextBtn.disabled = true;
	    } else {
	        nextBtn.disabled = false;
	    }
	    
	}

	// 비동기로 데이터를 가져옴
	async function fetchData(offset){
		
		// 기준 날짜 가져오기
		const baseyear = rangeDisplay.dataset.baseyear;
		
		try{
			// fetch로 서버 요청
			const response = await fetch(`/attendance/changeVacationRange?baseyear=\${baseyear}&offset=\${offset}`);
			const data = await response.json();
			
			console.log(data);
		
			// 테이블 갱신
	    	updateVacationTable(data.vacationList);
			
			// 요약카드 갱신
	    	updateSummaryCards(data.vacationList[0]);
				
	    	// 날짜 갱신
	    	rangeDisplay.textContent = data.year;
	    	rangeDisplay.dataset.baseyear = data.year;
			
	    	// 버튼 갱신
			updateButtonState();
			
		} catch(e){
			console.error(e);
			console.log('데이터 로딩 실패');
		}
	}
	
	function updateVacationTable(vacationList){
		
	    const tbody = document.querySelector(".table tbody");
	    tbody.innerHTML = "";
	    
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
	
	function updateSummaryCards(data){
		totYrycCoCard.textContent = data.totYrycCo + "일";
		useCoCard.textContent = data.allUseCo + "일";
		remainCoCard.textContent = data.totYrycCo - data.allUseCo + "일";
	}
	
	document.querySelector("#excelDownloadBtn").addEventListener("click", function() {
		
	    const table = document.querySelector("table");
	    
		// 데이터가 없으면
	    if (!table || table.rows.length === 0) {
	        alert("다운로드할 데이터가 없습니다.");
	        return; // 더 이상 진행하지 않음
	    }
		
	 	// table → worksheet 바로 변환
	    const ws = XLSX.utils.table_to_sheet(table);

	    // 워크북 생성 및 시트 추가
	    const wb = XLSX.utils.book_new();
	    XLSX.utils.book_append_sheet(wb, ws, '연차내역');
	    const yearName = rangeDisplay.dataset.baseyear;
	    
        const fileName = `연차내역 (\${yearName}년).xlsx`;
        
        // 엑셀 파일 다운로드
        XLSX.writeFile(wb, fileName);
	});
	
	updateButtonState();
</script>

</body>
</html>