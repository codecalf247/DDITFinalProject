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
    /* 좌측 레일 폭(받은메일함과 동일) */
    .left-part{width:280px}
    @media (max-width: 992px){ .left-part{width:100%} }
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
        <!-- 배너 -->
        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
          <div class="card-body px-4 py-3">
            <div class="row align-items-center">
              <div class="col-9">
                <h4 class="fw-semibold mb-8">임시보관함</h4>
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

        <!-- 본문 -->
        <div class="card overflow-hidden chat-application">
          <div class="d-flex w-100">
            <!-- Left rail -->
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
                <li class="list-group-item has-submenu">
                  <a class="menu-link" href="#"><i class="ti ti-folder fs-5"></i> 메일함 <i class="ti ti-chevron-right menu-toggle"></i></a>
                  <ul class="submenu">
                    <li class="list-group-item"><a class="menu-link" href="${pageContext.request.contextPath}/mail/inbox"><i class="ti ti-file-text fs-5 me-2"></i>받은메일함</a></li>
                    <li class="list-group-item">
                      <a class="menu-link d-flex justify-content-between align-items-center" href="${pageContext.request.contextPath}/mail/sentbox">
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

            <!-- Main -->
            <div class="d-flex w-100">
              <div class="w-100 p-3">

                <!-- 액션/검색 바 -->
                <div class="d-flex align-items-center gap-2 mb-2 toolbar-compact">
                  <div class="d-flex gap-2">
                    <!-- 체크 시 활성화됨 -->
                    <button type="button" class="btn btn-sm btn-outline-danger" id="btnErase" disabled>영구삭제</button>
                  </div>

                  <div class="ms-auto d-flex align-items-center gap-2 flex-wrap">
                    <!-- 검색 (제목만) -->
                    <form id="searchForm"
                          action="${pageContext.request.contextPath}/mail/temporary"
                          method="get"
                          class="d-flex align-items-center gap-2 flex-wrap">
                      <input type="hidden" name="searchType" value="emailTitle">
                      <input type="hidden" name="page" value="1"/>
                      <div class="input-group">
                        <input type="text" name="searchWord" class="form-control" value="${searchWord}" placeholder="제목으로 검색">
                        <button class="btn btn-outline-secondary btn-sm" type="submit" title="검색">
                          <i class="ti ti-search"></i><span class="d-none d-sm-inline ms-1">검색</span>
                        </button>
                      </div>
                    </form>
                  </div>
                </div>

                <!-- 리스트 -->
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0" id="tempTable">
                    <thead>
                      <tr>
                        <th style="width:36px;"><input type="checkbox" id="chkAll" aria-label="전체선택"/></th>
                        <th style="width:220px;">작성자</th>
                        <th>제목</th>
                        <th style="width:160px;">작성일</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:if test="${not empty temporaryList}">
                        <c:forEach items="${temporaryList}" var="mail">
                          <tr>
                            <td>
                              <input type="checkbox" class="row-chk" aria-label="메일 선택" data-email-no="${mail.emailNo}">
                            </td>
                            <td class="text-truncate" style="max-width:220px;"><c:out value="${mail.senderEmpNm}"/></td>
                            <td class="text-truncate">
                              <!-- 제목 클릭 → 초안 편집 열기 -->
                              <a class="mail-subject" href="${pageContext.request.contextPath}/mail/draftForm?draftEmailNo=${mail.emailNo}">
                                <c:out value="${mail.emailTitle}"/>
                              </a>
                            </td>
                            <td><c:out value="${mail.emailWrtDt}"/></td>
                          </tr>
                        </c:forEach>
                      </c:if>
                      <c:if test="${empty temporaryList}">
                        <tr><td colspan="4" class="text-center text-muted py-4">임시저장함이 비었습니다.</td></tr>
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
                <form id="pageForm" action="${pageContext.request.contextPath}/mail/temporary" method="get">
                  <input type="hidden" name="page" id="page">
                  <input type="hidden" name="searchType" value="emailTitle">
                  <input type="hidden" name="searchWord" value="${searchWord}">
                </form>

              </div>
            </div>
            </div>
            </div>
          </div>
        </div><!-- /card -->

      </div><!-- /container -->

    </div><!-- /container-fluid -->
  </div><!-- /body-wrapper -->

  <%@ include file="/module/footerPart.jsp" %>

  <script type="text/javascript">
$(function () {
  let contextPath = "${pageContext.request.contextPath}";
  let pageForm    = $("#pageForm");
  let chkAll      = $("#chkAll");
  let $btnErase   = $("#btnErase");

  // CSRF (폼 전송용)
  let csrfToken    = $('meta[name="_csrf"]').attr('content');
  let csrfParamKey = $('meta[name="_csrf_parameter"]').attr('content') || '_csrf';

  // 상위 메뉴 링크 방지
  $(".has-submenu > .menu-link").on("click", function (e) {
    if ($(this).attr("href") === "#") e.preventDefault();
  });

  // 현재 URL과 일치하는 메뉴 강조
  (function markActive() {
    let path = window.location.pathname;
    $(".list-group-menu a.menu-link[href]").each(function () {
      let href = $(this).attr("href");
      if (href && href !== "#" && path.startsWith(href)) $(this).addClass("active");
    });
  })();

  // 페이지 이동(검색어 동기화)
  window.fn_pagination = function (pageNo) {
    let word = $("#searchForm input[name='searchWord']").val() || "";
    pageForm.find("input[name='page']").val(pageNo);
    pageForm.find("input[name='searchWord']").val(word);
    pageForm.trigger("submit");
  };

  // ========= 체크박스 =========
  function syncEraseButton() {
    let hasAny = $(".row-chk:checked").length > 0;
    $btnErase.prop("disabled", !hasAny);
  }

  chkAll.on("change", function () {
    $(".row-chk").prop("checked", chkAll.prop("checked"));
    syncEraseButton();
  });

  $(document).on("change", ".row-chk", function () {
    let total   = $(".row-chk").length;
    let checked = $(".row-chk:checked").length;
    chkAll.prop("checked", total === checked);
    chkAll.prop("indeterminate", checked > 0 && checked < total);
    syncEraseButton();
  });

  // 선택한 이메일번호 수집
  function collectSelectedEmailNos() {
    return $(".row-chk:checked").map(function(){ return $(this).data("email-no"); }).get();
  }

  // ========= 영구삭제 (폼 전송 - A안) =========
  $btnErase.on("click", function () {
    let ids = collectSelectedEmailNos();
    if (ids.length === 0) { 
      Swal.fire({ title: '선택된 항목이 없습니다.', icon: 'info', confirmButtonText: '확인' });
      return; 
    }

    Swal.fire({
      title: '영구삭제 확인',
      text: '선택한 임시저장 메일을 영구 삭제하시겠습니까? (되돌릴 수 없음)',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((res) => {
      if (!res.isConfirmed) return;

      // 동적 폼 생성 (application/x-www-form-urlencoded)
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = contextPath + '/mail/temporary/erase';

      // CSRF 파라미터
      if (csrfToken) {
        const csrfInput = document.createElement('input');
        csrfInput.type  = 'hidden';
        csrfInput.name  = csrfParamKey;   // 보통 _csrf
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
      }

      // ids 여러 개
      ids.forEach(function (id) {
        const input = document.createElement('input');
        input.type  = 'hidden';
        input.name  = 'ids';
        input.value = id;
        form.appendChild(input);
      });

      document.body.appendChild(form);
      form.submit(); // 컨트롤러에서 flash msg 후 redirect
    });
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
</script>


</body>
</html>
