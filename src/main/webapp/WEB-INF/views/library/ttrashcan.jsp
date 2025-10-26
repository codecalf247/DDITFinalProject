<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 휴지통</title>
  <%@ include file="/module/headPart.jsp" %>
  <%@ include file="/module/header.jsp" %>
  <style>
    .folder-card, .file-card {
      border: 1px solid #eee;
      border-radius: 10px;
      padding: 15px;
      text-align: left;
      position: relative;
      transition: 0.2s;
      cursor: default; 
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
  </style>
</head>
<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 
      
      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-9">
              <h4 class="fw-semibold mb-8">휴지통</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                  <li class="breadcrumb-item active" aria-current="page">휴지통</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>
      
      <div class="d-flex my-4">
        <div class="flex-grow-1 text-center">
          <div class="btn-group" role="group" aria-label="자료실 카테고리">
            <a href="${pageContext.request.contextPath}/main/teamlibrary"
               class="btn btn-outline-primary">
              <i class="ti ti-user"></i> 자료실
            </a>
            <a href="${pageContext.request.contextPath}/main/trashcan"
               class="btn btn-outline-primary" id="personalLibraryBtn">
              <i class="ti ti-trash"></i> 개인 휴지통
            </a>
            <a href="${pageContext.request.contextPath}/main/ttrashcan"
               class="btn btn-outline-primary active" id="teamLibraryBtn">
              <i class="ti ti-trash"></i> 팀별 휴지통
            </a>
            <a href="${pageContext.request.contextPath}/main/atrashcan"
               class="btn btn-outline-primary" id="allLibraryBtn">
              <i class="ti ti-trash"></i> 전사 휴지통
            </a>
          </div>
        </div>
      </div>
      
   <div class="d-flex justify-content-end align-items-center my-3 gap-2">
  <!-- 검색창 -->
 
  
  <!-- 휴지통 버튼 -->
  <a href="${pageContext.request.contextPath}/main/ttrashcan"
     class="btn btn-primary active" id="trashcanBtn">
    <i class="ti ti-trash"></i> 휴지통
  </a>
  </div>
      <div class="row g-3 mt-4" id="trashcan-content">
        <p class="text-center text-muted">휴지통 내용을 불러오는 중...</p>
      </div>
    </div>
  </div>    
<%@ include file="/module/footerPart.jsp" %>
<script>
    // 페이지 로딩 시 휴지통 내용 불러오기
    document.addEventListener('DOMContentLoaded', function() {
        loadTrashcanContent();
    });

    function loadTrashcanContent() {
        fetch('${pageContext.request.contextPath}/main/ttrashcanData', {
            method: 'GET'
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('네트워크 응답이 올바르지 않습니다.');
            }
            return response.json();
        })
        .then(data => {
        	console.log("data:", data);
            renderContent(data.folders, data.files);
        })
        .catch(error => {
            console.error('Error loading trashcan content:', error);
            document.getElementById('trashcan-content').innerHTML = 
                `<div class="col-12"><div class="alert alert-danger">휴지통 내용을 불러오는 데 실패했습니다.</div></div>`;
        });
    }

    function renderContent(folders, files) {
        const contentDiv = document.getElementById('trashcan-content');
        contentDiv.innerHTML = '';

        if (folders.length === 0 && files.length === 0) {
            contentDiv.innerHTML = `<div class="col-12"><p class="text-center text-muted">휴지통이 비어있습니다.</p></div>`;
            return;
        }

        folders.forEach(folder => {
            const folderHtml = `
                <div class="col-md-3">
                    <div class="folder-card p-3 my-2 border" data-folder-no="\${folder.folderNo}">
                        <i class="ti ti-folder folder-icon"></i>
                        <div class="mt-2 fw-semibold">\${folder.folderName}</div>
                        <small class="text-muted">${folder.folderCrtYmd}</small>
                        <div class="dropdown folder-menu">
                            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" onclick="event.stopPropagation();">
                                <i class="ti ti-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item text-primary" href="#" onclick="restoreFolder(\${folder.folderNo}); return false;">복원</a></li>
                                <li><a class="dropdown-item text-danger" href="#" onclick="permanentlyDeleteFolder(\${folder.folderNo}); return false;">영구 삭제</a></li>
                            </ul>
                        </div>
                    </div>
                </div>`;
            contentDiv.innerHTML += folderHtml;
        });

        files.forEach(file => {
            const fileHtml = `
                <div class="col-md-3">
                    <div class="file-card p-3 my-2 border" data-file-no="${file.fileNo}">
                        <i class="ti ti-file-description file-icon"></i>
                        <div class="mt-2 fw-semibold">\${file.originalNm}</div>
                        <small class="text-muted">${file.fileRegDt} ${file.fileFancysize}</small>
                        <div class="dropdown file-menu">
                            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" onclick="event.stopPropagation();">
                                <i class="ti ti-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item text-primary" href="#" onclick="restoreFile(\${file.fileNo}); return false;">복원</a></li>
                                <li><a class="dropdown-item text-danger" href="#" onclick="permanentlyDeleteFile(\${file.fileNo}); return false;">영구 삭제</a></li>
                            </ul>
                        </div>
                    </div>
                </div>`;
            contentDiv.innerHTML += fileHtml;
        });
    }

    function restoreFolder(folderNo) {
        Swal.fire({
            title: '폴더를 복원하시겠습니까?',
            text: "폴더가 복원됩니다.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '복원',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/trestoreFolder', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'folderNo=' + folderNo
                })
                .then(response => response.json())
                .then(data => {
                    if(data.status === 'success') {
                        Swal.fire('복원 완료!', data.msg, 'success').then(() => {
                            loadTrashcanContent();
                        });
                    } else {
                        Swal.fire('복원 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    Swal.fire('오류 발생', '복원 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }
    
    function restoreFile(fileNo) {
        Swal.fire({
            title: '파일을 복원하시겠습니까?',
            text: "파일이 복원됩니다.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '복원',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/trestoreFile', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'fileNo=' + fileNo
                })
                .then(response => response.json())
                .then(data => {
                    if(data.status === 'success') {
                        Swal.fire('복원 완료!', data.msg, 'success').then(() => {
                            loadTrashcanContent();
                        });
                    } else {
                        Swal.fire('복원 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    Swal.fire('오류 발생', '복원 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }

    function permanentlyDeleteFolder(folderNo) {
        Swal.fire({
            title: '폴더를 영구 삭제하시겠습니까?',
            text: "이 작업은 되돌릴 수 없습니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '영구 삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/permanentlyDeleteFolder', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'folderNo=' + folderNo
                })
                .then(response => response.json())
                .then(data => {
                    if(data.status === 'success') {
                        Swal.fire('영구 삭제 완료!', data.msg, 'success').then(() => {
                            loadTrashcanContent();
                        });
                    } else {
                        Swal.fire('삭제 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    Swal.fire('오류 발생', '폴더 삭제 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }

    function permanentlyDeleteFile(fileNo) {
        Swal.fire({
            title: '파일을 영구 삭제하시겠습니까?',
            text: "이 작업은 되돌릴 수 없습니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '영구 삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/main/permanentlyDeleteFile', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'fileNo=' + fileNo
                })
                .then(response => response.json())
                .then(data => {
                    if(data.status === 'success') {
                        Swal.fire('영구 삭제 완료!', data.msg, 'success').then(() => {
                            loadTrashcanContent();
                        });
                    } else {
                        Swal.fire('삭제 실패', data.msg, 'error');
                    }
                })
                .catch(error => {
                    Swal.fire('오류 발생', '파일 삭제 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    }

    // 휴지통 비우기 기능 (예시)
    function emptyTrashcan() {
        Swal.fire({
            title: '휴지통을 비우시겠습니까?',
            text: "휴지통의 모든 항목이 영구 삭제됩니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '모두 삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                // TODO: 휴지통 비우기 API 호출
                Swal.fire('휴지통 비우기 완료!', '휴지통이 비었습니다.', 'success').then(() => {
                    loadTrashcanContent();
                });
            }
        });
    }
</script>
</body>
</html>