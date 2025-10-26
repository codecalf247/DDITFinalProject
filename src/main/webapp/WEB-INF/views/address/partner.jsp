<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <%@ include file="/module/header.jsp" %>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<style>
  .list-group-item .menu-link { display:flex; align-items:center; }
  .list-group-item .menu-link i { font-size:1.2rem; margin-right:7px; }
  .w-30 { width:30%; } @media (max-width: 992px){ .w-30{ width:100%; } }
  .table td, .table th { vertical-align:middle !important; }
  .upload-box{
    border:1px dashed var(--bs-border-color,#e5e7eb);
    border-radius:.75rem; background:var(--bs-body-bg);
    width:140px; height:140px; display:flex; align-items:center; justify-content:center; cursor:pointer;
  }
  .upload-box:hover{ background:rgba(93,135,255,.06); }
  .search-compact .input-group { width:260px; }
  @media (max-width: 576px){ .search-compact .input-group { width:100%; } }
</style>

<body>
<%@ include file="/module/aside.jsp" %>

<c:if test="${not empty message}">
<script>
  document.addEventListener('DOMContentLoaded', function(){
    const msg  = "<c:out value='${message}'/>";
    const icon = /완료|성공|등록/.test(msg) ? "success" : "error";
    Swal.fire({ title: msg, icon: icon });
  });
</script>
</c:if>

<div class="body-wrapper">
  <div class="container-fluid">

<div class="body-wrapper">
  <div class="container">
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">업체 주소록</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Address</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <div class="card overflow-hidden chat-application">

      <div class="d-flex w-100">
        <!-- Left rail -->
        <div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
          <div class="px-6 pt-4">
            <div class="card">
              <div class="card-header">
                <div class="d-flex align-items-center">
                  <h6 class="card-title lh-base mb-0">주소록</h6>
                </div>
                <div class="row px-6 pt-2">
                  ${empInfo.empNm} (${empInfo.deptNm} ${empInfo.jbgdNm})
                </div>
              </div>
            </div>
          </div>

          <ul class="list-group list-group-menu mh-n100">
            <li class="border-bottom my-3"></li>
            <li class="list-group-item has-submenu">
              <a class="menu-link" href="#">
                <i class="ti ti-address-book fs-5"></i>
                주소록
                <i class="ti ti-chevron-right menu-toggle"></i>
              </a>
              <ul class="submenu">
                <li class="list-group-item">
                  <a class="menu-link" href="${pageContext.request.contextPath}/address/board">
                    <i class="ti ti-users fs-5 me-2"></i>사내주소록
                  </a>
                </li>
                <li class="list-group-item">
                  <a class="menu-link" href="${pageContext.request.contextPath}/address/partner">
                    <i class="ti ti-building fs-5 me-2"></i>업체주소록
                  </a>
                </li>
              </ul>
            </li>
          </ul>
        </div>

        <!-- Main content -->
        <div class="d-flex w-100">
          <div class="w-100 p-3">

            <!-- 액션/검색 -->
            <div class="d-flex align-items-center gap-2 mb-2 toolbar-compact">
              <!-- 검색영역 + 등록 버튼을 같은 줄에 배치 -->
              <div class="ms-auto d-flex align-items-center gap-2 flex-wrap search-compact">
                <form id="searchForm"
                      action="${pageContext.request.contextPath}/address/partner"
                      method="get"
                      class="d-flex align-items-center gap-2 flex-wrap">

                  <div class="btn-group">
                    <button id="searchTypeBtn" type="button"
                            class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                            data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      <c:choose>
                        <c:when test="${searchType eq 'ccpyNm'}">협력업체명</c:when>
                        <c:when test="${searchType eq 'chargerNm'}">담당자명</c:when>
                        <c:otherwise>전체</c:otherwise>
                      </c:choose>
                    </button>

                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" data-search-type="all" href="#">전체</a></li>
                      <li><a class="dropdown-item" data-search-type="ccpyNm" href="#">협력업체명</a></li>
                      <li><a class="dropdown-item" data-search-type="chargerNm" href="#">담당자명</a></li>
                    </ul>
                  </div>

                  <input type="hidden" name="searchType" id="hiddenSearchType" value="${empty searchType ? 'all' : searchType}">

                  <div class="input-group w-80">
                    <input type="text" name="searchWord" class="form-control" value="${searchWord}" placeholder="검색어 입력">
                    <button class="btn btn-outline-secondary" type="submit" title="검색">
                      <i class="ti ti-search"></i>
                      <span class="d-none d-sm-inline ms-1">검색</span>
                    </button>
                  </div>

                  <!-- 등록하기 버튼 (검색 옆) -->
                  <button type="button" class="btn btn-primary ms-2" id="addBtn">
                    <i class="ti ti-plus me-1"></i>등록하기
                  </button>
                </form>
              </div>
            </div>

            <!-- ▼▼▼ 협력업체 주소록 ▼▼▼ -->
            <div>
              <table class="table align-middle text-nowrap mb-0" id="partnerTable">
                <thead class="bg-body-tertiary">
                  <tr>
                    <th style="width:280px;">협력업체명</th>
                    <th style="width:180px;">담당자명</th>
                    <th style="width:280px;">이메일</th>
                    <th class="text-center" style="width:120px;">업체분류</th>
                    <th style="width:220px;">전화번호</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="ccpy" items="${ccpyList}" varStatus="vs">
                    <tr data-id="${ccpy.ccpyNo}">
                      <td class="cell-company">
                        <div class="d-flex align-items-center gap-2">
                          <c:set var="logo" value="${empty ccpy.ccpyImagePath ? pageContext.request.contextPath.concat('/resources/assets/images/profile/user-1.jpg') : ccpy.ccpyImagePath}" />
                          <img src="${logo}" alt="${ccpy.ccpyNm}" class="rounded-circle" style="width:36px;height:36px;object-fit:cover;">
                          <span class="cell-company-name">${ccpy.ccpyNm}</span>
                        </div>
                      </td>
                      <td class="cell-manager-name">${ccpy.chargerNm}</td>
                      <td class="cell-email">${ccpy.ccpyEmail}</td>
                      <td class="text-center cell-category"><c:out value="${ccpy.ccpyTy}" /></td>
                      <td class="cell-phone">
                        <div class="d-flex align-items-center justify-content-between">
                          <span>${ccpy.chargerTelno}</span>
                          <div class="dropdown ms-2">
                            <button class="btn p-0 bg-transparent border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false" title="메뉴">
                              <i class="ti ti-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-portal">
                              <li><button type="button" class="dropdown-item btn-edit">수정</button></li>
                              <li><button type="button" class="dropdown-item text-danger btn-delete">삭제</button></li>
                            </ul>
                          </div>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>

                  <c:if test="${empty ccpyList}">
                    <tr><td colspan="5" class="text-center text-muted py-5">표시할 업체가 없습니다.</td></tr>
                  </c:if>
                </tbody>
              </table>
            </div>

            <!-- 페이지네이션 (여백 추가: mt-3) -->
            <div class="flex-grow-1 d-flex justify-content-center mt-3">
              <div class="d-flex align-items-center">
                ${pagingVO.pagingHTML2}
              </div>
            </div>

            <!-- 페이징용 히든 폼 -->
            <form id="pageForm" action="${pageContext.request.contextPath}/address/partner" method="get">
              <input type="hidden" name="page" id="page">
              <input type="hidden" name="searchType" value="${empty searchType ? 'all' : searchType}">
              <input type="hidden" name="searchWord" value="${searchWord}">
            </form>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
  </div><!-- /.container-fluid -->
</div><!-- /.body-wrapper -->

<!-- 등록 모달 -->
<div class="modal fade" id="partnerCreateModal" tabindex="-1" aria-labelledby="partnerCreateLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content border-2" style="box-shadow:0 0 0 3px rgba(93,135,255,.35);">
      <div class="modal-header">
        <h5 class="modal-title fw-bold">협력업체 <span id="partnerCreateLabel">등록</span></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="partnerCreateForm" autocomplete="off" enctype="multipart/form-data" action="/address/partner/insert" method="post">
      	<input type="hidden" name="ccpyNo" id="createCcpyNo"> 
        <div class="modal-body">
          <div class="row g-4">
		   	<div class="col-md-3 d-flex justify-content-center">
			    <label class="upload-box" for="uploadFile">
			        <div id="initial-upload" class="text-center">
			            <i class="ti ti-camera fs-3 d-block mb-2"></i>
			            <span class="small text-muted">회사 로고</span>
			        </div>
			        <img id="uploadFile-preview" class="img-fluid" style="display: none; max-width: 140px; max-height: 140px; object-fit: cover; border-radius: .75rem;">
			    </label>
			    <input type="file" id="uploadFile" name="uploadFile" style="display: none;">
			</div>
            <div class="col-md-9">
              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label">협력업체명 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="createCompany" name="ccpyNm" placeholder="협력업체명을 입력하세요" required>
                </div>
                <div class="col-md-6">
                  <label class="form-label">담당자명 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="createManager" name="chargerNm" placeholder="담당자명을 입력하세요" required>
                </div>
                <div class="col-md-6">
                  <label class="form-label">이메일</label>
                  <input type="email" class="form-control" id="createEmail" name="ccpyEmail" placeholder="example@company.com">
                </div>
                <div class="col-md-6">
                  <label class="form-label">연락처</label>
                  <input type="text" class="form-control" id="createPhone" name="chargerTelno" placeholder="01000000000">
                </div>
                <div class="col-md-6">
                  <label class="form-label">업체분류</label>
                  <select class="form-select" id="createCategory" name="ccpyTy">
                    <option value="" selected disabled>업체분류를 선택하세요</option>
                    <c:forEach var="type" items="${commonList}">
                      <option value="${type.cmmnCdId}">${type.cmmnCdNm}</option>
                    </c:forEach>
                  </select>
                </div>
              </div>
            </div>
          </div><!-- /row -->
        </div>
        <div class="modal-footer">
          <button type="button" class="btn bg-secondary-subtle text-secondary" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary" id="partnerCreateBtn">등록</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<script type="text/javascript">
$(function(){
	let addBtn = $("#addBtn");
	let editBtn = $(".btn-edit");
	let delBtn = $(".btn-delete");
	let partnerCreateModal = $("#partnerCreateModal");
	let partnerCreateLabel = $("#partnerCreateLabel"); 
	let partnerCreateBtn = $("#partnerCreateBtn");
	let partnerCreateForm = $("#partnerCreateForm");

	// 모달 영역 내 Element들
	let createCcpyNo = $("#createCcpyNo"); 
	let createCompany = $("#createCompany"); 
	let createManager = $("#createManager"); 
	let createEmail = $("#createEmail"); 
	let createPhone = $("#createPhone"); 
	let createCategory = $("#createCategory"); 

	// 검색 드롭다운
	document.querySelectorAll('.dropdown-menu .dropdown-item').forEach(item => {
	  item.addEventListener('click', function (e) {
	    const type = this.getAttribute('data-search-type');
	    if (!type) return;
	    e.preventDefault();
	    document.getElementById('searchTypeBtn').textContent = this.textContent.trim();
	    document.getElementById('hiddenSearchType').value = type;
	  });
	});

	// 페이지네이션
	window.fn_pagination = function (pageNo) {
	  const pageForm = document.getElementById('pageForm');
	  document.getElementById('page').value = pageNo;
	  pageForm.submit();
	};

	// 등록 모달 열기
	addBtn.on("click", function(){
		partnerCreateModal.modal("show");
		createCcpyNo.remove();
		partnerCreateLabel.text("등록");
		partnerCreateBtn.text("등록");
		createCompany.val("");
		createManager.val(""); 
		createEmail.val("");
		createPhone.val("");
	});

	// 수정 모달 열기
	editBtn.on("click", function(){
		partnerCreateModal.modal("show");
		partnerCreateLabel.text("수정");
		partnerCreateBtn.text("수정");
		createCcpyNo.show();

		let ccpyId = $(this).parents("tr").data("id");
		$.ajax({
			url : "/address/partner/" + ccpyId,
			type : "post",
			data : JSON.stringify({ ccpyId }),
			contentType : "application/json; charset=utf-8",
			success : function(res){
				createCcpyNo.val(res.ccpyNo);
				createCompany.val(res.ccpyNm);
				createManager.val(res.chargerNm); 
				createEmail.val(res.ccpyEmail);
				createPhone.val(res.chargerTelno);
				$("#createCategory option").each(function(){
					this.selected = (this.value == res.ccpyTy);
				});
			}
		});
	});

	// 등록/수정 실행
	partnerCreateBtn.on("click", function(){
		let createCompanyVal = createCompany.val(); 
		let createManagerVal = createManager.val(); 
		let createEmailVal = createEmail.val(); 
		let createPhoneVal = createPhone.val();
		let createCategoryVal = createCategory.val();

		if(!createCompanyVal){ alert("협력업체명을 입력해주세요!"); return; }
		if(!createManagerVal){ alert("담당자명을 입력해주세요!"); return; }
		if(!createEmailVal){ alert("이메일을 입력해주세요!"); return; }
		if(!createPhoneVal){ alert("핸드폰을 입력해주세요!"); return; }

		const isEdit = $(this).text().trim() === "수정";
		if (isEdit) {
		  const fd = new FormData(partnerCreateForm[0]);
		  $.ajax({
		    url: "/address/partner/update",
		    type: "POST",
		    data: fd,
		    processData: false,
		    contentType: false,
		    success: function () {
		      Swal.fire({ title: '수정되었습니다.', icon: 'success' }).then(() => {
		        partnerCreateModal.modal('hide');
		        $("#pageForm").trigger("submit");
		      });
		    },
		    error: function (xhr) {
		      Swal.fire('수정 실패', '서버 오류가 발생했습니다. (' + xhr.status + ')', 'error');
		    }
		  });
		  return;
		}
		partnerCreateForm.submit();
	});

	// 삭제
	delBtn.on("click", function () {
	  const ccpyId = $(this).parents("tr").data("id");
	  const rowCountBefore = $("#partnerTable tbody tr").length;
	  const currentPage = Number("<c:out value='${pagingVO.currentPage}' default='1'/>");

	  Swal.fire({
	    title: '삭제하시겠습니까?',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonText: '네',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (!result.isConfirmed) return;

	    $.ajax({
	      url: "/address/partner/delete/" + ccpyId,
	      type: "POST",
	      contentType: "application/json; charset=utf-8",
	      dataType: "text",
	      data: JSON.stringify({ ccpyNo: ccpyId }),
	      success: function (res) {
	        if ((res || "").trim().toUpperCase() === "OK") {
	          const nextPage = (rowCountBefore <= 1 && currentPage > 1) ? currentPage - 1 : currentPage;
	          Swal.fire({ title: '삭제되었습니다.', icon: 'success' }).then(() => {
	            $("#page").val(nextPage);
	            $("#pageForm").trigger("submit");
	          });
	        } else {
	          Swal.fire('삭제 실패', '응답이 예상과 다릅니다: ' + res, 'error');
	        }
	      },
	      error: function (xhr) {
	        Swal.fire('삭제 실패', '서버 오류가 발생했습니다. (' + xhr.status + ')', 'error');
	      }
	    });
	  });
	});

  // 로고 미리보기
  const fileInput = document.getElementById('uploadFile');
  const initialUpload = document.getElementById('initial-upload');
  const previewImage = document.getElementById('uploadFile-preview');
  fileInput.addEventListener('change', function(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        previewImage.src = e.target.result;
        previewImage.style.display = 'block';
        initialUpload.style.display = 'none';
      };
      reader.readAsDataURL(file);
    } else {
      previewImage.src = '';
      previewImage.style.display = 'none';
      initialUpload.style.display = 'block';
    }
  });

  /* =========================
     전화번호 화면 표기 포맷 (지역번호 특수처리 없음)
     11자리 -> 3-4-4, 10자리 -> 3-3-4, 그 외: 원본 유지
     ========================= */
  function formatMobile(raw) {
    if (!raw) return '';
    const s = String(raw).replace(/\D/g, '');
    if (s.length === 11) return s.replace(/^(\d{3})(\d{4})(\d{4})$/, '$1-$2-$3');
    if (s.length === 10) return s.replace(/^(\d{3})(\d{3})(\d{4})$/, '$1-$2-$3');
    return raw; // 길이가 다르면 그대로
  }

  // 테이블 표시값만 포맷
  document.querySelectorAll('#partnerTable .cell-phone span').forEach(function(el){
    el.textContent = formatMobile(el.textContent);
  });

});
</script>
</body>
</html>
