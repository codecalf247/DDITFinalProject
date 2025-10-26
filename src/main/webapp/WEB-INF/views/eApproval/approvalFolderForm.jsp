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
</head>
<style>
.cke_notifications_area{
display: none;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
										<c:choose>
											<c:when test="${empty sanctnFolderInfo}">
												<h5 class="card-title fw-semibold mb-4">📝 전자결재 양식 등록</h5>
											</c:when>
											<c:otherwise>
												<h5 class="card-title fw-semibold mb-4">📝 전자결재 양식 수정</h5>
											</c:otherwise>
										</c:choose>

										<form id="approvalForm" action="/eApprovalForm/register" method="post">
											<div class="mb-3">
												<label class="form-label" for="formType">양식종류</label>
												<input
													type="text" class="form-control" id="formType" name="formNm" value="${sanctnFolderInfo.formNm }"
													placeholder="양식 문서명을 입력하세요." required>
											</div>
											<div class="mb-4">
												<label class="form-label" for="description">설명</label>
												<textarea class="form-control" id="description" name="formDc"
													rows="3" placeholder="양식 상위문서명에 대한 설명을 작성해주세요." required>${sanctnFolderInfo.formDc }</textarea>
											</div>
											<div class="d-flex justify-content-end gap-2">
											    <button type="button" onClick="location.href='${pageContext.request.contextPath}/eApproval/approvalFormFolder'"
											        class="btn bg-info-subtle text-info">취소</button>
	        										<c:choose>
													<c:when test="${empty sanctnFolderInfo}">
													    <button type="button" id="folderRegister"
													        class="btn btn-primary">등록하기</button>
													</c:when>
													<c:otherwise>
													    <button type="button" id="folderModify"
													        class="btn btn-primary">수정하기</button>
													</c:otherwise>
												</c:choose>
											</div>
											<c:if test="${not empty sanctnFolderInfo}">
											  <input type="hidden" id="formNo" name="formNo" value="${sanctnFolderInfo.formNo }">
											</c:if>
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
	
	// 등록하기 버튼 눌렀을 때
	if(document.querySelector("#folderRegister")){
		document.querySelector("#folderRegister").addEventListener("click", function(){
			console.log("폴더 등록하기 버튼 누름");
			
			let formType = document.querySelector("#formType").value;
			let description = document.querySelector("#description").value;
			
			if(!formType || !description){
				registerNullErrorAlert();
				return;
			}
			
			let data = {
				formNm: formType,
				formDc: description
			};
			
			console.log("보내려는 데이터: ", data);
			
			fetch("${pageContext.request.contextPath}/eApprovalForm/folderRegister", {
				method: "post",
				headers: {
					"Content-Type": "application/json"
				},
				body: JSON.stringify(data)
			}).then((res) => {
				console.log(res);
				res.text().then((rslt) => {
					console.log("결과값: ", rslt);
					if(rslt == "SUCCESS"){
						console.log("상위 폴더 등록 완료");
						registerSuccessAlert().then((res)=>{
							if(res.isConfirmed){
								location.href = "${pageContext.request.contextPath}/eApproval/approvalFormFolder";
							}
						});
					}else{
						registerErrorAlert();
					}
				});
			});
			
		});
		
	}
	
	// 수정하기 버튼 누름
	if(document.querySelector("#folderModify")){
		document.querySelector("#folderModify").addEventListener("click", function(){
			let formNo = document.querySelector("#formNo").value;			
			document.querySelector("#approvalForm").setAttribute("action", "${pageContext.request.contextPath}/eApprovalForm/modifyFolder/" + formNo);
			document.querySelector("#approvalForm").submit();
		});
	}
	
});

///////////////////////////////////////////////////
// sweetAlert
function registerSuccessAlert(){
	return Swal.fire({
		title: `폴더 등록에 성공하였습니다,`,
		icon: "success",
        confirmButtonText: "확인"
	});
}

function registerErrorAlert(){
	Swal.fire({
		title: `폴더 등록에 실패하였습니다,`,
		icon: "error",
        confirmButtonText: "확인"
	});
}

function registerNullErrorAlert(){
	Swal.fire({
		title: `양식 종류 및 설명을 작성해주세요.`,
		icon: "error",
        confirmButtonText: "확인"
	});
}
</script>

<%@ include file="/module/footerPart.jsp"%>
</body>
</html>