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
<script src="https://cdn.ckeditor.com/4.21.0/standard/ckeditor.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<body>
	<%@ include file="/module/aside.jsp"%>

	<div id="alert-area" style="position: fixed; top: 20px; right: 20px; width: 250px; z-index: 9999;"></div>

	<!-- 문서 전체 페이지 -->
	<div class="body-wrapper">
		<div class="container-fluid">
			<div class="body-wrapper">
			
				<!-- 전자결재 문서 기안서 전체 -->
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
								<div class="col-3"></div>
							</div>
						</div>
					</div>
						
					<!-- 전자결재 기안문서 안에 사이드바, 내용, 결재선 -->
					<div class="d-flex w-100">
						<%@ include file="/WEB-INF/views/eApproval/approvalAside.jsp"%>
						<div class="w-100">
							<div class="p-3">
								<!-- 기안문서 영역 -->
								<div class="row w-100">
									<!-- 본문 영역 -->
									<div class="col-md-9 p-3">
										<h3 class="text-center mb-4">${sanctnDocInfo.formNm }</h3>
										<!-- 날인 부분 -->
										<div class="row mb-3">
											<div class="col-12 text-end">
												<div style="border: 1px solid #ccc; padding: 5px; width: 100px; display: inline-block;">
													<div style="font-size: 12px; border-bottom: 1px solid #ccc; padding-bottom: 5px; margin-bottom: 5px;">
														${sanctnDocInfo.jbgdCd }
													</div>
													<div class="text-center">
														<img id="stampPreview" src="${stampUrl }" alt="도장 이미지" class="img-fluid mb-3 rounded-circle"
															style="max-height: 60px;"> <br> 
														<span style="font-size: 14px; display: inline-block; margin-top: 5px;">${sanctnDocInfo.empNm }</span>
													</div>
												</div>
											</div>
										</div>
										
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
																<td>${fn:substring(sanctnDocInfo.wrtDt, 0, 4)}-
																	${fn:substring(sanctnDocInfo.wrtDt, 5, 7)}-
																	${fn:substring(sanctnDocInfo.wrtDt, 8, 10)}</td>
															<td class="bg-light fw-semibold text-center">문서번호</td>
															<td class="text-dark ps-3">${sanctnDocInfo.sanctnDocNo }</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
										<div class="form-title mb-3 p-2 bg-light-subtle rounded"
											style="font-weight: bold; font-size: 16px;">
											<!-- 문서 제목 입력 -->
											<div class="mb-1">
												<label for="docTitle" class="form-label fw-bold">문서
													제목</label> <input type="text" class="form-control" id="docTitle"
													name="docTitle" value="${sanctnDocInfo.sanctnTitle }"
													placeholder="문서 제목을 입력하세요">
											</div>
										</div>
										<hr>
										<div class="form-title mb-1 p-2 bg-light-subtle rounded"
											style="font-weight: bold; font-size: 16px;">
											<label for="docContent" class="form-label fw-bold">문서
												내용</label>
										</div>
										<div class="mx-auto" style="max-width: 700px;">
											<form id="formSubmit">
												<div class="formCn-content mb-4" id="formCn">
													<c:choose>
														<c:when
															test="${sanctnDocInfo.docProcessSttus eq '09005' or sanctnDocInfo.docProcessSttus eq '09001'}">
															${sanctnDocInfo.sanctnCn }
														</c:when>
														<c:otherwise>
															${sanctnDocInfo.formCn }
														</c:otherwise>
													</c:choose>
												</div>
											</form>
											<div class="mb-3 d-flex align-items-center gap-2">
												<label for="fileUpload" class="form-label mb-0 me-2">첨부파일</label>
												<input class="form-control" type="file" id="fileUpload"
													name="files" multiple style="flex: 1;">
												<button type="button" class="btn btn-primary"
													id="fileUploadBtn">업로드</button>
											</div>
											<div class="form-text" style="color: red;">- 파일 선택 후
												업로드 버튼을 누르셔야 됩니다.</div>
											<div class="form-text">- 여러 파일을 선택하려면 Ctrl 또는 Shift 키를
												사용하세요.</div>
										</div>
									</div>

									<!-- 결재선 영역 -->
									<div class="col-md-3 p-3"
										style="max-height: 800px; overflow-y: auto;">
										<div class="card p-3 shadow-sm">
											<h5 class="mb-3">결재선</h5>
											<c:forEach items="${sanctnerList }" var="sanctner">
												<div class="d-flex align-items-center mb-2 p-2 rounded"
													style="background-color: #f0f4f9;">
													<div class="flex-grow-1">
														<p class="mb-0 fw-bold">${sanctner.empNm }
															${sanctner.jbgdCd }</p>
														<p class="mb-0 text-muted" style="font-size: 12px;">${sanctner.deptNm }</p>
													</div>
													<div class="ms-auto badge bg-light text-dark">
														${sanctner.sanctnOrdr }차 승인</div>
												</div>
											</c:forEach>
										</div>

										<div class="card p-3 shadow-sm mt-4">
											<h5 class="mb-3">참조자</h5>
											<ul class="list-unstyled mb-0">
												<c:forEach items="${sanctnerCCList }" var="sanctnerCC">
													<li class="mb-1">${sanctnerCC.empNm }
														${sanctnerCC.jbgdCd } (${sanctnerCC.deptNm })</li>
												</c:forEach>
											</ul>
										</div>

										<c:if test="${not empty sanctnDocInfo.fileList }">
											<div class="card p-3 shadow-sm mt-4">
												<h5>첨부파일</h5>
												<div class="form-text mt-0">- 파일 클릭 시 다운로드 됩니다.</div>
												<ul class="list-unstyled mt-2">
													<c:forEach items="${sanctnDocInfo.fileList }" var="file">
														<li
															class="mb-1 d-flex justify-content-between align-items-center"
															data-file-no="${file.fileNo }"
															data-original-nm="${file.originalNm }"
															data-saved-nm="${file.savedNm }"><span> <svg
																	xmlns="http://www.w3.org/2000/svg" width="20"
																	height="20" viewBox="0 0 24 24">
										                            <g fill="none"
																		stroke="currentColor" stroke-linejoin="round"
																		stroke-width="1.5">
										                                <path stroke-linecap="round"
																		d="M4 4v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8.342a2 2 0 0 0-.602-1.43l-4.44-4.342A2 2 0 0 0 13.56 2H6a2 2 0 0 0-2 2m5 9h6m-6 4h3" />
										                                <path
																		d="M14 2v4a2 2 0 0 0 2 2h4" />
										                            </g>
										                        </svg> ${file.originalNm }
														</span>
															<button type="button"
																class="btn btn-sm btn-outline-danger ms-2 file-remove-btn">X</button>
														</li>
													</c:forEach>
												</ul>
											</div>
										</c:if>

									</div>

									<div class="d-flex justify-content-end p-3 border-top">
										<button class="btn btn-info me-2" id="temporarySave"
											type="button">
											<i class="bi bi-check-lg me-1"></i>임시저장
										</button>
										<button class="btn btn-success me-2" id="approvalSubmit"
											type="button">
											<i class="bi bi-check-lg me-1"></i>상신
										</button>
										<c:if test="${sanctnDocInfo.docProcessSttus eq '09002' }">
											<button class="btn btn-danger" id="cancelBtn">
												<i class="bi bi-x-lg me-1"></i>취소
											</button>
										</c:if>
										<c:if test="${sanctnDocInfo.docProcessSttus eq '09001' }">
											<button class="btn btn-danger"
												onClick="location.href='${pageContext.request.contextPath}/eApproval/dashBoard'">
												<i class="bi bi-x-lg me-1"></i>취소
											</button>
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


		<script type="text/javascript">
