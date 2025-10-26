<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>

  <style>
    /* 유틸 */
    .list-group-item .menu-link{display:flex;align-items:center}
    .list-group-item .menu-link i{font-size:1.2rem;margin-right:7px}

    /* 카드 overflow 보정 */
    .chat-application,
    .overflow-hidden.chat-application{ overflow: visible !important; }

    /* 좌측 레일 폭 */
    .left-part{ width:280px; }
    @media (max-width: 992px){ .left-part{ width:100%; } }

    /* 상세 본문 전용 */
    .mail-header .row-item{display:flex;align-items:center;gap:.75rem}
    .mail-header .label{width:84px;flex:0 0 84px;color:var(--bs-secondary-color)}
    .chip{
      display:inline-flex;align-items:center;gap:.35rem;
      padding:.35rem .65rem;border-radius:999px;
      background:rgba(var(--bs-primary-rgb),.12);color:var(--bs-primary);font-weight:500;
    }
    .attach-list .list-group-item{padding:.75rem 1rem}
    .attach-list i{opacity:.9}
    .mail-html{line-height:1.8;word-break:break-word}
    .mail-html img{max-width:100%;height:auto}
    .mail-html table{max-width:100%}
    .content-sep{height:12px;background:var(--bs-border-color);opacity:.35}

    /* 내용 카드만 좌측(휴지통) 라인까지 채우기 */
    .right-pane{display:flex;flex-direction:column}
    .mail-detail-card{
      display:flex;flex-direction:column;flex:1 1 auto;
      margin-bottom:0;
    }
    .mail-detail-card .mail-content{flex:1 1 auto;}
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
              <div class="d-flex align-items-center justify-content-between">
                <div class="flex-grow-1">
                  <h4 class="fw-semibold mb-2">메일 상세</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
                      </li>
                      <li class="breadcrumb-item active" aria-current="page">Mail</li>
                    </ol>
                  </nav>
                </div>
              </div>
            </div>
          </div>

          <!-- 레이아웃 -->
          <div class="card overflow-hidden chat-application">
            <div class="d-flex w-100">
              <!-- 좌측 레일 -->
              <div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
                <div class="px-6 pt-4">
                  <div class="card">
                    <div class="card-header">
                      <div class="d-flex align-items-center">
                        <h6 class="card-title lh-base mb-0">메일</h6>
                        <div class="ms-auto">
                          <!-- 작성 경로는 프로젝트 규칙에 맞춰 /mail/form 또는 /mail/insert 로 맞춰 쓰면 됨 -->
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
                  <!-- 메일함 -->
                  <li class="list-group-item has-submenu open">
                    <a class="menu-link" href="#">
                      <i class="ti ti-folder fs-5"></i><span>메일함</span>
                      <i class="ti ti-chevron-right menu-toggle ms-1"></i>
                    </a>
                    <ul class="submenu">
                      <li class="list-group-item">
                        <a class="menu-link" href="${pageContext.request.contextPath}/mail/inbox">
                          <i class="ti ti-file-text fs-5 me-2"></i>받은메일함
                        </a>
                      </li>
                      <li class="list-group-item">
                        <a class="menu-link d-flex justify-content-between align-items-center" href="${pageContext.request.contextPath}/mail/sentbox">
                          <span class="d-flex align-items-center"><i class="ti ti-file-text fs-5 me-2"></i>보낸메일함</span>
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
                  <!-- 기타 메일함 -->
                  <li class="list-group-item has-submenu mt-2">
                    <a class="menu-link" href="#">
                      <i class="ti ti-folder fs-5"></i><span>기타 메일함</span>
                      <i class="ti ti-chevron-right menu-toggle ms-1"></i>
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
                <div class="w-100 p-3 right-pane">

                  
                  

                  <!-- 메일 카드 -->
                  <div class="card border-0 shadow-sm mail-detail-card">
                    <div class="card-body px-4 py-4 mail-header">
                      <h3 class="fw-semibold mb-3 d-flex align-items-center gap-2">
                        <i class="ti ti-mail"></i>
                        <span><c:out value="${mail.emailTitle}"/></span>
                        <!-- (옵션) 휴지통 배지 -->
                        <c:if test="${mail.delYn eq 'Y'}">
                          <span class="badge text-bg-danger-subtle text-danger border border-danger-subtle">휴지통</span>
                        </c:if>
                      </h3>

                      <div class="row-item mb-2">
                        <div class="label">보낸사람</div>
                        <div><span class="chip"><i class="ti ti-user"></i><c:out value="${mail.senderEmpNm}"/></span></div>
                      </div>

                      <div class="row-item mb-2">
                        <div class="label">수신일</div>
                        <div class="text-body"><c:out value="${mail.recptnDt}"/></div>
                      </div>

                      <div class="row-item">
						  <div class="label">첨부파일</div>
						  <div class="flex-grow-1">
						   <c:choose>
							  <c:when test="${not empty mail.fileList and mail.fileList[0].fileNo gt 0}">
							    <ul class="list-group list-group-flush rounded-3 border attach-list mb-2">
							      <c:forEach var="file" items="${mail.fileList}">
							        <c:if test="${file.fileNo gt 0}">
							          <li class="list-group-item d-flex align-items-center justify-content-between">
							            <div class="d-flex align-items-center file-download-trigger"
							                 data-url="${pageContext.request.contextPath}/mail/download/${file.savedNm}"
							                 data-filename="${file.originalNm}" style="cursor:pointer;">
							              <i class="ti ti-file-text fs-5 me-2 text-primary"></i>
							              <div class="d-flex flex-column">
							                <span class="fw-medium text-decoration-underline text-primary">
							                  <c:out value="${file.originalNm}"/>
							                </span>
							                <small class="text-muted"><c:out value="${file.fileFancysize}"/></small>
							              </div>
							            </div>
							            <div class="ms-auto">
							              <a href="${pageContext.request.contextPath}/mail/download/${file.savedNm}"
							                 class="btn btn-sm btn-outline-secondary"
							                 download="${file.originalNm}">
							                <i class="ti ti-download"></i> 다운로드
							              </a>
							            </div>
							          </li>
							        </c:if>
							      </c:forEach>
							    </ul>
							  </c:when>
							  <c:otherwise>
							    <span class="text-muted mb-2">첨부파일 없음</span>
							  </c:otherwise>
							</c:choose>

						  </div>
						</div>
                    <div class="content-sep"></div>

                    <!-- 본문 -->
                    <div class="card-body px-4 py-4 mail-content">
                      <div class="mail-html">
                        <c:out value="${mail.emailCn}" escapeXml="false"/>
                      </div>
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div> <!-- /card -->

        </div>
      </div>
    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>
</body>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const downloadTriggers = document.querySelectorAll('.file-download-trigger');

    downloadTriggers.forEach(el => {
      el.addEventListener('click', function () {
        const fileUrl = el.dataset.url;
        const fileName = el.dataset.filename;

        // 가상의 a 태그 생성하여 클릭 이벤트로 다운로드 유도
        const link = document.createElement('a');
        link.href = fileUrl;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      });
    });
  });
</script>
</html>
