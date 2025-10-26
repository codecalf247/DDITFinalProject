<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
  <%@ include file="/module/header.jsp" %>

<style>
  .list-group-item .menu-link { display:flex; align-items:center; }
  .list-group-item .menu-link i { font-size:1.2rem; margin-right:7px; }
  .w-30 { width:30%; } @media (max-width: 992px){ .w-30{ width:100%; } }
  .table td, .table th { vertical-align:middle !important; }
  .text-center { text-align:center; }
  .search-compact .input-group { width:260px; }
  @media (max-width: 576px) { .search-compact .input-group { width:100%; } }
</style>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid">

<div class="body-wrapper">
  <div class="container">
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">사내 주소록</h4>
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
      <div class="d-flex align-items-center justify-content-between gap-6 m-3 d-lg-none">
        <button class="btn btn-primary d-flex" type="button" data-bs-toggle="offcanvas" data-bs-target="#chat-sidebar" aria-controls="chat-sidebar">
          <i class="ti ti-menu-2 fs-5"></i>
        </button>
        <form class="position-relative w-100">
          <input type="text" class="form-control search-chat py-2 ps-5" id="text-srh" placeholder="Search Contact" />
          <i class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
        </form>
      </div>

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

            <!-- 검색영역 (오른쪽 정렬) -->
            <div class="d-flex justify-content-end mb-2">
              <form id="searchForm"
                    action="${pageContext.request.contextPath}/address/board"
                    method="get"
                    class="d-flex align-items-center gap-2 flex-wrap search-compact">
              
                <div class="btn-group">
                  <button id="searchTypeBtn" type="button"
                          class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                          data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <c:choose>
                      <c:when test="${searchType eq 'all'}">전체</c:when>
                      <c:when test="${searchType eq 'empNm'}">사원명</c:when>
                      <c:when test="${searchType eq 'deptNm'}">부서명</c:when>
                      <c:otherwise>전체</c:otherwise>
                    </c:choose>
                  </button>
                  <ul class="dropdown-menu">
                    <li><a class="dropdown-item" data-search-type="all" href="#">전체</a></li>
                    <li><a class="dropdown-item" data-search-type="empNm" href="#">사원명</a></li>
                    <li><a class="dropdown-item" data-search-type="deptNm" href="#">부서명</a></li>
                  </ul>
                </div>

                <input type="hidden" name="searchType" id="hiddenSearchType" value="${searchType}">
                <div class="input-group w-80">
                  <input type="text" name="searchWord" class="form-control"
                         value="${searchWord}" placeholder="검색어 입력">
                  <button class="btn btn-outline-secondary btn-sm" type="submit" title="검색">
                    <i class="ti ti-search"></i>
                    <span class="d-none d-sm-inline ms-1">검색</span>
                  </button>
                </div>
              </form>
            </div>

            <!-- ▼▼▼ 주소록 테이블 ▼▼▼ -->
            <div class="table-responsive">
              <table class="table align-middle text-nowrap mb-0">
                <thead class="bg-body-tertiary">
                  <tr>
                    <th style="width:240px;">사원명</th>
                    <th style="width:280px;">이메일</th>
                    <th class="text-center" style="width:140px;">부서</th>
                    <th class="text-center" style="width:120px;">직책</th>
                    <th style="width:220px;">내선번호</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="emp" items="${empList}">
                    <tr>
                      <td>
                        <div class="d-flex align-items-center gap-2">
                          <c:set var="photo" value="${empty emp.profileFilePath ? pageContext.request.contextPath.concat('/resources/assets/images/profile/user-1.jpg') : emp.profileFilePath}" />
                          <img src="${photo}" alt="${emp.empNm}" class="rounded-circle" style="width:36px;height:36px;object-fit:cover;">
                          <span class="cell-emp-name">${emp.empNm}</span>
                        </div>
                      </td>
                      <td>${emp.email}</td>
                      <td class="text-center">${emp.deptNm}</td>
                      <td class="text-center">${emp.jbgdNm}</td>
                     <td>
						  <c:set var="rawTel" value="${fn:replace(fn:replace(emp.telno, '-', ''), ' ', '')}" />
						  <c:choose>
						    <c:when test="${not empty rawTel and fn:length(rawTel) == 11}">
						      <c:set var="fmtTel" value="${fn:substring(rawTel,0,3)}-${fn:substring(rawTel,3,7)}-${fn:substring(rawTel,7,11)}" />
						    </c:when>
						    <c:when test="${not empty rawTel and fn:length(rawTel) == 10}">
						      <c:set var="fmtTel" value="${fn:substring(rawTel,0,3)}-${fn:substring(rawTel,3,6)}-${fn:substring(rawTel,6,10)}" />
						    </c:when>
						    <c:otherwise>
						      <c:set var="fmtTel" value="${emp.telno}" />
						    </c:otherwise>
						  </c:choose>
						  <div>${fmtTel}</div>
						  <div class="text-muted small">${emp.extNo}</div>
						</td>
		              </tr>
                  </c:forEach>

                  <c:if test="${empty empList}">
                    <tr>
                      <td colspan="5" class="text-center text-muted py-5">표시할 사원이 없습니다.</td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>
            <!-- ▲▲▲ 끝 ▲▲▲ -->

            <!-- 페이지네이션 -->
            <div class="flex-grow-1 d-flex justify-content-center mt-3">
              <div class="d-flex align-items-center">
                ${pagingVO.pagingHTML2}
              </div>
            </div>

            <!-- 페이징 전달 폼 -->
            <form id="pageForm" action="${pageContext.request.contextPath}/address/board" method="get">
              <input type="hidden" name="page" id="page">
              <input type="hidden" name="searchType" value="${searchType}">
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

<%@ include file="/module/footerPart.jsp" %>
</body>

<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {
  // 검색 타입 드롭다운 → 버튼 텍스트/히든값 반영
  const dropdownItems = document.querySelectorAll('.dropdown-menu .dropdown-item');
  const searchTypeBtn = document.getElementById('searchTypeBtn');
  const hiddenSearchType = document.getElementById('hiddenSearchType');

  dropdownItems.forEach(item => {
    item.addEventListener('click', function (event) {
      event.preventDefault();
      const selectedText = this.textContent.trim();
      const selectedSearchType = this.getAttribute('data-search-type');
      searchTypeBtn.textContent = selectedText;
      hiddenSearchType.value = selectedSearchType;
    });
  });

  // 페이지 이동
  window.fn_pagination = function (pageNo) {
    const pageForm = document.getElementById('pageForm');
    document.getElementById('page').value = pageNo;
    pageForm.submit();
  };
});
</script>
</html>
