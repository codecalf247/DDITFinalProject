<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">

<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>

<%@ include file="/module/headPart.jsp"%>
</head>
<%@ include file="/module/header.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<body>
	<%@ include file="/module/aside.jsp"%>

	<div id="alert-area" style="position: fixed; top: 20px; right: 20px; width: 250px; z-index: 9999;"></div>

	<!-- 문서 전체 페이지 -->
	<div class="body-wrapper">
		<div class="container-fluid">
			<div class="body-wrapper">
					
				<!-- 전자결재 문서 상세보기 전체 -->
				<div class="container">
				
					<!-- 전자결재 상단바 -->
					<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">전자결재</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item">
												<a class="text-muted text-decoration-none" href="../main/index">Home</a>
											</li>
											<li class="breadcrumb-item" aria-current="page">
												<a class="text-muted text-decoration-none" href="/eApproval/dashBoard">Approval</a>
											</li>
										</ol>
									</nav>
								</div>
							</div>
						</div>
					</div>
					
					<!-- 전자결재 문서 안에 사이드바, 내용, 결재선 -->
					<div class="d-flex w-100">
						<%@ include file="/WEB-INF/views/eApproval/approvalAside.jsp"%>
						<div class="w-100">
							<!-- pdf 다운로드할 영역 지정 -->
							<div class="p-3" id="pdfDiv">
								<!-- 기안문서 영역 -->
								<div class="row w-100">
									<!-- 본문 영역 -->
									<div class="col-md-9 p-3">
										<h3 class="text-center mb-4">${sanctnDocInfo.formNm }</h3>
										<!-- 날인 부분 -->
										<div class="col-12 text-end">
											<div style="border: 1px solid #ccc; padding: 5px; width: 90px; display: inline-block;">
												<div style="font-size: 12px; border-bottom: 1px solid #ccc; padding-bottom: 5px; margin-bottom: 5px;">
													${sanctnDocInfo.jbgdCd }
												</div>
												<div class="text-center">
													<c:choose>
														<c:when test="${not empty stampUrl }">
															<img src="${stampUrl }" crossorigin="anonymous" class="img-fluid mb-1 
																rounded-circle" style="width: 50px; height: 50px; object-fit: contain;">
														</c:when>
														<c:otherwise>
															<img src="/resources/img/blank-stamp.png" crossorigin="anonymous"
																class="img-fluid mb-1 rounded-circle" style="width: 50px; height: 50px; object-fit: contain;">
														</c:otherwise>
													</c:choose> <br> 
													<span style="font-size: 14px; display: inline-block; margin-top: 5px;">${sanctnDocInfo.empNm }</span>
												</div>
											</div>
											<c:forEach items="${sanctnerList}" var="sanctner">
												<div
													style="border: 1px solid #ccc; padding: 5px; width: 90px; display: inline-block;">
													<div
														style="font-size: 12px; border-bottom: 1px solid #ccc; padding-bottom: 5px; margin-bottom: 5px;">
														${sanctner.jbgdCd}</div>
													<div class="text-center">
														<c:choose>
															<c:when
																test="${not empty sanctner.signFilePath 
														                   and (sanctner.sanctnSttus eq '20003' or sanctner.sanctnSttus eq '20004' or sanctner.sanctnSttus eq '20005')}">
																<img src="${sanctner.signFilePath}"
																	crossorigin="anonymous"
																	class="img-fluid mb-1 rounded-circle"
																	style="width: 50px; height: 50px; object-fit: contain;">
															</c:when>
															<c:otherwise>
																<img src="/resources/img/blank-stamp.png"
																	crossorigin="anonymous"
																	class="img-fluid mb-1 rounded-circle"
																	style="width: 50px; height: 50px; object-fit: contain;">
															</c:otherwise>
														</c:choose> <br> 
														<span style="font-size: 14px; display: inline-block; margin-top: 5px;">${sanctner.empNm}</span>
													</div>
												</div>
											</c:forEach>
										</div>
											
										<!-- 전자결재 공통 부분(기안자, 직급, 소속 등 기본 정보) -->
										<div class="row mb-3">
											<div class="col-12">
												<table class="table table-bordered">
													<tbody>
														<tr>
															<td class="bg-light fw-semibold text-center">기안자</td>
															<td class="text-dark ps-3">${sanctnDocInfo.empNm }</td>
															<td class="bg-light fw-semibold text-center">직급</td>
															<td class="text-dark ps-3">${sanctnDocInfo.jbgdCd }</td>
														</tr>
														<tr>
															<td class="bg-light fw-semibold text-center">소속</td>
															<td class="text-dark ps-3">${sanctnDocInfo.deptNm }</td>
															<td class="bg-light fw-semibold text-center">결재유형</td>
															<td class="text-dark ps-3"><c:if
																	test="${sanctnDocInfo.sanctnTy eq '06001' }">일반결재</c:if>
																<c:if test="${sanctnDocInfo.sanctnTy eq '06002' }">후결</c:if>
															</td>
														</tr>
														<tr>
															<td class="bg-light fw-semibold text-center">기안일</td>
															<td class="text-dark ps-3">
																${fn:substring(sanctnDocInfo.wrtDt, 0, 4)}-
																${fn:substring(sanctnDocInfo.wrtDt, 5, 7)}-
																${fn:substring(sanctnDocInfo.wrtDt, 8, 10)}</td>
															<td class="bg-light fw-semibold text-center">문서번호</td>
															<td class="text-dark ps-3">${sanctnDocInfo.sanctnDocNo }</td>
														</tr>
													</tbody>

												</table>
											</div>
										</div>
										
										<!-- 문서 제목 -->
										<div class="form-title mb-3 p-2 bg-light-subtle rounded" style="font-weight: bold; font-size: 16px;">
											<!-- 문서 제목 입력 -->
											<div class="mb-1">
												<label for="docTitle" class="form-label fw-bold">문서 제목</label> 
												<input type="text" class="form-control" id="docTitle" name="docTitle" 
													value="${sanctnDocInfo.sanctnTitle }" disabled placeholder="문서 제목을 입력하세요">
											</div>
										</div>
										<hr>
										
										<!-- 문서 내용 -->
										<div class="form-title mb-1 bg-light-subtle rounded" style="font-weight: bold; font-size: 16px;">
											<label for="docContent" class="form-label fw-bold">문서 내용</label>
										</div>
										<div class="mx-auto" style="max-width: 700px;">
											<form id="formSubmit">
												<div class="formCn-content mb-4" id="formCn">${sanctnDocInfo.sanctnCn }</div>
											</form>
										</div>
									</div><!-- 문서 본문 내용 끝 -->

									<!-- 결재선 div 영역 -->
									<div class="col-md-3 p-3" style="max-height: 1000px; overflow-y: auto;">

										<div class="card p-3 shadow-sm">
											<h5 class="mb-3">결재선</h5>
											<!-- 결재자 리스트 -->
											<c:forEach items="${sanctnerList}" var="sanctner">
												<div class="d-flex align-items-center mb-2 p-2 rounded" style="background-color: #f0f4f9;">
													<div class="flex-grow-1">
														<p class="mb-0 fw-bold">${sanctner.empNm} ${sanctner.jbgdCd}</p>
														<p class="mb-0 text-muted" style="font-size: 12px;">${sanctner.deptNm}</p>
														<!-- 각 결재자 의견 표시 -->
														<div class="ms-auto badge bg-light text-dark">${sanctner.sanctnOrdr}차 승인</div>
														<c:choose>
															<c:when test="${not empty sanctner.sanctnOpinion and sanctner.sanctnSttus ne '20007' }">
																<div class="border rounded p-2 mt-1 bg-light">의견: ${sanctner.sanctnOpinion}</div>
															</c:when>
															<c:when test="${not empty sanctner.sanctnOpinion and sanctner.sanctnSttus eq '20007'}">
																<div class="border rounded p-2 mt-1 bg-light" style="color: red;">반려사유: ${sanctner.sanctnOpinion}</div>
															</c:when>
														</c:choose>
													</div>
												</div>
											</c:forEach>
										</div>
								
										<!-- 참조선 영역 -->
										<c:if test="${not empty sanctnerCCList }">
											<div class="card p-3 shadow-sm mt-4">
												<h5 class="mb-3">참조자</h5>
												<ul class="list-unstyled mb-0">
													<c:forEach items="${sanctnerCCList }" var="sanctnerCC">
														<li class="mb-1">${sanctnerCC.empNm } ${sanctnerCC.jbgdCd } (${sanctnerCC.deptNm })</li>
													</c:forEach>
												</ul>
											</div>
										</c:if>

										<!-- 첨부파일 영역 -->
										<c:if test="${not empty sanctnDocInfo.fileList }">
											<div class="card p-3 shadow-sm mt-4">
												<h5>첨부파일</h5>
												<div class="form-text mt-0">- 파일 클릭 시 다운로드 됩니다.</div>
												<ul class="list-unstyled mt-2">
													<c:forEach items="${sanctnDocInfo.fileList }" var="file">
														<li class="mb-1" data-original-nm="${file.originalNm }" data-saved-nm="${file.savedNm }">
															<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
																<g fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="1.5">
																	<path stroke-linecap="round" d="M4 4v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8.342a2 2 0 0 0-.602-1.43l-4.44-4.342A2 2 0 0 0 13.56 2H6a2 2 0 0 0-2 2m5 9h6m-6 4h3" />
																	<path d="M14 2v4a2 2 0 0 0 2 2h4" />
																</g>
															</svg> 
															${file.originalNm }
														</li>
													</c:forEach>
												</ul>
											</div>
										</c:if>
										
										<!-- 결재의견 영역 -->
										<c:if test="${sanctnDocInfo.empNo ne drafterNo and sanctnDocInfo.docProcessSttus eq '09002' }">
											<div class="card p-3 shadow-sm">
											    <h5 class="d-flex justify-content-between align-items-center">
											        결재의견
											        <button type="button" id="addDummyOpinion" class="btn btn-sm btn-light ms-2">더미</button>
											    </h5>
												<div class="form-text mt-0">- 반려시 반드시 사유를 작성해주시기 바랍니다.</div>
												<textarea rows="5" cols="8" class="form-control" placeholder="결재 의견을 입력하세요" 
													id="approvalOpinion" name="approvalOpinion">
											    </textarea>
											</div>
										</c:if>

									</div> <!-- 결재선 div 영역 끝 -->
								</div> <!-- 기안문서 영역 끝 -->
							</div> <!-- pdf 다운로드 영역 끝 -->
							
							<!-- 승인/반려/재기안/회수 등 버튼 영역 -->
							<div class="d-flex justify-content-end p-3 border-top">
								<c:if test="${sanctnDocInfo.empNo eq drafterNo }">
									<c:if test="${sanctnDocInfo.delTy eq 'N' and sanctnDocInfo.docProcessSttus eq '09002'}">
										<button class="btn btn-warning me-1" id="delApprovalDoc">회수</button>
									</c:if>
									<c:if test="${sanctnDocInfo.docProcessSttus eq '09004' }">
										<button class="btn btn-info me-1" id="reSubmit">재기안</button>
									</c:if>
								</c:if>
								<c:forEach items="${sanctnerList }" var="sanctner">
									<c:if test="${sanctner.dcrbAuthYn eq 'Y' and sanctnDocInfo.docProcessSttus eq '09002'
										and sanctnDocInfo.empNo ne drafterNo }">
										<button class="btn btn-primary me-1" id="dcrbAuth">전결</button>
									</c:if>
								</c:forEach>
								<c:forEach items="${sanctnerList }" var="sanctner">
									<c:if test="${sanctner.lastSanctner eq drafterNo and sanctner.sanctnSttus eq '20002'}">
										<button class="btn btn-info me-1" id="approvalY">승인</button>
										<button class="btn btn-danger me-1" id="approvalN">반려</button>
									</c:if>
								</c:forEach>
								<button class="btn btn-success" id="pdfDownload">pdf 다운로드</button>
							</div> 
							
						</div>
					</div> <!-- 전자결재 문서 안에 사이드바, 내용, 결재선 영역 끝 -->

				</div> <!-- 전자결재 문서 상세보기 전체 영역 끝 -->
			</div>
		</div>
	</div> <!-- 문서 전체 페이지 영역 끝 -->


