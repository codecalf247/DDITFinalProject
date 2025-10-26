<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>


<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">


<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare - 프로젝트 목록</title>


<%@ include file="/module/headPart.jsp"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">

</head>

<%@ include file="/module/header.jsp"%>
<body>
	<%@ include file="/module/aside.jsp"%>

	<div class="body-wrapper">
		<div class="container-fluid">
			<style>

/* SweetAlert2를 Bootstrap 모달보다 위로 */
.swal2-container {
	z-index: 20000 !important;
}

.proj-card .card-body {
	line-height: 1.4;
}
/* 테마 대응: 라이트/다크 자동 전환 */
.proj-meta {
	font-size: .9rem;
	color: var(--bs-secondary-color);
}

.proj-meta b {
	color: var(--bs-body-color);
}

.title-part-padding {
	padding: .5rem 0;
}

#catTabs .nav-link {
	white-space: nowrap;
}
/* 카드 전체 클릭 표시 */
.clickable-card {
	cursor: pointer;
}
</style>

			<div class="body-wrapper">
				<div class="container">
					<!-- 상단 브레드크럼 -->
					<div
						class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">프로젝트</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a
												class="text-muted text-decoration-none"
												href="/main/dashboard">Home</a></li>
											<li class="breadcrumb-item" aria-current="page">Project
												List</li>
										</ol>
									</nav>
								</div>
							</div>
						</div>
					</div>

					<!-- Toolbar -->
					<div class="d-flex align-items-center flex-nowrap gap-2 mb-3" id="toolbarRow">
						<ul class="nav nav-pills flex-nowrap overflow-auto me-2" id="catTabs" role="tablist">
							<li class="nav-item">
									<a class="nav-link active" data-status="진행중" href="javascript:void(0)" role="tab"> 
									<i class="ti ti-user"></i> 
									<span>진행중</span>
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" data-status="완료" href="javascript:void(0)" role="tab"> 
									<i class="ti ti-users">
									</i>
									<span>완료</span>
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" data-status="보류" href="javascript:void(0)" role="tab"> 
								<i class="ti ti-folder"></i> 
								<span>보류</span>
							</a></li>
						</ul>

						<div class="input-group ms-auto me-2"
							style="max-width: 400px; min-width: 240px;">
							<input type="text" class="form-control" id="fileSearchInput"
								placeholder="검색어를 입력하세요">
							<button class="btn btn-outline-secondary" type="button"
								id="btnDoSearch">검색</button>
						</div>
						<sec:authorize access="hasRole('ROLE_MANAGER')">
						<button type="button" class="btn btn-success" id="uploadBtn"
							data-bs-toggle="modal" data-bs-target="#projectCreateModal">
							프로젝트 등록</button>
					</sec:authorize>
					</div>

					<!-- Section Title -->
					<div class="row">
						<div class="col-12">
							<div
								class="d-flex border-bottom title-part-padding px-0 mb-3 align-items-center">
								<h4 class="mb-0 fs-5">프로젝트 목록</h4>
							</div>
						</div>
					</div>

					<!-- Cards Grid -->
					<div class="row g-3" id="projectGrid">

						<c:forEach var="project" items="${projectList}">
							<div class="col-md-4 d-flex align-items-stretch proj-card"
								data-status="${fn:trim(project.prjctSttus)}"
								data-title="${project.sptNm}">
								<div class="card w-100 shadow card-hover clickable-card"
									data-href="/project/dashboard?prjctNo=${project.prjctNo}"
									role="button">
									<div  class="card-header text-bg-${project.prjctSttus == '진행중' ? 'info' : (project.prjctSttus == '완료' ? 'success' : 'warning')}">
										<h4
											class="mb-0 text-white card-title d-flex align-items-center justify-content-between">
											<span>${project.sptNm}</span> <i
												class="ti ti-arrow-right fs-8 opacity-75"></i>
										</h4>
									</div>
									<div class="card-body">
										<div class="proj-meta mb-2">
											  <b class="me-1">담당:</b>
											  <c:choose>
											    <c:when test="${empty project.participantsList}">
											      <span class="text-muted">담당자 없음</span>
											    </c:when>
											
											    <c:otherwise>
											      <%-- 이미 출력한 부서들을 콤마로 감싼 문자열로 관리 --%>
											      <c:set var="printedDepts" value="," scope="page" />
											      <c:set var="plist" value="${project.participantsList}" />
											
											      <%-- 1) DESIGN 먼저 --%>
											      <c:forEach var="a" items="${plist}">
											        <c:if test="${a.prjctPrtcpntType eq 'DESIGN'}">
											          <c:set var="dept" value="${a.deptNm}" />
											          <c:set var="needle" value=",${dept}," />
											          <c:if test="${not empty dept and not fn:contains(printedDepts, needle)}">
											            <span class="mb-1 badge bg-secondary-subtle text-secondary">
											              <strong>${fn:escapeXml(dept)}</strong>
											            </span>
											            <c:set var="printedDepts" value="${printedDepts}${dept}," scope="page" />
											          </c:if>
											        </c:if>
											      </c:forEach>
											
											      <%-- 2) FIELD 다음 --%>
											      <c:forEach var="a" items="${plist}">
											        <c:if test="${a.prjctPrtcpntType eq 'FIELD'}">
											          <c:set var="dept" value="${a.deptNm}" />
											          <c:set var="needle" value=",${dept}," />
											          <c:if test="${not empty dept and not fn:contains(printedDepts, needle)}">
											            <span class="mb-1 badge bg-danger-subtle text-danger">
											              <strong>${fn:escapeXml(dept)}</strong>
											            </span>
											            <c:set var="printedDepts" value="${printedDepts}${dept}," scope="page" />
											          </c:if>
											        </c:if>
											      </c:forEach>
											
											      <%-- 3) 나머지 팀 --%>
											      <c:forEach var="a" items="${plist}">
											        <c:if test="${a.prjctPrtcpntType ne 'DESIGN' and a.prjctPrtcpntType ne 'FIELD'}">
											          <c:set var="dept" value="${a.deptNm}" />
											          <c:set var="needle" value=",${dept}," />
											          <c:if test="${not empty dept and not fn:contains(printedDepts, needle)}">
											            <span class="mb-1 badge bg-success-subtle text-success">
											              <strong>${fn:escapeXml(dept)}</strong>
											            </span>
											            <c:set var="printedDepts" value="${printedDepts}${dept}," scope="page" />
											          </c:if>
											        </c:if>
											      </c:forEach>
											    </c:otherwise>
											  </c:choose>
											</div>

										<p class="proj-meta mb-0">
											<b>공사일정</b> : ${project.prjctStartYmd} ~
											${project.prjctDdlnYmd}
										</p>
									</div>
								</div>
							</div>
						</c:forEach>

						<!--  프로젝트가 한 개도 없을 때 노출 -->
						  <c:if test="${empty projectList}">
						    <div class="col-12">
						      <div class="alert alert-secondary text-center py-5 mb-0">
						        등록된 프로젝트가 없습니다.
						      </div>
						    </div>
						  </c:if>

					</div>


			
				<!-- 모달 열기용 숨김 버튼 (수정모드일때 자동 클릭)  -->
				<button type="button" class="btn btn-primary d-none" id="openCreateModalBtn" 
				data-bs-toggle="modal" data-bs-target="#projectCreateModal">
				열기
				</button>
				
					<%@ include file="projectCreateModal.jsp"%></div>

			

				
				<div class="d-flex justify-content-between align-items-center mt-4">
					<!-- 페이지네이션 -->
				<div class="d-flex w-100 justify-content-center py-3" id="pagingArea">
              <nav aria-label="페이지 이동">
                <ul class="pagination mb-0">
                  <c:choose>
                    <c:when test="${pagingVO.currentPage > 1}">
                      <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_pagination(${pagingVO.currentPage - 1});">Previous</a></li>
                    </c:when>
                    <c:otherwise>
                      <li class="page-item disabled"><a class="page-link" href="javascript:void(0)" tabindex="-1" aria-disabled="true">Previous</a></li>
                    </c:otherwise>
                  </c:choose>

                  <c:forEach begin="${pagingVO.startPage}" end="${pagingVO.endPage < pagingVO.totalPage ? pagingVO.endPage : pagingVO.totalPage}" var="idx">
                    <li class="page-item <c:if test='${pagingVO.currentPage eq idx}'>active</c:if>">
                      <a class="page-link" href="javascript:void(0);" onclick="fn_pagination(${idx});">${idx}</a>
                    </li>
                  </c:forEach>

                  <c:choose>
                    <c:when test="${pagingVO.currentPage < pagingVO.totalPage}">
                      <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_pagination(${pagingVO.currentPage + 1});">Next</a></li>
                    </c:when>
                    <c:otherwise>
                      <li class="page-item disabled"><a class="page-link" href="javascript:void(0)" tabindex="-1" aria-disabled="true">Next</a></li>
                    </c:otherwise>
                  </c:choose>
                </ul>
              </nav>
            </div>
		
		
		
				<form id="pageForm"
					action="${pageContext.request.contextPath}/project/projectList"
					method="get">
					<input type="hidden" name="page" id="page"> 
					<input type="hidden" name="searchType" value="${searchType}"> 
					<input type="hidden" name="searchWord" value="${searchWord}">
					<input type="hidden" name="sttus" id="sttus" value="${empty param.sttus ? '17002' : param.sttus}">
					
				</form>

			</div>
			<!-- /.container-fluid -->
			
		</div>
		<!-- /.body-wrapper -->

		<%@ include file="/module/footerPart.jsp"%>

