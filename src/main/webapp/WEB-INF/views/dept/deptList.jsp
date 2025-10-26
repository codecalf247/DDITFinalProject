<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">

<head>
<!-- Required meta tags -->
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>
<%@ include file="/module/headPart.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
body {
	padding-top: 4rem; /* header 높이 정도 확보 */
}

h4.fw-semibold {
	margin-bottom: 2rem; /* 원하는 값으로 */
}

.body-wrapper .container-fluid {
	padding-top: 3rem; /* 기존 1rem에서 더 내려서 상단 공간 확보 */
}

.table-hover tbody tr:hover {
	background-color: #f5f9fc;
	cursor: pointer;
}

.department-card {
	transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
	cursor: pointer;
	border: 1px solid transparent;
}

.department-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
}

.department-card.active {
	border: 1px solid #0d6efd;
	background-color: #eaf3ff;
	box-shadow: 0 4px 15px rgba(13, 110, 253, 0.25) !important;
	transform: translateY(0);
}

.employee-list-section {
	display: none; /* 초기에는 직원 목록을 숨김 */
}

.sub-dept {
	cursor: pointer;
	transition: background-color 0.2s;
}

.sub-dept:hover {
	background-color: #f5f9fc;
	color: black;
}
</style>
</head>
<%@ include file="/module/header.jsp"%>
<body>
	<%@ include file="/module/aside.jsp"%>

	<div class="body-wrapper">
		<div class="container-fluid">

			<div
				class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
				<div class="card-body px-4 py-3">
					<div class="row align-items-center">
						<div class="col-9">
							<h4 class="fw-semibold mb-8">부서 관리</h4>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a
										class="text-muted text-decoration-none"
										href="${pageContext.request.contextPath }/dept/deptList">Department</a>
									</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
			</div>

			<div class="card">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<h5 class="mb-0">부서 목록</h5>
					<button class="btn btn-primary" data-bs-toggle="modal"
						data-bs-target="#addDeptModal">
						<i class="ti ti-plus me-1"></i> 새 부서 등록
					</button>
				</div>
				<div>
					<h6 class="ms-5 text-muted">- 팀별 목록을 보려면 팀이름을 클릭하세요.</h6>
				</div>
				<div class="card-body">
					<c:set value="0" var="deptNo" />
					<div
						class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mb-4 deptArea">
						<c:forEach items="${deptList}" var="dept">
							<c:if test="${dept.deptNm ne '대표' }">
								<div class="col">
									<div class="card h-100 shadow-sm department-card">
										<div class="card-body">
											<!-- 상위 부서 -->
											<div class="d-flex justify-content-between align-items-center addBtn">
												<h5 class="card-title text-primary mb-0" data-upper-dept-no="${dept.deptNo}">
													${dept.deptNm}
												</h5>
												<div class="btn-group">
													<button type="button" class="btn btn-sm btn-outline-primary upperDeptEdit">수정</button>
													<button type="button" class="btn btn-sm btn-outline-danger upperDeptDel">삭제</button>
												</div>
											</div>
											<p class="card-text text-muted">
												<c:if test="${dept.deptNo ne 1 }">
													<c:forEach items="${upperDeptList }" var="upper">
														<c:if test="${upper.upperDeptNo eq dept.deptNo }">
																직원 수: ${upper.deptEmpCnt}명
															</c:if>
													</c:forEach>
												</c:if>
											</p>
											<ul class="list-group list-group-flush mt-3">
												<c:forEach items="${deptSubList}" var="deptSub">
													<c:if test="${dept.deptNo == deptSub.upperDeptNo}">
														<li
															class="list-group-item d-flex justify-content-between align-items-center py-2 px-3 sub-dept"
															data-dept-no="${deptSub.deptNo}">
															<div class="subDept" data-dept-no="${deptSub.deptNo}">
																<i class="ti ti-chevron-right me-2 text-muted"></i>
																${deptSub.deptNm}
															</div>
															<div class="btn-group btn-group-sm">
																<button class="btn btn-light border editBtn" title="수정">
																	<i class="ti ti-pencil"></i>
																</button>
																<button
																	class="btn btn-light border text-danger deleteBtn"
																	title="삭제">
																	<i class="ti ti-trash"></i>
																</button>
															</div>
														</li>
													</c:if>
												</c:forEach>
											</ul>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>


					<div id="empListContainer" class="employee-list-section">
						<h5 class="mb-3" id="employeeListTitle">직원 목록</h5>
						<div class="table-responsive text-center">
							<table class="table table-hover mb-0">
								<thead>
									<tr>
										<th class="p-4">부서</th>
										<th class="p-4">직급</th>
										<th class="p-4">이름</th>
										<th class="p-4">사번</th>
										<th class="p-4">부서이동</th>
									</tr>
								</thead>
								<tbody id="employeeTableBody">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="addDeptModal" tabindex="-1"
		aria-labelledby="addDeptModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md modal-dialog-centered">
			<!-- 크기 조정 + 중앙 정렬 -->
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="addDeptModalLabel">부서 선택</h5>
					<button type="button" class="btn-close" id="jstreeCloseBtn"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="d-flex align-items-center mt-2 px-3">
					<h6 class="fw-semibold ms-2 mb-0">부서명</h6>
					<div class="btn-group ps-2 flex-grow-1">
						<input type="text" class="form-control form-control-sm me-2"
							id="deptEmpSchName" placeholder="부서명을 입력하세요." />
					</div>
					<button id="deptEmpSch"
						class="btn btn-outline-secondary btn-sm me-2"
						style="display: none">검색</button>
					<button id="addBtn" class="btn btn-outline-primary btn-sm me-2">등록</button>
				</div>
				<div class="fw-semibold ms-4 mb-0 text-muted fs-2">- 하위 부서 등록시
					상위부서 선택 후 등록가능</div>
				<div class="modal-body">
					<!-- jstree 영역 -->
					<div id="deptJstree"></div>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="moveEmployeeModal" tabindex="-1"
		aria-labelledby="moveEmployeeModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="moveEmployeeModalLabel">직원 부서 이동</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="moveEmployeeForm">
						<input type="hidden" id="employeeIdToMove" name="empNo">
						<div class="mb-3">
							<label for="currentDept" class="form-label">현재 부서</label> <input
								type="text" class="form-control" id="currentDept" readonly>
						</div>
						<div class="mb-3">
							<label for="newDept" class="form-label">이동할 부서</label> <select
								class="form-select" id="newDept" name="newDeptNo" required>
								<option value="">부서 선택</option>
								<c:forEach items="${deptSubList }" var="dept">
									<option value="${dept.deptNo }">${dept.deptNm }</option>
								</c:forEach>
							</select>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="moveEmpBtn">이동</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
