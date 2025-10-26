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
									<h4 class="fw-semibold mb-8">근태 현황</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a class="text-muted text-decoration-none"
													href="${pageContext.request.contextPath}/main/index">Home</a></li>
											<li class="breadcrumb-item" aria-current="page">Attendance</li>
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

									<!-- 날짜 영역 -->
									<div class="row align-items-center mb-3">
										<!-- 1번째 칸: 빈 공간 -->
										<div class="col-4"></div>

										<!-- 2번째 칸: 날짜 영역 -->
										<div class="col-4 text-center">
											<div class="d-inline-flex align-items-center px-3 py-2 border rounded">
												<button class="btn btn-sm" id="prevBtn">&lt;</button>
												<span class="mx-2 " id="rangeDisplay" style="display:inline-block; width:200px;" data-base="${monday}">${monday} ~ ${sunday}</span>
												<button class="btn btn-sm" id="nextBtn">&gt;</button>
											</div>
										</div>

										<!-- 3번째 칸: nav 영역 -->
										<div class="col-4 text-end">
											<ul class="nav nav-tabs mb-0 justify-content-end">
												<li class="nav-item">
													<a class="nav-link active" data-bs-toggle="tab" role="tab" id="weekTab">주간</a>
												</li>
												<li class="nav-item">
													<a class="nav-link" data-bs-toggle="tab" role="tab" id="monthTab">월간</a>
												</li>
											</ul>
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
																class="ti ti-calendar-smile text-info display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="countWork">${empty workRecordList[0].countWork ? 0 : workRecordList[0].countWork}/5</h2>
															<h3 class="mb-1 fs-3">출근 일수</h3>
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
																class="ti ti-clock text-success display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="allWorkTime">${empty workRecordList[0].formatAllWorkTime ? '0시간' : workRecordList[0].formatAllWorkTime }</h2>
															<h3 class="mb-1 fs-3">총 근무시간</h3>
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
																class="ti ti-graph text-secondary display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="avgWorkTime">${empty workRecordList[0].formatAvgWorkTime ? '0분' : workRecordList[0].formatAvgWorkTime}</h2>
															<h3 class="mb-1 fs-3">평균 근무시간</h3>
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
																class="ti ti-alarm-snooze text-danger display-6"></i>
														</span>
														<div class="ms-4">
															<h2 class="fw-bolder fs-6" id="countLate">${empty workRecordList[0].countLate ? '0' : workRecordList[0].countLate}</h2>
															<h3 class="mb-1 fs-3">지각 횟수</h3>
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
													<th>날짜</th>
													<th>요일</th>
													<th>출근시간</th>
													<th>퇴근시간</th>
													<th>근무시간</th>
													<th>연장근무</th>
													<th>상태</th>
												</tr>
											</thead>
											<tbody class="text-center">
												<!-- 가데이터 -->
												
												<c:forEach items="${workRecordList}" var="workRecord">
													<tr>
														<td>${workRecord.workYmd }</td>
														<td>${workRecord.dayOfTheWeek }</td>
														<td>${workRecord.beginTime eq null ? '--:--' : workRecord.beginTime}</td>
														<td>${workRecord.endTime eq null ? '--:--' : workRecord.endTime}</td>
														<td>${workRecord.formatWorkTime }</td>
														<td>${workRecord.formatOverTime }</td>
														<td>
															<c:choose>
																<c:when test="${workRecord.workSttus == '정상출근'}">
																	<span class="mb-1 badge rounded-pill  bg-success-subtle text-success">${workRecord.workSttus} </span>
																</c:when>
																<c:when test="${workRecord.workSttus == '지각'}">
																	<span class="mb-1 badge rounded-pill  bg-danger-subtle text-danger">${workRecord.workSttus} </span>
																</c:when>
																<c:otherwise>
																	<span class="mb-1 badge rounded-pill  bg-info-subtle text-info">${workRecord.workSttus} </span>
																</c:otherwise>
															</c:choose>
															
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
									<!-- 근태 현황 데이터 끝  -->
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
			
        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>
