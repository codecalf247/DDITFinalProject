<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <style>
    /* 상단 툴바 정렬 */
    #toolbarRow { gap: .5rem; }
    #catTabs { max-width: 520px; white-space: nowrap; }
    #catTabs .nav-link { white-space: nowrap; }

    /* ====== 행 Hover 가시성 강화 ====== */
    /* table-hover가 있어도 테마/오버라이드 때문에 연해질 수 있어 보정 */
    .table.table-hover > tbody > tr:hover:not(.empty-row) > * {
      background-color: rgba(13,110,253,.06) !important; /* Bootstrap primary의 아주 연한 톤 */
      transition: background-color .12s ease;
      cursor: pointer;
    }
    
    /* 각 탭의 페이징 영역 */
    .pagination-container { display: flex; justify-content: center; margin-top: 1rem; }
  </style>
</head>
<%@ include file="/module/header.jsp" %>

<body>

  <div class="body-wrapper">
    <div class="container-fluid"> 
      <div class="body-wrapper">
        <div class="container">
        
        
            <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			  <div class="card-body px-4 py-3">
			    <div class="row align-items-center">
			      <div class="col-9">
			        <h4 class="fw-semibold mb-8">프로젝트</h4>
			        <nav aria-label="breadcrumb">
			          <ol class="breadcrumb">
			            <li class="breadcrumb-item">
			              <a class="text-muted text-decoration-none" href="/main/dashboard">Home</a>
			            </li>
			            <li class="breadcrumb-item">
			              <a class="text-muted text-decoration-none" href="/project/dashboard?prjctNo=${project.prjctNo}">Project</a>
			            </li>
			            <li class="breadcrumb-item" aria-current="page">Project Library</li>
			          </ol>
			        </nav>
			      </div>
			    </div>
			  </div>
			</div>
        
          <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

          <c:set var="uri" value="${pageContext.request.requestURI}" />

          <div class="d-flex align-items-center flex-nowrap gap-2 mb-3" id="toolbarRow">
            <ul class="nav nav-pills flex-nowrap overflow-auto me-2" id="catTabs" role="tablist">
			  <li class="nav-item">
			    <a class="nav-link active" data-bs-toggle="tab" href="#tab-2d" role="tab" data-file-ty="2D" data-page="1">
			      <i class="ti ti-file"></i> <span>2D 자료</span>
			    </a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-bs-toggle="tab" href="#tab-3d" role="tab" data-file-ty="3D" data-page="1">
			      <i class="ti ti-file"></i> <span>3D 자료</span>
			    </a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-bs-toggle="tab" href="#tab-field" role="tab" data-file-ty="FIELD" data-page="1">
			      <i class="ti ti-file"></i> <span>현장 자료</span>
			    </a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-bs-toggle="tab" href="#tab-etc" role="tab" data-file-ty="ETC" data-page="1">
			      <i class="ti ti-folder"></i> <span>참고 자료</span>
			    </a>
			  </li>
			</ul>

            <div class="input-group ms-auto me-2" style="max-width: 400px; min-width: 240px;">
              <input type="text" class="form-control" id="fileSearchInput" placeholder="검색어를 입력하세요">
              <button class="btn btn-outline-secondary" type="button" id="btnDoSearch">검색</button>
            </div>

           <%-- [수정 시작] 자료 등록 버튼 권한 제어 로직 --%>
            <sec:authentication property="principal.member" var="loginUser"/>
            <c:set var="ADMIN_EMP_NO" value="202508001" />
            <c:set var="loginEmpNo" value="${loginUser.empNo}" />

            <%-- 1. 관리자 여부 확인 --%>
            <c:set var="isAdmin" value="${loginEmpNo eq ADMIN_EMP_NO}" />

            <%-- 2. 담당자 여부 확인 --%>
            <c:set var="isManager" value="false" />
            <c:forEach var="ptcpnt" items="${project.participantsList}">
                <c:if test="${ptcpnt.empNo eq loginEmpNo}">
                    <c:set var="isManager" value="true" />
                </c:if>
            </c:forEach>

            <%-- 관리자이거나 프로젝트 담당자일 경우에만 자료 등록 버튼 표시 --%>
            <c:if test="${isAdmin or isManager}">
	            <a href="${pageContext.request.contextPath}/project/filesInsert?prjctNo=${project.prjctNo}" class="btn btn-success" id="uploadBtn">
	              자료 등록
	            </a>
            </c:if>
            <%-- [수정 끝] 자료 등록 버튼 권한 제어 로직 --%>
          </div>

          <div class="tab-content border rounded-3 p-3">
		    <div class="tab-pane fade show active" id="tab-2d" role="tabpanel">
		        <table class="table table-hover text-nowrap mb-0 align-middle">
		            <thead class="text-dark fs-4">
		                <tr>
		                    <th><h6 class="fs-4 fw-semibold mb-0">No</h6></th>
		                    <th><h6 class="fs-4 fw-semibold mb-0">File Title</h6></th>
		                    <th><h6 class="fs-4 fw-semibold mb-0">User</h6></th>
		                    <th><h6 class="fs-4 fw-semibold mb-0">Date</h6></th>
		                    <th><h6 class="fs-4 fw-semibold mb-0">Type</h6></th>
		                </tr>
		            </thead>
               
               <tbody id="fileTableBody-2d"></tbody>
              </table>
              <div class="pagination-container" id="paging-2d"></div>
            </div>

            <div class="tab-pane fade" id="tab-3d" role="tabpanel">
              <table class="table table-hover text-nowrap mb-0 align-middle">
                <thead class="text-dark fs-4">
                  <tr>
                    <th><h6 class="fs-4 fw-semibold mb-0">No</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">File Title</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">User</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Date</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Type</h6></th>
                  </tr>
                </thead>
                <tbody id="fileTableBody-3d"></tbody>
              </table>
              <div class="pagination-container" id="paging-3d"></div>
            </div>
            
             <div class="tab-pane fade" id="tab-field" role="tabpanel">
              <table class="table table-hover text-nowrap mb-0 align-middle">
                <thead class="text-dark fs-4">
                  <tr>
                    <th><h6 class="fs-4 fw-semibold mb-0">No</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">File Title</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">User</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Date</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Type</h6></th>
                  </tr>
                </thead>
                <tbody id="fileTableBody-field"></tbody>
              </table>
              <div class="pagination-container" id="paging-field"></div>
            </div>
            

            <div class="tab-pane fade" id="tab-etc" role="tabpanel">
              <table class="table table-hover text-nowrap mb-0 align-middle">
                <thead class="text-dark fs-4">
                  <tr>
                    <th><h6 class="fs-4 fw-semibold mb-0">No</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">File Title</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">User</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Date</h6></th>
                    <th><h6 class="fs-4 fw-semibold mb-0">Type</h6></th>
                  </tr>
                </thead>
                <tbody id="fileTableBody-etc"></tbody>
              </table>
              <div class="pagination-container" id="paging-etc"></div>
            </div>
          </div>
        </div>
      </div>
      
    </div>
  </div>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
 <script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

 <%@ include file="/module/footerPart.jsp" %>

  <script>