/////////////////////////////////////////////////////////////
//부서 tree
let deptJstree = $("#deptJstree").jstree({
	//검색 기능 활성화
	"plugins": ["search"],
	//tree에 보여줄 데이터
	"core": {
		 // core.data에 함수 넣으면 자동으로 (obj, cb) 두개를 호출
		 // obj: 현재 요청 중인 노드 정보, cb: 데이터를 반환하는 콜백
			"data": function (obj, cb) {
	     $.ajax({
	         url: "/dept/upperDeptTreeList",
	         type: "get",
	         success: function(res) {
	             console.log("결과 리스트", res);
	
	             res.forEach((node) => {
	                 if(node.parent == "#"){
	                     node.icon = "ti ti-users";
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

let deptNo, upperDeptNo = "";
//node가 select 되었을 때
$("#deptJstree").on("select_node.jstree", function(e, data) {
	let node = data.node;
	console.log("select 했을 때", node);
	
	// 자식 node가 있으면 부서라고 판단
	if(node.children.length > 0) {
	   // 선택한 부서 가져오기
	   deptNo = node.original.id;
	   upperDeptNo = node.original.parent;
	   
	   console.log("선택한 부서(부모):", deptNo, upperDeptNo);
	}else{
	   deptNo = node.original.id;
	   upperDeptNo = node.original.parent;
	   
	   console.log("선택한 부서(자식):", deptNo, upperDeptNo);
	}
	
	
	
});

//검색 결과가 없을 때
$("#deptJstree").on("search.jstree", function(e, data){
	console.log("검색");
	if(data.nodes.length === 0){
		$("#empSchName").val("").focus();
		$("#empSchName").attr("placeholder", "검색 결과가 없습니다.");
	}
});

/////////////////////////////////////////////////////////////////////////
document.addEventListener("DOMContentLoaded", () => {
	let empNo = "";
	
	// 새 모달 열기
	let modal = new bootstrap.Modal(document.querySelector("#moveEmployeeModal"));
	let treeModal = new bootstrap.Modal(document.querySelector("#addDeptModal"));
	
	// 팀 이름 선택시 팀 목록 보여주기
	document.querySelectorAll(".card-title").forEach(el => {
		el.addEventListener("click", function(){
			let upperDeptNo = el.dataset.upperDeptNo;
			console.log("upperDeptNo: ", upperDeptNo);
			
			// 팀 목록 가져오기
			axios.get("/dept/deptEmpList", {
				params : {
					upperDeptNo : upperDeptNo
				}
			}).then((res) => {
				console.log("res:", res);
				
				if(res.status == 200){
					console.log("팀 목록 가져오기 성공");
					
					document.querySelector("#employeeTableBody").innerHTML = "";
					
					// empList style 보이게 설정 후, 팀별 사원 목록 출력
					document.querySelector(".employee-list-section").style.display = "block";
					res.data.forEach(el => {
						document.querySelector("#employeeTableBody").innerHTML += `
							<tr>
								<td>\${el.deptNm}</td>
								<td>\${el.jbgdCd}</td>
								<td>\${el.empNm}</td>
								<td>\${el.empNo}</td>
								<td><i class="ti ti-arrow-bar-right" data-dept-Nm="\${el.deptNm}"
										data-emp-no="\${el.empNo}"></i></td>
							</tr>
						`;
					});
					
					// modal 안에 현재 부서 넣어놓기
					document.querySelectorAll(".ti-arrow-bar-right").forEach(el => {
						el.addEventListener("click", function(){
							let deptNm = el.dataset.deptNm;
							empNo = el.dataset.empNo;
							console.log("deptNm, empNo: ", deptNm, empNo);
							document.querySelector("#currentDept").value = deptNm;
							modal.show();
						});
					});
					
				}
				
			});
			
		});
	});
	
	// 하위 팀 목록 보여주기
	document.querySelectorAll(".subDept").forEach(el => {
		el.addEventListener("click", function(){
			let deptNo = el.dataset.deptNo;
			console.log("deptNo: ", deptNo);
			
			// 팀 목록 가져오기
			axios.get("/dept/deptTeamEmpList", {
				params : {
					deptNo : deptNo
				}
			}).then((res) => {
				console.log("res:", res);
				
				if(res.status == 200){
					console.log("팀 목록 가져오기 성공");
					
					document.querySelector("#employeeTableBody").innerHTML = "";
					
					// empList style 보이게 설정 후, 팀별 사원 목록 출력
					document.querySelector(".employee-list-section").style.display = "block";
					res.data.forEach(el => {
						document.querySelector("#employeeTableBody").innerHTML += `
							<tr>
								<td>\${el.deptNm}</td>
								<td>\${el.jbgdCd}</td>
								<td>\${el.empNm}</td>
								<td>\${el.empNo}</td>
								<td><i class="ti ti-arrow-bar-right" data-dept-Nm="\${el.deptNm}"
										data-emp-no="\${el.empNo}"></i></td>
							</tr>
						`;
					});
					
					// modal 안에 현재 부서 넣어놓기
					document.querySelectorAll(".ti-arrow-bar-right").forEach(el => {
						el.addEventListener("click", function(){
							let deptNm = el.dataset.deptNm;
							empNo = el.dataset.empNo;
							console.log("deptNm, empNo: ", deptNm, empNo);
							document.querySelector("#currentDept").value = deptNm;
							modal.show();
						});
					});
					
				}
				
			});
			
		});
	});
	
	// 부서 이동
	document.querySelector("#moveEmpBtn").addEventListener("click", function(){
		let selDeptNo = document.querySelector("#newDept").value;
		console.log("selDeptNo: ", selDeptNo);
		
		axios.post("/dept/empDeptMove", {
			empNo : empNo,
			deptNo : selDeptNo
		}).then((res) => {
			console.log("부서이동 res: ", res);
			
			if(res.status == 200){
				console.log("부서이동 성공");
				Swal.fire({
					title : "부서이동이 완료 되었습니다.",
					icon : "success",
					confirmButtonText : "확인"
				}).then((res) => {
					if(res.isConfirmed){
						modal.hide();
						document.querySelector(".employee-list-section").style.display = "none";
					}
				})
			}
		})
		
	});
	
	// 상위 부서 수정
	document.querySelectorAll(".upperDeptEdit").forEach(upperEditBtn => {
		upperEditBtn.addEventListener("click", function(event){
			event.stopPropagation();
			console.log("상위 부서 수정 버튼");
			
			// 가장 가까운 부서명
	        let cardBody = upperEditBtn.closest(".card-body");
			let h5 = cardBody.querySelector("h5.card-title");
			// 저장할 부서명
	        let deptUpperName = h5.innerText.trim();
	        console.log("deptUpperName:", deptUpperName);
			
	        // 기존 수정/삭제 버튼 숨기기
	        let btnGroup = cardBody.querySelector(".btn-group");
	        btnGroup.style.display = "none";
	        
	        h5.innerHTML = `
	            <input type="text" class="form-control form-control-sm edit-input me-2" value="\${deptUpperName}">
	            <button class="btn btn-primary btn-sm saveBtn">저장</button>
	            <button class="btn btn-secondary btn-sm cancelBtn ms-1">취소</button>
	        `;
	        
	        cardBody.querySelector(".edit-input").addEventListener("click", function(event){
	        	event.stopPropagation();
	        });
	        
	        // 상위 부서명 수정 저장
	        cardBody.querySelector(".saveBtn").addEventListener("click", function(event){
	        	event.stopPropagation();
	        	console.log("저장버튼");
				let upperMdfDeptNm = cardBody.querySelector(".edit-input").value;
				let upperMdfDeptNo = h5.dataset.upperDeptNo;
				console.log("upperMdfDeptNm, upperMdfDeptNo: ", upperMdfDeptNm, upperMdfDeptNo);
				
				axios.post("/dept/mdfDept", {
					deptNo : upperMdfDeptNo,
					deptNm : upperMdfDeptNm
				}).then((res) => {
					console.log("uppermdfDept res: ", res);
					
					if(res.status == 200){
						Swal.fire({
							title : "부서명 수정이 완료되었습니다.",
							icon : "success",
							confirmButtonText : "확인"
						}).then((res) => {
							if(res.isConfirmed){
								location.href = location.href;
							}
						})
					}
				});
	        });
	        
	        // 하위 부서명 수정 취소
	        cardBody.querySelector(".cancelBtn").addEventListener("click", function(event){
	        	console.log("취소버튼 클릭");
	        	event.stopPropagation();
	        	location.href = location.href;
	        });
		});
	});
	
	// 상위 부서 삭제
	document.querySelectorAll(".upperDeptDel").forEach(upperDeptDel => {
		upperDeptDel.addEventListener("click", function(){
			
			// 가장 가까운 부서명
	        let cardBody = upperDeptDel.closest(".card-body");
			let h5 = cardBody.querySelector("h5.card-title");
			let upperDeptNo = h5.dataset.upperDeptNo;
			console.log("상위 부서 삭제 버튼, upperDeptNo:", upperDeptNo);
			
			Swal.fire({
				title : "부서를 삭제하시겠습니까?",
				html : "상위 부서 삭제시 하위 부서도 삭제됩니다.",
				icon : "warning",
		        showCancelButton: true,
		        confirmButtonText: "네",
		        cancelButtonText: "취소"
			}).then((res) => {
				if(res.isConfirmed){
					axios.post("/dept/delDept", {
						upperDeptNo : upperDeptNo
					}).then((res) => {
						console.log("delDeptNo res: ", res);
						
						if(res.status == 200){
							Swal.fire({
								title : "부서명 삭제가 완료되었습니다.",
								icon : "success",
								confirmButtonText : "확인"
							}).then((res) => {
								if(res.isConfirmed){
									location.href = location.href;
								}
							})
						}
					});
				}
			});
		});

	});
	
	
	// 하위 부서 수정
	document.querySelectorAll(".editBtn").forEach(editBtn => {
		editBtn.addEventListener("click", function(){
			console.log("하위 부서 수정 버튼");
			
			// 가장 가까운 부서명
	        let li = editBtn.closest(".sub-dept");
			// 저장할 부서명
	        let deptName = li.querySelector("div").innerText.trim();
	        
	        // 기존 수정/삭제 버튼 숨기기
	        let btnGroup = li.querySelector(".btn-group");
	        btnGroup.style.display = "none";

	   		// input + 저장/취소 버튼 바꾸기
	        li.innerHTML = `
	            <input type="text" class="form-control form-control-sm edit-input me-2" value="\${deptName}">
	            <button class="btn btn-primary btn-sm saveBtn">저장</button>
	            <button class="btn btn-secondary btn-sm cancelBtn ms-1">취소</button>
	        `;
			
	        // 하위 부서명 수정 저장
	        li.querySelector(".saveBtn").addEventListener("click", function(){
	        	console.log("저장버튼");
				let mdfDeptNm = li.querySelector(".edit-input").value;
				let mdfDeptNo = li.dataset.deptNo;
				console.log("mdfDeptNm, mdfDeptNo: ", mdfDeptNm, mdfDeptNo);
				
				axios.post("/dept/mdfDept", {
					deptNo : mdfDeptNo,
					deptNm : mdfDeptNm
				}).then((res) => {
					console.log("mdfDept res: ", res);
					
					if(res.status == 200){
						Swal.fire({
							title : "부서명 수정이 완료되었습니다.",
							icon : "success",
							confirmButtonText : "확인"
						}).then((res) => {
							if(res.isConfirmed){
								location.href = location.href;
							}
						})
					}
				});
	        });
	        
	        // 하위 부서명 수정 취소
	        li.querySelector(".cancelBtn").addEventListener("click", function(){
	        	console.log("취소버튼 클릭");
	        	location.href = location.href;
	        });
	        
		});
	});
	
	// 하위 부서명 삭제  
	document.querySelectorAll(".deleteBtn").forEach(delBtn => {
		delBtn.addEventListener("click", function(){
			let li = delBtn.closest("li");
			let delDeptNo = li.dataset.deptNo;
			console.log("하위 부서 삭제 버튼, delDeptNo:", delDeptNo);
			
			Swal.fire({
				title : "부서를 삭제하시겠습니까?",
				html : "상위 부서 삭제시 하위 부서도 삭제됩니다.",
				icon : "warning",
		        showCancelButton: true,
		        confirmButtonText: "네",
		        cancelButtonText: "취소"
			}).then((res) => {
				if(res.isConfirmed){
					axios.post("/dept/delDept", {
						deptNo : delDeptNo
					}).then((res) => {
						console.log("delDeptNo res: ", res);
						
						if(res.status == 200){
							Swal.fire({
								title : "부서명 삭제가 완료되었습니다.",
								icon : "success",
								confirmButtonText : "확인"
							}).then((res) => {
								if(res.isConfirmed){
									location.href = location.href;
								}
							})
						}
					});
				}
			});
		});
	});
	
	
	/////////////////////////////////////////////////////////
	// jstree 관련
	// 부서 등록
	document.querySelector("#addBtn").addEventListener("click", function(){
		let deptNm = document.querySelector("#deptEmpSchName").value;
		
		if((upperDeptNo == "#" || upperDeptNo == "") && deptNo == ""){
			upperDeptNo = 0;
		}else{
			upperDeptNo = deptNo;
		}
		
		console.log("upperDeptNo, deptNo: ", upperDeptNo, deptNo);
		
		axios.post("/dept/insertDept", {
			upperDeptNo : upperDeptNo,
			deptNm : deptNm
		}).then((res) => {
			console.log("insertDept res: ", res);
			
			if(res.status == 200){
				Swal.fire({
					title : "부서 등록이 완료되었습니다.",
					icon : "success",
					confirmButtonText : "확인"
				}).then((res) => {
					if(res.isConfirmed){
						modalClose();
						location.href = location.href;
					}
				})
			}
		});
		
	});
	
	
	// jstree내 검색 버튼
	document.querySelector("#deptEmpSch").addEventListener("click", function(){
		empSearch();
	});
	
	// jstree내 enter 키
	document.querySelector("#deptEmpSchName").addEventListener("keypress", function(e){
		if(e.which === 13){
			empSearch();
		}
	});
	
	document.querySelector("#addDeptModal").addEventListener("shown.bs.modal", function(){
		if(deptJstree){
			deptJstree.jstree("refresh");
		}
	});
	
	// modal 창 닫기
	document.querySelector("#jstreeCloseBtn").addEventListener("click", function(){
		modalClose();
	});
	

//////////////////////////////
//검색
	function empSearch(){
		console.log("검색 실행");
		let deptEmpSchName = document.querySelector("#deptEmpSchName").value;
		
		deptJstree.jstree("search", deptEmpSchName);
		
		console.log(deptEmpSchName);
	}
	
	// modal 닫기
	function modalClose(){
		document.querySelectorAll(".jstree-anchor").forEach(jsEl => {
			jsEl.classList.remove("jstree-search");
			jsEl.classList.remove("jstree-clicked");
		})
		document.querySelector("#deptEmpSchName").value = "";
		deptJstree.jstree("close_all");
		treeModal.hide();
	}
});
	
</script>

	<%@ include file="/module/footerPart.jsp"%>
</body>
</html>