<script type="text/javascript">
	

$(function () {
  const grid = $('#projectGrid');
  const search = $('#fileSearchInput');
  
  // 기존 로직은 그대로 두고, 탭 클릭 시 reloadProjectList 호출하도록 수정
  // 탭 클릭
  $('#catTabs').on('click', '.nav-link', function (e) {
    e.preventDefault(); // 기본 링크 이동 방지
    const newStatus = $(this).attr('data-status');
    const sttusCode = newStatus === '진행중' ? '17002' : newStatus === '완료' ? '17003' : '17004';
    
    // 탭 활성화 클래스 변경
    $('#catTabs .nav-link').removeClass('active');
    $(this).addClass('active');

    // 서버로 요청 보내기 (첫 페이지로 초기화)
    window.reloadProjectList(1, sttusCode);
  });
  
  // 검색
  $('#btnDoSearch').on('click', function () { 
    // 검색 버튼 클릭 시에도 현재 탭의 상태를 파라미터에 추가하여 요청
    const currentStatus = $('#catTabs .nav-link.active').attr('data-status');
    const sttusCode = currentStatus === '진행중' ? '17002' : currentStatus === '완료' ? '17003' : '17004';
    const searchType = 'title'; // 예시: 검색 타입은 고정
    const searchWord = $('#fileSearchInput').val();

    window.reloadProjectList(1, sttusCode, searchType, searchWord);
  });
  
  $('#fileSearchInput').on('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      $('#btnDoSearch').trigger('click');
    }
  });

  // 카드 전체 클릭 이동
  $('#projectGrid').on('click', '.clickable-card', function () {
    const href = $(this).data('href');
    if (href) window.location.href = href;
  });

  // 페이지 로드 시 현재 URL의 sttus 파라미터에 따라 탭 활성화
  const urlParams = new URLSearchParams(window.location.search);
  const currentSttus = urlParams.get('sttus') || '17002'; // 기본값 '17002'
  const activeTab = $('#catTabs .nav-link').filter(function() {
      const statusText = $(this).text().trim();
      return (currentSttus === '17002' && statusText === '진행중') ||
             (currentSttus === '17003' && statusText === '완료') ||
             (currentSttus === '17004' && statusText === '보류');
  });
  
  if (activeTab.length) {
      $('#catTabs .nav-link').removeClass('active');
      activeTab.addClass('active');
  } else {
      $('#catTabs .nav-link[data-status="진행중"]').addClass('active');
  }

  // 기존 applyFilters() 함수는 필요 없으므로 삭제하거나 주석 처리
  // 이 함수는 클라이언트 측에서만 필터링하는 로직이므로, 서버에서 데이터를 받아오는 방식에서는 필요 없습니다.
  // 이 부분은 주석 처리합니다.
  
  // 6개 초과 보정 (서버가 실수로 6개 초과를 내려줘도 프론트에서 안전망)
  var $cards = $('#projectGrid .proj-card');
  if ($cards.length > 6) {
    $cards.slice(6).remove();
  }
});



