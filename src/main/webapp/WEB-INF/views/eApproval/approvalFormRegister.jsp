<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">

<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>
<%@ include file="/module/headPart.jsp"%>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<style>
.cke_notifications_area{
display: none;
}
</style>
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
											<li class="breadcrumb-item" aria-current="page">approvalForm</li>
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


							<div class="container-fluid">
								<div class="card">
									<div class="card-body">
										<h5 class="card-title fw-semibold mb-4">📝 전자결재 양식 등록</h5>

										<form id="approvalForm" novalidate>
											<div class="mb-3">
												<label class="form-label" for="formType">양식종류</label>
													<select class="form-control" id="upperFormNo">
														<c:choose>
															<c:when test="${empty form }">
																<c:forEach items="${approvalFolderList }" var="folder">
																		<option value="${folder.formNo }">${folder.formNm }</option>
																</c:forEach>
															</c:when>
															<c:otherwise>
																	<option value="${form.upperFormNo }">${form.upperFormNm }</option>
															</c:otherwise>
														</c:choose>
													</select>
											</div>
											<div class="mb-3">
												<label class="form-label" for="title">양식명</label> <input
													type="text" class="form-control" id="title" name="title" value="${form.formNm }"
													placeholder="양식명을 입력하세요." required>
											</div>
											<div class="mb-4">
												<label class="form-label" for="description">설명</label>
												<textarea class="form-control" id="description" name="description"
													rows="3" placeholder="양식 문서에 대한 설명을 작성해주세요." required>${form.formDc }</textarea>
											</div>
											<div class="mb-4">
												<label class="form-label" for="content">내용</label>
												<textarea class="form-control" id="content" name="content"
													rows="6" placeholder="양식 문서에 대한 내용을 작성해주세요." required>${form.formCn }</textarea>
											</div>
											<div class="d-flex justify-content-end gap-2">
												<c:choose>
													<c:when test="${empty form }">
													    <button type="button" onClick="location.href='${pageContext.request.contextPath}/eApprovalForm/approvalFormList/${formNo }'"
													        class="btn btn-light">취소</button>
													    <button type="button" id="newFormRegister"
													        class="btn btn-primary">등록하기</button>
													</c:when>
													<c:otherwise>
													    <button type="button" onClick="location.href='${pageContext.request.contextPath}/eApprovalForm/approvalFormDetail/${form.formNo }'"
													        class="btn btn-light">취소</button>
													    <button type="button" id="formModify"
													        class="btn btn-warning">수정하기</button>
													</c:otherwise>
												</c:choose>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="alert-area"
		style="position: fixed; top: 20px; right: 20px; width: 250px; z-index: 9999;">
	</div>



<script type="text/javascript">
document.addEventListener("DOMContentLoaded", () => {
	CKEDITOR.replace("content");
	
	// 등록하기 버튼 클릭
	if(document.querySelector("#newFormRegister")){
		document.querySelector("#newFormRegister").addEventListener("click", function(){
			console.log("등록하기 버튼 누름");
			
			let upperFormNo = document.querySelector("#upperFormNo").value;
			let title = document.querySelector("#title").value;
			let description = document.querySelector("#description").value;
			// .getData()는 인스턴스에서 "내용"가져오기 (html 그대로 문자열 반환) 
			let content = CKEDITOR.instances.content.getData(); 
			
			if(!upperFormNo || !title || !description || !content){
				checkErrorAlert();
			}
			
			let data = {
				upperFormNo: upperFormNo,
				formNm: title,
				formDc: description,
				formCn: content
			};
			
			console.log("보내려는 데이터: ", data);
			
			fetch("${pageContext.request.contextPath}/eApprovalForm/formRegister", {
				method: "post",
				headers: {
					"Content-Type": "application/json"
				},
				body: JSON.stringify(data)
			}).then((res) => {
				console.log("결과값: ", res);
				if(res.status == 200){
					registerSuccessAlert().then((res) => {
						if(res.isConfirmed){
							location.href = "${pageContext.request.contextPath}/eApprovalForm/approvalFormList/" + upperFormNo;
						}else{
							registerErrorAlert();
							return;
						}
					});
				}
			});
			
		});
		
	}
	
	// 수정하기 버튼 클릭
	if(document.querySelector("#formModify")){
		document.querySelector("#formModify").addEventListener("click", function(){
			console.log("수정하기 버튼");
			
			let formNo = ${form.formNo};
			let upperFormNo = document.querySelector("#upperFormNo").value;
			let title = document.querySelector("#title").value;
			let description = document.querySelector("#description").value;
			// .getData()는 인스턴스에서 "내용"가져오기 (html 그대로 문자열 반환) 
			let content = CKEDITOR.instances.content.getData(); 
			
			if(!upperFormNo || !title || !description || !content){
				checkErrorAlert();
			}
			
			let data = {
				upperFormNo: upperFormNo,
				formNo: formNo,
				formNm: title,
				formDc: description,
				formCn: content
			};
			
			console.log("보내려는 데이터: ", data);
			
			fetch("${pageContext.request.contextPath}/eApprovalForm/docDetailModify/" + formNo, {
				method: "post",
				headers: {
					"Content-Type" : "application/json"
				},
				body: JSON.stringify(data)
			}).then((res) => {
				console.log(res);
				if(res.status == 200){
					console.log("수정 성공");
				}
			});
		});
	}
	
});


////////////////////////////////
// sweetAlert

// 새 양식 등록 성공
function registerSuccessAlert(){
	return Swal.fire({
		title: "등록에 성공하였습니다.",
		icon: "success",
		confirmButtonText: "확인"
	});
}

// 새 양식 등록 실패
function registerErrorAlert(){
	Swal.fire({
		title: "등록에 실패하였습니다.",
		icon: "error",
        confirmButtonText: "확인"
	});
}

// 유효성 검사
function checkErrorAlert(){
	Swal.fire({
		title: "모든 항목을 입력해야 합니다.",
		icon: "error",
        confirmButtonText: "확인"
	});
}

</script>

<%@ include file="/module/footerPart.jsp"%>
</body>
</html>