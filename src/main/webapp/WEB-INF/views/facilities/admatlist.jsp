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
  .filter-group.input-group.input-group-sm .form-control{padding-top:.5rem;padding-bottom:.5rem}
  .filter-group .input-group-text{border-right:0;border-top-right-radius:0;border-bottom-right-radius:0}
  .filter-group .form-control{border-left:0;border-right:0;border-radius:0}
  .filter-group .dropdown-toggle{border-top-left-radius:0;border-bottom-left-radius:0}
  .filter-group .form-control:focus{box-shadow:none}
  .filter-group .input-group-text,.filter-group .form-control,.filter-group .dropdown-toggle{
    background:var(--bs-body-bg); color:var(--bs-body-color); border-color:var(--bs-border-color);
  }
  .filter-group .input-group-text i{color:var(--bs-secondary-color)}
  .status-group .btn{border-radius:.6rem;padding:.45rem .9rem}
  .status-group .btn + .btn{margin-left:.5rem}
  #btnAddMtril{font-weight:700;padding:.6rem 1.1rem;border-radius:.8rem}
  .mtril-avatar{width:40px;height:40px;border-radius:50%;object-fit:cover}
  #mtrilTable th:nth-child(2), #mtrilTable td:nth-child(2){ width:110px; text-align:center; }
  #mtrilTable th:nth-child(3), #mtrilTable td:nth-child(3){ text-align:center; padding-left:0 !important; }
  #mtrilTable th:nth-child(4), #mtrilTable td:nth-child(4){ width:160px; text-align:center; }
  #mtrilTable th:nth-child(6), #mtrilTable td:nth-child(6){ width:56px; text-align:right; }
  .badge{ border:1px solid var(--bs-border-color); }
  /* 중앙 썸네일 박스 */
  .profile_wrap{width:140px;height:140px;border:1px dashed var(--bs-border-color);border-radius:.75rem;position:relative;overflow:hidden;cursor:pointer;background:var(--bs-body-bg);}
  .profile_label{width:100%;height:100%;display:flex;justify-content:center;align-items:center;color:var(--bs-secondary-color);font-size:14px;}
  .profile_input{position:absolute;top:0;left:0;width:100%;height:100%;opacity:0;cursor:pointer;}
 	
 .eqh-38 .form-control,.eqh-38 .btn { height: 38px; padding: .375rem .75rem; }

.eqh-38-btn { height: 38px; padding: .375rem .75rem; display:inline-flex; align-items:center; }

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
              <h4 class="fw-semibold mb-8">자재 관리</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
                  <li class="breadcrumb-item" aria-current="page">MatManage</li>
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
    <div class="btn-group" role="group">
      <a href="${pageContext.request.contextPath}/admat/admatlist?statusFilter=&searchWord=${fn:escapeXml(param.searchWord)}"
         class="btn btn-outline-primary <c:if test='${empty statusFilter}'>active</c:if>">전체</a>
      <a href="${pageContext.request.contextPath}/admat/admatlist?statusFilter=normal&searchWord=${fn:escapeXml(param.searchWord)}"
         class="btn btn-outline-primary <c:if test='${statusFilter eq "normal"}'>active</c:if>">정상</a>
      <a href="${pageContext.request.contextPath}/admat/admatlist?statusFilter=shortage&searchWord=${fn:escapeXml(param.searchWord)}"
         class="btn btn-outline-primary <c:if test='${statusFilter eq "shortage"}'>active</c:if>">재고부족</a>
    </div>
  </div>

  <!-- 가운데: 유연한 공간 -->
  <div class="col"></div>

  <!-- 오른쪽: 검색 + 자재추가 (내용만큼) -->
  <div class="col-auto d-flex align-items-center gap-2 flex-nowrap">
    <!-- 검색 폼 (기본 높이 = 상태필터와 동일) -->
    <form id="searchForm"
          action="${pageContext.request.contextPath}/admat/admatlist"
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
            data-bs-toggle="modal" data-bs-target="#createMaterialModal">
      <i class="ti ti-plus me-1"></i> 자재 추가하기
    </button>
  </div>
