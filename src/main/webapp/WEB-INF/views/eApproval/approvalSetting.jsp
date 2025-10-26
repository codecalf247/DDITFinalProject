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
<style type="text/css">
/* 검색된 노드 색상 변경 */
/* jstree3 검색 강조 스타일 */
#jstree3 .jstree-search {
    color: #00AFF0 !important;   /* 글자색 하늘 파랑 */
    border-radius: 4px;          /* 살짝 둥글게 */
    font-weight: bold;           /* 강조 (옵션) */
}

/* jstree 앵커 글자 기본 기울임 없애기 */
#jstree3 .jstree-anchor {
    font-style: normal !important; /* 기울임 제거 */
}
</style>

</head>
<%@ include file="/module/header.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
	
<body>
	<%@ include file="/module/aside.jsp"%>
	
	<div id="alert-area"
		style="position: fixed; top: 20px; right: 20px; width: 250px; z-index: 9999;">
	</div>

	<div class="body-wrapper">
		<div class="container-fluid">
			<div class="body-wrapper">
				<div class="container">
					<div
						class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">전자결재 환경 설정</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a
												class="text-muted text-decoration-none" href="../main/index">Home</a>
											</li>
											<li class="breadcrumb-item" aria-current="page"><a
												class="text-muted text-decoration-none"
												href="/eApproval/dashBoard">Approval</a></li>
											<li class="breadcrumb-item" aria-current="page">approvalSetting</li>
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

							<div class="d-flex w-100 right-part">
								<div class="w-100 ps-0 ps-xl-5">
									<div class="row">
										<div class="col-lg-6 mb-4">
											<div class="card shadow">
												<div
													class="card-header bg-primary-subtle border-bottom border-primary">
													<h5 class="card-title mb-0 text-primary">날인 정보 기록</h5>
												</div>
												<div class="card-body">
													<div class="d-flex flex-column align-items-center mb-4">
														<h6 class="mb-3">내 결재 도장 이미지</h6>
														<div
															class="border border-2 border-dashed rounded-3 p-4 text-center d-flex flex-column align-items-center w-100"
															style="min-height: 180px;">
															<img id="stampPreview" src="${stampUrl }"
																alt="도장 이미지" class="img-fluid mb-3 rounded-circle"
																style="max-height: 120px;">
															<div class="d-flex gap-2">
																<input type="file" id="stampUpload" class="d-none"
																	accept="image/*">
																<button type="button" class="btn btn-sm btn-primary"
																	id="stampUploadBtn">
																	<i class="ti ti-upload me-1"></i> 도장 업로드
																</button>
															</div>
														</div>
													</div>
												</div>
												<div class="card-footer text-end">
													<button type="button" id="saveStamp" class="btn btn-primary">
														<i class="ti ti-device-floppy me-1"></i> 저장
													</button>
													<button type="button" id="delStamp"
														class="btn btn-danger">
														<i class="ti ti-trash me-1"></i> 삭제
													</button>
												</div>
											</div>
										</div>

										<div class="col-lg-6 mb-4">
											<div class="card shadow">
												<div
													class="card-header bg-danger-subtle border-bottom border-danger">
													<h5 class="card-title mb-0 text-danger">대결자 설정</h5>
												</div>
												<div class="card-body">
													<div class="mb-3">
														<label for="selectedApprover"
															class="form-label fw-semibold">대결자 선택</label>
														<div class="d-flex align-items-center gap-2">
															<input type="text" class="form-control"
																style="width: 290px;" id="selectedApprover"
																placeholder="조직도에서 대결자를 선택해주세요." readonly>
															<button type="button" class="btn btn-primary"
																data-bs-toggle="modal" data-bs-target="#jstreeModal">
																<i class="ti ti-users me-1"></i> 조직도
															</button>
														</div>
													</div>
													<div class="row mb-3 gx-2">
														<div class="col-6">
															<label for="startDate" class="form-label fw-semibold">대결
																시작일</label> <input type="date" class="form-control"
																id="startDate">
														</div>
														<div class="col-6">
															<label for="endDate" class="form-label fw-semibold">대결
																종료일</label> <input type="date" class="form-control" id="endDate">
														</div>
													</div>
													<div class="form-check form-switch mb-3">
														<input class="form-check-input" type="checkbox"
															id="delegateActiveSwitch" <c:if test="${not empty proxyInfo }">checked</c:if>> 
															<label
															class="form-check-label" for="delegateActiveSwitch">대결
															지정 활성화</label>
													</div>
													<div id="currentDelegateInfo"
													     class="alert alert-info border-info mt-4 p-3 d-none"
													     data-proxy-sanctner-no="${not empty proxyInfo ? proxyInfo.proxySanctnerNo : ''}">
														<h6 class="alert-heading text-info">현재 대결자 정보</h6>
														<p class="mb-1">
															<strong>지정된 대결자:</strong> 
															<span id="delegateName"
																class="fw-bold">
																<c:if test="${not empty proxyInfo }">
																	${proxyInfo.proxyNm } (${proxyInfo.deptNm }/${proxyInfo.jbgdCd })
																</c:if>
																<c:if test="${empty proxyInfo }">
																	지정된 대결자가 없습니다.
																</c:if>
															</span>
														</p>
														<p class="mb-0">
															<strong>대결 기간:</strong>
															<span id="delegatePeriodStart"> 
																<c:if test="${not empty proxyInfo }">
																	${proxyInfo.beginYmd }~ 
																</c:if>
															</span> 
															<span id="delegatePeriodEnd">
																<c:if test="${not empty proxyInfo }">
																	${proxyInfo.endYmd }
																</c:if>
															</span>
															<span id="emptyDelegatePeriodEnd">
																<c:if test="${empty proxyInfo }">
																	-
																</c:if>
															</span>
														</p>
														
													    <div class="text-end">
													        <button type="button" id="proxyDelete" class="btn btn-sm btn-outline-danger">
													            <i class="ti ti-trash me-1"></i> 대결자 삭제
													        </button>
													    </div>
														
													</div>
												</div>
												<div class="card-footer text-end">
													<button type="button" id="proxySave" class="btn btn-danger">
														<i class="ti ti-device-floppy me-1"></i> 대결자 지정
													</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
	<div class="modal fade" id="jstreeModal" tabindex="-1"
		aria-labelledby="jstreeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-md">
			<div class="modal-content">
				<div class="modal-header border-bottom">
					<h5 class="modal-title" id="jstreeModalLabel">
						<i class="ti ti-users me-2"></i>조직도
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body p-3">
					<div class="d-flex align-items-center mb-3">
						<h6 class="fw-semibold mb-0">부서선택</h6>
						<div class="btn-group ps-2 d-flex flex-grow-1">
							<input type="text" class="form-control form-control-sm me-2"
								id="organizationChart" placeholder="사원/부서 검색하세요." />
						</div>
						<button id="organizationChartSch" class="btn btn-outline-secondary btn-sm">검색</button>
					</div>
					<div id="jstree3"
						style="min-height: 350px; overflow: auto;">

					</div>
				</div>
				<div class="modal-footer border-top">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary"
						id="selectApproverBtn">선택 완료</button>
				</div>
			</div>
		</div>
	</div>
	
