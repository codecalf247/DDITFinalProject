<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <%@ include file="/module/header.jsp" %>
</head>

<style>
  /* 검색바 */
  .filter-group.input-group.input-group-sm .form-control{padding-top:.5rem;padding-bottom:.5rem}
  .filter-group .input-group-text{border-right:0;border-top-right-radius:0;border-bottom-right-radius:0}
  .filter-group .form-control{border-left:0;border-right:0;border-radius:0}
  .filter-group .dropdown-toggle{border-top-left-radius:0;border-bottom-left-radius:0}
  .filter-group .form-control:focus{box-shadow:none}
  .filter-group .input-group-text,.filter-group .form-control,.filter-group .dropdown-toggle{
    background:var(--bs-body-bg); color:var(--bs-body-color); border-color:var(--bs-border-color);
  }
  .filter-group .input-group-text i{color:var(--bs-secondary-color)}

  /* 상태 토글 & 버튼 */
  .status-group .btn{border-radius:.6rem;padding:.45rem .9rem}
  .status-group .btn + .btn{margin-left:.5rem}
  #btnAddEquip{font-weight:700;padding:.6rem 1.1rem;border-radius:.8rem}

  /* 테이블 썸네일 */
  .equip-avatar{width:40px;height:40px;border-radius:50%;object-fit:cover}

  /* 등록횟수/상태/옵션 정렬 유지 */
  #equipTable th:nth-child(3), #equipTable td:nth-child(3){ width:110px; text-align:center; }
  #equipTable th:nth-child(4), #equipTable td:nth-child(4){ text-align:center; padding-left:0 !important; }
  #equipTable th:nth-child(5), #equipTable td:nth-child(5){ width:56px; text-align:right; }

  /* 중앙 업로드 박스 (수정 모달) */
  .profile_wrap{
    width:140px;height:140px;border:1px dashed var(--bs-border-color,#e5e7eb);
    border-radius:.75rem;background:var(--bs-body-bg);position:relative;overflow:hidden;cursor:pointer;
  }
  .profile_label{width:100%;height:100%;display:flex;justify-content:center;align-items:center;
    color:var(--bs-secondary-color);font-size:14px;}
  .profile_inner{text-align:center}
  .profile_inner i{font-size:20px;display:block;margin-bottom:5px}
  .profile_input{position:absolute;top:0;left:0;width:100%;height:100%;opacity:0;cursor:pointer}

  /* 배지 외곽선 유지 (네 코드 의도 반영) */
  .badge { border: 1px solid var(--bs-border-color); }
</style>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid"> 
    <div class="body-wrapper">
      <div class="container">

        <!-- 배너 -->
        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
          <div class="card-body px-4 py-3">
            <div class="row align-items-center">
              <div class="col-9">
                <h4 class="fw-semibold mb-8">장비 관리</h4>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
                    <li class="breadcrumb-item" aria-current="page">EquipManage</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </div>

       
      <!-- 검색 + 상태 필터 (왼쪽=분류, 가운데=공백, 오른쪽=검색/추가) -->
<div class="row align-items-center pb-3">
  <!-- 왼쪽: 상태 필터 (내용만큼) -->
 <div class="col-auto">
	<div class="btn-group mb-3" role="group">
          <a href="${pageContext.request.contextPath}/adequip/adeqlist?statusFilter=&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${empty statusFilter}'>active</c:if>">전체</a>
          <a href="${pageContext.request.contextPath}/adequip/adeqlist?statusFilter=normal&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "normal"}'>active</c:if>">정상</a>
          <a href="${pageContext.request.contextPath}/adequip/adeqlist?statusFilter=rent&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "rent"}'>active</c:if>">대여중</a>
          <a href="${pageContext.request.contextPath}/adequip/adeqlist?statusFilter=repair&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "repair"}'>active</c:if>">고장</a>
   </div>
</div>
  <!-- 가운데: 유연한 공간 -->
  <div class="col"></div>

  <!-- 오른쪽: 검색 + 자재추가 (내용만큼) -->
  <div class="col-auto d-flex align-items-center gap-2 flex-nowrap">
    <!-- 검색 폼 (기본 높이 = 상태필터와 동일) -->
    <form id="searchForm"
          action="${pageContext.request.contextPath}/adequip/adequiplist"
          method="get"
          class="input-group"             
          style="width:320px;">           
      <input type="text" name="searchWord" class="form-control"
             value="${fn:escapeXml(searchWord)}" placeholder="검색어를 입력하세요.">
      <button class="btn btn-outline-secondary" type="submit">
        <i class="ti ti-search me-1"></i> 검색
      </button>
      <input type="hidden" name="page" value="1"/>
      <input type="hidden" name="statusFilter" value="${statusFilter}"/>
    </form>

    <!-- 자재 추가 버튼 (기본 사이즈) -->
    <button type="button" class="btn btn-primary" id="btnAddMtril"
            data-bs-toggle="modal" data-bs-target="#addEquipModal">
      <i class="ti ti-plus me-1"></i> 장비 추가하기
    </button>
  </div>
</div>

      <!-- 장비 목록 테이블 -->
      <div class="card">
        <div class="table-responsive">
          <table class="table text-nowrap mb-0 align-middle" id="equipTable">
            <thead class="text-dark">
              <tr>
                <th>장비명</th>
                <th>등록일</th>
                <th>이력횟수</th>
                <th>상태</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="eqpmn" items="${eqpmnList}">
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <img class="equip-avatar" src="${eqpmn.filePath }" alt="">
                      <div class="ms-3">
                        <div class="fw-semibold">${eqpmn.eqpmnNm}</div>
                        <small class="text-muted">${eqpmn.eqpmnDc }</small>
                      </div>
                    </div>
                  </td>
                  <td>${eqpmn.eqpmnRegYmd}</td>
                  <td>${eqpmn.eqpmnHistCnt }</td>

                  <!-- ▼ 상태: pill 배지 + DB 라벨 그대로 노출 -->
                  <td>
                    <c:choose>
                      <c:when test="${eqpmn.eqpmnSttus eq '13001'}">
                        <span class="badge rounded-pill bg-success-subtle text-success border border-success-subtle px-3 py-1">
                          <c:out value="${eqpmn.eqpmnSttusNm}"/>
                        </span>
                      </c:when>
                      <c:when test="${eqpmn.eqpmnSttus eq '13002'}">
                        <span class="badge rounded-pill bg-warning-subtle text-warning border border-warning-subtle px-3 py-1">
                          <c:out value="${eqpmn.eqpmnSttusNm}"/>
                        </span>
                      </c:when>
                      <c:when test="${eqpmn.eqpmnSttus eq '13003'}">
                        <span class="badge rounded-pill bg-danger-subtle text-danger border border-danger-subtle px-3 py-1">
                          <c:out value="${eqpmn.eqpmnSttusNm}"/>
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge rounded-pill bg-body-tertiary text-body px-3 py-1">
                          <c:out value="${eqpmn.eqpmnSttusNm}"/>
                        </span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <!-- ▲ 상태 끝 -->

                  <td>
                    <!-- 옵션 메뉴 -->
                    <div class="dropdown text-center">
                      <button class="btn p-0 bg-transparent border-0" type="button"
                              data-bs-toggle="dropdown" aria-expanded="false" title="메뉴">
                        <i class="ti ti-dots-vertical"></i>
                      </button>
                      <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                          <!-- ★ 대여자 이름 전달(data-renter) -->
                          <button type="button" class="dropdown-item action-edit" 
                                  data-bs-toggle="modal" data-bs-target="#editModal"
                                  data-id="${eqpmn.eqpmnNo}"
                                  data-name="${eqpmn.eqpmnNm}"
                                  data-status="${eqpmn.eqpmnSttus}"
                                  data-thumb="${eqpmn.filePath }"
                                  data-memo="${eqpmn.eqpmnDc}"
                                  data-group-no="${eqpmn.fileGroupNo }"
                                  data-renter="<c:out value='${eqpmn.empNm}'/>">
                            수정
                          </button>
                        </li>
                        <li>
                          <!-- 삭제 -->
                          <button type="button" class="dropdown-item text-danger btn-delete" 
                                  data-bs-toggle="modal" data-bs-target="#deleteEquipModal"
                                  data-id="${eqpmn.eqpmnNo}"
                                  data-group-no="${eqpmn.fileGroupNo }">
                            삭제
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty eqpmnList}">
                <tr><td colspan="5" class="text-center text-muted py-5">표시할 장비가 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <div class="flex-grow-1 d-flex justify-content-center">
        <div class="d-flex align-items-center">
            ${pagingVO.pagingHTML2}
        </div>
    </div>

      <!-- 페이징용 히든 폼 -->
      <form id="pageForm" action="${pageContext.request.contextPath}/adequip/adeqlist" method="get">
        <input type="hidden" name="page" id="page">
        <input type="hidden" name="searchWord" value="${searchWord}">
      </form>

    </div>
  </div>