</div>
	
      <!-- 자재 목록 테이블 -->
      <div class="card mt-2">
        <div class="table-responsive">
          <table class="table text-nowrap mb-0 align-middle" id="mtrilTable">
            <thead class="text-dark">
              <tr>
                <th><h6 class="mb-0">자재명</h6></th>
                <th><h6 class="mb-0">재고 수량</h6></th>
                <th><h6 class="mb-0">재고 상태</h6></th>
                <th><h6 class="mb-0">자재 유형</h6></th>
                <th><h6 class="mb-0">자재 설명</h6></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="mat" items="${matList}">
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <img class="mtril-avatar" src="${mat.filePath}" alt="">
                      <div class="ms-3 fw-semibold"><c:out value="${mat.mtrilNm}"/></div>
                    </div>
                  </td>

                  <td><c:out value="${mat.stock}" default="0"/></td>

                  <td>
                    <c:choose>
                      <c:when test="${mat.stockStatus eq 'normal'}">
                        <span class="badge rounded-pill bg-success-subtle text-success border border-success-subtle px-3 py-1">정상</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge rounded-pill bg-warning-subtle text-warning border border-warning-subtle px-3 py-1">재고부족</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td><c:out value="${mat.mtrilTyNm}" default="-"/></td>
                  <td><c:out value="${mat.mtrilDc}" default="-"/></td>

                  <td>
                    <div class="dropdown text-center">
                      <button class="btn p-0 bg-transparent border-0" type="button" data-bs-toggle="dropdown">
                        <i class="ti ti-dots-vertical"></i>
                      </button>
                      <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                          <button type="button" class="dropdown-item action-edit"
                                  data-id="${mat.mtrilId}"
                                  data-name="${mat.mtrilNm}"
                                  data-thumb="${mat.filePath}"
                                  data-group-no="${mat.fileGroupNo}"
                                  data-desc="${mat.mtrilDc}"
                                  data-ty="${mat.mtrilTy}"
                                  data-tynm="${mat.mtrilTyNm}"
                                  data-unit="${mat.unit}"
                                  data-unitnm="${mat.unitNm}"
                                  data-stock="${mat.stock}"
                                  data-minstock="${mat.minStock}">
                            수정
                          </button>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item text-danger btn-delete"
                                  data-bs-toggle="modal" data-bs-target="#deleteMtrilModal"
                                  data-id="${mat.mtrilId}"
                                  data-group-no="${mat.fileGroupNo}">
                            삭제
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              </c:forEach>

              <c:if test="${empty matList}">
                <tr><td colspan="6" class="text-center text-muted py-5">표시할 자재가 없습니다.</td></tr>
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
      <form id="pageForm" action="${pageContext.request.contextPath}/admat/admatlist" method="get">
        <input type="hidden" name="page" id="page">
        <input type="hidden" name="searchWord" value="${searchWord}">
        <input type="hidden" name="statusFilter" value="${statusFilter}">
      </form>

	  </div>	
    </div>
  </div>
</div>


<!-- ================== 자재 등록 모달 ================== -->
<div class="modal fade" id="createMaterialModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <form id="createMaterialForm"
            action="${pageContext.request.contextPath}/admat/insert"
            method="post" enctype="multipart/form-data">
        <div class="modal-header">
          <h5 class="modal-title">자재 등록</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
          <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
          </c:if>

          <div class="border rounded-3 p-3 bg-body mb-3">
            <div class="fw-semibold mb-3">자재 정보</div>

            <div class="mb-3">
              <label class="form-label">자재명 <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="mtrilNm" placeholder="예: 시멘트 (25kg)" required>
            </div>

            <div class="mb-3">
              <label class="form-label">자재유형 <span class="text-danger">*</span></label>
              <select class="form-select" name="mtrilTy" required>
                <option value="" hidden>카테고리를 선택하세요</option>
                <option value="16001">설비자재</option>
                <option value="16002">목자재</option>
                <option value="16003">전기자재</option>
                <option value="16004">타일자재</option>
                <option value="16005">철물자재</option>
                <option value="16006">도장자재</option>
                <option value="16007">도배자재</option>
                <option value="16008">마루자재</option>
                <option value="16009">마감자재</option>
                <option value="16010">기타소모품</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">단위 <span class="text-danger">*</span></label>
              <select class="form-select" name="unit" required>
                <option value="" hidden>단위를 선택하세요</option>
                <option value="14001">개</option>
                <option value="14002">포</option>
                <option value="14003">통</option>
                <option value="14004">롤</option>
                <option value="14005">장</option>
                <option value="14006">세트</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">재고 수량 <span class="text-danger">*</span></label>
              <input type="number" class="form-control" name="stock" value="0" min="0" required>
            </div>
            <div class="mb-3">
              <label class="form-label">최소 재고량</label>
              <input type="number" class="form-control" name="minStock" value="30" min="0">
              <div class="form-text">최소 재고량 이하로 떨어지면 재고부족으로 표시됩니다.</div>
            </div>

            <div class="mb-2">
              <label class="form-label">이미지</label>
              <div class="input-group">
                <input type="file" class="form-control" id="matImage" name="uploadFile" accept="image/*">
                <button class="btn btn-outline-secondary" type="button" id="matImageClear">업로드 취소</button>
              </div>
            </div>
            <div id="matPreviewWrap" class="d-none mb-3">
              <img id="matPreviewImg" class="rounded border" style="max-width:100%;height:auto" alt="미리보기">
            </div>

            <div class="mb-2">
              <label class="form-label">설명</label>
              <textarea class="form-control" name="mtrilDc" rows="3" placeholder="자재에 대한 상세 설명을 입력하세요..."></textarea>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
          <button type="button" id="createMaterialSubmit" class="btn btn-primary">자재 등록</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ================== 자재 수정 모달 ================== -->
