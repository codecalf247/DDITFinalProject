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

			<style>
				/* 두 번째 모달 배경 */
				.modal-backdrop.show:nth-of-type(2) {
					z-index: 1060 !important;
				}

				/* 두 번째 모달 */
				#modal2 {
					z-index: 1070 !important;
				}
			</style>
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
												<h4 class="fw-semibold mb-8">근태 이력</h4>
												<nav aria-label="breadcrumb">
													<ol class="breadcrumb">
														<li class="breadcrumb-item"><a
																class="text-muted text-decoration-none"
																href="${pageContext.request.contextPath}/main/index">Home</a>
														</li>
														<li class="breadcrumb-item" aria-current="page"><a
																class="text-muted text-decoration-none"
																href="${pageContext.request.contextPath}/attendance">Attendance</a>
														</li>
														<li class="breadcrumb-item" aria-current="page">
															AttendanceHistory</li>
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

											<!-- 메뉴 파일 -->
											<%@ include file="/WEB-INF/views/attendance/attdMenu.jsp" %>
												<!-- 메뉴 파일 끝 -->
										</div>

										<!-- Main content -->
										<div class="d-flex w-100">
											<div class="w-100 p-3">

												<!-- 필터 및 날짜 영역 -->
												<form class="row g-2 mb-2 align-items-center" id="searchForm" method="get">
													<input type="hidden" name="page" id="page"/>
													<!-- 오른쪽 정렬 영역 -->
													<div class="col d-flex justify-content-end gap-2 ms-auto">
											
														<!-- 검색 조건 select -->
														<select class="form-select w-auto" id="searchType" name="searchType">
															<option value="all" ${pagingVO.searchType eq 'all' ? 'selected' : ''} >전체</option>
															<option value="01001" ${pagingVO.searchType eq '01001' ? 'selected' : ''}>정상출근</option>
															<option value="01002" ${pagingVO.searchType eq '01002' ? 'selected' : ''}>지각</option>
															<option value="01003" ${pagingVO.searchType eq '01003' ? 'selected' : ''}>연차</option>
															<option value="01004" ${pagingVO.searchType eq '01004' ? 'selected' : ''}>반차</option>
															<option value="01005" ${pagingVO.searchType eq '01005' ? 'selected' : ''}>병가</option>
															<option value="01006" ${pagingVO.searchType eq '01006' ? 'selected' : ''}>결근</option>
															<option value="01007" ${pagingVO.searchType eq '01007' ? 'selected' : ''}>외근</option>
														</select>

														<!-- 시작일 -->
														<div class="col-md-2">
															<input type="date" class="form-control"
																value="${startDay}" id="startDay" name="startDay"/>
														</div>

														<!-- ~ 표시 -->
														<div
															class="col-auto d-flex align-items-center justify-content-center">
															<span>~</span>
														</div>

														<!-- 종료일 -->
														<div class="col-md-2">
															<input type="date" class="form-control"
																value="${endDay}" id="endDay" name="endDay"/>
														</div>

														<!-- 버튼 -->
														<button type="button"
															class="btn bg-secondary-subtle text-secondary" id="searchBtn">
															<i class="ti ti-search"></i> 검색
														</button>
													</div>
												</form>
												<!-- 날짜 영역 끝 -->

												<!-- 결과 수 영역-->
												<div style="text-align: right;">
													<span>총 ${pagingVO.totalRecord }건</span>
												</div>
												<!-- 결과 수 영역 끝-->

												<!-- 근태 현황 데이터 -->
												<div class="table-responsive">
													<table class="table table-hover align-middle mb-0"
														style="table-layout: fixed;">
														<thead class="bg-body-tertiary text-center">
															<tr>
																<th>날짜</th>
																<th>요일</th>
																<th>출근시간</th>
																<th>퇴근시간</th>
																<th>근무시간</th>
																<th>연장근무</th>
																<th>상태</th>
																<th style="width: 140px;">사유</th>
															</tr>
														</thead>
														<tbody class="text-center">
														<c:if test="${not empty pagingVO.dataList}">
															<c:forEach items="${pagingVO.dataList}" var="workHist">
																<tr data-record-no="${workHist.workRcordNo}">
																	<td>${fn:substring(workHist.histDt, 0, 10)}</td>
																	<td>${workHist.workRcordVO.dayOfTheWeek}</td>
																	<td>${workHist.workRcordVO.beginTime}</td>
																	<td>${workHist.workRcordVO.endTime}</td>
																	<td>${workHist.workRcordVO.formatWorkTime}</td>
																	<td>${workHist.workRcordVO.formatOverTime}</td>
																	<td>
																		<c:choose>
																			<c:when test="${workHist.workSttus == '정상출근'}">
																				<span class="mb-1 badge rounded-pill  bg-success-subtle text-success">${workHist.workSttus} </span>
																			</c:when>
																			<c:when test="${workHist.workSttus == '지각'}">
																				<span class="mb-1 badge rounded-pill  bg-danger-subtle text-danger">${workHist.workSttus} </span>
																			</c:when>
																			<c:otherwise>
																				<span class="mb-1 badge rounded-pill  bg-info-subtle text-info">${workHist.workSttus} </span>
																			</c:otherwise>
																		</c:choose>
																	</td>
																	<td class="text-truncate">${workHist.requstResn}</td>
																</tr>
															</c:forEach>
														</c:if>
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
															<i class="ti ti-download fs-4 me-2"></i> 다운로드
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
					</div>
					<!-- <div class="container-fluid"> -->
				</div>
				<!-- <div class="body-wrapper"> -->

				<!-- 근태 상세 내역 모달 -->
				<div class="modal fade" id="historyModal" tabindex="-1" aria-hidden="true">
				  <div class="modal-dialog modal-lg modal-dialog-centered">
				    <div class="modal-content">
				
				      <!-- 헤더 -->
				      <div class="modal-header">
				        <h5 class="modal-title fw-bold">근태 상세 내역</h5>
				      </div>
				
				      <!-- 바디 -->
				      <div class="modal-body">
						 <input type="hidden" id="attendanceNo" name="workRcordNo">
						 
				        <!-- 날짜 + 요일 -->
				        <div class="row mb-3">
				          <div class="col-md-6">
				            <label class="form-label">날짜</label>
				            <input type="text" class="form-control" id="attendanceDate" disabled>
				          </div>
				          <div class="col-md-6">
				            <label class="form-label">요일</label>
				            <input type="text" class="form-control" id="attendanceDay" disabled>
				          </div>
				        </div>
				
				        <!-- 출근시간 + 퇴근시간 -->
				        <div class="row mb-3">
				          <div class="col-md-6">
				            <label class="form-label">출근시간</label>
				            <input type="time" class="form-control" id="attendanceStart" disabled>
				          </div>
				          <div class="col-md-6">
				            <label class="form-label">퇴근시간</label>
				            <input type="time" class="form-control" id="attendanceEnd" disabled>
				          </div>
				        </div>
				
				        <!-- 근무시간 + 연장근무 -->
				        <div class="row mb-3">
				          <div class="col-md-6">
				            <label class="form-label">근무시간</label>
				            <input type="text" class="form-control" id="attendanceWorktime" disabled>
				          </div>
				          <div class="col-md-6">
				            <label class="form-label">연장근무</label>
				            <input type="text" class="form-control" id="attendanceOvertime" disabled>
				          </div>
				        </div>
				
				        <!-- 상태 -->
				        <div class="mb-3">
				          <label class="form-label">상태</label>
				          <input type="text" class="form-control" id="attendanceStatus" disabled>
				        </div>
				
				        <!-- 사유 -->
				        <div class="mb-3">
				          <label class="form-label">사유</label>
				          <textarea class="form-control" id="attendanceNote" rows="3" style="resize: none;" disabled></textarea>
				        </div>
				
				      </div>
				
				      <!-- 푸터 -->
				      <div class="modal-footer">
				        <button type="button" class="btn btn-primary" id="openModal2">수정요청</button>
				        <button type="button" id="cancel" data-bs-dismiss="modal" class="btn btn-danger">닫기</button>
				      </div>
				
				    </div>
				  </div>
				</div>


				<!-- 모달 2 -->
				<div class="modal fade" id="modal2" tabindex="-1">
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
							 <input type="hidden" id="updAttendanceNo" name="workRcordNo">
								<!-- 근태 목록 -->
								<div class="row mb-3">
									<div class="col-md-6">
										<label class="form-label">대상 날짜</label>
										<input class="form-control" type="text" id="updAttendanceDate" disabled>
									</div>
									<div class="col-md-6">
										<label class="form-label">상태</label>
										<input class="form-control" type="text" id="updAttendanceStatus" disabled>
									</div>
								</div>
								
								<!-- 출근시간 + 퇴근시간 -->
						        <div class="row mb-3">
						          <div class="col-md-6">
						            <label class="form-label">출근시간</label>
						            <input type="time" class="form-control" id="updAttendanceStart" disabled>
						          </div>
						          <div class="col-md-6">
						            <label class="form-label">퇴근시간</label>
						            <input type="time" class="form-control" id="updAttendanceEnd" disabled>
						          </div>
						        </div>

								<div class="mb-3">
									<label class="form-label">근태 목록</label>
									<select class="form-select" id="updReqType">
										<option value="23001">출근시간 변경</option>
										<option value="23002">퇴근시간 변경</option>
									</select>
								</div>

								<!-- 요청 시간 -->
								<div class="form-group mb-3">
									<label class="form-label">요청 시간</label>
									<input type="time" class="form-control" id="updReqTime" value="09:00">
									<div class="invalid-feedback"></div>
								</div>

								<!-- 사유 -->
								<div class="mb-3">
									<label class="form-label">사유</label>
									<textarea class="form-control" rows="3" placeholder="사유 입력" id="updReason" style="resize: none;"></textarea>
									<div class="invalid-feedback"></div>
								</div>
								
								<!-- 반려 사유 -->
								<div class="mb-3" id="returnDiv" >
									<label class="form-label">반려사유</label>
									<textarea class="form-control" rows="1" id="returnReason" style="resize: none;" disabled></textarea>
								</div>

								<!-- 첨부파일 -->
								<div class="mb-3" id="fileDiv" >
									<label for="formFile" class="form-label">첨부파일</label>
									<input class="form-control" type="file" id="updFile">
								</div>
								
								<!-- 다운로드 영역 -->
								<div id="fileArea"></div>

							</div>

							<!-- 푸터 -->
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" id="sendReqBtn">전송</button>
								<button type="button" id="cancel" data-bs-dismiss="modal"
									class="btn btn-danger">닫기</button>
							</div>
						</div>
					</div>
				</div>


				<%@ include file="/module/footerPart.jsp" %>
		</body>
		
        <!-- SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <!-- XLSL 엑셀 다운 용 -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
		
		<script>
			
			// 검색 버튼 클릭 시
			document.querySelector("#searchBtn").addEventListener("click", function(){
				document.querySelector("#searchForm").submit();
			});
		
			// 테이블 행 클릭 시
			document.querySelectorAll("table tbody tr").forEach((row) => {
			  row.addEventListener("click", function () {
			    const rowData = {
			      no: this.dataset.recordNo,
			      date: this.cells[0].innerText,
			      day: this.cells[1].innerText,
			      start: this.cells[2].innerText,
			      end: this.cells[3].innerText,
			      worktime: this.cells[4].innerText,
			      overtime: this.cells[5].innerText,
			      status: this.cells[6].innerText,
			      note: this.cells[7].innerText,
			    };
	
			    // 모달에 데이터 채우기 (input, textarea → val)
			    $("#attendanceNo").val(rowData.no);
			    $("#attendanceDate").val(rowData.date);
			    $("#attendanceDay").val(rowData.day);
			    $("#attendanceStart").val(rowData.start);
			    $("#attendanceEnd").val(rowData.end);
			    $("#attendanceWorktime").val(rowData.worktime);
			    $("#attendanceOvertime").val(rowData.overtime);
			    $("#attendanceStatus").val(rowData.status);
			    $("#attendanceNote").val(rowData.note);
	
			    // 모달 띄우기
			    $("#historyModal").modal("show");
			  });
			});

			// 모달1 안 버튼 클릭 시 모달2 열기
			document.getElementById("openModal2").addEventListener("click", function () {
				
				const workRcordNo = $("#attendanceNo").val();
				
				fetch("/attendance/getRequest",{
					method : "POST",
					headers: { "Content-Type": "application/json" },
					body : JSON.stringify({ workRcordNo : workRcordNo })
				})
				.then(res => res.text())                // 먼저 텍스트로 받음
				.then(text => text ? JSON.parse(text) : null)  // 빈 문자열이면 null 처리
				.then(data => {
					$("#updAttendanceStart").val($("#attendanceStart").val());
					$("#updAttendanceEnd").val($("#attendanceEnd").val());
					$("#updAttendanceDate").val($("#attendanceDate").val());
					$("#updAttendanceStatus").val($("#attendanceStatus").val());
				    $("#updAttendanceNo").val($("#attendanceNo").val());
					
					console.log(data);
					if(data){	// 요청 데이터가 있으면
						// 요청 데이터 넣기
						$("#updReqType").val(data.requstTy);
						$("#updReqTime").val(data.requstTime.substring(0,2) + ":" + data.requstTime.substring(2,4));
						$("#updReason").val(data.requstResn);
						$("#returnReason").val(data.returnResn);
						
				        // 파일 다운로드 링크 세팅
			            $("#fileDiv").hide(); // 숨기기
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
				        
						$("#returnDiv").show();
						document.querySelector("#updReqType").disabled = true;
						document.querySelector("#updReqTime").disabled = true;
						document.querySelector("#updReason").disabled = true;
						$("#sendReqBtn").text(data.requstSttus);
						$("#sendReqBtn").prop("disabled", true);
						
					}else{
			            $("#fileDiv").show();
			            $("#updFile").val('');
		            	$("#downloadBtn").hide();
						$("#returnDiv").hide();
						
						$("#updReqType").val('23001');
						$("#updReqTime").val('09:00');
						$("#updReason").val('병원에 다녀왔습니다.');
						$("#sendReqBtn").text('전송');
						$("#sendReqBtn").prop("disabled", false);
						document.querySelector("#updReqType").disabled = false;
						document.querySelector("#updReqTime").disabled = false;
						document.querySelector("#updReason").disabled = false;
					}
				})
				.catch(err => {
					$("#modal2").modal("hide");
					console.error("Error: ", err);
                    Swal.fire("알림", "요청 데이터 에러", "error");
				});
				
				var modal2 = new bootstrap.Modal(document.getElementById("modal2"));

				modal2.show();
			});
			
			document.querySelector("#sendReqBtn").addEventListener("click", function(){
				
				// 유효성 검사
				const workRcordNo = document.querySelector("#updAttendanceNo").value;
				const requstTy = document.querySelector("#updReqType").value;
				const requstTime = document.querySelector("#updReqTime").value;
				const requstResn = document.querySelector("#updReason").value;
				
				if(requstTime == ""){
					document.querySelector("#updReqTime").classList.add('is-invalid');
					document.querySelector("#updReqTime").nextElementSibling.textContent = "시간을 선택해주세요"; // 메시지 동적 설정
					return
				}else{
					document.querySelector("#updReqTime").classList.remove('is-invalid');
					document.querySelector("#updReqTime").nextElementSibling.textContent = ""; // 메시지 초기화
				}
				
				if(requstResn == "")	{
					document.querySelector("#updReason").classList.add('is-invalid');
					document.querySelector("#updReason").nextElementSibling.textContent = "사유를 작성해주세요"; // 메시지 동적 설정
					return
				}else{
					document.querySelector("#updReason").classList.remove('is-invalid');
					document.querySelector("#updReason").nextElementSibling.textContent = ""; // 메시지 초기화
				}
				
				const formData = new FormData();

				// 일반 데이터 추가
				formData.append("workRcordNo", workRcordNo);
				formData.append("requstTy",    requstTy);
				formData.append("requstTime",  requstTime);
				formData.append("requstResn",  requstResn);
				
				// 파일 첨부
				const fileInput = document.querySelector("#updFile");
				if(fileInput && fileInput.files.length > 0){
					formData.append("attachFile", fileInput.files[0]);
				}
				
				fetch("/attendance/updateRequest",{
					method : "POST",
					body : formData
				})
				.then(res => res.text())
				.then(data => {
					if(data == "OK"){
						$("#historyModal").modal("hide");
						$("#modal2").modal("hide");
                        Swal.fire("알림", "수정 요청 전송", "success");
					}else{
						$("#modal2").modal("hide");
                        Swal.fire("알림", "수정 요청 전송 실패", "warning");
					}
				})
				.catch(err => {
					$("#modal2").modal("hide");
					console.error("Error: ", err);
                    Swal.fire("알림", "수정 요청 전송 에러", "error");
				});
			});
			
			document.querySelector("#excelDownloadBtn").addEventListener("click", function() {
				
			    const tableBody = document.querySelector("table tbody");
			    
				// 데이터가 없으면
			    if (!tableBody || tableBody.rows.length === 0) {
			        alert("다운로드할 데이터가 없습니다.");
			        return; // 더 이상 진행하지 않음
			    }
			    
				const searchType = document.querySelector("#searchType").value;
				const startDay = document.querySelector("#startDay").value;
				const endDay = document.querySelector("#endDay").value;
				
			    const payload = {
			        startDay: startDay,
			        endDay: endDay,
			        searchType: searchType
			    };
				
			    console.log(payload);
			    fetch(`/attendance/getExcelData`, {
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
			        const headers = ["날짜", "요일", "출근시간", "퇴근시간", "근무시간", "연장근무", "상태", "사유"];

			        // 데이터 배열
			        const rows = data.map(row => [
			            row.histDt,
			            row.workRcordVO.dayOfTheWeek,
			            row.workRcordVO.beginTime,
			            row.workRcordVO.endTime,
			            row.workRcordVO.formatWorkTime,
			            row.workRcordVO.formatOverTime,
			            row.workSttus,
			            row.requstResn
			        ]);
					
			        const fileName = `근태이력 (${startDay} ~ ${endDay}).xlsx`;
			        
			        // SheetJS 배열 → 워크시트
			        const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
			        const wb = XLSX.utils.book_new();
			        XLSX.utils.book_append_sheet(wb, ws, '근태이력');

			        // 엑셀 파일 다운로드
			        XLSX.writeFile(wb, fileName);
			    })
			    .catch(err => {
			        console.error("엑셀 다운로드 에러:", err);
			    });
			});

		    $(function(){
		    	let pagingArea = $("#pagingArea");
		    	let searchForm = $("#searchForm");
		    	
		    	pagingArea.on("click", "a", function(event){
		    		event.preventDefault();
		    		let pageNo = $(this).data("page");
		    		searchForm.find("#page").val(pageNo);
		    		searchForm.submit();
		    	});
		    })
		</script>