// 행 추가 버튼
function addQ(){
	console.log("행 추가");
	let tr = document.createElement("tr");
	tr.innerHTML = `
           <td><input type="text" class="form-control" name="qItem[]"></td>
           <td><input type="text" class="form-control" name="qDesc[]"></td>
           <td><input type="number" class="form-control q-qty" name="qQty[]"></td>
           <td><input type="number" class="form-control q-price" name="qPrice[]" step="100"></td>
           <td><input type="number" class="form-control q-amt" name="qAmt[]" step="100"></td>
	`;
	
	console.log(tr);
	document.querySelector("#qTbl").querySelector("tbody").appendChild(tr);
	
}

// 합계 구하기
function calcSum() {
    let sum = 0;
    
    document.querySelectorAll(".amt").forEach(input => {
      let val = parseInt(input.value) || 0; // 값 없으면 0 처리
      sum += val;
    });
    
    document.querySelector("#sum").textContent = sum.toLocaleString(); // 3자리 콤마
}

///////////////////////////////////////////////////////////////
document.addEventListener("DOMContentLoaded", () => {
	// 입력할 때마다 자동 합계 업데이트
	document.querySelectorAll(".amt").forEach(input => {
	  input.addEventListener("input", calcSum);
	});
	
	let fileGroupNo;
	
	document.querySelector("#fileUploadBtn").addEventListener("click", function(){
		console.log("파일 업로드");
		
		let fileUpload = document.querySelector("#fileUpload");
		let files = Array.from(fileUpload.files); // 배열 형태의 파일 목록

		let formData = new FormData();
		files.forEach(file => formData.append("files", file));
		
		// 문서번호도 같이 보내기
		let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }"; 
		formData.append("type", "basic");
		formData.append("sanctnDocNo", sanctnDocNo);
		
		console.log("파일:", formData.get("sanctnDocNo"));
		
		fetch("/eApproval/fileUpload", {
			method : "post",
			body : formData
		}).then((res) => {
			console.log("res:", res);
			if(res.ok){
				Swal.fire({
					title : "파일 업로드 완료!",
					icon : "success",
					confirmButtonText: "확인"
				});
				return res.text();
			}
		}).then((rslt) => {
			console.log(rslt);
			fileGroupNo = rslt;
		});
	
	});
	
	
	// 상신 버튼 클릭시
	document.querySelector("#approvalSubmit").addEventListener("click", function(){
		console.log("제출버튼");
		
		// formCn 영역 전체 가져오기
		let formCn = document.querySelector("#formCn");
		console.log(formCn);
		
		// 안에 있는 input/textarea/select 순회
		formCn.querySelectorAll("input, textarea, select").forEach(el => {
			if(el.tagName === "TEXTAREA"){
				el.innerText = el.value;
			}else if(el.tagName === "SELECT"){
				el.querySelectorAll("option").forEach(opt => {
					opt.removeAttribute("selected");
					if(opt.value === el.value){
						opt.setAttribute("selected", "selected");
					}
				});
			}else if(el.tagName === "INPUT"){
				el.setAttribute("value", el.value);
			}
		});
		
		if(document.querySelector("#addRow")){
			formCn.querySelector("#addRow").remove();
		}
		if(document.querySelector("#addDummyRow")){
			formCn.querySelector("#addDummyRow").remove();
		}
		if(document.querySelector("#addDummyLeave")){
			formCn.querySelector("#addDummyLeave").remove();
		}
		
		let finalFormCn = formCn.innerHTML;
		console.log("최종 저장: ", finalFormCn);
		
		let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }";
		let sanctnTitle = document.querySelector("#docTitle").value;
		let docProcessSttus = "09002";
		
// 		if(fileGroupNo == )
		
		let data = {
			sanctnDocNo : sanctnDocNo,
			sanctnTitle : sanctnTitle,
			sanctnCn : finalFormCn,
			docProcessSttus : docProcessSttus,
			fileGroupNo : fileGroupNo
		};
		
		console.log("보내려는 data: ", data);
		
		if(document.querySelector("#stampPreview").getAttribute("src").trim() == ""){
			Swal.fire({
				title : "날인 등록 후 결재 상신 가능합니다.",
				icon : "warning",
				confirmButtonText : "확인"
			});
			return;
		}
		
		fetch("/eApproval/approvalDocRegister", {
			method: "post",
			headers: {
				"Content-Type" : "application/json"
			},
			body: JSON.stringify(data)
		}).then((res) => {
			console.log("res:", res);
			if(res.ok){
				console.log("문서 상신 완료");
				Swal.fire({
					title : "문서 상신이 완료되었습니다.",
					icon : "success",
					confirmButtonText: "확인"
				}).then((res)=>{
					if(res.isConfirmed){
						location.href = "${pageContext.request.contextPath}/eApproval/inProcess";
					}
				})
			}else{
				console.log("문서 상신 실패");
			}
			
		});
		
		
	});

	const yujin = (cssSel) => document.querySelector(cssSel);

	// 임시저장 버튼
	yujin("#temporarySave").addEventListener("click", function(){
		console.log("임시저장 버튼 클릭");
		
		// formCn 영역 전체 가져오기
		let formCn = document.querySelector("#formCn");
		console.log(formCn);
		
		// 안에 있는 input/textarea/select 순회
		formCn.querySelectorAll("input, textarea, select").forEach(el => {
			if(el.tagName === "TEXTAREA"){
				el.innerText = el.value;
			}else if(el.tagName === "SELECT"){
				el.querySelectorAll("option").forEach(opt => {
					opt.removeAttribute("selected");
					if(opt.value === el.value){
						opt.setAttribute("selected", "selected");
					}
				});
			}else if(el.tagName === "INPUT"){
				el.setAttribute("value", el.value);
			}
		});
		
		let finalFormCn = formCn.innerHTML;
		console.log("최종 저장: ", finalFormCn);
		
		let sanctnDocNo = "${sanctnDocInfo.sanctnDocNo }";
		let sanctnTitle = document.querySelector("#docTitle").value;
		let docProcessSttus = "09005";
		
		let data = {
			sanctnDocNo : sanctnDocNo,
			sanctnTitle : sanctnTitle,
			sanctnCn : finalFormCn,
			docProcessSttus : docProcessSttus,
			fileGroupNo : fileGroupNo
		};
		
		console.log("보내려는 data: ", data);
		
		if(document.querySelector("#stampPreview").getAttribute("src").trim() == ""){
			Swal.fire({
				title : "날인 등록 후 결재 상신 가능합니다.",
				icon : "warning",
				confirmButtonText : "확인"
			});
			return;
		}
		
		fetch("/eApproval/approvalDocRegister", {
			method: "post",
			headers: {
				"Content-Type" : "application/json"
			},
			body: JSON.stringify(data)
		}).then((res) => {
			console.log("res:", res);
			if(res.ok){
				console.log("임시 저장 완료");
				Swal.fire({
					title : "임시 저장이 완료되었습니다.",
					icon : "success",
					confirmButtonText: "확인"
				}).then((res)=>{
					if(res.isConfirmed){
						location.href = "${pageContext.request.contextPath}/eApproval/draft";
					}
				})                         
			}else{
				console.log("임시 저장 실패");
			}
			
		});
	});

	// 파일 다운로드 처리
	if(document.querySelector("li svg")){
		document.querySelectorAll('li').forEach(li => {
			li.addEventListener("click", function(e){
				if(e.target.classList.contains("file-remove.btn")) return;
				
				let savedNm = li.dataset.savedNm;
				
		        if(!savedNm) {
		            return;
		        }
				
				location.href = "/eApproval/docFileDownload?fileName=" + encodeURIComponent(savedNm);
			});
			
			// 임시저장 파일 삭제
		    let removeBtn = li.querySelector(".file-remove-btn");
		    if(removeBtn){
		        removeBtn.addEventListener("click", function(e){
		            e.stopPropagation(); 
		            li.remove();  // 화면에서 삭제
		            let fileNo = removeBtn.closest("li").dataset.fileNo;
		            console.log("삭제할 파일 번호: ", fileNo);
		            
		            // 서버 삭제 요청
		            axios.post("/eApproval/delFile",{
		            	fileNo : fileNo
		            }).then((res) => {
		            	if(res.status == 200){
		            		console.log("임시저장 파일 삭제 완료");
		            	}
		            })	
		        });
		    }
		});
	}
	
	// 취소버튼시 문서 결재 insert 됐으니 삭제 해줘야됨
	document.querySelector("#cancelBtn").addEventListener("click", function(){
		let delDocNo = "${sanctnDocInfo.sanctnDocNo }";
		
		console.log("취소 버튼 클릭 no: ", delDocNo);
		
		axios.post("/eApproval/delDoc", delDocNo, {
			headers: {"Content-Type": "text/plain"}
		}).then((res) => {
			if(res.status == 200){
				console.log("삭제 성공");
				location.href = "${pageContext.request.contextPath}/eApproval/dashBoard";
			}
		});
	});
	
	
	///////////////////////////////////////////////////////////////////////////////////
	
	// 견적서 더미
	if(document.querySelector("#addDummyRow")){
		document.querySelector("#addDummyRow").addEventListener("click", function(){
			document.querySelector("#vendor").value = "(주)좋은자재";
			document.querySelector("#reqDept").value = "디자인 3팀 - 이유진 / 현장 1팀 - 김형준";
			document.querySelector("#reason").value = "위와 같이 견적서를 제출하오니 승인 부탁드립니다.";
			
		    let tbody = document.querySelector("#qTbl tbody");
		    tbody.innerHTML = ""; // 기존 행 초기화
	
		    const rows = [
		        ["철거", "마루, 타일, 욕실", "13,050,000", "10,200,000", "23,250,000"],
		        ["설비", "배수이동, 매립수전 설치", "1,300,000", "3,400,000", "4,700,000"],
		        ["목공", "히든도어, 가벽설치, 천장", "28,500,000", "25,650,000", "54,150,000"],
		        ["전기", "전기 배선, 조명 설치", "10,000,000", "4,400,000", "14,400,000"],
		        ["타일", "조적벽체, 젠다이, 샤워부스", "18,600,000", "8,400,000", "27,000,000"],
		        ["도배", "방 전체, 거실", "1,500,000", "5,800,000", "7,300,000"],
		        ["필름", "거실, 주방", "1,500,000", "3,800,000", "5,300,000"],
		        ["도장", "베란다", "600,000", "1,000,000", "1,600,000"],
		        ["마루", "방 전체, 거실", "9,800,000", "-", "9,800,000"],
		        ["가구", "아일랜드 테이블, 붙박이장", "52,500,000", "-", "52,500,000"],
		        ["마감", "실리콘", "-", "700,000", "700,000"]
		    ];
	
		    rows.forEach(row => {
		        let tr = document.createElement("tr");
		        tr.innerHTML = `
		            <td>\${row[0]}</td>
		            <td>\${row[1]}</td>
		            <td>\${row[2]}</td>
		            <td>\${row[3]}</td>
		            <td>\${row[4]}</td>
		        `;
		        tbody.appendChild(tr);
		    });
	
		    // 소계 행 추가
		    let trTotal = document.createElement("tr");
		    trTotal.innerHTML = `
		        <th colspan="2" class="text-center">소계</th>
		        <th>137,350,000</th>
		        <th>63,350,000</th>
		        <th>200,700,000</th>
		    `;
		    tbody.appendChild(trTotal);
		});
	}
	
	// 휴가 신청서 더미
	if(document.querySelector("#addDummyLeave")){
		document.querySelector("#addDummyLeave").addEventListener("click", function(){
		    console.log("더미데이터 입력");

		    // 휴가 종류 선택
		    document.querySelector("select[name='leaveType']").value = "연차";

		    // 날짜 더미값
		    document.querySelector("input[name='from']").value = "2025-10-10";
		    document.querySelector("input[name='to']").value = "2025-10-10";

		    // 사용일수
		    document.querySelector("input[name='days']").value = 1;

		    // 사유
		    document.querySelector("textarea[name='reason']").value = "개인 사정으로 휴가 사용";
		});
	}

});

</script>
		<%@ include file="/module/footerPart.jsp"%>
</body>
</html>