<div class="modal fade" id="editMaterialModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <form id="editMaterialForm"
            action="${pageContext.request.contextPath}/admat/update"
            method="post" enctype="multipart/form-data">
        <div class="modal-header">
          <h5 class="modal-title">자재 수정</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
          <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
          </c:if>

          <!-- PK/파일그룹 -->
          <input type="hidden" name="mtrilId" id="editMtrilId">
          <input type="hidden" name="fileGroupNo" id="editFileGroupNo">

          <!-- 가운데 썸네일 1장 -->
          <div class="d-flex justify-content-center mb-3">
            <label class="profile_wrap">
              <div class="profile_label" id="editInitialUpload">
                <div class="profile_inner" style="text-align:center">
                  <i class="ti ti-camera" style="font-size:20px;display:block;margin-bottom:5px"></i>
                  <span>이미지 선택</span>
                </div>
              </div>
              <img id="editPreviewImg" src="" alt="미리보기"
                   style="display:none;width:100%;height:100%;object-fit:cover;border-radius:.75rem;">
              <input type="file" id="editUpload" name="uploadFile" accept="image/*" class="profile_input">
            </label>
          </div>
          <div class="text-center mb-3">
            <button type="button" class="btn btn-sm btn-outline-secondary" id="editUploadClear">이미지 지우기</button>
          </div>

          <!-- 폼 항목 -->
          <div class="border rounded-3 p-3 bg-body">
            <div class="mb-3">
              <label class="form-label">자재명 <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="mtrilNm" id="editMtrilNm" required>
            </div>

            <div class="mb-3">
              <label class="form-label">자재유형 <span class="text-danger">*</span></label>
              <select class="form-select" name="mtrilTy" id="editMtrilTy" required>
                <option value="" hidden>카테고리를 선택하세요</option>
                <c:forEach var="c" items="${mtrilTyList}">
                  <option value="${c.cmmnCdId}">${c.cmmnCdNm}</option>
                </c:forEach>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">단위 <span class="text-danger">*</span></label>
              <select class="form-select" name="unit" id="editUnit" required>
                <option value="" hidden>단위를 선택하세요</option>
                <c:forEach var="c" items="${unitList}">
                  <option value="${c.cmmnCdId}">${c.cmmnCdNm}</option>
                </c:forEach>
              </select>
            </div>

            <div class="row g-2">
              <div class="col-md-6">
                <label class="form-label">재고 수량 <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="stock" id="editStock" min="0" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">최소 재고량</label>
                <input type="number" class="form-control" name="minStock" id="editMinStock" min="0">
                <div class="form-text">최소 재고량 보다 부족할 시 재고부족으로 표시됩니다.</div>
              </div>
            </div>

            <div class="mt-3">
              <label class="form-label">설명</label>
              <textarea class="form-control" name="mtrilDc" id="editMtrilDc" rows="3"></textarea>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary" id="editSaveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ================== 삭제 확인 모달 ================== -->