<script type="text/javascript">
document.addEventListener("DOMContentLoaded", () => {
	
	// 회수 버튼 클릭시
	if(document.querySelector("#delApprovalDoc")){
		document.querySelector("#delApprovalDoc").addEventListener("click", function(){
			console.log("회수 버튼 클릭");
			
			fetch("/eApproval/deleteApproval/${sanctnDocInfo.sanctnDocNo }", {
				method : "post",
			}).then(res => {
				return res.text();
			}).then((result) => {
				if(result == "SUCCESS"){
					console.log("회수 완료");
					Swal.fire({
						title : "회수 완료되었습니다.",
						icon : "success",
						confirmButtonText : "확인"
					}).then((res)=>{
						if(res.isConfirmed){
							location.href = "${pageContext.request.contextPath}/eApproval/inProcess";
						}
					})
				}else{
					console.log("이미 1차 결재자가 결재하였으므로 회수 못함");
					Swal.fire({
						title : "회수 실패",
						html : "이미 결재한 결재자가 있으므로 회수할 수 없습니다.",
						icon : "error",
						confirmButtonText : "확인"
					});
				}
			});
		});
	}
	
	// 전자결재 cn 안에 속성 바꾸기
	document.querySelectorAll("#formCn input, #formCn textarea, #formCn select").forEach(el => {
	    if (el.tagName === "INPUT") {
	      let type = el.type; // input의 타입 체크
	      if (["text", "number", "date", "email", "password"].includes(type)) {
	        // 텍스트는 readonly
	        el.readOnly = true;
	      } else {
	        // 체크박스, 라디오 등 disabled
	        el.disabled = true;
	      }
	    } else {
	      // textarea, select는 disabled 처리
	      el.disabled = true;
	    }
	});
	
	// 파일 다운로드 처리
	if(document.querySelector("li svg")){
		document.querySelectorAll('li').forEach(li => {
			li.addEventListener("click", function(){
				let savedNm = li.dataset.savedNm;
				
		        if(!savedNm) {
		            return;
		        }
				
				location.href = "/eApproval/docFileDownload?fileName=" + encodeURIComponent(savedNm);
			});
		});
	}
	
	// 승인 처리
	if(document.querySelector("#approvalY")){
		document.querySelector("#approvalY").addEventListener("click", function(){
			console.log("승인버튼클릭");
			// 날인 등록 되어있는지 확인
			let isSignFile = "${empty isSignFile}" === "true";
			if(isSignFile){
				Swal.fire({
					title : "날인 등록 후 결재 상신 가능합니다.",
					icon : "warning",
					confirmButtonText : "확인"
				});
				return;
			}
			
		    Swal.fire({
		        title: "결재를 승인하시겠습니까?",
		        icon: "warning",
		        showCancelButton: true,
		        confirmButtonText: "네",
		        cancelButtonText: "취소"
		    }).then((res) => {
		    	 if(res.isConfirmed){
		    		 let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }";
		    		 let sanctnOpinion = document.querySelector("#approvalOpinion").value.trim();
		    		 
		    		 let data = {};
		    		 if(sanctnOpinion == null){
		    			 data = {
	    					 sanctnDocNo : sanctnDocNo
		    			 };
		    		 }else{
			    		 data = {
		    				 sanctnDocNo : sanctnDocNo,
							 sanctnOpinion : sanctnOpinion
			    		 };
		    		 }
		    		 
		    		 console.log("보내려는 데이터: ", data);
		    		 
		    		 fetch("/eApproval/approvalTy", {
		    			 method : "post",
		    			 headers : {
		    				 "Content-Type" : "application/json"
		    			 },
		    			 body : JSON.stringify(data)
		    		 }).then((res) => {
						if(res.ok){
							console.log("res: ", res);
							console.log("결재 승인 완료");
							Swal.fire({
								title : "결재 승인이 완료되었습니다.",
								icon : "success",
								confirmButtonText : "네"
							}).then((res) => {
								if(res.isConfirmed){
									location.href = "${pageContext.request.contextPath}/eApproval/history";
								}
							})
						}
		    		 });
		    	 }
		     })
		});
	}
	
	// 반려 처리
	if(document.querySelector("#approvalN")){
		document.querySelector("#approvalN").addEventListener("click", function(){
			console.log("반려 처리 버튼 클릭");
	   		let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }";
			let sanctnSttus = "20007";
			let sanctnOpinion = document.querySelector("#approvalOpinion").value.trim();
			
			
		    Swal.fire({
		        title: "결재를 반려하시겠습니까?",
		        icon: "warning",
		        showCancelButton: true,
		        confirmButtonText: "네",
		        cancelButtonText: "취소"
		    }).then((res) => {
		    	 if(res.isConfirmed){
		    		 if(sanctnOpinion == null || sanctnOpinion == ""){
		    			 Swal.fire({
		    				title : "반려 사유를 결재의견란에 입력해주시기 바랍니다.",
		    				icon : "warning",
		    				confirmButtonText : "네"
		    			 });
		    			 return;
		    		 }
		    		 
 		    		 let data = {
		    			sanctnDocNo : sanctnDocNo,
						sanctnSttus : sanctnSttus,
						sanctnOpinion : sanctnOpinion
 		    		 };
		    		 
 		    		 fetch("/eApproval/approvalTy",{
 		    			 method : "post",
 		    			 headers : {
 		    				 "Content-Type" : "application/json" 		    			 
 		    			 },
 		    			 body : JSON.stringify(data)
 		    		 }).then((res) => {
 		    			 if(res.ok){
							console.log("반려 처리 성공");
							Swal.fire({
								title : "반려 처리했습니다.",
								icon : "success",
								confirmButtonText : "확인"
							}).then((res) => {
								if(res.isConfirmed){
									location.href = "${pageContext.request.contextPath}/eApproval/history";
								}
							})
 		    			 }else{
							console.log("반려 처리 실패: ", res);
						 }
 		    		 })
		    	 }
		     })
		});
	}
	
	// pdf 다운로드
	if(document.querySelector("#pdfDownload")){
		document.querySelector("#pdfDownload").addEventListener("click", function(){
			console.log("pdf다운로드 클릭");
			
			// pdf 만들 영역 선택
			let targetPdf = document.querySelector("#pdfDiv");
			
			// html2canvas를 사용해 선택한 영역을 canvas 이미지로 변환 
			html2canvas(targetPdf, { scale: 2, useCORS: true }).then(canvas => {
			    let imgWidth = 555; // PDF 내에서 이미지 너비 (A4 폭 맞춤)
			    let pageHeight = 842 - 40; // A4 높이 - 여백
			    let imgHeight = canvas.height * imgWidth / canvas.width;
			
			    let content = [];
			    let y = 0;
			
			    while (y < canvas.height) {
			        // 페이지 캔버스 하나씩 생성
			        let pageCanvas = document.createElement("canvas");
			        pageCanvas.width = canvas.width;
			        pageCanvas.height = Math.min(
			            canvas.height - y,
			            pageHeight * canvas.width / imgWidth
			        );
			
			        let ctx = pageCanvas.getContext("2d");
			        ctx.drawImage(
			            canvas,
			            0, y,                               // 원본 시작 좌표
			            canvas.width, pageCanvas.height,    // 원본 잘라낼 영역
			            0, 0,
			            canvas.width, pageCanvas.height     // 새 캔버스 크기
			        );
			
			        let pageImgData = pageCanvas.toDataURL("image/png");
			
			        content.push({
			            image: pageImgData,
			            width: imgWidth
			        });
			
			        y += pageCanvas.height; // 다음 잘라낼 시작 위치
				
			        // 페이지 넘어갈 때 자동 줄바꿈
			        if (y < canvas.height) {
			            content.push({ text: '', pageBreak: 'after' });
			        }
			    }
			
			    let docDefinition = {
			        pageSize: "A4",
			        pageMargins: [30, 30, 30, 30],
			        content: content
			    };
			
			    pdfMake.createPdf(docDefinition).download("전자결재문서.pdf");
				
				console.log("pdf 다운로드 완료");
			});
		});
	}
	
	// 재기안 버튼
	if(document.querySelector("#reSubmit")){
		document.querySelector("#reSubmit").addEventListener("click", function(){
			console.log("재기안 버튼 클릭");
			
			// modal 창 열기
			new bootstrap.Modal(document.querySelector("#newApprovalModal")).show();

			// 근데 이제? 모달 창 열을 때 양식 문서, 제목, 타입, 결재선 다 가져와야되잖아?
			fetch("/eApproval/reSubmit/${sanctnDocInfo.sanctnDocNo}", { method : "get"})
			.then(res => res.json())
			.then(data => {
				console.log("res: ", data);
				
				// 문서 번호 저장
				reSanctnDocNo = data.sanctnDocInfo.sanctnDocNo;
				console.log("문서 번호 저장: ", reSanctnDocNo);
				
				// 양식 정보 불러오기
				document.querySelector("#documentForm").dataset.formNo = data.sanctnDocInfo.formNo;
				document.querySelector("#documentForm").value = data.sanctnDocInfo.formNm;
				document.querySelector("#documentTitle").value = data.sanctnDocInfo.sanctnTitle;
				if(data.sanctnDocInfo.sanctnTy == '06001'){
					document.querySelector("#approvalType").options[0].selected = true;
				}else{
					document.querySelector("#approvalType").options[1].selected = true;
				}
				if(data.sanctnDocInfo.emrgncyYn == 'Y'){
					document.querySelector("#flexSwitchCheckDefault").checked = true;
				}
				document.querySelector("#documentDetails").value = data.sanctnDocInfo.formDc;
				
				// 결재선 불러오기
				let sanctnerTable = document.querySelector("#approvalLineTableBody");
				data.sanctnerList.forEach(sl => {
				    let checked = sl.dcrbAuthYn === 'Y' ? 'checked' : '';
				    let proxyName = sl.proxyEmpNm ? sl.proxyEmpNm : '-';
				    
				    sanctnerTable.innerHTML += `
				        <tr data-emp-no = "\${sl.empNo}"
							data-proxy-emp-no="\${sl.lastSanctner}"
							data-proxy-jbgd-cd="\${sl.lastSanctnerJbgd}">
				            <td>\${sl.empNm}</td>
				            <td>\${sl.lastSanctnerJbgd}</td>
				            <td>\${sl.deptNm}</td>
				            <td>
				                <input type="radio" class="form-check-input visually-prominent-checkbox" name="finalApproval" ${checked}>
				            </td>
				            <td>\${proxyName}</td>
				            <td><i class="ti ti-trash fs-4 text-danger delete-line"></i></td>
				        </tr>
				    `;
				})
				
				// 참조선 불러오기
				let referenceLineTable = document.querySelector("#referenceLineTableBody");
				data.sanctnerCCList.forEach(scl => {
					referenceLineTable.innerHTML += `
						<tr data-emp-no = "\${scl.empNo}">
							<td>\${scl.empNm}</td>
							<td>\${scl.jbgdCd}</td>
							<td>\${scl.deptNm}</td>
							<td><i class="ti ti-trash fs-4 text-danger delete-line"></i></td>
						</tr>
					`;
				})
				
			});
			
		});
	}
	
	// 전결 처리
	if(document.querySelector("#dcrbAuth")){
		document.querySelector("#dcrbAuth").addEventListener("click", function(){
			console.log("전결버튼 클릭");
			let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }";
			let sanctnSttus = "20005";
			let sanctnOpinion = document.querySelector("#approvalOpinion").value.trim();

			let data = {
			sanctnDocNo : sanctnDocNo,
			sanctnSttus : sanctnSttus,
			sanctnOpinion : sanctnOpinion
			};

			fetch("/eApproval/approvalTy", {
				method : "post",
				headers : {
					"Content-Type" : "application/json"
				},
				body : JSON.stringify(data)
			}).then((res) => {
				if(res.ok){
					console.log("전결 권한으로 문서 결재 완료");
					location.href = "${pageContext.request.contextPath}/eApproval/history";
				}else{
					console.log("전결 권한 클릭 실패");
				}
			})
		});
	}
	
	// 결재의견 더미데이터
	if(document.querySelector("#addDummyOpinion")){
	    document.querySelector("#addDummyOpinion").addEventListener("click", function(){
	        document.querySelector("#approvalOpinion").value = "해당일자는 회사 워크샵이라 연차 사용 불가능합니다.";
	    });
	}
	
});


</script>
	<%@ include file="/module/footerPart.jsp"%>
</body>
</html>