</div>

<!-- ====== 새 장비 등록 모달 ====== -->
<div class="modal fade" id="addEquipModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">새 장비 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body pt-0">
        <form id="addEquipForm" enctype="multipart/form-data"
              action="${pageContext.request.contextPath}/adequip/insert"
              method="post">
          <div class="mb-3">
            <label class="form-label">장비명 <span class="text-danger">*</span></label>
            <input type="text" class="form-control" name="eqpmnNm" required>
          </div>
          <div class="mb-3">
            <label class="form-label">이미지</label>
            <div class="input-group">
              <input type="file" class="form-control" id="fileInput" name="uploadFile" accept="image/*">
              <button type="button" class="btn btn-outline-secondary" id="clearBtn">지우기</button>
            </div>
            <div class="mt-2 d-none" id="previewWrap">
              <img id="previewImg" class="rounded border" style="max-width:100%;height:auto" alt="미리보기">
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label">설명</label>
            <textarea class="form-control" name="eqpmnDc" rows="3"></textarea>
          </div>
          <div class="mb-3">
            <label class="form-label">장비 상태 <span class="text-danger">*</span></label>
            <select class="form-select" name="eqpmnSttus" required>
              <option value="13001">정상</option>
              <option value="13002">대여중</option>
              <option value="13003">고장</option>
            </select>
          </div>
        </form>
      </div>
      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-dark" id="addEquipSubmitBtn">장비 등록</button>
      </div>
    </div>
  </div>