$(function () {
  /* ========================= A. 헬퍼/선택자 ========================= */
  var SEL = {
    tabPane: '.tab-pane',
    tabTrigger: 'a[data-bs-toggle="tab"]',
    searchInput: '#fileSearchInput',
    searchBtn: '#btnDoSearch',
    tableBodies: "[id^='fileTableBody-']",
    paginationContainer: '.pagination-container'
  };

  function getActiveSuffix() {
    var $pane = $(SEL.tabPane + '.active');
    return $pane.length ? $pane.attr('id').replace('tab-', '') : '';
  }
  function getSuffixFromHref(href) { return href.replace('#tab-', ''); }

  /* =================== B. 빈 상태(모든 탭 공통) =================== */
  function ensureEmptyRow($tbody) {
    if ($tbody.find('tr.empty-row').length === 0) {
      var colCount = $tbody.closest('table').find('thead th').length || 5;
      var html = ''
        + '<tr class="empty-row d-none">'
        + '  <td colspan="' + colCount + '" class="text-center text-muted py-5">'
        + '    등록된 자료가 없습니다.'
        + '  </td>'
        + '</tr>';
      $tbody.append(html);
    }
  }
  function updateEmptyStateForTbody($tbody) {
    ensureEmptyRow($tbody);
    var visibleRows = $tbody.find('tr').not('.empty-row').filter(':visible').length;
    $tbody.find('tr.empty-row').toggleClass('d-none', visibleRows > 0);
  }

  /* ========== F. 공통 렌더러 & 탭 AJAX 로드 ========== */
  function renderTable(pagingVO, $tbody) {
    $tbody.empty();
    var fileList = pagingVO.dataList;
    if (fileList && fileList.length > 0) {
      $.each(fileList, function (i, file) {
        var row = ''
          + '<tr data-prjct-file-no="' + file.prjctFileNo + '">'
          + '  <td><div class="fw-semibold">' + (pagingVO.totalRecord - pagingVO.startRow + 1 - i) + '</div></td>'
          + '  <td>'
          + '    <div class="d-flex align-items-center">'
          + '      <span class="round-40 bg-primary-subtle text-primary d-flex align-items-center justify-content-center rounded-circle me-3">'
          + '        <i class="ti ti-file-spreadsheet fs-6"></i>'
          + '      </span>'
          + '      <div>'
          + '        <h6 class="fs-4 fw-semibold mb-0">' + file.fileTitle + '</h6>'
          + '        <span class="text-muted small">' + (file.originalNm || '') + '</span>'
          + '      </div>'
          + '    </div>'
          + '  </td>'
          + '  <td><div class="fw-semibold">' + (file.empNm || '') + '</div></td>'
          + '  <td><span class="text-muted">' + (file.fileRegDt || '') + '</span></td>'
          + '  <td><div class="fw-semibold">' + file.fileTy + '</div></td>'
          + '</tr>';
        $tbody.append(row);
      });
    }
    updateEmptyStateForTbody($tbody);
  }

  function renderPagination(pagingVO, $container) {
	  // 안전 범위 보정
	  $container.html(pagingVO.pagingHTML);
	}

  
  function loadTab(targetPage) {
	  const $activeTab = $(SEL.tabTrigger + '.active');
      var fileTy = $activeTab.data('file-ty');
      var suf = getSuffixFromHref($activeTab.attr('href'));
      var $tbody = $('#fileTableBody-' + suf);
      var $paging = $('#paging-' + suf);
      var prjctNo = "${project.prjctNo}";
      var searchWord = $("#fileSearchInput").val();

      $.ajax({
        url: "${pageContext.request.contextPath}/project/filesAjax",
        type: "GET",
        data: { prjctNo: prjctNo, fileTy: fileTy, currentPage: targetPage, searchWord: searchWord },
        dataType: "json",
        success: function (data) {
          renderTable(data, $tbody);
          renderPagination(data, $paging);
        },
        error: function () { alert("자료를 불러오는 중 오류가 발생했습니다."); }
      });
  }
  
  // 탭 클릭 시 로드
  $(document).on('shown.bs.tab', SEL.tabTrigger, function() {
      // 탭 전환 시 항상 1페이지 로드
      loadTab(1);
  });
  
  // 페이지네이션 링크 클릭 시 로드
  $(document).on('click', '.pagination-container .page-link', function(e) {
      e.preventDefault();
      var newPage = $(this).data('page');
      if (newPage) {
          loadTab(newPage);
      }
  });

  // 검색 버튼 클릭 시 로드
  $(SEL.searchBtn).on('click', function(){
      loadTab(1); // 검색 시 항상 1페이지부터 시작
  });
  
  // 검색창에서 Enter 키 입력 시 로드
  $(SEL.searchInput).on('keyup', function(e){
      if(e.key === 'Enter') {
          loadTab(1); // 검색 시 항상 1페이지부터 시작
      }
  });

  /* ========== G. 행 클릭 → 상세 페이지 이동 ========== */
  $(document).on("click", "#fileTableBody-2d tr, #fileTableBody-3d tr, #fileTableBody-field tr, #fileTableBody-etc tr", function (e) {
    // 버튼 클릭은 제외하고 상세 페이지로 이동
    if ($(e.target).closest('.btn-group').length) return;
    const prjctFileNo = $(this).data("prjct-file-no");
    if (prjctFileNo) {
      window.location.href = "${pageContext.request.contextPath}/project/filesDetail?prjctFileNo=" + prjctFileNo;
    }
  });

  /* ========== H. 초기 로드: 현재 활성 탭 데이터를 즉시 불러옴 ========== */
  var $activeTab = $('a[data-bs-toggle="tab"].active');
  if (!$activeTab.length) {
    $activeTab = $(SEL.tabTrigger).first().addClass('active');
    $($(SEL.tabTrigger).first().attr('href')).addClass('show active');
  }
  loadTab(1);
});
</script>

</body>
</html>