<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>


<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<head>
  <!-- Required meta tags -->
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
  <%@ include file="/module/header.jsp" %>
<style>

.breadcrumb-item i {
 	display: inline-block;
    vertical-align: center;
}
  .folder-card, .file-card {
    border: 1px solid #eee;
    border-radius: 10px;
    padding: 15px;
    text-align: left;
    position: relative;
    transition: 0.2s;
    cursor: pointer; 
  }
  .folder-card:hover, .file-card:hover {
    background-color: #f9f9f9;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  }
  .folder-icon {
    font-size: 2rem;
    color: #2c7be5;
  }
  .file-icon {
    font-size: 2rem;
    color: #6c757d;
  }
  .folder-menu, .file-menu {
    position: absolute;
    top: 10px;
    right: 10px;
  }
  .drop-highlight {
    border: 2px dashed #2c7be5;
    background-color: #eef5ff;
  }
    /* 읽기 전용 입력 상자 스타일 (배경색 추가) */
    .form-control[readonly] {
        background-color: #e9ecef; /* 부트스트랩 기본 회색 */
        opacity: 1; /* 투명도 제거 */
    }
</style>
<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 

<c:set var="uri" value="${pageContext.request.requestURI}" />

<div class="body-wrapper">
<div id="alert-area" 
     style="position: fixed; top: 20px; right: 20px; width: 350px; z-index: 9999;">
</div>
  <div class="container">
  <div class="d-flex justify-content-end mb-3">
</div>

<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="uploadModalLabel">자료 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="fileUploadForm" action="${pageContext.request.contextPath}/main/puploadFile" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="folderNoInput" name="folderNo" value="0">
                    <input type="hidden" id="upperFolderInput" name="upperFolder">
                    <input type="hidden" id="folderTyInput" name="folderTy" value="10001">
                    <input type="hidden" id="delYnInput" name="delYn" value="N">
                    <input type="hidden" id="deptNoInput" name="deptNo">
                    
                    <div class="mb-3">
                        <label class="form-label d-block">자료 종류 선택</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="uploadType" id="typeFile" value="file" checked>
                            <label class="form-check-label" for="typeFile">파일 업로드</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="uploadType" id="typeFolder" value="folder">
                            <label class="form-check-label" for="typeFolder">폴더 생성</label>
                        </div>
                    </div>

                    <div id="folderNameGroup" class="mb-3 d-none">
                        <label for="folderName" class="form-label">폴더 이름</label>
                        <input type="text" class="form-control" id="folderName" name="folderName" placeholder="새 폴더 이름을 입력하세요.">
                    </div>

                    <div id="fileUploadGroup">
                        <div class="mb-3">
                            <label for="fileUpload" class="form-label">파일 선택</label>
                            <input class="form-control" type="file" id="fileUpload" name="uploadFiles" required>
                        </div>
                        <div class="mb-3">
                            <label for="fileName" class="form-label">파일 이름</label>
                            <input type="text" class="form-control" id="fileName" name="fileName" readonly>
                        </div>
                        <div class="mb-3 row g-2">
                            <div class="col">
                                <label for="fileSize" class="form-label">파일 크기</label>
                                <input type="text" class="form-control" id="fileSize" name="fileSize" readonly>
                            </div>
                            <div class="col">
                                <label for="fileDate" class="form-label">등록 날짜</label>
                                <input type="text" class="form-control" id="fileDate" name="fileDate" readonly>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
				<button type="button" id="uploadBtn" class="btn btn-primary px-4">등록</button>
            </div>
        </div>
    </div>
</div>
<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
				
					<div class="col-9">
						<h4 class="fw-semibold mb-8">개인 자료실</h4>
						<nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <c:forEach var="pathFolder" items="${pathList}" varStatus="status">
                                        <c:if test="${not status.first}">
                                            <i class="ti text-muted me-1"></i>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${status.last}">
                                                <li class="breadcrumb-item active" aria-current="page">
                                                    ${pathFolder.folderName}
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="breadcrumb-item">
                                                    <a href="${pageContext.request.contextPath}/main/personallibrary?upperFolder=${pathFolder.folderNo}" class="text-muted text-decoration-none">
                                                        ${pathFolder.folderName}
                                                    </a>
                                                </li> 
                                                &nbsp;&nbsp;>&nbsp;
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </ol>
                            </nav>
					</div>
				 </div>
			</div>
		</div>
		
		
   <div class="d-flex my-4">
  <!-- 가운데 영역 (flex-grow-1로 공간 차지 + text-center로 중앙정렬) -->
  <div class="flex-grow-1 text-center">
    <div class="btn-group" role="group" aria-label="자료실 카테고리">
      <a href="${pageContext.request.contextPath}/main/personallibrary"
         class="btn btn-outline-primary" id="personalLibraryBtn">
        <i class="ti ti-user"></i> 개인 자료실
      </a>
      <a href="${pageContext.request.contextPath}/main/teamlibrary"
         class="btn btn-outline-primary" id="teamLibraryBtn">
        <i class="ti ti-users"></i> 팀별 자료실
      </a>
      <a href="${pageContext.request.contextPath}/main/alllibrary"
         class="btn btn-outline-primary" id="allLibraryBtn">
        <i class="ti ti-folder"></i> 전사 자료실
      </a>
    </div>
  </div>

  <!-- 오른쪽 휴지통 -->
  <div>
    <a href="${pageContext.request.contextPath}/main/trashcan"
       class="btn btn-outline-danger" id="trashcanBtn">
      <i class="ti ti-trash"></i> 휴지통
    </a>
  </div>
</div>

    <!-- 저장 용량 -->
 <div class="text-end mb-2">
    <small>개인 자료실 용량: <strong>${totalSize} / ${totalCapacity}</strong></small>
</div>

  <div class="w-100 d-inline-block">
        <div class="float-start">
            <c:if test="${fn:length(pathList) > 1}">
                <c:set var="parentFolder" value="${pathList[fn:length(pathList)-2]}" />
                <a href="${pageContext.request.contextPath}/main/personallibrary?upperFolder=${parentFolder.folderNo}" 
                   class="btn btn-outline-secondary">
                    ← 뒤로가기
                </a>
            </c:if>
        </div>
        
        <span class="float-end w-50 d-flex justify-content-end align-items-center">
        <form id="searchForm" action="${pageContext.request.contextPath}/main/personallibrary" method="get" class="d-flex align-items-center me-2">               
                <div class="btn-group">
                    <button id="searchTypeBtn" type="button"
                        class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                        data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <c:choose>
                            <c:when test="${param.searchType eq 'folderName'}">폴더명</c:when>
                            <c:when test="${param.searchType eq 'fileName'}">파일명</c:when>
                            <c:otherwise>검색종류</c:otherwise>
                        </c:choose>	
                    </button>
                    <ul class="dropdown-menu animated rubberBand">
                        <li><a class="dropdown-item" data-search-type="folderName" href="#">폴더명</a></li>
                        <li><a class="dropdown-item" data-search-type="fileName" href="#">파일명</a></li>
                    </ul>
                </div>
                <input type="hidden" name="searchType" id="hiddenSearchType" value="${param.searchType}">
                
                <div class="input-group ms-2">
                    <input type="text" name="searchWord" class="form-control"
                           value="${param.searchWord}" placeholder="검색어를 입력하세요.">
                    <button class="btn btn-outline-secondary" type="submit">
                        <i class="ti ti-search"></i>
                    </button>
                </div>
            </form>
            
            <button class="btn btn-success d-inline-block" data-bs-toggle="modal" data-bs-target="#uploadModal">자료 등록</button>
        </span>
    </div>
     <!-- 자료등록 + 검색 끝 -->


    <!-- 파일/폴더 목록 -->
    <div class="row g-3" id="fileArea">
    <c:forEach var="folder" items="${folders}">
        <div class="col-md-3">
            <div class="folder-card drop-target" data-folder-no="${folder.folderNo}">
                <i class="ti ti-folder folder-icon"></i>
                <div class="mt-2 fw-semibold">${folder.folderName}</div>
                <small class="text-muted">${folder.folderCrtYmd}</small>
               <div class="dropdown folder-menu">
			    <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" onclick="event.stopPropagation();">
			        <i class="ti ti-dots-vertical"></i>
			    </button>
			    <ul class="dropdown-menu dropdown-menu-end">
			        <li><a class="dropdown-item text-danger" href="#" onclick="deleteFolder(${folder.folderNo}); return false;">삭제</a></li>
			    </ul>
			</div>
            </div>
        </div>
    </c:forEach>

    <c:forEach var="file" items="${files}">
        <div class="col-md-3">
            <div class="file-card" draggable="true" data-file-no="${file.fileNo}">
              <a href="${pageContext.request.contextPath}/main/downloadFile/${file.fileNo}">
				    <i class="ti ti-file-description file-icon"></i>
				    <div class="mt-2 fw-semibold">${file.originalNm}</div>
				</a>
                <small class="text-muted">${file.fileReg_Dt} ${file.fileFancysize}</small>
                <div class="dropdown file-menu">
                    <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown">
                        <i class="ti ti-dots-vertical"></i>
                    </button>
	                    <ul class="dropdown-menu dropdown-menu-end">
				        <li><a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/main/downloadFile/${file.fileNo}">다운로드</a></li>
				        <li><a class="dropdown-item text-danger" href="#" onclick="deleteFile(${file.fileNo}); return false;">삭제</a></li>
				    </ul>
                </div>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty folders and empty files}">
         <div class="col-12"><p class="text-center text-muted">폴더나 파일이 없습니다.</p></div>
    </c:if>

    </div>
  </div>
