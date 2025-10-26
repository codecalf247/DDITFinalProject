<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<style>
/* Custom CSS for a more prominent checkbox */
.visually-prominent-checkbox {
  width: 1rem; /* Make the checkbox larger */
  height: 1rem;
  
  /* Change the color to be more visible */
  background-color: #e9ecef; /* A light gray */
  border: 2px solid #6c757d; /* A darker border */
}

.visually-prominent-checkbox:checked {
  background-color: #0d6efd; /* Bootstrap's primary blue */
  border-color: #0d6efd;
}

/* 검색된 노드 색상 변경 */
/* jstree3 검색 강조 스타일 */
#jstree .jstree-search,
#jstree2 .jstree-search {
    color: #00AFF0 !important;   /* 글자색 하늘 파랑 */
    border-radius: 4px;          /* 살짝 둥글게 */
    font-weight: bold;           /* 강조 (옵션) */
}

/* jstree 앵커 글자 기본 기울임 없애기 */
#jstree .jstree-search,
#jstree2 .jstree-search {
    font-style: normal !important; /* 기울임 제거 */
}
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
	<div class="px-6 pt-4">
		<div class="card">
			<div class="card-header">
				<div class="d-flex align-items-center">
					<h6 class="card-title 1h-base">전자결재</h6>
					<div class="ms-auto">
						<div
							class="link d-flex btn-minimize px-2 text-white align-items-center">
							<button class="btn btn-sm btn-outline-primary" id="treeModalBtn">
								<i class="ti ti-file-plus fs-5"></i> 새 결재 작성
							</button>
						</div>
					</div>
				</div>
				<div class="row px-6">
					<sec:authorize access="isAuthenticated()">
						<sec:authentication property="principal.member.empNm"/>
						(<sec:authentication property="principal.member.deptNm"/>)
					</sec:authorize>
				</div>
			</div>
		</div>
	</div>
	<ul class="list-group list-group-menu mh-n100">
		<li class="border-bottom my-3"></li>
		<li class="list-group-item has-submenu"><a
			class="menu-link mb-2 d-block" href="#"> <i
				class="ti ti-file-invoice"></i> 결재 상신함 <i
				class="ti ti-chevron-right menu-toggle"></i>
		</a>
			<ul class="submenu" style="border-radius: 8px;">
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/pending">결재대기</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/inProcess">결재진행</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/completed">결재완료</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/draft">임시저장</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/rejectDocument">반려함</a></li>
			</ul></li>
		<li class="list-group-item has-submenu"><a
			class="menu-link mb-2 d-block" href="#"> <i
				class="ti ti-mail-opened"></i> 결재 수신함 <i
				class="ti ti-chevron-right menu-toggle"></i>
		</a>
			<ul class="submenu" style="border-radius: 8px;">
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/inbox">수신결재</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/history">결재내역</a></li>
				<li class="list-group-item"><a class="menu-link"
					href="${pageContext.request.contextPath}/eApproval/CCDocument">수신참조</a></li>
			</ul></li>
		<li class="list-group-item"><a class="menu-link"
			href="${pageContext.request.contextPath}/eApproval/trash"> <i
				class="ti ti-trash"></i> 휴지통
		</a></li>
		<li class="list-group-item"><a class="menu-link"
			href="${pageContext.request.contextPath}/eApproval/approvalFormFolder">
				<i class="ti ti-file-settings"></i> 전자결재 양식
		</a></li>
		<li class="list-group-item"><a class="menu-link"
			href="${pageContext.request.contextPath}/eApproval/approvalSetting">
				<i class="ti ti-file-settings"></i> 전자결재 환경설정
		</a></li>
	</ul>
</div>

