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
    .table thead{background:var(--bs-body-tertiary)}
    a.mail-subject{color:var(--bs-body-color);text-decoration:none}
    a.mail-subject:hover{color:var(--bs-primary);text-decoration:underline}
    .left-part{width:280px}
    @media (max-width: 992px){ .left-part{width:100%} }
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
        <div class="container-fluid">
          <div class="container">
            <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
              <div class="card-body px-4 py-3">
                <div class="row align-items-center">
                  <div class="col-9">
                    <h4 class="fw-semibold mb-2">보낸 메일함</h4>
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

            <div class="card overflow-hidden chat-application">
              <div class="d-flex w-100">
                <div class="left-part border-end flex-shrink-0 d-none d-lg-block">
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
                          <c:if test="${not empty empInfo}">
                            <c:out value="${empInfo.empNm}"/> (<c:out value="${empInfo.deptNm}"/> <c:out value="${empInfo.jbgdNm}"/>)
                          </c:if>
                        </div>
                      </div>
                    </div>
                  </div>

                  <ul class="list-group list-group-menu mh-n100">
                    <li class="border-bottom my-3"></li>
                    <li class="list-group-item has-submenu open">
                      <a class="menu-link" href="#"><i class="ti ti-folder fs-5"></i> 메일함 <i class="ti ti-chevron-right menu-toggle"></i></a>
                      <ul class="submenu">
                        <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/inbox"><i class="ti ti-file-text fs-5 me-2"></i>받은메일함</a></li>
                        <li class="list-group-item">
                          <a class="menu-link d-flex justify-content-between align-items-center active" href="${pageContext.request.contextPath}/mail/sentbox">
                            <span class="d-flex align-items-center"><i class="ti ti-file-text fs-5 me-2"></i>보낸메일함</span>
                          </a>
                        </li>
                        <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/refmail"><i class="ti ti-file-text fs-5 me-2"></i>참조메일함</a></li>
                        <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/reservation"><i class="ti ti-file-text fs-5 me-2"></i>예약메일함</a></li>
                      </ul>
                    </li>
                    <li class="list-group-item has-submenu mt-2">
                      <a class="menu-link" href="#"><i class="ti ti-folder fs-5"></i> 기타 메일함 <i class="ti ti-chevron-right menu-toggle"></i></a>
                      <ul class="submenu">
                        <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/temporary"><i class="ti ti-folder fs-5 text-primary me-2"></i>임시보관함</a></li>
                        <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/trash"><i class="ti ti-trash fs-5 text-warning me-2"></i>휴지통</a></li>
                      </ul>
                    </li>
                  </ul>
                </div>

                <div class="d-flex w-100">
                  <div class="w-100 p-3">
                    <div class="d-flex align-items-center gap-2 mb-2 toolbar-compact">
                      <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-outline-danger" id="btnDelete">삭제</button>
                      </div>

                      <div class="ms-auto d-flex align-items-center gap-2 flex-wrap search-compact">
                        <div class="btn-group">
                          <button id="searchTypeBtn" type="button"
                                  class="btn bg-secondary-subtle text-secondary dropdown-toggle"
                                  data-bs-toggle="dropdown" aria-expanded="false">
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
                              action="${pageContext.request.contextPath}/mail/sentbox"
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

                    <div class="table-responsive">
                      <table class="table table-hover align-middle mb-0" id="sentTable">
                        <thead>
                          <tr>
                            <th style="width:36px;"><input type="checkbox" id="chkAll" aria-label="전체선택"/></th>
                            <th style="width:220px;">받는사람</th>
                            <th>제목</th>
                            <th style="width:160px;">날짜</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:if test="${not empty SendList}">
                            <c:forEach items="${SendList}" var="sent">
                              <tr data-email-no="${sent.emailNo}">
                                <td>
                                  <input type="checkbox"
                                         class="row-chk"
                                         aria-label="메일 선택"
                                         data-dsptch-id="${sent.dsptchEmailboxNo}"
                                         data-email-no="${sent.emailNo}" />
                                </td>
                                <td class="text-truncate" style="max-width:220px;">
                                  <c:set value="${fn:split(sent.rcverNames, ', ')}" var="names"/>
                                  <i class="ti ti-eye fs-5 view"></i>&nbsp;
                                  <c:if test="${fn:length(names) - 1 ne 0}">
                                    ${names[0]} 외 ${fn:length(names) - 1}명
                                  </c:if>
                                  <c:if test="${fn:length(names) - 1 eq 0}">
                                    ${names[0]}
                                  </c:if>
                                </td>
                                <td class="text-truncate">
                                  <a class="mail-subject" href="${pageContext.request.contextPath}/mail/senddetail?emailNo=${sent.emailNo}&type=sent">
                                    <c:out value="${sent.emailTitle}"/>
                                  </a>
                                </td>
                                <td><c:out value="${sent.recptnDt}"/></td>
                              </tr>
                            </c:forEach>
                          </c:if>

                          <c:if test="${empty SendList}">
                            <tr>
                              <td colspan="4" class="text-center text-muted py-4">보낸 메일이 없습니다.</td>
                            </tr>
                          </c:if>
                        </tbody>
                      </table>
                    </div>

                    <div class="flex-grow-1 d-flex justify-content-center mt-3">
                      <div class="d-flex align-items-center">
                        ${pagingVO.pagingHTML2}
                      </div>
                    </div>

                    <form id="pageForm" action="${pageContext.request.contextPath}/mail/sentbox" method="get">
                      <input type="hidden" name="page" id="page">
                      <input type="hidden" name="searchType" value="${empty searchType ? 'all' : searchType}">
                      <input type="hidden" name="searchWord" value="${searchWord}">
                    </form>
                  </div>
                </div>
              </div>
            </div>

          </div> <!-- /.container -->
        </div>
      </div>
    </div>
  </div>

  <!-- 읽음 확인 모달 -->
  <div class="modal fade" id="mail-modal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-md">
      <div class="modal-content modal-filled bg-info-subtle text-info">
        <div class="modal-body p-4">
          <div class="text-center text-success">
            <i class="ti ti-circle-check fs-7"></i>
            <h4 class="mt-2">참조 확인용</h4>
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>-</th><th>수신자</th><th>수신일시</th>
                </tr>
              </thead>
              <tbody id="tbody"></tbody>
            </table>
            <button type="button" class="btn btn-light my-2" data-bs-dismiss="modal">닫기</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>
