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
												<h4 class="fw-semibold mb-8">전사 근태 통계</h4>
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
															CompanyAttdAnalytics</li>
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

												<div class="col-4 text-center w-100 mb-3">
													<!-- 오른쪽 정렬 영역 -->
													<div class="col d-flex justify-content-end gap-2 ms-auto">
											
														<!-- 검색 조건 select -->
														<select class="form-select w-auto" id="searchRange" name="searchRange">
															<option value="month">1달</option>
															<option value="quater">3달</option>
															<option value="year">1년</option>
														</select>
														
													</div>
												</div>

												<div class="row mt-4">

													<div class="card col-lg-6 col-md-6 m-0">
														<div class="card-body">
															<h4 class="card-title">평균 근무시간</h4>
															<canvas id="chart-avgworktime"></canvas>
														</div>
													</div>

													<div class="card col-lg-6 col-md-6 m-0">
														<div class="card-body">
															<h4 class="card-title">부서 연장근무</h4>
															<canvas id="chart-overtime"></canvas>
														</div>
													</div>

												</div>
												
												<div class="row mt-4">

													<div class="card col-lg-6 col-md-6 m-0">
														<div class="card-body">
															<h4 class="card-title">부서별 상태</h4>
															<canvas id="chart-status"></canvas>
														</div>
													</div>

												<div class="card col-lg-6 col-md-6 m-0">
												  <div class="card-body text-center">
												    <h4 class="card-title">근무 유형별 인원수</h4>
												    <canvas id="chart-worktype" style="width:250px; display:block; margin:0 auto;"></canvas>
												  </div>
												</div>

												</div>
												
												<!-- 근태 현황 데이터 -->
												<div class="table-responsive mt-2">
													<h4>부서별 상세 통계</h4>
													<table class="table table-hover align-middle mb-0"
														style="table-layout: fixed;">
														<thead class="bg-body-tertiary text-center">
															<tr>
																<th>부서</th>
																<th>총인원</th>
																<th>평균 출근율</th>
																<th>평균 지각률</th>
																<th>평균 근무시간</th>
																<th>총 연장근무</th>
															</tr>
														</thead>
														<tbody class="text-center"></tbody>
													</table>
												</div>
												<!-- 근태 현황 데이터 끝  -->

											</div>
										</div>

									</div>
								</div>
							</div>
						</div>

					</div> <!-- <div class="container-fluid"> -->
				</div> <!-- <div class="body-wrapper"> -->
				<%@ include file="/module/footerPart.jsp" %>
				
			   <!-- chartJs -->
			   <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

			   <!-- axios -->
			   <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
			   
			   <script type="text/javascript">
				// Chart.js 차트 객체를 전역으로 선언하여, 새 데이터가 들어올 때 이전 차트를 제거(destroy) 가능
				let avgWorkChart;	// 평균 근무시간 막대 차트
				let overtimeChart;	// 부서 연장근무 막대 차트
				let deptStatusChart;// 부서별 상태 스택형 막대차트
				let workTypeChart;	// 근무 유형 파이차트

				// 평균 근무시간 막대차트 초기화 함수
				function initAvgWorkChart(data) {
					// 캔버스 요소 가져옴
				    const ctx = document.getElementById('chart-avgworktime').getContext('2d');
				    if (avgWorkChart) avgWorkChart.destroy(); // 기존 차트 제거
					
				    // 라벨과 데이터 배열 생성
				    const labels = data.map(item => item.deptNm);				// 부서명
				    const avgWorkData = data.map(item => item.avgWorkTimeMin);	// 평균 근무시간
					
				    // 차트 생성
				    avgWorkChart = new Chart(ctx, {
				        type: 'bar',	// 바 타입
				        data: {
				            labels,	// 축 데이터 [부서명배열]
				            datasets: [{
				                label: '평균 근무시간 (분)', // 축의 제목
				                data: avgWorkData,		  // dataset 값
				                backgroundColor: 'rgba(54, 162, 235, 0.7)' // 막대색
				            }]
				        },
				        options: { 
				        	responsive: true, 						 // 화면 크기에 따로 자동 리사이즈
				        	plugins: { legend: { display: false } }, // 범례 숨김
				        	scales: { y: { beginAtZero: true } } }	 // y축 0부터 시작
				    });
				}
	
				// 연장근무 막대차트 초기화 함수
				function initOvertimeChart(data) {
					// 캔버스 요소 가져옴
				    const ctx = document.getElementById('chart-overtime').getContext('2d');
					
					// 기존 차트 제거
				    if (overtimeChart) overtimeChart.destroy();
	
					// 라벨과 데이터 배열
				    const labels = data.map(item => item.deptNm);
				    const overtimeData = data.map(item => item.overTimeMin);
	
				    // 차트 생성
				    overtimeChart = new Chart(ctx, {
				        type: 'bar',
				        data: {
				            labels,
				            datasets: [{
				                label: '연장근무 (분)',
				                data: overtimeData,
				                backgroundColor: 'rgba(255, 99, 132, 0.7)'
				            }]
				        },
				        options: { responsive: true, 
				        		  plugins: { legend: { display: false } }, 
				        		  scales: { y: { beginAtZero: true } } }
				    });
				    
				    
				}
		
				// 부서별 상태 스택형 막대차트 초기화 함수
				function initDeptStatusChart(data) {
					// canvas 가져오기
				    const ctx = document.getElementById('chart-status').getContext('2d');
					
					// 기존차트 제거
				    if (deptStatusChart) deptStatusChart.destroy();
					
					// 라벨과 데이터 배열
				    const labels = data.map(item => item.deptNm);
				    const workRatio = data.map(item => item.workRatio);
				    const lateRatio = data.map(item => item.lateRatio);
				    const annualRatio = data.map(item => item.annualRatio);
				    const countWork = data.map(item => item.countWork)   
				    const countLate = data.map(item => item.countLate)  
				    const countAnnual = data.map(item => item.countAnnualLeave)   
				    
				    console.log(countAnnual);
				    console.log(annualRatio);
				    console.log(1111);
				    
				    // 차트 생성
				    deptStatusChart = new Chart(ctx, {
				        type: 'bar',
				        data: {
				            labels,
				            datasets: [
				                { label: '출근', data: workRatio, extra : countWork,  backgroundColor: 'rgba(75, 192, 192, 0.7)' },
				                { label: '지각', data: lateRatio, extra : countLate, backgroundColor: 'rgba(255, 206, 86, 0.7)' },
				                { label: '연차', data: annualRatio, extra : countAnnual, backgroundColor: 'rgba(153, 102, 255, 0.7)' }
				            ]
				        },
				        options: {
				            responsive: true,
				            plugins: { 
				            	legend: { position: 'top' },// 범례 상단
				            	tooltip: {
			            	        callbacks: {
			            	          label: function(context) {
			            	            // 커스텀 extra 값 불러오기
			            	            const extraValue = context.dataset.extra[context.dataIndex];
			            	            return `\${extraValue}`;
			            	          }
			            	        }
				            	}
				            },	
				            scales: { 
				            	x: { stacked: true },
				            	y: { stacked: true, beginAtZero: true } 
				            }
				        }
				    });
				}
				
				// 근무 유형별 파이차트 초기화 함수
				function initWorkTypeChart(data) {
					// canvas 가져오기
				    const ctx = document.getElementById('chart-worktype').getContext('2d');
					
					// 기존 차트 제거
				    if (workTypeChart) workTypeChart.destroy();
				
					// 라벨과 데이터 배열
				    const labels = data.map(item => item.workTyNm); // 정규, 유연
				    const values = data.map(item => item.empCount);
					
				    // 차트 생성
				    workTypeChart = new Chart(ctx, {
				        type: 'pie',
				        data: {
				            labels,
				            datasets: [{
				                data: values,
				                backgroundColor: ['rgba(54, 162, 235, 0.7)', 'rgba(255, 99, 132, 0.7)']
				            }]
				        },
				        options: { 
				        	responsive: false, 
				        	plugins: { legend: { position: 'top' } } 
				        }
				    });
				}
				
				// 테이블 갱신
				function updateTable(dataList){
					
			        const tbody = document.querySelector("table tbody");
			        tbody.innerHTML = ""; // 기존 내용 초기화
			        
			        if (dataList && dataList.length > 0) {
			            dataList.forEach(record => {
			                const tr = `
			                    <tr>
			                        <td>\${record.deptNm}</td>
			                        <td>\${record.empCount}명</td>
			                        <td>\${record.workRatio}%</td>
			                        <td>\${record.lateRatio}%</td>
			                        <td>\${record.formatAvgWorkTime}</td>
			                        <td>\${record.formatOverTime}</td>
			                    </tr>
			                `;
			                tbody.insertAdjacentHTML("beforeend", tr);
			            });
			        } else {
			            tbody.innerHTML = `<tr><td colspan="6" class="text-center">데이터가 없습니다.</td></tr>`;
			        }
				}
	
				// 기간별 데이터 업데이트
				async function updateCharts(range) {
				    // 부서별 근태 데이터
				    await axios.post(`/attendance/companyDeptAnalytics`, { range : range })
				        .then(res => {
				        	console.log(res.data);
				            initAvgWorkChart(res.data);
				            initOvertimeChart(res.data);
				            initDeptStatusChart(res.data);
				            updateTable(res.data);
				        });
	
				    // 근무 유형 데이터
				    await axios.post(`/attendance/companyWorkTypeAnalytics`, { range : range })
				        .then(res => {
				        	console.log(res.data);
				            initWorkTypeChart(res.data);
				    });
				}
	
				// 페이지 로드시
				document.addEventListener("DOMContentLoaded", function() {
				    const range = document.getElementById('searchRange').value;
				    updateCharts(range);
	
				    document.getElementById('searchRange').addEventListener('change', function() {
				        updateCharts(this.value);
				    });
				});		
			   		

			   </script>
		</body>
</html>