<!-- 모달 설정 -->
<div class="modal fade" id="newApprovalModal" tabindex="-1"
	aria-labelledby="newApprovalModalLabel" aria-hidden="true"
	style="height:">
	<div class="modal-dialog modal-xl modal-dialog-centered">
		<div class="modal-content" style="height: 700px;">
			<div class="modal-header bg-light-info">
				<h5 class="modal-title" id="newApprovalModalLabel">결재정보</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body p-4">
				<ul class="nav nav-tabs nav-justified" id="myTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="document-info-tab"
							data-bs-toggle="tab" data-bs-target="#document-info"
							type="button" role="tab" aria-controls="document-info"
							aria-selected="true">
							<i class="ti ti-file-text fs-5"></i> 문서정보
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="approval-line-tab"
							data-bs-toggle="tab" data-bs-target="#approval-line"
							type="button" role="tab" aria-controls="approval-line"
							aria-selected="false">
							<i class="ti ti-users fs-5"></i> 결재선
						</button>
					</li>
				</ul>

				<div class="tab-content" id="myTabContent">
					<div class="tab-pane fade show active" id="document-info"
						role="tabpanel" aria-labelledby="document-info-tab">
						<div class="row pt-3 m-3"
							style="height: 450px; max-height: 450px; overflow: hidden;">
							<div class="col-md-4 border-end">
								<div class="d-flex align-items-center mb-3">
									<h6 class="fw-semibold mb-0">양식함</h6>
									<div class="btn-group ps-2 d-flex flex-grow-1">
										<input type="text" class="form-control form-control-sm me-2"
											id="docSchName" placeholder="문서명을 입력하세요." />
									</div>
									<button id="docSch" class="btn btn-outline-secondary btn-sm">검색</button>
								</div>
								<div id="jstree" style="height: 380px; overflow-y: scroll;"></div>
							</div>
							<div class="col-md-8">
								<div class="mb-3 row">
									<label for="documentForm" class="col-sm-3 col-form-label">양식문서
										<span class="text-danger">*</span>
									</label>
									<div class="col-sm-9">
										<input type="text" readonly class="form-control"
											id="documentForm" value="">
									</div>
								</div>
								<div class="mb-3 row">
									<label id="dummyTitle" for="documentTitle" class="col-sm-3 col-form-label">문서제목
										<span class="text-danger">*</span>
									</label>
									<div class="col-sm-9">
										<input type="text" required class="form-control"
											id="documentTitle" placeholder="문서제목을 입력해주세요.">
									</div>
								</div>
								<div class="mb-3 row">
									<label for="approvalType" class="col-sm-3 col-form-label">결재타입</label>
									<div class="col-sm-9">
										<select class="form-select" id="approvalType">
											<option selected>일반결재</option>
											<option>후결</option>
										</select>
									</div>
								</div>
								<div class="mb-3 row">
									<label for="urgentSetting" class="col-sm-3 col-form-label">긴급설정</label>
									<div class="col-sm-9">
										<div class="form-check form-switch mt-2">
											<input class="form-check-input" type="checkbox" role="switch"
												id="flexSwitchCheckDefault"> <label
												class="form-check-label" for="flexSwitchCheckDefault">긴급</label>
										</div>
									</div>
								</div>
								<div class="mb-3 row">
									<label for="documentDetails" class="col-sm-3 col-form-label">양식
										상세정보</label>
									<div class="col-sm-9">
										<textarea class="form-control" readonly id="documentDetails"
											rows="4"></textarea>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="tab-pane fade" id="approval-line" role="tabpanel"
						aria-labelledby="approval-line-tab">
						<div class="row">
							<div class="d-flex align-items-center mb-4 pt-4">
								<h6 class="fw-semibold mb-0">결재선 저장</h6>
								<div class="ms-3 flex-grow-1">
									<input type="text" class="form-control form-control-sm"
										id="saveLineName" placeholder="저장할 결재선 이름을 입력하세요." />
								</div>
								<button class="btn btn-primary btn-sm ms-2" id="saveLineBtn">저장</button>
								<div class="ms-2">
									<select class="form-select form-select-sm" id="savedLines">
										<option value="">--저장 결재선--</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row"
							style="height: 400px; max-height: 400px; overflow: hidden;">
							<div class="col-md-5 flex-column">
								<div class="d-flex align-items-center mb-3">
									<h6 class="fw-semibold mb-0">부서선택</h6>
									<div class="btn-group ps-2 d-flex flex-grow-1">
										<input type="text" class="form-control form-control-sm me-2"
											id="lineSchName" placeholder="사원/부서 검색하세요." />
									</div>
									<button id="lineSch" class="btn btn-outline-secondary btn-sm">검색</button>
								</div>
								<div id="jstree2" class="flex-grow-1"
									style="height: 360px; overflow-y: scroll;"></div>
							</div>

							<div class="col-md-1 text-center" style="align-content: center;">
								<button class="btn btn-sm btn-primary" id="approvalLineBtn">
									결재 <i class="bi bi-arrow-right fs-4"></i>
								</button>
								<button class="btn btn-sm btn-info" id="referenceLineBtn">
									참조 <i class="bi bi-arrow-right fs-4"></i>
								</button>
							</div>

							<div class="col-md-6 flex-column"
								style="height: 400px; overflow-y: scroll;">
								<div class="row d-flex">
									<div class="flex-grow-1">
										<div class="d-flex align-items-center mb-3">
											<h6 class="fw-semibold mb-0">결재선 선택</h6>
											<span class="text-danger ms-2">*</span>
											<div class="ms-auto">
												<button class="btn btn-outline-secondary btn-sm"
													id="resetApprovalLineBtn">
													<i class="ti ti-rotate-2 fs-5"></i> 초기화
												</button>
											</div>
										</div>
										<div class="table-responsive">
											<table class="table table-hover table-striped">
												<thead>
													<tr>
														<th>결재자</th>
														<th>직급</th>
														<th>부서</th>
														<th>전결권한</th>
														<th>대결자</th>
														<th>삭제</th>
													</tr>
												</thead>
												<tbody id="approvalLineTableBody">

												</tbody>
											</table>
										</div>

										<div class="col-md-5 d-flex align-items-center">
											<div
												class="d-flex justify-content-end align-items-center me-3 w-100">
												<h6 class="fw-semibold mb-0"></h6>
											</div>
										</div>
									</div>
								</div>

								<!-- 참조자 -->
								<div class="row">
									<div class="flex-grow-1">
										<div class="d-flex align-items-center mb-3">
											<h6 class="fw-semibold mb-0">참조선 선택</h6>
											<div class="ms-auto">
												<button class="btn btn-outline-secondary btn-sm"
													id="resetReferenceLineBtn">
													<i class="ti ti-rotate-2 fs-5"></i> 초기화
												</button>
											</div>
										</div>
										<div class="table-responsive">
											<table class="table table-hover table-striped">
												<thead>
													<tr>
														<th>이름</th>
														<th>직급</th>
														<th>부서</th>
														<th>삭제</th>
													</tr>
												</thead>
												<tbody id="referenceLineTableBody">

												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer"
				style="border-top: solid 0.6px rgb(0, 0, 0, 0.1);">
				<button type="button" id="submit" class="btn btn-primary">확인</button>
				<button type="button" id="cancel" data-bs-dismiss="modal"
					class="btn btn-light">취소</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