<script type="text/javascript">
	
	// 전역 변수 선언
	let currentType = "week"; // 타입(주/월)
	const weekTab = document.querySelector("#weekTab"); // 주별 toggle
	const monthTab = document.querySelector("#monthTab"); // 월별 toggle

	const prevBtn = document.querySelector("#prevBtn"); // 이전 버튼
	const nextBtn = document.querySelector("#nextBtn"); // 다음 버튼

	const rangeDisplay = document.querySelector("#rangeDisplay"); // 기간 디스플레이
	
	const countWork = document.querySelector("#countWork");
	const allWorkTime = document.querySelector("#allWorkTime");
	const avgWorkTime = document.querySelector("#avgWorkTime");
	const countLate = document.querySelector("#countLate");
	
	// 탭 클릭시 타입 변경
	weekTab.addEventListener("click", function(){
		currentType = "week"
		fetchData(0);
	});
	
	monthTab.addEventListener("click", function(){
		currentType = "month"
		fetchData(0);
	});
	
	// 버튼 클릭 이벤트
	prevBtn.addEventListener("click", () => fetchData(-1));
	nextBtn.addEventListener("click", () => fetchData(1));
	
	// 비동기로 데이터를 가져옴
	async function fetchData(offset){
		
		// 기준 날짜 가져오기
		const baseDate = rangeDisplay.dataset.base;
		
		try{
			// fetch로 서버 요청
			const response = await fetch(`/attendance/changeRange?baseDate=\${baseDate}&offset=\${offset}&type=\${currentType}`);
			const data = await response.json();
			
		    if(currentType == "week"){
				// 화면 update
		    	updateAttendanceTable(data);
		    	updateSummaryCards(data.workRecordList[0]);
				
		    	// 날짜 갱신
		    	rangeDisplay.textContent = data.monday + " ~ " + data.sunday;
		    	rangeDisplay.dataset.base = data.monday;
		    }else{
		    	updateAttendanceTable(data);
		      
		      rangeDisplay.textContent = data.month.substr(0,7);
		      rangeDisplay.dataset.base = data.month ;
		    }
			
		} catch(e){
			console.error(e);
			console.log('데이터 로딩 실패');
		}
	}
	
	function updateAttendanceTable(data){
		
	    const thead = document.querySelector(".table thead");
	    const tbody = document.querySelector(".table tbody");
	    tbody.innerHTML = "";
	    console.log(data);
	    console.log(currentType);
	    if(currentType == "week"){
	    	
	        thead.innerHTML = `
	            <tr>
	              <th>날짜</th>
	              <th>요일</th>
	              <th>출근시간</th>
	              <th>퇴근시간</th>
	              <th>근무시간</th>
	              <th>연장근무</th>
	              <th>상태</th>
	            </tr>
	        `;
	        
		    data.workRecordList.forEach(record => {
		    	console.log(record);
		        const tr = document.createElement("tr");
		        tr.innerHTML = `
		            <td>\${record.workYmd}</td>
		            <td>\${record.dayOfTheWeek}</td>
		            <td>\${record.beginTime || '--:--'}</td>
		            <td>\${record.endTime || '--:--'}</td>
		            <td>\${record.formatWorkTime}</td>
		            <td>\${record.formatOverTime || '0분' }</td>
		            <td><span class="badge \${record.workSttus=='지각'?'bg-danger-subtle text-danger': record.workSttus=='정상출근'?'bg-success-subtle text-success':'bg-info-subtle text-info'}">\${record.workSttus}</span></td>
		        `;
		        tbody.appendChild(tr);
		    });
	    	
	    }else{
	    	
	    	let allWorkTimeMin = 0;
	    	let allAvgWorkTimeMin = 0;
	    	let allCountLate = 0;
	    	let allCountWork = 0;
	    	let count = 0;
	    	
	        thead.innerHTML = `
	            <tr>
	        	 	<th>주차</th>
		            <th>출근일수</th>
		            <th>총 근무시간</th>
		            <th>평균 근무시간</th>
		            <th>지각횟수</th>
	            </tr>
	        `;
	        
	        data.workWeekRecordList.forEach(record => {
		    	allWorkTimeMin += record.workTimeMin;
		    	allCountWork += record.countWork;
		    	allCountLate += record.countLate;
		    	
		        const tr = document.createElement("tr");
		        tr.innerHTML = `
		            <td>\${record.week}주차</td>
		            <td>\${record.countWork}일</td>
		            <td>\${record.formatWorkTime}</td>
		            <td>\${record.formatAvgWorkTime || '0분'}</td>
		            <td>\${record.countLate}회</td>
		        `;
		        tbody.appendChild(tr);
		        
		    });
	        
	        if(allWorkTimeMin > 0){
	        	allAvgWorkTimeMin = Math.round(allWorkTimeMin / allCountWork) 
	        }else{
	        	allAvgWorkTimeMin = 0;
	        }
	        
	        
	        let summary = {
	    	   allWorkTimeMin : allWorkTimeMin,
	    	   allAvgWorkTimeMin : allAvgWorkTimeMin,
	    	   allCountLate : allCountLate,
	    	   allCountWork : allCountWork	
	        }
	        
	        updateSummaryCards(summary);
	    }

	    
	}
	
	// 요약 카드 갱신
	function updateSummaryCards(summary) {
		
		console.log(summary);
		
		if(currentType == "week"){
			if(summary != null){
				countWork.textContent = summary.countWork + "/5";
				allWorkTime.textContent = summary.formatAllWorkTime || "0분";
				avgWorkTime.textContent = summary.formatAvgWorkTime || "0분";
				countLate.textContent = summary.countLate;
			}else{
				countWork.textContent = '0/5';
				allWorkTime.textContent = '0시간';
				avgWorkTime.textContent = '0분';
				countLate.textContent = 0;
			}
		}else{
			countWork.textContent = summary.allCountWork + "일";
			allWorkTime.textContent = Math.trunc(summary.allWorkTimeMin / 60) + "시간 " + (summary.allWorkTimeMin % 60) + "분" ;
			avgWorkTime.textContent = Math.trunc(summary.allAvgWorkTimeMin / 60) + "시간 " + (summary.allAvgWorkTimeMin % 60) + "분" ;
			countLate.textContent = summary.allCountLate;
		}
	}
</script>
</body>