<div class="modal fade" id="deleteMtrilModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:400px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">삭제 확인</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <form id="deleteForm" action="${pageContext.request.contextPath}/admat/delete" method="post">
        <c:if test="${not empty _csrf}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        </c:if>
        <input type="hidden" name="mtrilId" id="deleteMtrilId">
        <input type="hidden" name="fileGroupNo" id="deleteFileGroupNo">

        <div class="modal-body">
          이 자재를 정말 삭제하시겠습니까?
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
$(function () {
  /* ===== 변수 캐싱 ===== */
  let $pageForm             = $("#pageForm");
  let $page                 = $("#page");
  let $deleteForm           = $("#deleteForm");
  let $deleteConfirmBtn     = $("#deleteConfirmBtn");

  let $createMaterialForm   = $("#createMaterialForm");
  let $createMaterialModal  = $("#createMaterialModal");
  let $createMaterialSubmit = $("#createMaterialSubmit");

  let $matImage             = $("#matImage");
  let $matPreviewWrap       = $("#matPreviewWrap");
  let $matPreviewImg        = $("#matPreviewImg");
  let $matImageClear        = $("#matImageClear");

  let $editModal            = $("#editMaterialModal");

  /* ===== 페이징 ===== */
  window.fn_pagination = function (pageNo) {
    $page.val(pageNo);
    $pageForm.trigger("submit");
  };

  /* ===== 등록 이미지 미리보기 ===== */
  $matImage.on("change", function () {
    let file = this.files && this.files[0];
    if (!file) {
      $matPreviewWrap.addClass("d-none");
      $matPreviewImg.attr("src", "");
      return;
    }
    let reader = new FileReader();
    reader.onload = function (e) {
      $matPreviewImg.attr("src", e.target.result);
      $matPreviewWrap.removeClass("d-none");
    };
    reader.readAsDataURL(file);
  });

  /* ===== 이미지 선택 취소 ===== */
  $matImageClear.on("click", function () {
    $matImage.val("");
    $matPreviewImg.attr("src", "");
    $matPreviewWrap.addClass("d-none");
  });

  /* ===== 자재 등록 제출 ===== */
  $createMaterialSubmit.on("click", function () {
    if ($createMaterialForm[0].checkValidity()) {
      $createMaterialSubmit.prop("disabled", true);
      $createMaterialForm.trigger("submit");
      let modal = bootstrap.Modal.getInstance($createMaterialModal[0]);
      modal && modal.hide();
    } else {
      $createMaterialForm[0].reportValidity();
    }
  });

  /* ===== 모달 닫힐 때 폼 리셋 ===== */
  $createMaterialModal.on("hidden.bs.modal", function () {
    $createMaterialForm[0].reset();
    $matPreviewImg.attr("src", "");
    $matPreviewWrap.addClass("d-none");
    $createMaterialSubmit.prop("disabled", false);
  });

  /* ===== 자재 수정 모달 바인딩 ===== */
  $(document).on("click", ".action-edit", function () {
    let id       = $(this).data("id");
    let name     = $(this).data("name");
    let thumb    = $(this).data("thumb") || "";
    let groupNo  = $(this).data("group-no") || "";
    let desc     = $(this).data("desc") || "";
    let ty       = $(this).data("ty") || "";
    let unit     = $(this).data("unit") || "";
    let stock    = $(this).data("stock");
    let minStock = $(this).data("minstock");

    // 원본 썸네일 보관 (이미지 지우기 시 복원용)
    $editModal.data("orig-thumb", thumb);

    // 값 채우기
    $("#editMtrilId").val(id);
    $("#editFileGroupNo").val(groupNo);
    $("#editMtrilNm").val(name);
    $("#editMtrilDc").val(desc);
    $("#editMtrilTy").val(ty);
    $("#editUnit").val(unit);
    $("#editStock").val((stock ?? 0));
    $("#editMinStock").val((minStock ?? 30));

    // 썸네일
    let $img  = $("#editPreviewImg");
    let $init = $("#editInitialUpload");
    if (thumb) { $img.attr("src", thumb).show(); $init.hide(); }
    else { $img.attr("src", "").hide(); $init.show(); }

    // 파일 인풋 초기화
    $("#editUpload").val("");

    // 모달 오픈
    let modal = new bootstrap.Modal(document.getElementById("editMaterialModal"));
    modal.show();
  });

  /* ===== 수정 모달: 파일 미리보기 / 초기화 ===== */
  $("#editUpload").on("change", function () {
    let file = this.files && this.files[0];
    if (!file) return;
    let reader = new FileReader();
    reader.onload = e => {
      $("#editPreviewImg").attr("src", e.target.result).show();
      $("#editInitialUpload").hide();
    };
    reader.readAsDataURL(file);
  });

  // 새로 선택한 파일만 취소하고, 기존 썸네일로 복원(없으면 프롬프트 표시)
  $("#editUploadClear").on("click", function () {
    $("#editUpload").val("");
    let orig = $editModal.data("orig-thumb") || "";
    if (orig) {
      $("#editPreviewImg").attr("src", orig).show();
      $("#editInitialUpload").hide();
    } else {
      $("#editPreviewImg").attr("src", "").hide();
      $("#editInitialUpload").show();
    }
  });

  /* ===== 삭제 모달 바인딩 ===== */
  $(document).on("click", ".btn-delete", function () {
    $("#deleteMtrilId").val($(this).data("id"));
    $("#deleteFileGroupNo").val($(this).data("group-no") || 0);
  });
  $deleteConfirmBtn.on("click", function () {
    $deleteConfirmBtn.prop("disabled", true);
    $deleteForm[0].submit();
  });
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