</body>

<script type="text/javascript">
$(function () {
  // ===== 변수 선언(상단) =====
  let contextPath      = "${pageContext.request.contextPath}";
  let pageForm         = $("#pageForm");
  let chkAll           = $("#chkAll");
  let searchTypeBtn    = $("#searchTypeBtn");
  let hiddenSearchType = $("#hiddenSearchType");
  let view             = $(".view");
  let mailModal        = $("#mail-modal");

  // CSRF
  let csrfToken     = $('meta[name="_csrf"]').attr('content');
  let csrfHeader    = $('meta[name="_csrf_header"]').attr('content');
  let csrfParamKey  = $('meta[name="_csrf_parameter"]').attr('content') || '_csrf';

  // 상위 메뉴 a[href="#"] 점프 방지
  $(".has-submenu > .menu-link").on("click", function (e) {
    if ($(this).attr("href") === "#") e.preventDefault();
  });

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

  // 페이지 이동(검색어 동기화 포함)
  window.fn_pagination = function (pageNo) {
    let word = $("#searchForm input[name='searchWord']").val() || "";
    pageForm.find("input[name='page']").val(pageNo);
    pageForm.find("input[name='searchWord']").val(word);
    pageForm.trigger("submit");
  };

//✅ 읽음 확인 모달 (EL 충돌 방지 버전)
  $(document).on("click", ".view", function () {
    const emailNo = $(this).closest("tr").data("emailNo");
    if (!emailNo) {
      console.warn("emailNo가 비어 있습니다.");
      return;
    }

    $.ajax({
      url: contextPath + "/mail/sentUserList/" + emailNo,
      type: "GET",
      dataType: "json",
      success: function (res) {
        const list = Array.isArray(res) ? res : [];
        let html = "";

        list.forEach(function (v) {
          const mailIcon = v.readngDt ? "opened" : "off";
          html += '<tr>'
               +   '<td><i class="ti ti-mail-' + mailIcon + ' fs-5"></i></td>'
               +   '<td>' + (v.senderEmpNm || '') + '</td>'
               +   '<td>' + (v.readngDt || '') + '</td>'
               + '</tr>';
        });

        if (!html) {
          html = '<tr><td colspan="3" class="text-center text-muted">데이터가 없습니다.</td></tr>';
        }

        $("#mail-modal #tbody").html(html);
        $("#mail-modal").modal("show");
      },
      error: function (xhr) {
        console.error(xhr);
        $("#mail-modal #tbody").html(
          '<tr><td colspan="3" class="text-center text-danger">조회 중 오류가 발생했습니다.</td></tr>'
        );
        $("#mail-modal").modal("show");
      },
    });
  });

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

  // 선택값 수집 (보낸 메일함: dsptch-id)
  function pickSelectedDsptchIds() {
    return $(".row-chk:checked").map(function(){ return $(this).data("dsptch-id"); }).get();
  }

  // ===== 삭제(폼 전송 + RedirectAttributes) =====
  $("#btnDelete").on("click", function () {
    let ids = pickSelectedDsptchIds();
    if (ids.length === 0) { Swal.fire({icon:'warning', title:'선택된 메일이 없습니다.'}); return; }

    Swal.fire({
      title: '삭제 확인',
      text: '선택한 메일을 휴지통으로 이동하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((res) => {
      if (!res.isConfirmed) return;

      // 동적 폼 생성 (application/x-www-form-urlencoded)
      let form = document.createElement('form');
      form.method = 'POST';
      form.action = contextPath + '/mail/sentbox/delete';

      // CSRF 파라미터
      if (csrfToken) {
        let csrfInput = document.createElement('input');
        csrfInput.type  = 'hidden';
        csrfInput.name  = csrfParamKey;
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
      }

      // ids 다중
      ids.forEach(function(id){
        let input = document.createElement('input');
        input.type  = 'hidden';
        input.name  = 'ids';
        input.value = id;
        form.appendChild(input);
      });

      document.body.appendChild(form);
      form.submit(); // 컨트롤러에서 ra.addFlashAttribute("msg", ...) 후 redirect
    });
  });
});

// ✅ 플래시 메시지(Swal)
let message = '${msg}';
if (message && message.trim() !== '') {
  Swal.fire({
    title: message,
    icon: 'success',
    confirmButtonText: '확인'
  });
}
</script>
</html>