<script type="text/javascript">
/////////////////////////////////////////////////////////////
//결재선 tree
let jsEl3 = $("#jstree3").jstree({
	// 검색 기능 활성화
  "plugins": ["search"],
  // tree에 보여줄 데이터
  "core": {
 	 // core.data에 함수 넣으면 자동으로 (obj, cb) 두개를 호출
 	 // obj: 현재 요청 중인 노드 정보, cb: 데이터를 반환하는 콜백
			"data": function (obj, cb) {
          $.ajax({
              url: "/eApprovalTree/approvalLine",
              type: "get",
              success: function(res) {
                  console.log("결과 리스트", res);

                  res.forEach((node) => {
                      if(node.parent == "#"){
                          node.icon = "ti ti-users";
                      } else {
                          node.icon = "ti ti-user";
                      }
                  });

                  // cb에 데이터 전달
                  cb.call(obj, res);
              },
  			error : function(error, status, thrown){
 				console.log(error);
 				console.log(status);
 				console.log(thrown);
 			}
          });
      },
      "check_callback": true // 이거 없으면 create_node 안먹음
  }
});

console.log("최초의 로딩된 js tree3 : "+ jsEl3);

//node가 select 되었을 때
$("#jstree3").on("select_node.jstree", function(e, data) {
	let node = data.node;
 	console.log("select 했을 때", node);

 // 자식 node가 있으면 팀이라고 판단
 if(node.children.length > 0) {
     console.log("팀이름:", node.text);
     return;
 }
	
 console.log("select 했을 때", node.text);
 
 if(node.children.length === 0){
	    // 사번 정보를 가져옴
	    empNo = node.original.id;
	    console.log(empNo);
 	
	    // "(" 기준으로 이름, 직급 저장
	    
 	// 이름 정보를 가져옴
	    let empNameAndPosition = node.text;
 	
	    let parts = empNameAndPosition.split("(");
	    empName = parts[0].trim();
	    jbgdCd = parts[1].replace(")", "").trim();
 	
	    // 부서 정보를 가져옴
	    parentNode = jsEl2.jstree(true).get_node(node.parent);
	    empDept = parentNode ? parentNode.text : "";
 }
});
 
