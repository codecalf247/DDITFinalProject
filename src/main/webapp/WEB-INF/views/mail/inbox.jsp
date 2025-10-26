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

  <style>
    .list-group-item .menu-link{display:flex;align-items:center}
    .list-group-item .menu-link i{font-size:1.2rem;margin-right:7px}

    /* 좌측 레일 폭 유틸만 유지 */
    .w-20{width:20%}
    @media (max-width: 992px){ .w-20{width:100%} }

    .banner-stretch{margin-left:-1rem;margin-right:-1rem;border-radius:.75rem}
    @media (min-width:992px){ .banner-stretch{margin-left:-1.5rem;margin-right:-1.5rem} }

    .table thead{background:var(--bs-body-tertiary)}
    a.mail-subject{color:var(--bs-body-color);text-decoration:none}
    a.mail-subject:hover{color:var(--bs-primary);text-decoration:underline}

    .mail-unread .mail-subject{font-weight:700}
    .submenu{display:block}
  </style>
</head>
<body>
<%@ include file="/module/header.jsp" %>
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
                <h4 class="fw-semibold mb-2">받은 메일함</h4>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
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

        <!-- 레이아웃 -->
        <div class="card overflow-hidden chat-application">
          <div class="d-flex w-100">
            <!-- Left rail -->
            <div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
              <div class="px-6 pt-4">
                <div class="card">
                  <div class="card-header">
                    <div class="d-flex align-items-center">
                      <h6 class="card-title lh-base mb-0">메일</h6>
                      <div class="ms-auto">
                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/mail/form">새 메일 작성</a>
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

                <li class="list-group-item has-submenu open">
                  <a class="menu-link" href="#">
                    <span><i class="ti ti-folder fs-5"></i>메일함</span>
                    <i class="ti ti-chevron-right menu-toggle"></i>
                  </a>
                  <ul class="submenu">
                    <li class="list-group-item">
                      <a class="menu-link" href="${pageContext.request.contextPath}/mail/inbox">
                        <i class="ti ti-file-text fs-5 me-2"></i>받은메일함
                      </a>
                    </li>
                    <li class="list-group-item">
                      <a class="menu-link d-flex justify-content-between align-items-center" href="${pageContext.request.contextPath}/mail/sentbox">
                        <span class="d-flex align-items-center">
                          <i class="ti ti-file-text fs-5 me-2"></i>보낸메일함
                        </span>
                      </a>
                    </li>
                    <li class="list-group-item">
                      <a class="menu-link" href="${pageContext.request.contextPath}/mail/refmail">
                        <i class="ti ti-file-text fs-5 me-2"></i>참조메일함
                      </a>
                    </li>
                    <li class="list-group-item">
                      <a class="menu-link" href="${pageContext.request.contextPath}/mail/reservation">
                        <i class="ti ti-file-text fs-5 me-2"></i>예약메일함
                      </a>
                    </li>
                  </ul>
                </li>

                <li class="list-group-item has-submenu mt-2">
                  <a class="menu-link" href="#">
                    <i class="ti ti-folder fs-5"></i>기타 메일함
                    <i class="ti ti-chevron-right menu-toggle"></i>
                  </a>
                  <ul class="submenu">
                    <li class="list-group-item">
                      <a class="menu-link" href="${pageContext.request.contextPath}/mail/temporary">
                        <i class="ti ti-folder fs-5 text-primary me-2"></i>임시보관함
                      </a>
                    </li>
                    <li class="list-group-item">
                      <a class="menu-link" href="${pageContext.request.contextPath}/mail/trash">
                        <i class="ti ti-trash fs-5 text-warning me-2"></i>휴지통
                      </a>
                    </li>
                  </ul>
                </li>
              </ul>
            </div>

            <!-- 메인 영역 -->
            <div class="d-flex w-100">
              <div class="w-100 p-3">

                <!-- 액션/검색 바 -->
                <div class="d-flex align-items-center gap-2 mb-2 toolbar-compact">
                  <div class="d-flex gap-2">
                    <button type="button" class="btn btn-sm btn-outline-primary" id="btnRead">읽음</button>
                    <button type="button" class="btn btn-sm btn-outline-danger" id="btnDelete">삭제</button>
                  </div>

                  <div class="ms-auto d-flex align-items-center gap-2 flex-wrap search-compact">
                    <div class="btn-group">
                      <button id="searchTypeBtn" type="button"
                              class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                              data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <c:choose>
                          <c:when test="${searchType eq 'empNm'}">보낸사람</c:when>
                          <c:when test="${searchType eq 'emailTitle'}">제목</c:when>
                          <c:otherwise>전체</c:otherwise>
                        </c:choose>
                      </button>
                      <ul class="dropdown-menu">
                        <li><a class="dropdown-item" data-search-type="all" href="#">전체</a></li>
                        <li><a class="dropdown-item" data-search-type="empNm" href="#">보낸사람</a></li>
                        <li><a class="dropdown-item" data-search-type="emailTitle" href="#">제목</a></li>
                      </ul>
                    </div>

                    <form id="searchForm"
                          action="${pageContext.request.contextPath}/mail/inbox"
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

                <!-- 메일 리스트 -->
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0" id="inboxTable">
                    <thead>
                      <tr>
                        <th style="width:36px;"><input type="checkbox" id="chkAll" aria-label="전체선택"/></th>
                        <th style="width:220px;">보낸사람</th>
                        <th>제목</th>
                        <th style="width:160px;">날짜</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:if test="${not empty inboxList}">
                        <c:forEach items="${inboxList}" var="inbox">
                          <tr class="${empty inbox.readngDt ? 'mail-unread' : ''}">
                            <td>
                              <input type="checkbox"
                                     class="row-chk"
                                     aria-label="메일 선택"
                                     data-recptn-id="${inbox.recptnEmailboxNo}" />
                            </td>
                            <td class="text-truncate" style="max-width:220px;"><c:out value="${inbox.senderEmpNm}"/></td>
                            <td class="text-truncate">
                              <a class="mail-subject" href="${pageContext.request.contextPath}/mail/detail?recptnEmailboxNo=${inbox.recptnEmailboxNo}">
                                <c:out value="${inbox.emailTitle}"/>
                              </a>
                            </td>
                            <td><c:out value="${inbox.recptnDt}"/></td>
                          </tr>
                        </c:forEach>
                      </c:if>

                      <c:if test="${empty inboxList}">
                        <tr>
                          <td colspan="4" class="text-center text-muted py-4">받은 메일이 없습니다.</td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>

                <!-- 페이지네이션 -->
                <div class="flex-grow-1 d-flex justify-content-center mt-3">
                  <div class="d-flex align-items-center">
                    ${pagingVO.pagingHTML2}
                  </div>
                </div>

                <!-- 페이징용 히든 폼 -->
                <form id="pageForm" action="${pageContext.request.contextPath}/mail/inbox" method="get">
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
</body>
<script type="text/javascript">
$(function () {
  let contextPath      = "${pageContext.request.contextPath}";
  let pageForm         = $("#pageForm");
  let chkAll           = $("#chkAll");
  let searchTypeBtn    = $("#searchTypeBtn");
  let hiddenSearchType = $("#hiddenSearchType");

  let csrfToken  = $('meta[name="_csrf"]').attr('content');
  let csrfHeader = $('meta[name="_csrf_header"]').attr('content');

  $(".has-submenu > .menu-link").on("click", function (e) {
    if ($(this).attr("href") === "#") e.preventDefault();
  });

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

  window.fn_pagination = function (pageNo) {
    let word = $("#searchForm input[name='searchWord']").val() || "";
    pageForm.find("input[name='page']").val(pageNo);
    pageForm.find("input[name='searchWord']").val(word);
    pageForm.trigger("submit");
  };

  // 전체 선택
  chkAll.on("change", function () {
    $(".row-chk").prop("checked", chkAll.prop("checked"));
  });
  $(document).on("change", ".row-chk", function () {
    let total   = $(".row-chk").length;
    let checked = $(".row-chk:checked").length;
    chkAll.prop("checked", total === checked);
    chkAll.prop("indeterminate", checked > 0 && checked < total);
  });

  // 선택값 수집 (받은함은 recptnEmailboxNo만 필요)
  function pickSelectedRecptnIds() {
    return $(".row-chk:checked").map(function(){ return $(this).data("recptn-id"); }).get();
  }

  // 읽음 처리 (AJAX 유지, 에러 메시지 보강)
  $("#btnRead").on("click", function () {
    let ids = pickSelectedRecptnIds();
    if (ids.length === 0) { alert("선택된 메일이 없습니다."); return; }

    $.ajax({
      url: contextPath + "/mail/inbox/read",
      type: "POST",
      data: JSON.stringify({ ids: ids }),
      contentType: "application/json; charset=utf-8",
      beforeSend: function(xhr){
        if (csrfToken && csrfHeader) xhr.setRequestHeader(csrfHeader, csrfToken);
      },
      success: function () {
        $(".row-chk:checked").each(function(){
          $(this).closest("tr").removeClass("mail-unread");
        });
      },
      error: function(xhr){
        const ct = xhr.getResponseHeader('Content-Type') || '';
        let msg = '읽음 처리 중 오류가 발생했습니다.';
        if (ct.includes('application/json') && xhr.responseJSON && xhr.responseJSON.message) {
          msg = xhr.responseJSON.message;
        } else if (xhr.responseText) {
          msg = xhr.status + ' ' + xhr.statusText + ' : ' + xhr.responseText;
        }
        alert(msg);
      }
    });
  });

  // 삭제(휴지통 이동) - SweetAlert2 확인 후 폼 전송
  $("#btnDelete").on("click", function () {
    const ids = pickSelectedRecptnIds();

    if (ids.length === 0) {
      Swal.fire({ title: '경고', text: '삭제할 메일을 선택하세요.', icon: 'warning', confirmButtonText: '확인' });
      return;
    }

    Swal.fire({
      title: '삭제 확인',
      text: "선택한 메일을 정말 삭제하시겠습니까?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/mail/inbox/delete';

        const csrfParam = $('meta[name="_csrf_parameter"]').attr('content') || '_csrf';
        const csrfTokenVal = $('meta[name="_csrf"]').attr('content');
        if (csrfTokenVal) {
          const csrfInput = document.createElement('input');
          csrfInput.type  = 'hidden';
          csrfInput.name  = csrfParam;
          csrfInput.value = csrfTokenVal;
          form.appendChild(csrfInput);
        }

        ids.forEach(function(id){
          const input = document.createElement('input');
          input.type  = 'hidden';
          input.name  = 'ids';
          input.value = id;
          form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
      }
    });
  });

  // ✅ 플래시 메시지(Swal): 컨트롤러에서 ra.addFlashAttribute("msg", ...)로 전달된 값 사용
  let message = '${msg}';
  if (message && message.trim() !== '') {
    Swal.fire({
      title: message,
      icon: 'success',
      confirmButtonText: '확인'
    });
  }
});
</script>

</html>