/////////////////////////////////////////////////////
// 양식 문서 tree
let jsEl = $("#jstree").jstree({
	// 검색 기능 활성화
     "plugins": ["search"],
     // tree에 보여줄 데이터
     "core": {
    	 // core.data에 함수 넣으면 자동으로 (obj, cb) 두개를 호출
    	 // obj: 현재 요청 중인 노드 정보, cb: 데이터를 반환하는 콜백
			"data": function (obj, cb) {
             $.ajax({
                 url: "/eApprovalTree/documentList",
                 type: "get",
                 success: function(res) {
                     console.log("결과 리스트", res);

                     res.forEach((node) => {
                         if(node.parent == "#"){
                             node.icon = "ti ti-folder";
                         } else {
                             node.icon = "ti ti-file-text";
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
 
let formNo="";
//node가 select 되었을 때
$("#jstree").on("select_node.jstree", function(e, data) {
	let node = data.node;
    console.log("select 했을 때", node);

    // 자식 node가 있으면 폴더라고 판단
    if (node.children.length > 0) {
        console.log("폴더:", node.text);
        return;
    }

    // 선택한 node formNo 저장
    formNo = node.id;
    console.log("선택한 양식번호: ", formNo);

    // 견적서 및 휴가 신청서 더미데이터
    if(formNo == "201"){ 
    	document.querySelector("#documentTitle").value = "삼성아파트 견적서 승인 요청";
    }else if(formNo == "102"){
    	document.querySelector("#documentTitle").value = "휴가 신청서(김지후)";
    }
    
    // 선택한 node 명 input에 표시
    $("#documentForm").val(node.text);

    // 선택한 nodeID 서버로 전송
    // 서버에서 제공한 문서 ID가 있으면 그걸, 없으면 jsTree 노드 ID 사용
    let docId = node.original.originalDoc || node.id;

    $.ajax({
    	url:"/eApprovalTree/documentDC",
    	type:"get",
    	data:{formNo: docId},
    	success:function(res){
    		$("#documentDetails").val(res);
    	},
		error : function(error, status, thrown){
			console.log(error);
			console.log(status);
			console.log(thrown);
		}
    });
});
 
// 검색 결과가 없을 때
$("#jstree").on("search.jstree", function(e, data){
	console.log("검색");
	if(data.nodes.length === 0){
		$("#docSchName").val("").focus();
		$("#docSchName").attr("placeholder", "검색 결과가 없습니다.");
	}
})

console.log("최초의 로딩된 js tree : "+ jsEl);

/////////////////////////////////////////////////////////////
// 결재선 tree
let jsEl2 = $("#jstree2").jstree({
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
                         if(node.text.includes("디자인") || node.text.includes("현장") || node.text.includes("회계/인사")){
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

console.log("최초의 로딩된 js tree2 : "+ jsEl2);


let empNo="", empName="", jbgdCd="", parentNode="", empDept="";

//node가 select 되었을 때
$("#jstree2").on("select_node.jstree", function(e, data) {
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
$("#jstree2").on("search.jstree", function(e, data){
	console.log("검색");
	if(data.nodes.length === 0){
		$("#lineSchName").val("").focus();
		$("#lineSchName").attr("placeholder", "검색 결과가 없습니다.");
	}
});

let reSanctnDocNo="";
$(function(){
	/////////////////////////////////////////////////////////////////////////////
	// 공통
	let loginEmpNo="<sec:authentication property='principal.member.empNo'/>"; // 로그인한 사용자
	
	let treeModalBtn = $("#treeModalBtn");				// 새 결재 작성 버튼
	let newApprovalModal = $("#newApprovalModal");		// 모달 Element
	
	saveLineList();
	
	// 새 결재 작성 버튼 클릭 이벤트
	$("#treeModalBtn").on("click", function(){
		jsEl.jstree("refresh");
		jsEl2.jstree("refresh");
		$("#documentTitle").html("");
		$("#newApprovalModal").modal("show");
	});
	
    // 모달 내, 취소 버튼 클릭 이벤트
    $("#cancel").on("click", function(){
        $("#newApprovalModal").modal("hide");
    });
   
    // 모달이 완전히 닫힌 후 실행될 이벤트
    $("#newApprovalModal").on("hidden.bs.modal", function(){
        let jsTreeStatus = jsEl.jstree(true);
        let jsTreeStatus2 = jsEl2.jstree(true);
        
        if(jsTreeStatus){
            jsEl.jstree("close_all");
        }
        if(jsTreeStatus2){
            jsEl2.jstree("close_all");
        }
        
        // css 지우기
        $(".jstree-anchor").removeClass("jstree-search");
        $(".jstree-anchor").removeClass("jstree-clicked");
        
        // 폼 입력 필드 초기화
        $("#docSchName").val("");
        $("#lineSchName").val("");
        $("#docSchName").attr("placeholder", "문서명을 입력하세요.");
        $("#lineSchName").attr("placeholder", "사원명을 입력하세요.");
        $("#documentForm").val("");
        $("#documentTitle").val("");
        $("#documentDetails").val("");
		
		$("#approvalLineTableBody tr").text("");        
		$("#referenceLineTableBody tr").text("");        

        // 문서정보 탭 활성화
        $("#document-info-tab").tab("show");

    });
	
	// 결재문서 insert
	let sanctnDocNo="";
	function sanctnDocInsert(){
		let sanctnTitle = $("#documentTitle").val();
		let sanctnTy = $("#approvalType option:selected").val();
		let emrgncyYn = $("#flexSwitchCheckDefault").is(":checked") ? "Y" : "N";;
		
		if(sanctnTy == "일반결재"){
			sanctnTy = "06001";
		}else{
			sanctnTy = "06002";
		}
		
		if(formNo == null || formNo == ""){
			formNo = document.querySelector("#documentForm").dataset.formNo;
		}
		
		let data = {
			formNo : formNo, // 문서양식번호
			empNo : loginEmpNo,	// 기안자사번
			sanctnTitle : sanctnTitle, // 결재제목
			sanctnTy : sanctnTy, // 결재유형
			emrgncyYn : emrgncyYn // 긴급여부
		};
		
		console.log("선택한 data", data);
		
		$.ajax({
			url: "/eApproval/sanctnDoc",
			type: "post",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			success: function(res){
				if(res != null){
					console.log("문서정보 insert 성공: ", res);
					sanctnDocNo = res;
					console.log("문서정보 번호", sanctnDocNo);
					
					// 결재선, 참조선 insert
					sanctnerInsert();
					sanctnCCInsert();
					
					setTimeout(function(){
						// 그리고 페이지 이동
						if(reSanctnDocNo != ""){
							location.href = "${pageContext.request.contextPath}/eApproval/reRegister/" + reSanctnDocNo + "?sanctnDocNo=" + sanctnDocNo; 
						}else{
							location.href = "${pageContext.request.contextPath}/eApproval/register/" + sanctnDocNo; 
						}
					}, 1000);
					
				}
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		});
	}
	
	// 결재자 insert
	function sanctnerInsert(){
		let approvalList = [];
		let alreadyChecked = false;
		
		$("#approvalLineTableBody tr").each(function(i){
			let approvalEmpNo = $(this).attr("data-emp-no"); 
			let proxyEmpNo = $(this).attr("data-proxy-emp-no") || null; 
			let proxyJbgdCd = $(this).attr("data-proxy-jbgd-cd") || null; 
	        let dcrbAuthYn = $(this).find("input[name='finalApproval']:checked").length > 0 ? "Y" : "N";
			let jbgdCd = $(this).find("td:eq(1)").text().trim();
			
			let data = {
				sanctnDocNo : sanctnDocNo, // 결재문서번호
				empNo : approvalEmpNo,	// 결재자사번
				lastSanctner : proxyEmpNo ? proxyEmpNo : approvalEmpNo, // 최종결재자사번
				lastSanctnerJbgd : proxyJbgdCd ? proxyJbgdCd : jbgdCd, // 최종결재자직급
				sanctnOrdr : i + 1, // 결재순번
				dcrbAuthYn : dcrbAuthYn // 전결권한여부		
			};
			
			console.log("결재선 data:", data);
			
			approvalList.push(data);
		});
		
		console.log("전체결재선 data:", approvalList);
		
		$.ajax({
			url: "/eApproval/sanctner",
			type: "post",
			data: JSON.stringify(approvalList),
			contentType: "application/json; charset=utf-8",
			success: function(res){
				if(res == "SUCCESS"){
					console.log("결재자 insert 성공");
				}
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		});
		
	}
	
	// 참조자 insert
	function sanctnCCInsert(){
		let sanctnCCList = [];
		
		$("#referenceLineTableBody tr").each(function(){
			let sanctnCCEmpNo = $(this).attr("data-emp-no");
			
			let data = {
				sanctnDocNo : sanctnDocNo,
				empNo : sanctnCCEmpNo
			};
			
			sanctnCCList.push(data);
			
		});
		
		console.log("참조자 data: ", sanctnCCList);
		
		$.ajax({
			url: "/eApproval/sanctnCC",
			type: "post",
			data: JSON.stringify(sanctnCCList),
			contentType: "application/json; charset=UTF-8",
			success: function(res){
				if(res == "SUCCESS"){
					console.log("참조자 insert 성공");
				}
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		})
	}
	
	// 확인 버튼
	$("#submit").on("click", function(){
		console.log("확인 버튼");
		
		// 유효성 검사
		let docType = $("#documentForm").val();
		if(docType == null || docType == ""){
			typeErrorAlert();
			$("#documentTitle").focus();
			return;
		}
		
		let title = $("#documentTitle").val();
		if(title == null || title == ""){
			titleErrorAlert();
			$("#documentTitle").focus();
			return;
		}
		
		let approvalLineTableBody = $("#approvalLineTableBody td").text();
		console.log(approvalLineTableBody);
		if(approvalLineTableBody == null || approvalLineTableBody == ""){
			approvalLineTableBodyAlert();
			return;
		}
		
		// 이제 확인 버튼 누르면 문서 정보 insert, 끝나면 결재선까지 insert
		sanctnDocInsert();
	});
	
	
	////////////////////////////////////////////////////
	// 문서정보
	
	// 검색
	function docSearch(){
		console.log("검색 실행");
	    let docSchName = $("#docSchName").val();
	    
	    jsEl.jstree("search", docSchName);
	    
	    console.log(docSchName);
	}
	
	// 검색 버튼
	$("#docSch").on("click",function(){
		docSearch();
	});
	
	// enter 키
	$("#docSchName").on("keypress", function(e){
		if(e.which === 13){
			docSearch();
		}
	});
	
	////////////////////////////////////////////////////
	// 결재선
	// 검색
	function lineSearch(){
		console.log("검색 실행");
	    let lineSchName = $("#lineSchName").val();
	    
	    jsEl2.jstree("search", lineSchName);
	    
	    console.log(lineSchName);
	}
	
	// 검색 버튼
	$("#lineSch").on("click",function(){
		lineSearch();
	});
	
	// enter 키
	$("#lineSchName").on("keypress", function(e){
		if(e.which === 13){
			lineSearch();
		}
	});
	
	// 결재선 휴지통 아이콘 클릭 시
	$("#approvalLineTableBody").on("click", ".delete-line", function(){
		// 클릭된 아이콘의 가장 가까운 부모 <tr>를 찾아서 삭제
		$(this).closest("tr").remove();
	});
	
	// 결재선 초기화 선택시
	$("#resetApprovalLineBtn").on("click", function(){
		$("#approvalLineTableBody tr").text("");
	});
	
	// 참조선 휴지통 아이콘 클릭 시
	$("#referenceLineTableBody").on("click", ".delete-line", function(){
		// 클릭된 아이콘의 가장 가까운 부모 <tr>를 찾아서 삭제
		$(this).closest("tr").remove();
	});
	
	// 참조선 초기화 선택시
	$("#resetReferenceLineBtn").on("click", function(){
		$("#referenceLineTableBody tr").text("");
	});
    
	// 사원이 이미 선택되어있는지 확인하는 함수
    function alreadyEmp(table, empName, jbgdCd, empDept){
    	let returnVal = false;  
    	
    	$(table).find("tr").each(function(){
    		 let name = $(this).find("td:eq(0)").text().trim();
    		 let position = $(this).find("td:eq(1)").text().trim();
    		 let dept = $(this).find("td:eq(2)").text().trim();
    		 
	    	if(empName === name && empDept === dept){
	    		returnVal = true;
	    		return returnVal;
	    	}
    	});
    	
    	return returnVal;
    }
	
    // 결재선 추가
    $("#approvalLineBtn").on("click", function(){
    	// 사원 선택했는지 확인
    	if(!empName){
    		approvalLineErrorAlert();
    		return;
    	}
    	
		if(loginEmpNo == empNo){
			equalsEmpErrorAlert();
			return;
		}
    	
    	// 이미 결재선에 선택되어있는 사원인지 확인
    	let approvalReturnVal = alreadyEmp("#approvalLineTableBody", empName, jbgdCd, empDept);
    	// 참조선에 선택되어있는 사원인지 확인
    	let referenceReturnVal = alreadyEmp("#referenceLineTableBody", empName, jbgdCd, empDept);
    	
    	if(approvalReturnVal == true || referenceReturnVal == true){
	    	alreadyEmpErrorAlert();
	    	return;
    	}
    	
    	// 결재자가 대결자를 설정해놓고 대결자 설정 종료기간이 지나지 않았더라면 대결자 이름이 떠야됨 
    	// 그럼 종료일자가 오늘 날짜보다 큰 날짜의 대결자리스트를 뽑아와서
    	// 클릭하는 사원(결재자)이 대결자리스트에 있다면
    	// 결재버튼 클릭시 대결자 이름 추가되기?
    	
    	$.ajax({
    		url: "/eApproval/proxyInfo",
    		type: "get",
    		data: {empNo: empNo},
    		success: function(res){
    			let newRow="";
    			if(res){
	    			console.log("대결자 출력하자!!!", res);
	    			let proxyNm = res.proxyNm;
	    			let proxyJbgdCd = res.jbgdCd;
	    			let proxyEmpNo = res.proxyEmpNo;
				    // 불러온 정보 행 추가
				    newRow = `
				        <tr data-emp-no="\${empNo}"
				        	data-proxy-emp-no="\${proxyEmpNo}"
				        	data-proxy-jbgd-cd="\${proxyJbgdCd}">
				            <td>\${empName}</td>
				            <td>\${jbgdCd}</td>
				            <td>\${empDept}</td>
				            <td>
								<input type="radio" class="form-check-input visually-prominent-checkbox" name="finalApproval">
							</td>
							<td>\${proxyNm}</td>
				            <td>
				           		 <i class="ti ti-trash fs-4 text-danger delete-line"></i>
				        	</td>
				        </tr>
				    `;
    			}else{
    				console.log("대결자 없음");
				    newRow = `
				        <tr data-emp-no="\${empNo}">
				            <td>\${empName}</td>
				            <td>\${jbgdCd}</td>
				            <td>\${empDept}</td>
				            <td>
								<input type="radio" class="form-check-input visually-prominent-checkbox" name="finalApproval">
							</td>
							<td>-</td>
				            <td>
				           		 <i class="ti ti-trash fs-4 text-danger delete-line"></i>
				        	</td>
				        </tr>
				    `;
    			}
			    
			    // 생성된 행을 결재선 본문(tbody)에 추가
			    $("#approvalLineTableBody").append(newRow);
				newRow = "";
    		},
    		error: function(error, status, thrown){
    			console.log(error);
    			console.log(status);
    			console.log(thrown);
    		}
    	});
    	
    	
  	});
    
    // 참조자 추가
    $("#referenceLineBtn").on("click", function(){
    	// 사원 선택했는지 확인
    	if(!empName){
    		referenceLineErrorAlert();
    		return;
    	}
    	
		if(loginEmpNo == empNo){
			equalsEmpErrorAlert();
			return;
		}
    	
    	// 결재선에 선택되어있는 사원인지 확인
    	let approvalReturnVal = alreadyEmp("#approvalLineTableBody", empName, jbgdCd, empDept);
    	// 이미 참조선에 선택되어있는 사원인지 확인
    	let referenceReturnVal = alreadyEmp("#referenceLineTableBody", empName, jbgdCd, empDept);
    	
    	if(approvalReturnVal == true || referenceReturnVal == true){
	    	alreadyEmpErrorAlert();
	    	return;
    	}
    	
	    // 불러온 정보 행 추가
	    let newRow = `
	    	<tr data-emp-no="\${empNo}">
	            <td>\${empName}</td>
	            <td>\${jbgdCd}</td>
	            <td>\${empDept}</td>
	            <td>
	           		 <i class="ti ti-trash fs-4 text-danger delete-line"></i>
	        	</td>
	        </tr>
	    `;
	    
	    // 생성된 행을 참조자 본문(tbody)에 추가
    	$("#referenceLineTableBody").append(newRow);
    	newRow = "";
    });
	
    function saveLineList(){
    	$.ajax({
    		url: `/eApproval/saveLineList?empNo=\${loginEmpNo}`,
    		type: "get",
    		success: function(res){
    			console.log("결재선 List:", res);
    			res.forEach(line => {
// 	    			console.log("line: ", line);
    			    $("#savedLines").append(
    			            `<option value="\${line.bkmkNo}">\${line.bkmkNm}</option>`
    			    );
    			});
    		},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
    	});
    }
    
	// 결재선 저장
	$("#saveLineBtn").on("click", function(){
		let saveLineName = $("#saveLineName").val(); // 결재선 저장명
		let empNoList = []; // 사번 리스트
		
		// 유효성 검사
		if(!empName){
			approvalLineErrorAlert();
			return;
		}
		
		if(saveLineName == null || saveLineName == ""){
			noSaveLineNameAlert();
			return;
		}
		
    	$("#approvalLineTableBody").find("tr").each(function(){
			// data-emp-no 속성에서 사번을 가져와 리스트에 추가
			empNoList.push($(this).data("emp-no"));
    	});
    	
		let data = {
			empNo: loginEmpNo,
			bkmkNm: saveLineName,
			empNoList: empNoList
		}
		
		console.log("전송할 데이터 확인: ", data);
		
		$.ajax({
			url: "/eApproval/saveLine",
			type: "post",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8", 
			success: function(res){
				if(res == "SUCCESS"){
					saveLineSuccessAlert();
					// 성공 이후 저장 결재선 바로 보여주기 위한 함수
					saveLineList();
				}else{
					saveLineErrorAlert();
				}
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		});
		
	});
	
    // 저장된 결재선 선택시
    $("#savedLines").on("change", function() {
        let saveLineSelect = $(this).val();
        console.log(saveLineSelect);
        
        $("#approvalLineTableBody").text("");
        $("#referenceLineTableBody").text("");
        
        $.ajax({
        	url: `/eApproval/saveLineEmp?saveLineSelect=\${saveLineSelect}`,
        	type: "get",
        	success: function(res){
        		console.log(res);
        		res.forEach(lineListEmp=>{
        			let proxyEmpNm = lineListEmp.proxyEmpNm || "-";
        			console.log(proxyEmpNm);
	        		$("#approvalLineTableBody").append(
	        			`<tr data-emp-no="\${lineListEmp.empNo}">
	        	            <td>\${lineListEmp.empNm}</td>
	        	            <td>\${lineListEmp.jbgdNm}</td>
	        	            <td>\${lineListEmp.deptNm}</td>
							<td>
								<input type="radio" class="form-check-input visually-prominent-checkbox" name="finalApproval">
							</td>
							<td>\${proxyEmpNm}</td>
	        	            <td>
	        	           		 <i class="ti ti-trash fs-4 text-danger delete-line"></i>
	        	        	</td>
	        	        </tr>`
        			);
        		});
        		
        		// 시연을 위한 하드코딩
        	    let newRow = `
        	    	<tr data-emp-no=202508009>
        	            <td>김진영</td>
        	            <td>주임</td>
        	            <td>회계/인사 1팀</td>
        	            <td>
        	           		 <i class="ti ti-trash fs-4 text-danger delete-line"></i>
        	        	</td>
        	        </tr>
        	    `;
        	    
        	    // 생성된 행을 참조자 본문(tbody)에 추가
            	$("#referenceLineTableBody").append(newRow);
        	},			
        	error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
        });
        
        
    });
    
	
});

/////////////////////////////////////////////////////////////// 
// sweetalert 

// 양식 문서 erroralert
function typeErrorAlert() {
     Swal.fire({
         title: `양식문서를 선택해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 문서 제목 erroralert
function titleErrorAlert() {
     Swal.fire({
         title: `문서 제목을 입력해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선 erroralert
function approvalLineTableBodyAlert() {
     Swal.fire({
         title: `결재선을 선택해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선 아무도 선택하지 않았는데 결재 버튼 클릭시 erroralert
function approvalLineErrorAlert() {
     Swal.fire({
         title: `결재자를 선택해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선 아무도 선택하지 않았는데 참조 버튼 클릭시 erroralert
function referenceLineErrorAlert() {
     Swal.fire({
         title: `참조자를 선택해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 이미 선택되어 있는 사원 클릭 erroralert
function alreadyEmpErrorAlert() {
     Swal.fire({
         title: `이미 선택되어 있는 사원입니다.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선 저장 성공 alert
function saveLineSuccessAlert() {
     Swal.fire({
         title: `결재선 저장이 완료되었습니다.`,
         icon: "success",
         confirmButtonText: "확인"
     });
	}

// 결재선 저장 실패 erroralert
function saveLineErrorAlert() {
     Swal.fire({
         title: `결재선 저장에 실패하였습니다.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선 저장명 없을 때 erroralert
function noSaveLineNameAlert() {
     Swal.fire({
         title: `결재선 저장명을 입력해주세요.`,
         icon: "error",
         confirmButtonText: "확인"
     });
	}

// 결재선을 자기자신으로 선택했을 경우 erroralert
function equalsEmpErrorAlert() {
     Swal.fire({
         title: `본인을 선택할 수 없습니다.`,
         icon: "error",
         confirmButtonText: "확인"
     });
}

</script>