//검색 결과가 없을 때
$("#jstree3").on("search.jstree", function(e, data){
	console.log("검색");
	if(data.nodes.length === 0){
		$("#organizationChart").val("").focus();
		$("#organizationChart").attr("placeholder", "검색 결과가 없습니다.");
	}
});

$(function(){
    // model에 proxyInfo가 있으면
    let proxyInfoExists = "${not empty proxyInfo}" === "true";

    if(proxyInfoExists){
        // 스위치 켜기
        $("#delegateActiveSwitch").prop("checked", true);

        // 슬라이드로 보여주기
        $("#currentDelegateInfo").removeClass("d-none").hide().slideDown();
    }
	
	let loginEmpNo="<sec:authentication property='principal.member.empNo'/>"; // 로그인한 사용자
	
	// 모달이 완전히 닫힌 후 실행될 이벤트
	$("#jstreeModal").on("hidden.bs.modal", function(){
	    let jsTreeStatus3 = jsEl3.jstree(true);
	    
	    if(jsTreeStatus3){
	        jsEl3.jstree("close_all");
	    }
	    
	    // css 지우기
	    $(".jstree-anchor").removeClass("jstree-search");
	    $(".jstree-anchor").removeClass("jstree-clicked");
	    
	    // 폼 입력 필드 초기화
	    $("#organizationChart").val("");
	    $("#organizationChart").attr("placeholder", "문서명을 입력하세요.");
	});

	// 검색
	function lineSearch(){
		console.log("검색 실행");
	    let organizationChart = $("#organizationChart").val();
	    
	    jsEl3.jstree("search", organizationChart);
	    
	    console.log(organizationChart);
	}

	// 검색 버튼
	$("#organizationChartSch").on("click", function(){
		lineSearch();
	});

	// enter 키
	$("#organizationChart").on("keypress", function(e){
		if(e.which === 13){
			lineSearch();
		}
	});


	// 선택된 대결자를 input에 표시
	$("#selectApproverBtn").on("click", function() {
		if(!empNo){
        	noSeletedAlert();
            return;
        } else {
			let selectedName = empName + " (" + empDept + "/" + jbgdCd +")";
			$("#selectedApprover").val(selectedName);
        }
	    $("#jstreeModal").modal("hide"); // 모달 닫기
	});

	// 도장 업로드 클릭 시
	document.querySelector("#stampUploadBtn").addEventListener("click", function(){
		document.querySelector("#stampUpload").click();
	});
	
	// 도장 업로드 이미지 미리보기
	document.querySelector("#stampUpload").addEventListener("change", function(event){
		let file = event.target.files[0];
		
		if(file){
			let reader = new FileReader();
			reader.onload = function(e){
				let preview = document.querySelector("#stampPreview");
				preview.src = e.target.result;
				preview.style.display = "block";
			}
			reader.readAsDataURL(file);
		}
	});
	
	// 도장 업로드 저장
	document.querySelector("#saveStamp").addEventListener("click", function(){
		console.log("도장 업로드 저장");
		
		let stampUpload = document.querySelector("#stampUpload");
		let file = stampUpload.files[0];
		
		let formData = new FormData();
		formData.append("file", file);
		
		console.log("formData: ", formData);
		
		fetch("/eApproval/insertStamp", {
			method : "post",
			body : formData
		}).then((res) => {
			console.log("res: ", res);
			if(res.ok){
				console.log("도장 업로드 완료");
				Swal.fire({
					title : "도장 업로드 설정이 완료되었습니다.",
					icon : "success",
					confirmButtonText : "확인"
				});
			}else{
					Swal.fire({
					title : "도장 업로드 설정에 실패하였습니다.",
					icon : "error",
					confirmButtonText : "확인"
					});
			}
		})
	});
	
	// 도장 업로드 이미지 삭제
	document.querySelector("#delStamp").addEventListener("click", function(){
		fetch("/eApproval/delStamp", {
			method : "post"
		}).then((res) => {
			console.log("res:", res);
			if(res.ok){
				console.log("도장 이미지 삭제 완료");
				Swal.fire({
					title : "저장된 도장을 삭제하였습니다.",
					icon : "success",
					confirmButtonText : "확인"
				});
				document.querySelector("#stampPreview").style.display = "none";
			}else{
				Swal.fire({
					title : "저장된 도장 삭제에 실패하였습니다.",
					icon : "error",
					confirmButtonText : "확인"
					});
			}
		});
	});

	// 대결자 선택시 자동적으로 스위치 온
	function delegateActiveSwitchOn(startDate, endDate){
		let selectedName = empName + " (" + empDept + "/" + jbgdCd +")";
		$("#delegateName").text(selectedName);
		$("#delegatePeriodStart").text(startDate + "~");
		$("#delegatePeriodEnd").text(endDate);
		$("#emptyDelegatePeriodEnd").text("");
       	$("#delegateActiveSwitch").prop("checked", true); 
        $("#currentDelegateInfo").removeClass("d-none").hide().slideDown();
	};
	
	$("#delegateActiveSwitch").on("change", function() {
	    if ($(this).is(":checked")) {
	        $("#currentDelegateInfo").removeClass("d-none").hide().slideDown();
	    } else {
	        $("#currentDelegateInfo").slideUp(function() {
	            $(this).addClass("d-none");
	        });
	    }
	});

	// 대결자 저장
	$("#proxySave").on("click", function(){
		let startDateVal = $("#startDate").val().replaceAll("-","");
		let endDateVal = $("#endDate").val().replaceAll("-","");
		
		console.log("proxy 사번: ", empNo);
		console.log("시작 날짜: ", startDateVal);
		console.log("종료 날짜: ", endDateVal);
		
		if(loginEmpNo == empNo){
			equalsEmpErrorAlert();
			return;
		}
		
		if(!empNo){
			noSeletedAlert();
			return;
		}
		else if(!startDateVal){
			noSelectedDateAlert();
			return;
		}else if(!endDateVal){
			noSelectedDateAlert();
			return;
		}
		
		let data = {
			empNo : loginEmpNo,
			proxyEmpNo : empNo,
			beginYmd : startDateVal,
			endYmd : endDateVal
		};
		
		console.log("보내려는 data", data);
		
		$.ajax({
			url: "/eApproval/proxySave",
			type: "post",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			success: function(res){
				console.log(res);
				if(res.status == "SUCCESS"){
					console.log("대결자 등록 성공");
					proxyInsertAlert();
					delegateActiveSwitchOn(res.startDate, res.endDate);
					// proxySanctnerNo도 함께 업데이트
		            $("#currentDelegateInfo").data("proxy-sanctner-no", res.proxySanctnerNo);
				}else{
					proxyErrorAlert();
				}
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		});
		
	});
	
	// 대결자 삭제
	$("#proxyDelete").on("click", function(){
		console.log("대결자 삭제 버튼");
		
		if($("#emptyDelegatePeriodEnd").text().trim() == "-"){
			notSelectedProxyErrorAlert();
			return;
		}
		
		// 진짜 삭제할건지!!!
		Swal.fire({
			title: "정말로 삭제하시겠습니까?",
			icon:"warning",
			showCancelButton: true,
			confirmButtonText: "네",
			cancelButtonText: "취소"
		}).then((res) => {
	    	if(res.isConfirmed){
				let proxySanctnerNo = $("#currentDelegateInfo").data("proxy-sanctner-no");
				console.log("삭제하려는 data: ", proxySanctnerNo);
				
				$.ajax({
					url: "/eApproval/proxyDelete",
					type: "post",
					data: {proxySanctnerNo : proxySanctnerNo},
					success: function(res){
						if(res == "SUCCESS"){
							deleteSuccessAlert();
							$("#delegateName").text("지정된 대결자가 없습니다.");
							$("#delegatePeriodStart").text("");
							$("#delegatePeriodEnd").text("");
							$("#emptyDelegatePeriodEnd").text("-");
						}
					},
					error: function(error, status, thrown){
						console.log(error);
						console.log(status);
						console.log(thrown);
					}
				});
	    		
	    	}
	    });

		
	});
	
	
	///////////////////////////////////////////////
	// sweetAlert
	
	// 조직도 사원 안했을 때 erroralert
	function noSeletedAlert() {
	     Swal.fire({
	         title: `대결자를 선택해주세요.`,
	         html: `(팀/부서는 선택할 수 없습니다.)`,
	         icon: "error",
	         confirmButtonText: "확인",
	     });
	}
	
	// 대결자 등록 alert
	function proxyInsertAlert() {
	     Swal.fire({
	         title: `대결자가 설정되었습니다.`,
	         icon: "success",
	         confirmButtonText: "확인",
	     });
	}
	
	// 대결자 erroralert
	function proxyErrorAlert() {
	     Swal.fire({
	         title: `대결자 저장 실패하였습니다.`,
	         html: `기존 대결자 삭제 후 다시 진행해주세요.`,
	         icon: "error",
	         confirmButtonText: "확인",
	     });
	}
	
	// 대결자를 자기자신으로 선택했을 경우 erroralert
	function equalsEmpErrorAlert() {
	     Swal.fire({
	         title: `대결자 저장 실패하였습니다.`,
	         html: `본인을 대결자로 선택하실 수 없습니다.`,
	         icon: "error",
	         confirmButtonText: "확인",
	     });
	}
	
	// 대결자 삭제 성공 alert
	function deleteSuccessAlert() {
	     Swal.fire({
	         title: `대결자 삭제 완료되었습니다.`,
	         icon: "success",
	         confirmButtonText: "확인",
	     });
	}
	
	// 대결자 날짜 선택 erroralert
	function noSelectedDateAlert() {
	     Swal.fire({
	         title: `대결 일자를 선택해주세요.`,
	         icon: "error",
	         confirmButtonText: "확인",
	     });
	}
	
	// 삭제할 대결자 없을 때 erroralert
	function notSelectedProxyErrorAlert() {
	     Swal.fire({
	         title: `삭제할 대결자가 없습니다.`,
	         icon: "error",
	         confirmButtonText: "확인",
	     });
	}

});

</script>
<%@ include file="/module/footerPart.jsp"%>
</body>
</html>