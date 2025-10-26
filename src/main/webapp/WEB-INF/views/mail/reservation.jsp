<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    .list-group-item .menu-link { display:flex; align-items:center; }
    .list-group-item .menu-link i { font-size:1.2rem; margin-right:7px; }
  </style>
</head>

<body>
  <%@ include file="/module/header.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <div class="body-wrapper">
    <div class="container-fluid">
      <div class="body-wrapper">
        <div class="container">
          <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
            <div class="card-body px-4 py-3">
              <div class="row align-items-center">
                <div class="col-9">
                  <h4 class="fw-semibold mb-8">예약 메일함</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">Mail</li>
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
                        <h6 class="card-title lh-base mb-0">메일</h6>
                        <div class="ms-auto">
                          <div class="link d-flex btn-minimize px-2 text-white align-items-center">
                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/mail/form">새 메일 작성</a>
                          </div>
                        </div>
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
                    <a class="menu-link" href="#"><i class="ti ti-folder fs-5"></i>메일함<i class="ti ti-chevron-right menu-toggle"></i></a>
                    <ul class="submenu">
                      <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/inbox"><i class="ti ti-file-text fs-5 me-2"></i>받은메일함</a></li>
                      <li class="list-group-item"><a class="menu-link d-flex justify-content-between align-items-center" href="${pageContext.request.contextPath}/mail/sentbox"><span class="d-flex align-items-center"><i class="ti ti-file-text fs-5 me-2"></i>보낸메일함</span></a></li>
                      <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/refmail"><i class="ti ti-file-text fs-5 me-2"></i>참조메일함</a></li>
                      <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/reservation"><i class="ti ti-file-text fs-5 me-2"></i>예약메일함</a></li>
                    </ul>
                  </li>

                  <li class="list-group-item has-submenu mt-2">
                    <a class="menu-link" href="#"><i class="ti ti-folder fs-5"></i>기타 메일함<i class="ti ti-chevron-right menu-toggle"></i></a>
                    <ul class="submenu">
                      <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/temporary"><i class="ti ti-folder fs-5 text-primary me-2"></i>임시보관함</a></li>
                      <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/trash"><i class="ti ti-trash fs-5 text-warning me-2"></i>휴지통</a></li>
                    </ul>
                  </li>
                </ul>
              </div>

              <!-- Main content -->
              <div class="d-flex w-100">
                <div class="w-100 p-3">
                  <!-- toolbar -->
                  <div class="d-flex align-items-center gap-2 mb-2 toolbar-compact">
                    <div class="d-flex gap-2">
                      <button type="button" class="btn btn-sm btn-outline-danger" id="btnDelete">삭제</button>
                    </div>

                    <div class="ms-auto d-flex align-items-center gap-2 flex-wrap search-compact">
                      <div class="btn-group">
                        <button id="searchTypeBtn" type="button"
                                class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                                data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                          <c:choose>
                            <c:when test="${searchType eq 'rcvrName'}">받는사람</c:when>
                            <c:when test="${searchType eq 'emailTitle'}">제목</c:when>
                            <c:otherwise>전체</c:otherwise>
                          </c:choose>
                        </button>
                        <ul class="dropdown-menu">
                          <li><a class="dropdown-item" data-search-type="all" href="#">전체</a></li>
                          <li><a class="dropdown-item" data-search-type="rcvrName" href="#">받는사람</a></li>
                          <li><a class="dropdown-item" data-search-type="emailTitle" href="#">제목</a></li>
                        </ul>
                      </div>

                      <form id="searchForm"
                            action="${pageContext.request.contextPath}/mail/reservation"
                            method="get"
                            class="d-flex align-items-center gap-2 flex-wrap">
                        <input type="hidden" name="searchType" id="hiddenSearchType" value="${empty searchType ? 'all' : searchType}">
                        <input type="hidden" name="page" value="1"/>
                        <div class="input-group">
                          <input type="text" name="searchWord" class="form-control" value="${searchWord}" placeholder="검색어 입력">
                          <button class="btn btn-outline-secondary btn-sm" type="submit" title="검색">
                            <i class="ti ti-search"></i><span class="d-none d-sm-inline ms-1">검색</span>
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>

                  <!-- list -->
                  <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="inboxTable">
                      <thead>
                        <tr>
                          <th style="width:36px;"><input type="checkbox" id="chkAll" aria-label="전체선택"/></th>
                          <th style="width:220px;">받는사람</th>
                          <th>제목</th>
                          <th style="width:160px;">예약시간</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:if test="${not empty reserveList}">
                          <c:forEach items="${reserveList}" var="rv">
                            <tr>
                              <td>
                                <input type="checkbox"
                                       class="row-chk"
                                       aria-label="메일 선택"
                                       data-email-no="${rv.emailNo}" />
                              </td>
                              <!-- 받는사람 표기: rcverNames 우선, 없으면 senderEmpNm 폴백 -->
                              <td class="text-truncate" style="max-width:220px;">
                                <c:choose>
                                  <c:when test="${not empty rv.rcverNames}">
                                    <c:set var="names" value="${fn:split(rv.rcverNames, ', ')}"/>
                                    <c:choose>
                                      <c:when test="${fn:length(names) gt 1}">
                                        <c:out value="${names[0]}"/> 외 <c:out value="${fn:length(names) - 1}"/>명
                                      </c:when>
                                      <c:otherwise>
                                        <c:out value="${names[0]}"/>
                                      </c:otherwise>
                                    </c:choose>
                                  </c:when>
                                  <c:otherwise>
                                    <c:out value="${rv.senderEmpNm}"/>
                                  </c:otherwise>
                                </c:choose>
                              </td>

                              <td class="text-truncate">
                                <a class="mail-subject"
                                   href="${pageContext.request.contextPath}/mail/tempdetail?emailNo=${rv.emailNo}">
                                  <c:out value="${rv.emailTitle}"/>
                                </a>
                              </td>
                              <td><c:out value="${rv.resveDsptchDt}"/></td>
                            </tr>
                          </c:forEach>
                        </c:if>

                        <c:if test="${empty reserveList}">
                          <tr>
                            <td colspan="4" class="text-center text-muted py-4">예약된 메일이 없습니다.</td>
                          </tr>
                        </c:if>
                      </tbody>
                    </table>
                  </div>

                  <!-- pagination -->
                  <div class="flex-grow-1 d-flex justify-content-center mt-3">
                    <div class="d-flex align-items-center">
                      ${pagingVO.pagingHTML2}
                    </div>
                  </div>

                  <!-- paging hidden form -->
                  <form id="pageForm" action="${pageContext.request.contextPath}/mail/reservation" method="get">
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

    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>

  <script type="text/javascript">
  $(function () {
    let contextPath      = "${pageContext.request.contextPath}";
    let pageForm         = $("#pageForm");
    let chkAll           = $("#chkAll");
    let searchTypeBtn    = $("#searchTypeBtn");
    let hiddenSearchType = $("#hiddenSearchType");
    const RESERVE_URL    = contextPath + "/mail/reservation";

    // CSRF
    let csrfToken   = $('meta[name="_csrf"]').attr('content');
    let csrfParam   = $('meta[name="_csrf_parameter"]').attr('content') || '_csrf';

    // 상위 메뉴 a[href="#"] 점프 방지
    $(".has-submenu > .menu-link").on("click", function (e) {
      if ($(this).attr("href") === "#") e.preventDefault();
    });

    // 현재 URL과 일치하는 메뉴만 강조
    (function markActive() {
      let path = window.location.pathname;
      $(".list-group-menu a.menu-link[href]").each(function () {
        let href = $(this).attr("href");
        if (href && href !== "#" && path.startsWith(href)) {
          $(this).addClass("active");
        }
      });
    })();

    // 검색타입 드롭다운 -> pageForm 동기화
    document.querySelectorAll(".dropdown-menu .dropdown-item").forEach(function (item) {
      item.addEventListener("click", function (e) {
        e.preventDefault();
        let selectedText = this.textContent.trim();
        let selectedType = this.getAttribute("data-search-type");
        searchTypeBtn.text(selectedText);
        hiddenSearchType.val(selectedType);
        let st = pageForm.find("input[name='searchType']");
        if (st.length) st.val(selectedType);
      });
    });

    // 페이지 이동(검색어 동기화)
    window.fn_pagination = function (pageNo) {
      let word = $("#searchForm input[name='searchWord']").val() || "";
      pageForm.attr("action", RESERVE_URL);
      pageForm.find("input[name='page']").val(pageNo);
      pageForm.find("input[name='searchWord']").val(word);
      pageForm.trigger("submit");
    };

    // 전체선택
    chkAll.on("change", function () {
      $(".row-chk").prop("checked", chkAll.prop("checked"));
    });
    $(document).on("change", ".row-chk", function () {
      let total   = $(".row-chk").length;
      let checked = $(".row-chk:checked").length;
      chkAll.prop("checked", total === checked);
      chkAll.prop("indeterminate", checked > 0 && checked < total);
    });

    // 선택값 수집 (예약: email_no 기준)
    function pickSelectedEmailNos() {
      return $(".row-chk:checked").map(function(){ return $(this).data("email-no"); }).get();
    }

    // 예약메일 삭제 (폼 전송)
    $("#btnDelete").on("click", function () {
      let emailNos = pickSelectedEmailNos();
      if (emailNos.length === 0) {
        Swal.fire({ title: '선택된 메일이 없습니다.', icon: 'info', confirmButtonText: '확인' });
        return;
      }

      Swal.fire({
        title: '영구삭제 확인',
        text: '선택한 예약 메일을 영구삭제하시겠습니까? (발송되지 않습니다)',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
      }).then((res) => {
        if (!res.isConfirmed) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/mail/reservation/erase';

        // CSRF 파라미터
        if (csrfToken) {
          const csrfInput = document.createElement('input');
          csrfInput.type  = 'hidden';
          csrfInput.name  = csrfParam;
          csrfInput.value = csrfToken;
          form.appendChild(csrfInput);
        }

        // ids 여러 개
        emailNos.forEach(function(id){
          const input = document.createElement('input');
          input.type  = 'hidden';
          input.name  = 'ids';
          input.value = id;
          form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
      });
    });

    // 플래시 메시지(Swal)
    let message = '${msg}';
    if (message && message.trim() !== '') {
      Swal.fire({ title: message, icon: 'success', confirmButtonText: '확인' });
    }
  });
  </script>
</body>
</html>