</div>



        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>
<script>
    // 현재 페이지의 폴더 번호를 추적하는 변수
    let currentFolderNo = 0;
    
    // 파일 및 폴더 목록을 다시 로드하는 함수
    function reloadFileAndFolderList() {
        location.reload(); 
    }

    document.addEventListener('DOMContentLoaded', function() {
        // URL에서 'upperFolder' 파라미터 값 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const folderParam = urlParams.get('upperFolder');
        currentFolderNo = folderParam ? parseInt(folderParam) : 1; 
        
        const upperFolderHidden = document.getElementById('upperFolderHidden');
        if (upperFolderHidden) {
            upperFolderHidden.value = currentFolderNo;
        }

        const message = '${msg}';
        if (message && message.trim() !== '') {
            Swal.fire({
                title: message,
                icon: 'success',
                confirmButtonText: '확인'
            });
        }
        
        // 현재 URL에 따라 버튼 활성화
        const currentUrl = window.location.pathname;
        const personalBtn = document.getElementById('personalLibraryBtn');
        const teamBtn = document.getElementById('teamLibraryBtn');
        const allBtn = document.getElementById('allLibraryBtn');

        if (currentUrl.includes("personallibrary")) {
            personalBtn.classList.add("btn-primary", "active");
            personalBtn.classList.remove("btn-outline-primary");
        } else if (currentUrl.includes("teamlibrary")) {
            teamBtn.classList.add("btn-primary", "active");
            teamBtn.classList.remove("btn-outline-primary");
        } else if (currentUrl.includes("alllibrary")) {
            allBtn.classList.add("btn-primary", "active");
            allBtn.classList.remove("btn-outline-primary");
        }
        
    // JSTL로 렌더링된 폴더에 클릭 이벤트 할당
    document.querySelectorAll(".folder-card").forEach(folder => {
        folder.addEventListener("click", (e) => {
            // 클릭된 요소가 삭제 버튼인지 확인
            const isDeleteButton = e.target.closest('a.dropdown-item.text-danger');
            
            // 삭제 버튼이 아닌 경우에만 페이지 이동
            if (!isDeleteButton) {
                const selectedFolderNo = folder.dataset.folderNo;
                window.location.href = '${pageContext.request.contextPath}/main/personallibrary?upperFolder=' + selectedFolderNo;
            }
        });
    });
        // 드롭다운 버튼 클릭 시 폴더 이동 막기
        document.querySelectorAll(".folder-menu button").forEach(btn => {
          btn.addEventListener("click", (event) => {
            event.stopPropagation(); 
          });
        });   
    });

	
    // 폴더에도 draggable 속성 추가
    document.querySelectorAll(".folder-card").forEach(folder => {
        folder.setAttribute("draggable", "true");
    });
	
    // Drag & Drop 로직
    let draggedElement = null;

    document.addEventListener("dragstart", e => {
        const target = e.target.closest(".file-card, .folder-card");
        if (target) {
            draggedElement = target;
            draggedElement.classList.add("dragging");
            const type = draggedElement.classList.contains("file-card") ? "file" : "folder";
            const id = draggedElement.dataset.fileNo || draggedElement.dataset.folderNo;
            
            e.dataTransfer.setData("text/plain", JSON.stringify({ type: type, id: id }));
        }
    });

    document.addEventListener("dragend", () => {
        if (draggedElement) {
            draggedElement.classList.remove("dragging");
            draggedElement = null;
        }
        document.querySelectorAll(".drop-highlight").forEach(el => el.classList.remove("drop-highlight"));
    });

    document.querySelectorAll(".drop-target").forEach(folder => {
        folder.addEventListener("dragover", e => {
            e.preventDefault();
            const draggedId = draggedElement.dataset.fileNo || draggedElement.dataset.folderNo;
            if (draggedId !== folder.dataset.folderNo) {
                 folder.classList.add("drop-highlight");
            }
        });

        folder.addEventListener("dragleave", () => {
            folder.classList.remove("drop-highlight");
        });

        folder.addEventListener("drop", e => {
            e.preventDefault();
            folder.classList.remove("drop-highlight");

            const data = JSON.parse(e.dataTransfer.getData("text/plain"));
            const type = data.type;
            const itemId = data.id;
            const targetFolderNo = folder.dataset.folderNo;
            const targetFolderName = folder.querySelector(".fw-semibold").innerText;
            const sourceFolderNo = currentFolderNo; 

            // 드래그한 요소가 드롭한 폴더와 같거나, 드래그한 폴더의 하위 폴더로 이동하는 것을 방지
            if (itemId === targetFolderNo) {
                 Swal.fire({
                    title: '경고',
                    text: '자신에게는 이동할 수 없습니다.',
                    icon: 'warning'
                });
                return;
            }
            moveItem(type, itemId, targetFolderNo, targetFolderName);
        });
    });
    
    // 파일/폴더 이동을 처리하는 통합 함수
    function moveItem(type, itemId, targetFolderNo, targetFolderName) {
        const actionUrl = "${pageContext.request.contextPath}/main/moveItem";
        const formData = new FormData();
        formData.append("type", type);
        formData.append("itemId", itemId);
        formData.append("targetFolderNo", targetFolderNo);

        fetch(actionUrl, {
            method: "POST",
            body: formData,
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json();
        })
        .then(data => {
            if (data.status === "success") {
                Swal.fire({
                    title: '📂 이동 완료!',
                    text: data.msg,
                    icon: 'success',
                    confirmButtonText: '확인',
                    timer: 3000,
                    timerProgressBar: true
                }).then(() => {
                    reloadFileAndFolderList(); // 성공 시 페이지 새로고침
                });
            } else {
                 Swal.fire({
                    title: '이동 실패',
                    text: data.msg,
                    icon: 'error'
                });
            }
        })
        .catch(error => {
            console.error("이동 중 오류:", error);
            Swal.fire({
                title: '오류 발생',
                text: '이동 중 서버 오류가 발생했습니다.',
                icon: 'error'
            });
        });
    }
    
    // drag & drop 로직 끝 --------------