window.fn_pagination = function(pageNo) {
    const currentStatusElement = $('#catTabs .nav-link.active');
    const currentStatusText = currentStatusElement.attr('data-status');
    const sttusCode = currentStatusText === '진행중' ? '17002' : currentStatusText === '완료' ? '17003' : '17004';

    const urlParams = new URLSearchParams(window.location.search);
    const searchType = urlParams.get('searchType') || '';
    const searchWord = urlParams.get('searchWord') || '';
    
    window.reloadProjectList(pageNo, sttusCode, searchType, searchWord);
};

</script>

<!-- 변경점: JS 문자열 비교 대신 JSTL로 "수정 모드"일 때만 모달 자동 오픈 ▼▼▼ -->
<c:if test="${status eq 'u'}">
<script type="text/javascript">
$(function(){
  $("#openCreateModalBtn").trigger("click");
});
</script>
</c:if>
<!-- 변경 끝-->


<script>

window.reloadProjectList = function(page, sttus, searchType, searchWord) {
    var params = {
        page: page || 1,
        sttus: sttus || '17002', // 기본값 17002
        searchType: searchType || '',
        searchWord: searchWord || ''
    };
    
    // 현재 URL 파라미터에서 검색어 가져오기 (검색어가 없는 경우)
    const currentUrlParams = new URLSearchParams(window.location.search);
    if (!params.searchWord) {
        params.searchWord = currentUrlParams.get('searchWord') || '';
    }
    if (!params.searchType) {
        params.searchType = currentUrlParams.get('searchType') || '';
    }

    // URL 파라미터를 갱신하여 페이지 새로고침 가능하도록 만듦
    const newUrl = new URL(window.location.origin + window.location.pathname);
    newUrl.searchParams.set('page', params.page);
    newUrl.searchParams.set('sttus', params.sttus);
    if (params.searchWord) {
      newUrl.searchParams.set('searchType', params.searchType);
      newUrl.searchParams.set('searchWord', params.searchWord);
    }
    window.history.pushState({ path: newUrl.href }, '', newUrl.href);

    $.get('/project/projectList', params, function(html) {
        var $dom = $('<div>').html(html);
        var $newGrid = $dom.find('#projectGrid');
        var $newPaging = $dom.find('#pagingArea');

        if ($newGrid.length) {
            $('#projectGrid').html($newGrid.html());
        }
        if ($newPaging.length) {
            $('#pagingArea').html($newPaging.html());
        }
    });
};



</script>





</body>
</html>