</div>

<!-- ====== 수정 모달 ====== -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">장비 수정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body pt-0">
        <!-- 중앙 로고 업로드 박스 -->
        <form id="editForm" action="${pageContext.request.contextPath}/adequip/update" method="post" enctype="multipart/form-data">
          <div class="d-flex justify-content-center mb-3">
            <label class="profile_wrap">
              <div class="profile_label" id="initial-upload">
                <div class="profile_inner">
                  <i class="ti ti-camera"></i>
                  <span class="profile_name">장비 이미지</span>
                </div>
              </div>
              <img id="editThumb" src="" alt="장비 이미지"
                   style="display:none; width:100%; height:100%; object-fit:cover; border-radius:.75rem;">
              <input type="file" id="editFileInput" name="uploadFile" class="profile_input" accept="image/*">
            </label>
          </div>

          <!-- 폼 -->
          <input type="hidden" name="eqpmnNo" id="editEquipId">
          <input type="hidden" name="fileGroupNo" id="editFileGroupNo">

          <div class="mb-3">
            <label class="form-label">장비명 <span class="text-danger">*</span></label>
            <input type="text" class="form-control" name="eqpmnNm" id="editNameInput" required>
          </div>

          <div class="mb-3">
            <label class="form-label">장비 상태 <span class="text-danger">*</span></label>
            <select class="form-select" id="editStatusSelect" required>
              <option value="13001">정상</option>
              <option value="13002">대여중</option>
              <option value="13003">고장</option>
            </select>
            <input type="hidden" name="eqpmnSttus" id="eqpmnSttus" value=""/>
            <div id="stateLock" class="form-text text-danger d-none">
              <i class="ti ti-lock me-1"></i>대여중인 장비는 상태를 변경할 수 없습니다.
            </div>

            <!-- ★ 대여자 표시 영역 (처음엔 숨김) -->
            <div id="renterInfo" class="form-text d-none">
              <i class="ti ti-user me-1"></i>
              대여자: <span id="renterName">-</span>
            </div>
          </div>

          <div class="mb-1">
            <label class="form-label">내용 (메모)</label>
            <textarea class="form-control" name="eqpmnDc" id="editMemo" rows="3" placeholder="내용을 입력하세요..."></textarea>
          </div>
        </form>
      </div>

      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-dark" id="editSaveBtn">수정</button>
      </div>
    </div>
  </div>