</script>
<script>
    const fileUploadForm = document.getElementById('fileUploadForm');
    const typeFile = document.getElementById('typeFile');
    const typeFolder = document.getElementById('typeFolder');
    const folderNameGroup = document.getElementById('folderNameGroup');
    const fileUploadGroup = document.getElementById('fileUploadGroup');
    const fileUploadInput = document.getElementById('fileUpload');
    const fileNameInput = document.getElementById('fileName');
    const fileSizeInput = document.getElementById('fileSize');
    const fileDateInput = document.getElementById('fileDate');
    const folderNoInput = document.getElementById('folderNoInput');
    const upperFolderInput = document.getElementById('upperFolderInput');
    const folderTyInput = document.getElementById('folderTyInput');
    const delYnInput = document.getElementById('delYnInput');
    const deptNoInput = document.getElementById('deptNoInput');


    // 모달이 열릴 때 초기 상태 설정 및 오늘 날짜 자동 입력
    document.getElementById('uploadModal').addEventListener('show.bs.modal', function () {
        typeFile.checked = true; // 파일 업로드 라디오 버튼 기본 선택
        updateForm(); // 폼 초기화
        resetFileInputs(); // 입력 필드 초기화
        
        // 모달이 열리는 순간 등록 날짜를 오늘 날짜로 자동 설정
        const date = new Date();
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        fileDateInput.value = `${year}-${month}-${day}`;
        
        // 현재 폴더 번호를 히든 필드에 할당
        folderNoInput.value = currentFolderNo;
        upperFolderInput.value = currentFolderNo;

    });
    
	document.getElementById("uploadBtn").addEventListener("click", function() {
	    // 폼 유효성 검사
	    if (typeFolder.checked && document.getElementById("folderName").value.trim() === '') {
	        Swal.fire({
	            title: '경고',
	            text: '폴더 이름을 입력해주세요.',
	            icon: 'warning'
	        });
	        return;
	    }
	
	    const form = document.getElementById("fileUploadForm");
	    const formData = new FormData(form);
	    const actionUrl = typeFile.checked ? "${pageContext.request.contextPath}/main/puploadFile" : "${pageContext.request.contextPath}/main/puploadFolder";
	
	    fetch(actionUrl, {
	        method: "POST",
	        body: formData,
	    })
	    .then(response => {
	        if (!response.ok) {
	            return response.text().then(text => { throw new Error(text); });
	        }
	        // 파일 업로드 시에는 JSON이 아닌 문자열 응답이 올 수 있으므로, content-type을 확인
	        const contentType = response.headers.get("content-type");
	        if (contentType && contentType.indexOf("application/json") !== -1) {
	            return response.json();
	        } else {
	            return response.text();
	        }
	    })
	    .then(data => {
	        // 파일 업로드 성공 시에는 리다이렉트되므로, 여기서는 폴더 생성 성공 시만 처리
	        if (typeof data === 'object' && data.status === "success") {
	            Swal.fire({
	                title: data.msg,
	                icon: "success",
	                confirmButtonText: "확인"
	            }).then(() => {
	                const modal = bootstrap.Modal.getInstance(document.getElementById("uploadModal"));
	                modal.hide();
	                
	                // Ajax로 목록 갱신 (현재 페이지 새로고침)
	                location.reload(); 
	            });
	        } else if (typeof data === 'string') {
	            // 리다이렉트 응답을 받은 경우 (파일 업로드 성공)
	            // 아무것도 하지 않음. 브라우저가 자동으로 리다이렉트될 것임
	        } else {
	             Swal.fire({
	                title: "실패",
	                text: data.msg,
	                icon: "error",
	                confirmButtonText: "확인"
	            });
	        }
	    })
	    .catch(err => {
	        console.error('Error:', err);
	        Swal.fire({
	            title: "에러 발생!",
	            text: "오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
	            icon: "error"
	        });
	    });
	});

    // 라디오 버튼 선택에 따라 폼 내용 전환 및 action 변경
    function updateForm() {
        if (typeFile.checked) {
            fileUploadForm.action = "${pageContext.request.contextPath}/main/puploadFile";
            fileUploadGroup.classList.remove('d-none');
            folderNameGroup.classList.add('d-none');
            fileUploadInput.required = true;
            // 파일 업로드 시 필요한 필드만 name 속성 부여
            folderNoInput.name = 'folderNo';
            upperFolderInput.name = '';
            folderTyInput.name = '';
            delYnInput.name = '';
            deptNoInput.name = '';
        } else {
            fileUploadForm.action = "${pageContext.request.contextPath}/main/puploadFolder";
            fileUploadGroup.classList.add('d-none');
            folderNameGroup.classList.remove('d-none');
            fileUploadInput.required = false;
            // 폴더 생성 시 필요한 필드만 name 속성 부여
            folderNoInput.name = '';
            upperFolderInput.name = 'upperFolder';
            folderTyInput.name = 'folderTy';
            delYnInput.name = 'delYn';
            deptNoInput.name = 'deptNo';
        }
    }

    // 파일 선택 필드 및 폴더명 필드 초기화
    function resetFileInputs() {
        fileUploadInput.value = '';
        fileNameInput.value = '';
        fileSizeInput.value = '';
        fileDateInput.value = '';
        document.getElementById('folderName').value = '';
    }

    // 라디오 버튼 변경 시 폼 업데이트
    typeFile.addEventListener('change', updateForm);
    typeFolder.addEventListener('change', updateForm);

    // 파일 선택 시 파일 정보 동적으로 가져오기
    fileUploadInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            // 파일 이름 (확장자 포함)
            fileNameInput.value = file.name;

            // 파일 크기
            let size = file.size;
            let sizeStr = '';
            if (size < 1024) {
                sizeStr = size + ' B';
            } else if (size < 1024 * 1024) {
                sizeStr = (size / 1024).toFixed(2) + ' KB';
            } else {
                sizeStr = (size / (1024 * 1024)).toFixed(2) + ' MB';
            }
            fileSizeInput.value = sizeStr;
        } else {
            // 파일이 선택되지 않았을 때 초기화
            fileNameInput.value = '';
            fileSizeInput.value = '';
        }
    });
   
 	// 드롭다운 버튼 클릭 시 폴더 이동 막기
    document.querySelectorAll(".folder-menu button").forEach(btn => {
      btn.addEventListener("click", (event) => {
        event.stopPropagation(); 
      });
    });
 	
 // 폴더 삭제 함수
    function deleteFolder(folderNo) {
        Swal.fire({
            title: '폴더를 삭제하시겠습니까?',
            text: "삭제된 폴더는 휴지통으로 이동됩니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/deleteFolder', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'folderNo=' + folderNo
                })
                .then(response => response.json())
                .then(data => {
                    if(data.status === 'success') {
                        Swal.fire('삭제 완료!', data.msg, 'success').then(() => {
                            location.reload(); // 페이지 새로고침
                        });
                    } else {
                        Swal.fire('삭제 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    Swal.fire('오류 발생', '삭제 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }

 // 파일 삭제 함수
    function deleteFile(fileNo) {
        Swal.fire({
            title: '파일을 삭제하시겠습니까?',
            text: "삭제된 파일은 휴지통으로 이동됩니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/deleteFile', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'fileNo=' + fileNo
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('네트워크 응답이 올바르지 않습니다.');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.status === "success") {
                        Swal.fire('삭제 완료!', data.msg, 'success').then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire('삭제 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('오류 발생', '삭제 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }
 
 // 파일 복원
function restoreFile(fileNo) {
	    if (!fileNo) {
        Swal.fire('경고', '복원할 파일을 찾을 수 없습니다.', 'warning');
        return;

    }

    Swal.fire({
        title: '파일을 복원하시겠습니까?',
        text: "파일이 원래 위치로 복원됩니다.",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '복원',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('${pageContext.request.contextPath}/main/restoreFile', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'fileNo=' + fileNo
            })
            .then(res => {
                if (!res.ok) {
                    throw new Error('네트워크 응답이 올바르지 않습니다.');
                }
                return res.json();
            })
            .then(data => {
                if (data.status === "success") {
                    Swal.fire("복원 완료!", data.msg, "success").then(() => {
                        const element = document.querySelector(`.file-card[data-file-no='\${fileNo}']`);
                        if (element) {
                            element.remove();
                        } else {
                            location.reload();
                        }
                    });
                } else {
                    Swal.fire("실패", data.msg, "error");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire('오류 발생', '복원 중 오류가 발생했습니다.', 'error');
            });
        }
    });
}

    // 폴더 복원
    function restoreFolder(folderNo) {
      fetch("${pageContext.request.contextPath}/main/restoreFolder", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "folderNo=" + folderNo
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === "success") {
          Swal.fire("복원 완료!", data.msg, "success");
          document.querySelector(`.folder-card[data-folder-no='\${folderNo}']`).remove();
        } else {
          Swal.fire("실패", data.msg, "error");
        }
      });
    }
    
    // 검색 타입 드롭다운 이벤트 핸들링
    document.querySelectorAll('#searchForm .dropdown-item').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const searchType = this.getAttribute('data-search-type');
            document.getElementById('hiddenSearchType').value = searchType;
            document.getElementById('searchTypeBtn').textContent = this.textContent;
        });
    });

</script>
</body>