</div>

<!-- ====== 삭제 모달 ====== -->
<div class="modal fade" id="deleteEquipModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:400px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">삭제 확인</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <form id="deleteForm" action="${pageContext.request.contextPath}/adequip/delete" method="post">
        <input type="hidden" name="eqpmnNo" id="deleteEqpmnNo">
        <input type="hidden" name="fileGroupNo" id="deleteFileGroupNo">

        <div class="modal-body">
          이 장비를 정말 삭제하시겠습니까?
        </div>
        <div class="modal-footer border-0">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-danger" id="deleteConfirmBtn">삭제</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script>
$(function(){
  // 변수 선언 (등록 모달)
  let fileInput          = $("#fileInput");
  let previewWrap        = $("#previewWrap");
  let previewImg         = $("#previewImg");
  let clearBtn           = $("#clearBtn");
  let addEquipSubmitBtn  = $("#addEquipSubmitBtn");
  let addEquipForm       = $("#addEquipForm");
  let addEquipModal      = $("#addEquipModal");

  // 변수 선언 (수정 모달)
  let editFileInput      = $("#editFileInput");
  let editThumb          = $("#editThumb");
  let initialUpload      = $("#initial-upload");

  let editForm           = $("#editForm");
  let editEquipId        = $("#editEquipId");
  let editNameInput      = $("#editNameInput");
  let editStatusSelect   = $("#editStatusSelect");
  let eqpmnSttusHidden   = $("#eqpmnSttus");
  let editFileGroupNo    = $("#editFileGroupNo");
  let stateLock          = $("#stateLock");
  let editMemo           = $("#editMemo");
  let editSaveBtn        = $("#editSaveBtn");

  // 대여자 노출 영역
  let renterInfo         = $("#renterInfo");
  let renterName         = $("#renterName");

  // 상태 옵션 템플릿
  const OPT_ALL = ''
    + '<option value="13001">정상</option>'
    + '<option value="13002">대여중</option>'
    + '<option value="13003">고장</option>';
  const OPT_REPAIR_ONLY = ''
    + '<option value="13001">정상</option>'
    + '<option value="13003">고장</option>';

  // 삭제 모달
  let deleteForm         = $("#deleteForm");
  let deleteEqpmnNo      = $("#deleteEqpmnNo");
  let deleteFileGroupNo  = $("#deleteFileGroupNo");
  let deleteConfirmBtn   = $("#deleteConfirmBtn");

  // 페이징
  window.fn_pagination = function(pageNo){
    $("#page").val(pageNo);
    $("#pageForm").submit();
  };

  /* ===== 추가 모달: 이미지 미리보기 ===== */
  fileInput.on("change", () => {
    let file = fileInput[0].files[0];
    if (!file) { previewWrap.addClass("d-none"); previewImg.attr("src",""); return; }
    let reader = new FileReader();
    reader.onload = e => { previewImg.attr("src", e.target.result); previewWrap.removeClass("d-none"); };
    reader.readAsDataURL(file);
  });

  clearBtn.on("click", () => {
    fileInput.val(""); previewWrap.addClass("d-none"); previewImg.attr("src","");
  });

  addEquipSubmitBtn.on("click", () => {
    if (addEquipForm[0].checkValidity()) addEquipForm[0].submit();
    else addEquipForm[0].reportValidity();
  });

  addEquipModal.on("hidden.bs.modal", () => {
    addEquipForm[0].reset(); previewWrap.addClass("d-none"); previewImg.attr("src","");
  });

  /* ===== 수정 모달: 파일 변경 시 미리보기 ===== */
  editFileInput.on("change", function () {
    let file = this.files[0];
    if (file) {
      let reader = new FileReader();
      reader.onload = e => { editThumb.attr("src", e.target.result).show(); initialUpload.hide(); };
      reader.readAsDataURL(file);
    } else {
      editThumb.hide().attr("src",""); initialUpload.show();
    }
  });

  /* ===== 수정 모달 바인딩 ===== */
  $(document).on("click", ".action-edit", function () {
    let id     = $(this).data("id");
    let name   = $(this).data("name");

    // 숫자/문자/공백 혼용 대비 문자열로 고정
    let status = (($(this).data("status") ?? '') + '').trim(); // '13001'|'13002'|'13003'

    let thumb      = $(this).data("thumb");
    let memo       = $(this).data("memo");
    let fileGroupNo= $(this).data("group-no");

    // 대여자 이름도 안전하게 문자열로
    let renter = (($(this).data("renter") ?? '') + '').trim();

    // 이미지
    if (thumb) { editThumb.attr("src", thumb).show(); initialUpload.hide(); }
    else { editThumb.hide().attr("src",""); initialUpload.show(); }

    // 폼 값
    editEquipId.val(id);
    editNameInput.val(name);
    editFileGroupNo.val(fileGroupNo);
    editMemo.val(memo || "");

    // 상태별 처리
    if (status === "13002") {
      // 대여중: 전체 옵션 유지 + 잠금 + 대여자 표시(없으면 안내)
      editStatusSelect.html(OPT_ALL).val("13002").prop("disabled", true);
      stateLock.removeClass("d-none");
      renterName.text(renter || '대여자 정보 없음');
      renterInfo.removeClass("d-none");
    } else if (status === "13003") {
      // 고장: 정상/고장만
      editStatusSelect.html(OPT_REPAIR_ONLY).val("13003").prop("disabled", false);
      stateLock.addClass("d-none");
      renterInfo.addClass("d-none");
    } else {
      // 정상 및 기타
      editStatusSelect.html(OPT_ALL).val("13001").prop("disabled", false);
      stateLock.addClass("d-none");
      renterInfo.addClass("d-none");
    }
  });

  /* ===== 수정 저장 ===== */
  editSaveBtn.on("click", () => {
    // select가 disabled여도 값 전송되도록 hidden에 복사
    eqpmnSttusHidden.val(editStatusSelect.val());
    editForm.submit();
  });

  /* ===== 삭제 모달 바인딩/실행 ===== */
  $(document).on("click", ".btn-delete", function(){
    deleteEqpmnNo.val($(this).data("id"));
    deleteFileGroupNo.val($(this).data("group-no") || 0);
  });
  deleteConfirmBtn.on("click", () => { deleteForm.submit(); });
});
document.addEventListener('DOMContentLoaded', function() {
    const message = '${msg}';
    if (message && message.trim() !== '') {
        Swal.fire({
            title: message,
            icon: 'success',
            confirmButtonText: '확인'
        });
    }
});
</script>

</body>
</html>
