<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>	
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<style>
/* 꼭 필요한 커스텀 스타일 */
#orgPopupInfo .org-status {
    font-size: 12px;      /* 배지 안쪽 글씨 조정 */
    padding: 2px 6px;
}

#orgPopupInfo .org-left {
    width: 120px;         /* 사진+정보 영역 넓이 */
}

#orgPopupInfo .org-img {
    width: 80px;
    height: 80px;
    object-fit: cover;
}

#orgPopup, #orgPopupInfo {
    position: fixed;
    z-index: 2000; /* 충분히 위로 */
}

/* 검색된 노드 색상 변경 */
/* jstree3 검색 강조 스타일 */
#orgJstree .jstree-search {
    color: #00AFF0 !important;   /* 글자색 하늘 파랑 */
    border-radius: 4px;          /* 살짝 둥글게 */
    font-weight: bold;           /* 강조 (옵션) */
}

/* jstree 앵커 글자 기본 기울임 없애기 */
#orgJstree .jstree-search {
    font-style: normal !important; /* 기울임 제거 */
}
#notiItems .noti-item.is-hidden { display: none !important; }
</style>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

  <div class="toast toast-onload align-items-center text-bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-body hstack align-items-start gap-6">
      <i class="ti ti-alert-circle fs-6"></i>
      <div>
        <h5 class="text-white fs-3 mb-1">알람 제목</h5>
        <h6 class="text-white fs-2 mb-0">알람 내용!!!!!!!!!!</h6>
      </div>
      <button type="button" class="btn-close btn-close-white fs-2 m-0 ms-auto shadow-none" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>
  <!-- Preloader -->  
  <div class="preloader">
    <img src="${pageContext.request.contextPath }/resources/assets/images/logos/favicon.png" alt="loader" class="lds-ripple img-fluid" />
  </div>

    <div id="main-wrapper">
    <!-- Sidebar Start -->
    <aside class="left-sidebar with-vertical">
      <div><!-- ---------------------------------- -->
        <!-- Start Vertical Layout Sidebar -->
        <!-- ---------------------------------- -->
        <div class="main_logo">
          <a href="${pageContext.request.contextPath }/main/dashboard" class="main_logo_img">
            <img src="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png" />
          </a>
          <%-- <a href="${pageContext.request.contextPath }/resources/minisidebar/index.html" class="text-nowrap logo-img">
            <img src="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png" class="dark-logo" alt="Logo-Dark" />
            <img src="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png" class="light-logo" alt="Logo-light" />
          </a>
          <a href="javascript:void(0)" class="sidebartoggler ms-auto text-decoration-none fs-5 d-block d-xl-none aside_btn">
            <i class="ti ti-x"></i>
          </a> --%>
        </div>

        <nav class="sidebar-nav scroll-sidebar" data-simplebar>
          <ul id="sidebarnav">
            <!-- ---------------------------------- -->
            <!-- Home -->
            <!-- ---------------------------------- -->
            <li class="nav-small-cap">
              <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
              <span class="hide-menu">그룹웨어</span>
            </li>
            <!-- ---------------------------------- -->
            <!-- Dashboard -->
            <!-- ---------------------------------- -->
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/project/projectList"  aria-expanded="false">
                <span>
                  <i class="ti ti-layout-board-split"></i>
                </span>
                <span class="hide-menu">프로젝트</span>
              </a>
            </li>
            <li class="sidebar-item">
            <!--  a class = sidebar-link has-arrow 화살표 생김-->
              <a class="sidebar-link" href="${pageContext.request.contextPath }/attendance" aria-expanded="false">
                <span>
                  <i class="ti ti-alarm"></i>
                </span>
                <span class="hide-menu">근태</span>
              </a>           
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/eApproval/dashBoard" aria-expanded="false">
                <span>
                  <i class="ti ti-file-pencil"></i>
                </span>
                <span class="hide-menu">전자결재</span>
              </a>
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                <span>
                  <i class="ti ti-user-exclamation"></i>
                </span>
                <span class="hide-menu">인사관리</span>
              </a>
              	<ul aria-expanded="false" class="collapse first-level">
            <sec:authorize access="hasAnyRole('ROLE_MANAGER')">
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="${pageContext.request.contextPath }/hr/hrList" aria-expanded="false">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">인사관리</span>
                    </a>
                  </li>
            </sec:authorize>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="${pageContext.request.contextPath }/hr/myhr" aria-expanded="false">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">인사정보</span>
                    </a>
                  </li>
                </ul>  
            </li>
		<sec:authorize access="hasAnyRole('ROLE_MANAGER')">
            <li class="sidebar-item">
                    <a class="sidebar-link" href="${pageContext.request.contextPath }/dept/deptList" aria-expanded="false">
                <span>
                  <i class="ti ti-users"></i>
                </span>
                <span class="hide-menu">부서관리</span>
              </a>
            </li>
          </sec:authorize>
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/schedule/list" aria-expanded="false">
                <span>
                  <i class="ti ti-calendar"></i>
                </span>
                <span class="hide-menu">일정</span>
              </a>
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/mail/inbox    " aria-expanded="false">
                <span>
                  <i class="ti ti-mail"></i>
                </span>
                <span class="hide-menu">메일</span>
              </a>
            </li>            
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/main/listsurvey" aria-expanded="false">
                <span>
                  <i class="ti ti-checkup-list"></i>
                </span>
                <span class="hide-menu">설문</span>
              </a>
            </li>
           <li class="sidebar-item">
              <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                <span>
                  <i class="ti ti-building-warehouse"></i>
                </span>
                <span class="hide-menu">시설물</span>
              </a>
				<ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="${pageContext.request.contextPath }/meeting/roomlist" aria-expanded="false">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">회의실</span>
                    </a>
                  </li>                 
                  
                  <li class="sidebar-item">
                   <a class="sidebar-link" href="${pageContext.request.contextPath }/mat/list" aria-expanded="false">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">자재창고</s>
                    </a>
                  </li>
                  
                  
                  <li class="sidebar-item">
                   <a class="sidebar-link" href="${pageContext.request.contextPath }/equip/list" aria-expanded="false">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">장비창고</span>
                    </a>
                  </li>
                </ul>               
            </li>            
            <li class="sidebar-item">
              <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                <span class="rounded-3">
                  <i class="ti ti-clipboard"></i>
                </span>
                <span class="hide-menu">게시판</span>
              </a>
				<ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath }/boards/complaintboardlist" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">민원게시판</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath }/boards/noticelist" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">공지사항게시판</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath }/boards/freeboardlist" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">자유게시판</span>
                    </a>
                  </li>
                </ul>              
            </li>            
            <li class="sidebar-item">
              <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                <span class="rounded-3">
                  <i class="ti ti-folders"></i>
                </span>
                <span class="hide-menu">자료실</span>
              </a>
				<ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/main/personallibrary" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">개인자료실</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/main/teamlibrary" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">팀별자료실</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/main/alllibrary" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">전체자료실</span>
                    </a>
                  </li>
                </ul>                 
            </li>                       
            <li class="sidebar-item">
              <a class="sidebar-link" href="${pageContext.request.contextPath }/address/board" aria-expanded="false">
                <span>
                  <i class="ti ti-address-book"></i>
                </span>
                <span class="hide-menu">주소록</span>
              </a>
            </li>            
            <li class="sidebar-item">
              <a class="sidebar-link" id="organization" aria-expanded="false">
                <span>
                  <i class="ti ti-binary-tree"></i>
                </span>
                <span class="hide-menu">조직도</span>
              </a>
            </li>       
           <sec:authorize access="hasAnyRole('ROLE_MANAGER')">
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="${pageContext.request.contextPath }/analytics" aria-expanded="false">
                      <i class="ti ti-graph"></i>
                      <span class="hide-menu">통계</span>
                    </a>
                  </li>
            </sec:authorize>     
          </ul>
        </nav>
		<!-- 아래 프로필 사진 영역 -->
        <div class="fixed-profile p-3 mx-4 mb-2 bg-secondary-subtle rounded mt-3">
          <div class="hstack gap-3">
            <div class="john-img">
              <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-1.jpg" class="rounded-circle" width="40" height="40" alt="modernize-img" />
            </div>
            <div class="john-title">
              <h6 class="mb-0 fs-4 fw-semibold">Mathew</h6>
              <span class="fs-2">Designer</span>
            </div>
            <button class="border-0 bg-transparent text-primary ms-auto" tabindex="0" type="button" aria-label="logout" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="logout">
              <i class="ti ti-power fs-6"></i>
            </button>
          </div>
        </div>

        <!-- ---------------------------------- -->
        <!-- Start Vertical Layout Sidebar -->
        <!-- ---------------------------------- -->
      </div>
    </aside>
    <!--  Sidebar End -->
    <div class="page-wrapper">
      <!--  Header Start -->
      <header class="topbar">
        <div class="with-vertical"><!-- ---------------------------------- -->
          <!-- Start Vertical Layout Header -->
          <!-- ---------------------------------- -->
          <nav class="navbar navbar-expand-lg p-0">
            <ul class="navbar-nav">
              <li class="nav-item nav-icon-hover-bg rounded-circle ms-n2">
                <a class="nav-link sidebartoggler" id="headerCollapse" href="javascript:void(0)">
                  <i class="ti ti-menu-2"></i>
                </a>
              </li>
              <li class="nav-item nav-icon-hover-bg rounded-circle d-none d-lg-flex">
                <a class="nav-link" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#exampleModal">
                  <i class="ti ti-search"></i>
                </a>
              </li>
            </ul>

<!-- 해당 헤드 메뉴들 삭제 코드는 - headmenu.text -->
           
            <div class="d-block d-lg-none py-4">
              <a id="get-url" href="${pageContext.request.contextPath }/resources/minisidebar/index.html" class="text-nowrap logo-img">
                <img src="${pageContext.request.contextPath }/resources/assets/images/logos/dark-logo.svg" class="dark-logo" alt="Logo-Dark" />
                <img src="${pageContext.request.contextPath }/resources/assets/images/logos/light-logo.svg" class="light-logo" alt="Logo-light" />
              </a>
            </div>
            <a class="navbar-toggler nav-icon-hover-bg rounded-circle p-0 mx-0 border-0" href="javascript:void(0)" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
              <i class="ti ti-dots fs-7"></i>
            </a>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
              <div class="d-flex align-items-center justify-content-between">
                <a href="javascript:void(0)" class="nav-link nav-icon-hover-bg rounded-circle mx-0 ms-n1 d-flex d-lg-none align-items-center justify-content-center" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobilenavbar" aria-controls="offcanvasWithBothOptions">
                  <i class="ti ti-align-justified fs-7"></i>
                </a>
                <ul class="navbar-nav flex-row ms-auto align-items-center justify-content-center">
                  <!-- ------------------------------- -->
                  <!-- start language Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item nav-icon-hover-bg rounded-circle">
                    <a class="nav-link moon dark-layout" href="javascript:void(0)">
                      <i class="ti ti-moon moon"></i>
                    </a>
                    <a class="nav-link sun light-layout" href="javascript:void(0)">
                      <i class="ti ti-sun sun"></i>
                    </a>
                  </li>

                  <!-- ------------------------------- -->
                  <!-- end language Dropdown 삭제함  languagedrop.text-->
                  <!-- ------------------------------- -->

                  <!-- ------------------------------- -->
                  <!-- start shopping cart Dropdown -->
                  <!-- ------------------------------- -->
                  <!-- ------------------------------- -->
                  <!-- end shopping cart Dropdown -->
                  <!-- ------------------------------- -->
                  
                  <!--  채팅 -->
<li class="nav-item nav-icon-hover-bg rounded-circle">
  <a class="nav-link position-relative"
     href="javascript:void(0)"
     data-bs-toggle="offcanvas"
     data-bs-target="#chatDrawer"
     aria-controls="chatDrawer"
     title="Chat">
    <i class="ti ti-message-circle"></i>

    <!-- 총 안읽음 배지 -->
    <span id="chatTotalBadge" class="badge rounded-pill bg-danger d-none">0</span>
  </a>
</li>
					<!--  채팅 끝 -->
                  <!-- ------------------------------- -->
                  <!-- start notification Dropdown -->
                  <!-- ------------------------------- -->
					<!-- start notification Dropdown -->
					<li class="nav-item nav-icon-hover-bg rounded-circle dropdown">
					  <!-- ✅ Bootstrap 기본 드롭다운이면 data-bs-toggle="dropdown" 권장 -->
					  <a class="nav-link position-relative" href="javascript:void(0)"
					     id="drop2" aria-expanded="false" data-bs-toggle="dropdown">
					    <i class="ti ti-bell-ringing"></i>
					    <div id="notiDot" class="notification bg-primary rounded-circle" style="display:none;"></div> <!-- ✅ -->
					  </a>
					
					  <div class="dropdown-menu content-dd dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop2">
					    <div class="d-flex align-items-center justify-content-between py-3 px-7">
					      <h5 class="mb-0 fs-5 fw-semibold">Notifications</h5>
					      <span id="notiHeaderCount" class="badge text-bg-primary rounded-4 px-3 py-1 lh-sm">0 new</span> <!-- ✅ -->
					    </div>
					
					    <!-- ✅ 여기 id 부여해서 JS가 항목을 꽂아 넣을 수 있게 -->
					    <div id="notiItems" class="message-body" data-simplebar style="max-height:360px;">
					      <!-- SSE로 받아서 여기로 prepend 됩니다 -->
					    </div>
					
 					    <div class="py-6 px-7 mb-1">
					      <!-- <button id="notiSeeAll" class="btn btn-outline-primary w-100">See All Notifications</button> (선택) 링크 이동 -->
					    <button id="btnNotiReadAll" class="btn btn-outline-primary w-100">전체 읽음</button>
					    </div> 
					  </div>
					</li>
					<!-- end notification Dropdown -->
                  <!-- ------------------------------- -->
                  <!-- end notification Dropdown -->
                  <!-- ------------------------------- -->

                  <!-- ------------------------------- -->
                  <!-- start profile Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item dropdown">
                    <a class="nav-link pe-0" href="javascript:void(0)" id="drop1" aria-expanded="false">
                      <div class="d-flex align-items-center">
                        <div class="user-profile-img">
                          <img src="${pageContext.request.contextPath }<sec:authentication property='principal.member.profileFilePath'/>" class="rounded-circle" width="35" height="35" alt="modernize-img" />
                        </div>
                      </div>
                    </a>
                    <div class="dropdown-menu content-dd dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop1">
                      <div class="profile-dropdown position-relative" data-simplebar>
                        <div class="py-3 px-7 pb-0">
                          <h5 class="mb-0 fs-5 fw-semibold">User Profile</h5>
                        </div>
                        <div class="d-flex align-items-center py-9 mx-7 border-bottom">
                          <img src="${pageContext.request.contextPath }<sec:authentication property='principal.member.profileFilePath'/>" class="rounded-circle" width="80" height="80" alt="modernize-img" />
                          <div class="ms-3">
                            <h5 class="mb-1 fs-3"><sec:authentication property="principal.member.empNm"/>  </h5>
                            <span class="mb-1 d-block"><sec:authentication property="principal.member.deptNm"/> </span>
                            <p class="mb-0 d-flex align-items-center gap-2">
                              <i class="ti ti-mail fs-4"></i> <sec:authentication property="principal.member.wnmpyEmail"/> 
                            </p>
                          </div>
                        </div>
                        <div class="message-body">
                          <a href="${pageContext.request.contextPath }/hr/myhr" class="py-8 px-7 mt-8 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-account.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">내 인사정보</h6>
                              <span class="fs-2 d-block text-body-secondary">인사정보</span>
                            </div>
                          </a>
                          <a href="${pageContext.request.contextPath }/hr/myhr" class="py-8 px-7 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-inbox.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">My Inbox</h6>
                              <span class="fs-2 d-block text-body-secondary">Messages & Emails</span>
                            </div>
                          </a>
                          <a href="../minisidebar/app-notes.html" class="py-8 px-7 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-tasks.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">My Task</h6>
                              <span class="fs-2 d-block text-body-secondary">To-do and Daily Tasks</span>
                            </div>
                          </a>
                        </div>
                        <div class="d-grid py-4 px-7 pt-8">
<%--                           <div class="upgrade-plan bg-primary-subtle position-relative overflow-hidden rounded-4 p-4 mb-9">
                            <div class="row">
                              <div class="col-6">
                                <h5 class="fs-4 mb-3 fw-semibold">Unlimited Access</h5>
                                <button class="btn btn-primary">Upgrade</button>
                              </div>
                              <div class="col-6">
                                <div class="m-n4 unlimited-img">
                                  <img src="${pageContext.request.contextPath }/resources/assets/images/backgrounds/unlimited-bg.png" alt="modernize-img" class="w-100" />
                                </div>
                              </div>
                            </div>
                          </div> --%>
                          <a href="${pageContext.request.contextPath }/logout" class="btn btn-outline-primary">Log Out</a>
                        </div>
                      </div>
                    </div>
                  </li>
                  <!-- ------------------------------- -->
                  <!-- end profile Dropdown -->
                  <!-- ------------------------------- -->
                </ul>
              </div>
            </div>
          </nav>
          <!-- ---------------------------------- -->
          <!-- End Vertical Layout Header -->
          <!-- ---------------------------------- -->

          <!-- ------------------------------- -->
          <!-- apps Dropdown in Small screen -->
          <!-- ------------------------------- -->
          <!--  Mobilenavbar -->
          <div class="offcanvas offcanvas-start" data-bs-scroll="true" tabindex="-1" id="mobilenavbar" aria-labelledby="offcanvasWithBothOptionsLabel">
            <nav class="sidebar-nav scroll-sidebar">
              <div class="offcanvas-header justify-content-between">
                <img src="${pageContext.request.contextPath }/resources/assets/images/logos/favicon.ico" alt="modernize-img" class="img-fluid" />
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
              </div>
              <div class="offcanvas-body h-n80" data-simplebar="" data-simplebar>
                <ul id="sidebarnav">
                  <li class="sidebar-item">
                    <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                      <span>
                        <i class="ti ti-apps"></i>
                      </span>
                      <span class="hide-menu">Apps</span>
                    </a>
                    <ul aria-expanded="false" class="collapse first-level my-3">
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-chat.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-chat.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Chat Application</h6>
                            <span class="fs-2 d-block text-muted">New messages arrived</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-invoice.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-invoice.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Invoice App</h6>
                            <span class="fs-2 d-block text-muted">Get latest invoice</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-cotact.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-mobile.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Contact Application</h6>
                            <span class="fs-2 d-block text-muted">2 Unsaved Contacts</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-email.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-message-box.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Email App</h6>
                            <span class="fs-2 d-block text-muted">Get new emails</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/page-user-profile.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-cart.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">User Profile</h6>
                            <span class="fs-2 d-block text-muted">learn more information</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-calendar.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-date.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Calendar App</h6>
                            <span class="fs-2 d-block text-muted">Get dates</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-contact2.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-lifebuoy.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Contact List Table</h6>
                            <span class="fs-2 d-block text-muted">Add new contact</span>
                          </div>
                        </a>
                      </li>
                      <li class="sidebar-item py-2">
                        <a href="../minisidebar/app-notes.html" class="d-flex align-items-center">
                          <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-application.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                          </div>
                          <div>
                            <h6 class="mb-1 bg-hover-primary">Notes Application</h6>
                            <span class="fs-2 d-block text-muted">To-do and Daily tasks</span>
                          </div>
                        </a>
                      </li>
                      <ul class="px-8 mt-7 mb-4">
                        <li class="sidebar-item mb-3">
                          <h5 class="fs-5 fw-semibold">Quick Links</h5>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/page-pricing.html">Pricing Page</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/authentication-login.html">Authentication
                            Design</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/authentication-register.html">Register Now</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/authentication-error.html">404 Error Page</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/app-notes.html">Notes App</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/page-user-profile.html">User Application</a>
                        </li>
                        <li class="sidebar-item py-2">
                          <a class="fw-semibold text-dark" href="../minisidebar/page-account-settings.html">Account Settings</a>
                        </li>
                      </ul>
                    </ul>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/app-chat.html" aria-expanded="false">
                      <span>
                        <i class="ti ti-message-dots"></i>
                      </span>
                      <span class="hide-menu">Chat</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/app-calendar.html" aria-expanded="false">
                      <span>
                        <i class="ti ti-calendar"></i>
                      </span>
                      <span class="hide-menu">Calendar</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/app-email.html" aria-expanded="false">
                      <span>
                        <i class="ti ti-mail"></i>
                      </span>
                      <span class="hide-menu">Email</span>
                    </a>
                  </li>
                </ul>
              </div>
            </nav>
          </div>
        </div>
        <div class="app-header with-horizontal">
          <nav class="navbar navbar-expand-xl container-fluid p-0">
            <ul class="navbar-nav align-items-center">
              <li class="nav-item nav-icon-hover-bg rounded-circle d-flex d-xl-none ms-n2">
                <a class="nav-link sidebartoggler" id="sidebarCollapse" href="javascript:void(0)">
                  <i class="ti ti-menu-2"></i>
                </a>
              </li>
              <li class="nav-item d-none d-xl-block">
                <a href="../minisidebar/index.html" class="text-nowrap nav-link">
                  <img src="${pageContext.request.contextPath }/resources/assets/images/logos/dark-logo.svg" class="dark-logo" width="180" alt="modernize-img" />
                  <img src="${pageContext.request.contextPath }/resources/assets/images/logos/light-logo.svg" class="light-logo" width="180" alt="modernize-img" />
                </a>
              </li>
              <li class="nav-item nav-icon-hover-bg rounded-circle d-none d-xl-flex">
                <a class="nav-link" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#exampleModal">
                  <i class="ti ti-search"></i>
                </a>
              </li>
            </ul>
            <ul class="navbar-nav quick-links d-none d-xl-flex align-items-center">
              <!-- ------------------------------- -->
              <!-- start apps Dropdown -->
              <!-- ------------------------------- -->
              <li class="nav-item nav-icon-hover-bg rounded w-auto dropdown d-none d-lg-flex">
                <div class="hover-dd">
                  <a class="nav-link" href="javascript:void(0)">
                    Apps<span class="mt-1">
                      <i class="ti ti-chevron-down fs-3"></i>
                    </span>
                  </a>
                  <div class="dropdown-menu dropdown-menu-nav dropdown-menu-animate-up py-0">
                    <div class="row">
                      <div class="col-8">
                        <div class="ps-7 pt-7">
                          <div class="border-bottom">
                            <div class="row">
                              <div class="col-6">
                                <div class="position-relative">
                                  <a href="../minisidebar/app-chat.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-chat.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        Chat Application
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">New messages arrived</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-invoice.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-invoice.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">Invoice App</h6>
                                      <span class="fs-2 d-block text-body-secondary">Get latest invoice</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-contact2.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-mobile.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        Contact Application
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">2 Unsaved Contacts</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-email.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-message-box.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">Email App</h6>
                                      <span class="fs-2 d-block text-body-secondary">Get new emails</span>
                                    </div>
                                  </a>
                                </div>
                              </div>
                              <div class="col-6">
                                <div class="position-relative">
                                  <a href="../minisidebar/page-user-profile.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-cart.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        User Profile
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">learn more information</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-calendar.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-date.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        Calendar App
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">Get dates</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-contact.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-lifebuoy.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        Contact List Table
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">Add new contact</span>
                                    </div>
                                  </a>
                                  <a href="../minisidebar/app-notes.html" class="d-flex align-items-center pb-9 position-relative">
                                    <div class="text-bg-light rounded-1 me-3 p-6 d-flex align-items-center justify-content-center">
                                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-dd-application.svg" alt="modernize-img" class="img-fluid" width="24" height="24" />
                                    </div>
                                    <div>
                                      <h6 class="mb-1 fw-semibold fs-3">
                                        Notes Application
                                      </h6>
                                      <span class="fs-2 d-block text-body-secondary">To-do and Daily tasks</span>
                                    </div>
                                  </a>
                                </div>
                              </div>
                            </div>
                          </div>
                          <div class="row align-items-center py-3">
                            <div class="col-8">
                              <a class="fw-semibold d-flex align-items-center lh-1" href="javascript:void(0)">
                                <i class="ti ti-help fs-6 me-2"></i>Frequently Asked Questions
                              </a>
                            </div>
                            <div class="col-4">
                              <div class="d-flex justify-content-end pe-4">
                                <button class="btn btn-primary">Check</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="col-4 ms-n4">
                        <div class="position-relative p-7 border-start h-100">
                          <h5 class="fs-5 mb-9 fw-semibold">Quick Links</h5>
                          <ul class="">
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/page-pricing.html">Pricing Page</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/authentication-login.html">Authentication
                                Design</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/authentication-register.html">Register Now</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/authentication-error.html">404 Error Page</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/app-notes.html">Notes App</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/page-user-profile.html">User Application</a>
                            </li>
                            <li class="mb-3">
                              <a class="fw-semibold bg-hover-primary" href="../minisidebar/page-account-settings.html">Account Settings</a>
                            </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
              <!-- ------------------------------- -->
              <!-- end apps Dropdown -->
              <!-- ------------------------------- -->
              <li class="nav-item dropdown-hover d-none d-lg-block">
                <a class="nav-link" href="../minisidebar/app-chat.html">Chat</a>
              </li>
              <li class="nav-item dropdown-hover d-none d-lg-block">
                <a class="nav-link" href="../minisidebar/app-calendar.html">Calendar</a>
              </li>
              <li class="nav-item dropdown-hover d-none d-lg-block">
                <a class="nav-link" href="../minisidebar/app-email.html">Email</a>
              </li>
            </ul>
            <div class="d-block d-xl-none">
              <a href="../minisidebar/index.html" class="text-nowrap nav-link">
                <img src="${pageContext.request.contextPath }/resources/assets/images/logos/dark-logo.svg" width="180" alt="modernize-img" />
              </a>
            </div>
            <a class="navbar-toggler nav-icon-hover-bg rounded-circle p-0 mx-0 border-0" href="javascript:void(0)" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
              <span class="p-2">
                <i class="ti ti-dots fs-7"></i>
              </span>
            </a>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
              <div class="d-flex align-items-center justify-content-between px-0 px-xl-8">
                <a href="javascript:void(0)" class="nav-link round-40 p-1 ps-0 d-flex d-xl-none align-items-center justify-content-center" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobilenavbar" aria-controls="offcanvasWithBothOptions">
                  <i class="ti ti-align-justified fs-7"></i>
                </a>
                <ul class="navbar-nav flex-row ms-auto align-items-center justify-content-center">
                  <!-- ------------------------------- -->
                  <!-- start language Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item nav-icon-hover-bg rounded-circle">
                    <a class="nav-link moon dark-layout" href="javascript:void(0)">
                      <i class="ti ti-moon moon"></i>
                    </a>
                    <a class="nav-link sun light-layout" href="javascript:void(0)">
                      <i class="ti ti-sun sun"></i>
                    </a>
                  </li>
                  <li class="nav-item nav-icon-hover-bg rounded-circle dropdown">
                    <a class="nav-link" href="javascript:void(0)" id="drop2" aria-expanded="false">
                      <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-flag-en.svg" alt="modernize-img" width="20px" height="20px" class="rounded-circle object-fit-cover round-20" />
                    </a>
                    <div class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop2">
                      <div class="message-body">
                        <a href="javascript:void(0)" class="d-flex align-items-center gap-2 py-3 px-4 dropdown-item">
                          <div class="position-relative">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-flag-en.svg" alt="modernize-img" width="20px" height="20px" class="rounded-circle object-fit-cover round-20" />
                          </div>
                          <p class="mb-0 fs-3">English (UK)</p>
                        </a>
                        <a href="javascript:void(0)" class="d-flex align-items-center gap-2 py-3 px-4 dropdown-item">
                          <div class="position-relative">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-flag-cn.svg" alt="modernize-img" width="20px" height="20px" class="rounded-circle object-fit-cover round-20" />
                          </div>
                          <p class="mb-0 fs-3">中国人 (Chinese)</p>
                        </a>
                        <a href="javascript:void(0)" class="d-flex align-items-center gap-2 py-3 px-4 dropdown-item">
                          <div class="position-relative">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-flag-fr.svg" alt="modernize-img" width="20px" height="20px" class="rounded-circle object-fit-cover round-20" />
                          </div>
                          <p class="mb-0 fs-3">français (French)</p>
                        </a>
                        <a href="javascript:void(0)" class="d-flex align-items-center gap-2 py-3 px-4 dropdown-item">
                          <div class="position-relative">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-flag-sa.svg" alt="modernize-img" width="20px" height="20px" class="rounded-circle object-fit-cover round-20" />
                          </div>
                          <p class="mb-0 fs-3">عربي (Arabic)</p>
                        </a>
                      </div>
                    </div>
                  </li>
                  <!-- ------------------------------- -->
                  <!-- end language Dropdown -->
                  <!-- ------------------------------- -->

                  <!-- ------------------------------- -->
                  <!-- start shopping cart Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item nav-icon-hover-bg rounded-circle">
                    <a class="nav-link position-relative" href="javascript:void(0)" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
                      <i class="ti ti-basket"></i>
                      <span class="popup-badge rounded-pill bg-danger text-white fs-2">2</span>
                    </a>
                  </li>
                  <!-- ------------------------------- -->
                  <!-- end shopping cart Dropdown -->
                  <!-- ------------------------------- -->

                  <!-- ------------------------------- -->
                  <!-- start notification Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item nav-icon-hover-bg rounded-circle dropdown">
                    <a class="nav-link position-relative" href="javascript:void(0)" id="drop2" aria-expanded="false">
                      <i class="ti ti-bell-ringing"></i>
                      <div class="notification bg-primary rounded-circle"></div>
                    </a>
                    <div class="dropdown-menu content-dd dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop2">
                      <div class="d-flex align-items-center justify-content-between py-3 px-7">
                        <h5 class="mb-0 fs-5 fw-semibold">Notifications1111111111</h5>
                        <span class="badge text-bg-primary rounded-4 px-3 py-1 lh-sm">5 new</span>
                      </div>
                      <div class="message-body" data-simplebar>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-2.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">Roman Joined the Team!</h6>
                            <span class="fs-2 d-block text-body-secondary">Congratulate him</span>
                          </div>
                        </a>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-3.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">New message</h6>
                            <span class="fs-2 d-block text-body-secondary">Salma sent you new message</span>
                          </div>
                        </a>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-4.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">Bianca sent payment</h6>
                            <span class="fs-2 d-block text-body-secondary">Check your earnings</span>
                          </div>
                        </a>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-5.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">Jolly completed tasks</h6>
                            <span class="fs-2 d-block text-body-secondary">Assign her new tasks</span>
                          </div>
                        </a>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-6.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">John received payment</h6>
                            <span class="fs-2 d-block text-body-secondary">$230 deducted from account</span>
                          </div>
                        </a>
                        <a href="javascript:void(0)" class="py-6 px-7 d-flex align-items-center dropdown-item">
                          <span class="me-3">
                            <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-7.jpg" alt="user" class="rounded-circle" width="48" height="48" />
                          </span>
                          <div class="w-100">
                            <h6 class="mb-1 fw-semibold lh-base">Roman Joined the Team!</h6>
                            <span class="fs-2 d-block text-body-secondary">Congratulate him</span>
                          </div>
                        </a>
                      </div>
                      <div class="py-6 px-7 mb-1">
                        <button class="btn btn-outline-primary w-100">See All Notifications</button>
                      </div>
                    </div>
                  </li>
                  <!-- ------------------------------- -->
                  <!-- end notification Dropdown -->
                  <!-- ------------------------------- -->

                  <!-- ------------------------------- -->
                  <!-- start profile Dropdown -->
                  <!-- ------------------------------- -->
                  <li class="nav-item dropdown">
                    <a class="nav-link pe-0" href="javascript:void(0)" id="drop1" aria-expanded="false">
                      <div class="d-flex align-items-center">
                        <div class="user-profile-img">
                          <img src="${pageContext.request.contextPath }<sec:authentication property='principal.member.profileFilePath'/>" class="rounded-circle" width="35" height="35" alt="modernize-img" />
                        </div>
                      </div>
                    </a>
                    <div class="dropdown-menu content-dd dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop1">
                      <div class="profile-dropdown position-relative" data-simplebar>
                        <div class="py-3 px-7 pb-0">
                          <h5 class="mb-0 fs-5 fw-semibold">User Profile</h5>
                        </div>
                        <div class="d-flex align-items-center py-9 mx-7 border-bottom">
                          <img src="${pageContext.request.contextPath }/resources/assets/images/profile/user-1.jpg" class="rounded-circle" width="80" height="80" alt="modernize-img" />
                          <div class="ms-3">
                            <h5 class="mb-1 fs-3">Mathew Anderson</h5>
                            <span class="mb-1 d-block">Designer</span>
                            <p class="mb-0 d-flex align-items-center gap-2">
                              <i class="ti ti-mail fs-4"></i> info@modernize.com
                            </p>
                          </div>
                        </div>
                        <div class="message-body">
                          <a href="../minisidebar/page-user-profile.html" class="py-8 px-7 mt-8 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-account.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">My Profile</h6>
                              <span class="fs-2 d-block text-body-secondary">Account Settings</span>
                            </div>
                          </a>
                          <a href="../minisidebar/app-email.html" class="py-8 px-7 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-inbox.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">My Inbox</h6>
                              <span class="fs-2 d-block text-body-secondary">Messages & Emails</span>
                            </div>
                          </a>
                          <a href="../minisidebar/app-notes.html" class="py-8 px-7 d-flex align-items-center">
                            <span class="d-flex align-items-center justify-content-center text-bg-light rounded-1 p-6">
                              <img src="${pageContext.request.contextPath }/resources/assets/images/svgs/icon-tasks.svg" alt="modernize-img" width="24" height="24" />
                            </span>
                            <div class="w-100 ps-3">
                              <h6 class="mb-1 fs-3 fw-semibold lh-base">My Task</h6>
                              <span class="fs-2 d-block text-body-secondary">To-do and Daily Tasks</span>
                            </div>
                          </a>
                        </div>
                        <div class="d-grid py-4 px-7 pt-8">
                          <div class="upgrade-plan bg-primary-subtle position-relative overflow-hidden rounded-4 p-4 mb-9">
                            <div class="row">
                              <div class="col-6">
                                <h5 class="fs-4 mb-3 fw-semibold">Unlimited Access</h5>
                                <button class="btn btn-primary">Upgrade</button>
                              </div>
                              <div class="col-6">
                                <div class="m-n4 unlimited-img">
                                  <img src="${pageContext.request.contextPath }/resources/assets/images/backgrounds/unlimited-bg.png" alt="modernize-img" class="w-100" />
                                </div>
                              </div>
                            </div>
                          </div>
                          <a href="../minisidebar/authentication-login.html" class="btn btn-outline-primary">Log Out</a>
                        </div>
                      </div>
                    </div>
                  </li>
                  <!-- ------------------------------- -->
                  <!-- end profile Dropdown -->
                  <!-- ------------------------------- -->
                </ul>
              </div>
            </div>
          </nav>
        </div>
      </header>
      <!--  Header End -->   
      <aside class="left-sidebar with-horizontal">
        <!-- Sidebar scroll-->
        <div>
          <!-- Sidebar navigation-->
          <nav id="sidebarnavh" class="sidebar-nav scroll-sidebar container-fluid">
            <ul id="sidebarnav">
              <!-- ============================= -->
              <!-- Home -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Home</span>
              </li>
              <!-- =================== -->
              <!-- Dashboard -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span>
                    <i class="ti ti-home-2"></i>
                  </span>
                  <span class="hide-menu">Dashboard</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/index.html" class="sidebar-link">
                      <i class="ti ti-aperture"></i>
                      <span class="hide-menu">Modern</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/index2.html" class="sidebar-link">
                      <i class="ti ti-shopping-cart"></i>
                      <span class="hide-menu">eCommerce</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/index3.html" class="sidebar-link">
                      <i class="ti ti-currency-dollar"></i>
                      <span class="hide-menu">NFT</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/index4.html" class="sidebar-link">
                      <i class="ti ti-cpu"></i>
                      <span class="hide-menu">Crypto</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/index5.html" class="sidebar-link">
                      <i class="ti ti-activity-heartbeat"></i>
                      <span class="hide-menu">General</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/index6.html" class="sidebar-link">
                      <i class="ti ti-playlist"></i>
                      <span class="hide-menu">Music</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- Apps -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Apps</span>
              </li>
              <li class="sidebar-item">
                <a class="sidebar-link two-column has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span>
                    <i class="ti ti-archive"></i>
                  </span>
                  <span class="hide-menu">Apps</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-calendar.html" class="sidebar-link">
                      <i class="ti ti-calendar"></i>
                      <span class="hide-menu">Calendar</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-kanban.html" class="sidebar-link">
                      <i class="ti ti-layout-kanban"></i>
                      <span class="hide-menu">Kanban</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-chat.html" class="sidebar-link">
                      <i class="ti ti-message-dots"></i>
                      <span class="hide-menu">Chat</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/app-email.html" aria-expanded="false">
                      <span>
                        <i class="ti ti-mail"></i>
                      </span>
                      <span class="hide-menu">Email</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-contact.html" class="sidebar-link">
                      <i class="ti ti-phone"></i>
                      <span class="hide-menu">Contact Table</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-contact2.html" class="sidebar-link">
                      <i class="ti ti-list-details"></i>
                      <span class="hide-menu">Contact List</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-notes.html" class="sidebar-link">
                      <i class="ti ti-notes"></i>
                      <span class="hide-menu">Notes</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/app-invoice.html" class="sidebar-link">
                      <i class="ti ti-file-text"></i>
                      <span class="hide-menu">Invoice</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/page-user-profile.html" class="sidebar-link">
                      <i class="ti ti-user-circle"></i>
                      <span class="hide-menu">User Profile</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/blog-posts.html" class="sidebar-link">
                      <i class="ti ti-article"></i>
                      <span class="hide-menu">Posts</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/blog-detail.html" class="sidebar-link">
                      <i class="ti ti-details"></i>
                      <span class="hide-menu">Detail</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/eco-shop.html" class="sidebar-link">
                      <i class="ti ti-shopping-cart"></i>
                      <span class="hide-menu">Shop</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/eco-shop-detail.html" class="sidebar-link">
                      <i class="ti ti-basket"></i>
                      <span class="hide-menu">Shop Detail</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/eco-product-list.html" class="sidebar-link">
                      <i class="ti ti-list-check"></i>
                      <span class="hide-menu">List</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/eco-checkout.html" class="sidebar-link">
                      <i class="ti ti-brand-shopee"></i>
                      <span class="hide-menu">Checkout</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/eco-add-product.html">
                      <i class="ti ti-file-plus"></i>
                      <span class="hide-menu">Add Product</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a class="sidebar-link" href="../minisidebar/eco-edit-product.html">
                      <i class="ti ti-file-pencil"></i>
                      <span class="hide-menu">Edit Product</span>
                    </a>
                  </li>
                </ul>
              </li>

              <!-- ============================= -->
              <!-- Frontend pages -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Frontend pages</span>
              </li>
              <!-- =================== -->
              <!-- pages -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-app-window"></i>
                  </span>
                  <span class="hide-menu">Frontend pages</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/frontend-landingpage.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Homepage</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/frontend-aboutpage.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">About Us</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/frontend-contactpage.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Contact Us</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/frontend-blogpage.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Blog</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/frontend-blogdetailpage.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Blog Details</span>
                    </a>
                  </li>
                </ul>
              </li>

              <!-- ============================= -->
              <!-- PAGES -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">PAGES</span>
              </li>
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span>
                    <i class="ti ti-notebook"></i>
                  </span>
                  <span class="hide-menu">Pages</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/page-faq.html" class="sidebar-link">
                      <i class="ti ti-help"></i>
                      <span class="hide-menu">FAQ</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/page-account-settings.html" class="sidebar-link">
                      <i class="ti ti-user-circle"></i>
                      <span class="hide-menu">Account Setting</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/page-pricing.html" class="sidebar-link">
                      <i class="ti ti-currency-dollar"></i>
                      <span class="hide-menu">Pricing</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/widgets-cards.html" class="sidebar-link">
                      <i class="ti ti-cards"></i>
                      <span class="hide-menu">Card</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/widgets-banners.html" class="sidebar-link">
                      <i class="ti ti-ad"></i>
                      <span class="hide-menu">Banner</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/widgets-charts.html" class="sidebar-link">
                      <i class="ti ti-chart-bar"></i>
                      <span class="hide-menu">Charts</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../landingpage/index.html" class="sidebar-link">
                      <i class="ti ti-app-window"></i>
                      <span class="hide-menu">Landing Page</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- UI -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">UI</span>
              </li>
              <!-- =================== -->
              <!-- UI Elements -->
              <!-- =================== -->
              <li class="sidebar-item mega-dropdown">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-layout-grid"></i>
                  </span>
                  <span class="hide-menu">UI</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-accordian.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Accordian</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-badge.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Badge</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-buttons.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Buttons</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-dropdowns.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Dropdowns</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-modals.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Modals</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-tab.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Tab</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-tooltip-popover.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Tooltip & Popover</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-notification.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Alerts</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-progressbar.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Progressbar</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-pagination.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Pagination</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-typography.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Typography</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-bootstrap-ui.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Bootstrap UI</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-breadcrumb.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Breadcrumb</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-offcanvas.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Offcanvas</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-lists.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Lists</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-grid.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Grid</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-carousel.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Carousel</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-scrollspy.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Scrollspy</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-spinner.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Spinner</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/ui-link.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Link</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- Forms -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Forms</span>
              </li>
              <!-- =================== -->
              <!-- Forms -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link two-column has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-file-text"></i>
                  </span>
                  <span class="hide-menu">Forms</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <!-- form elements -->
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-inputs.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Forms Input</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-input-groups.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Input Groups</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-input-grid.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Input Grid</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-checkbox-radio.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Checkbox & Radios</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-bootstrap-switch.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Bootstrap Switch</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-select2.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Select2</span>
                    </a>
                  </li>
                  <!-- form inputs -->
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-basic.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Basic Form</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-vertical.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Vertical</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-horizontal.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Horizontal</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-actions.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Actions</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-row-separator.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Row Separator</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-bordered.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Bordered</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-detail.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Detail</span>
                    </a>
                  </li>
                  <!-- form wizard -->
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-wizard.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Form Wizard</span>
                    </a>
                  </li>
                  <!-- Quill Editor -->
                  <li class="sidebar-item">
                    <a href="../minisidebar/form-editor-quill.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Quill Editor</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- Tables -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Tables</span>
              </li>
              <!-- =================== -->
              <!-- Bootstrap Table -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-layout-sidebar"></i>
                  </span>
                  <span class="hide-menu">Tables</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-basic.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Basic Table</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-dark-basic.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Dark Basic Table</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-sizing.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Sizing Table</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-layout-coloured.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Coloured Table</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-datatable-basic.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Basic Initialisation</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-datatable-api.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">API</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/table-datatable-advanced.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Advanced Initialisation</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- Charts -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Charts</span>
              </li>
              <!-- =================== -->
              <!-- Apex Chart -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-chart-pie"></i>
                  </span>
                  <span class="hide-menu">Charts</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-line.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Line Chart</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-area.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Area Chart</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-bar.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Bar Chart</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-pie.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Pie Chart</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-radial.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Radial Chart</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/chart-apex-radar.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Radar Chart</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- ============================= -->
              <!-- Icons -->
              <!-- ============================= -->
              <li class="nav-small-cap">
                <i class="ti ti-dots nav-small-cap-icon fs-4"></i>
                <span class="hide-menu">Icons</span>
              </li>
              <!-- =================== -->
              <!-- Tabler Icon -->
              <!-- =================== -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <i class="ti ti-archive"></i>
                  </span>
                  <span class="hide-menu">Icon</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="../minisidebar/icon-tabler.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Tabler Icon</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="../minisidebar/icon-solar.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Solar Icon</span>
                    </a>
                  </li>
                </ul>
              </li>
              <!-- multi level -->
              <li class="sidebar-item">
                <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                  <span class="rounded-3">
                    <iconify-icon icon="solar:airbuds-case-minimalistic-line-duotone" class="ti"></iconify-icon>
                  </span>
                  <span class="hide-menu">Multi DD</span>
                </a>
                <ul aria-expanded="false" class="collapse first-level">
                  <li class="sidebar-item">
                    <a href="https://adminmart.github.io/premium-documentation/bootstrap/modernize/index.html" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Documentation</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="javascript:void(0)" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Page 1</span>
                    </a>
                  </li>
                  <li class="sidebar-item">
                    <a href="javascript:void(0)" class="sidebar-link has-arrow">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Page 2</span>
                    </a>
                    <ul aria-expanded="false" class="collapse second-level">
                      <li class="sidebar-item">
                        <a href="javascript:void(0)" class="sidebar-link">
                          <i class="ti ti-circle"></i>
                          <span class="hide-menu">Page 2.1</span>
                        </a>
                      </li>
                      <li class="sidebar-item">
                        <a href="javascript:void(0)" class="sidebar-link">
                          <i class="ti ti-circle"></i>
                          <span class="hide-menu">Page 2.2</span>
                        </a>
                      </li>
                      <li class="sidebar-item">
                        <a href="javascript:void(0)" class="sidebar-link">
                          <i class="ti ti-circle"></i>
                          <span class="hide-menu">Page 2.3</span>
                        </a>
                      </li>
                    </ul>
                  </li>
                  <li class="sidebar-item">
                    <a href="javascript:void(0)" class="sidebar-link">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Page 3</span>
                    </a>
                  </li>
                </ul>
              </li>
            </ul>
          </nav>
          <!-- End Sidebar navigation -->
        </div>
        <!-- End Sidebar scroll-->
      </aside>
      
	<!-- 왼쪽 아래 조직도 -->
	<div id="orgPopup" class="card shadow rounded p-2" style="position: fixed; bottom: 20px; left: 90px; width: 270px; display:none;">
	    <div class="org-header d-flex justify-content-between align-items-center border-bottom pb-1 mb-1">
	        <span>조직도</span>
	        <button id="orgClose" class="btn-close btn-close-black"></button>
	    </div>
	    <div class="d-flex align-items-center mt-2">
	        <h6 class="fw-semibold ms-2 mb-0">부서</h6>
	        <div class="btn-group ps-2 flex-grow-1">
	            <input type="text" class="form-control form-control-sm me-2" id="empSchName" placeholder="사원/부서 검색하세요." />
	        </div>
	        <button id="empSch" class="btn btn-outline-secondary btn-sm me-2">검색</button>
	    </div>
	    <div id="orgJstree" style="height:300px; overflow-y:auto;"></div>
	</div>
	
	<!-- 사원정보 팝업 -->
	<div id="orgPopupInfo" class="card shadow rounded p-3" style="position: fixed; bottom: 20px; left: 360px; width: 450px; height: 380px; display:none;">
	    <div class="org-header d-flex justify-content-between align-items-center border-bottom pb-1 mb-2">
	        <span>사원정보</span>
	        <button id="orgInfoClose" class="btn-close btn-close-black"></button>
	    </div>
	    <div class="org-body d-flex">
	        <!-- 왼쪽: 사진 + 상태 -->
	        <div class="org-left text-center" style="width:200px;">
	           	<div>
                <img id="imgProfile" src="https://via.placeholder.com/80" alt="프로필" class="rounded-circle org-img">
              </div>
	            <div id="workRecord" class="org-status badge bg-primary mt-1"></div>
	            <h6 class="fw-semibold mt-2" id="empName"></h6>
	            <div class="text-muted" id="empDept"></div>
	            <div class="mt-2 p-2 bg-light rounded">
	                <small id="empStatus"></small>
	            </div>
	            <div class="d-flex justify-content-center mt-2 gap-2">
	                <button id="mailBtn" class="btn btn-outline-secondary btn-sm"><i class="ti ti-mail"></i>메일</button>
	                <button id="orgChatBtn" class="btn btn-outline-secondary btn-sm"><i class="ti ti-message-chatbot"></i>채팅</button>
	            </div>
	        </div>
	        <!-- 오른쪽: 상세 정보 -->
	        <div class="org-right ms-3 flex-grow-1">
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">사번</h6>
	                <div id="empNo"></div>
	            </div>
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">부서</h6>
	                <div id="empDept2"></div>
	            </div>
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">직급</h6>
	                <div id="empJbgd"></div>
	            </div>
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">이메일</h6>
	                <div id="empEmail"></div>
	            </div>
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">휴대전화</h6>
	                <div id="empPhone"></div>
	            </div>
	            <div class="mb-2">
	                <h6 class="fw-semibold mb-1">내선번호</h6>
	                <div id="extNo"></div>
	            </div>
	        </div>
	    </div>
	</div>

<script type="text/javascript">
/////////////////////////////////////////////////////////////
  // JSP 컨텍스트 루트
  const CPATH = '${pageContext.request.contextPath}';
//결재선 tree
let orgJstree = $("#orgJstree").jstree({
// 검색 기능 활성화
  "plugins": ["search"],
  // tree에 보여줄 데이터
  "core": {
 	 // core.data에 함수 넣으면 자동으로 (obj, cb) 두개를 호출
 	 // obj: 현재 요청 중인 노드 정보, cb: 데이터를 반환하는 콜백
		"data": function (obj, cb) {
          $.ajax({
              url: "/eApprovalTree/approvalLine",
              type: "get",
              success: function(res) {
                  console.log("결과 리스트", res);

                  res.forEach((node) => {
                      if(node.parent == "#"){
                          node.icon = "ti ti-users";
                      } else {
                          node.icon = "ti ti-user";
                      }
                  });

                  // cb에 데이터 전달
                  cb.call(obj, res);
              },
  			error : function(error, status, thrown){
 				console.log(error);
 				console.log(status);
 				console.log(thrown);
 			}
          });
      },
      "check_callback": true // 이거 없으면 create_node 안먹음
  }
});

let empEmail, empPhone, extNo;
//node가 select 되었을 때
$("#orgJstree").on("select_node.jstree", function(e, data) {
	let node = data.node;
 	console.log("select 했을 때", node);

	// 자식 node가 있으면 팀이라고 판단
	if(node.children.length > 0) {
	    console.log("팀이름:", node.text);
	    return;
	}

	console.log("select 했을 때", node.text);
	
	if(node.children.length === 0){
	   // 사번 정보를 가져옴
	   empNo = node.original.id;
	   console.log(empNo);
 	
	   // "(" 기준으로 이름, 직급 저장
 	   // 이름 정보를 가져옴
	   let empNameAndPosition = node.text;
 	
	   let parts = empNameAndPosition.split("(");
	   empName = parts[0].trim();
	   jbgdCd = parts[1].replace(")", "").trim();
 	
	   // 부서 정보를 가져옴
	   parentNode = orgJstree.jstree(true).get_node(node.parent);
	   empDept = parentNode ? parentNode.text : "";
	}
	
	// empInfo 가져오기
	axios.get("/orgChart/orgEmpInfo",{
		params : {
			empNo : empNo
		}
	}).then((res) => {
		console.log("axios data: ", res.data);
		empEmail = res.data.wnmpyEmail;
		empPhone = res.data.telno;
		extNo = res.data.extNo;
		profileFilePath = res.data.profileFilePath;
    
		
		console.log("empEmail:", empEmail, empPhone, extNo, profileFilePath);
		
	 	document.querySelector("#empEmail").textContent = empEmail ? empEmail : "-";
	 	document.querySelector("#empPhone").textContent = empPhone ? empPhone.substring(0,3) + "-" + empPhone.substring(3,7) + "-" + empPhone.substring(7,11) : "-";
	 	document.querySelector("#extNo").textContent = extNo ? extNo.substring(0,3) + "-" + extNo.substring(3,6) + "-" + extNo.substring(6,10) : "-";
    	document.querySelector("#imgProfile").src = profileFilePath ? profileFilePath : "-";

	    if(res.data.workYmd == null){
	      document.querySelector("#workRecord").textContent = "출근 전";
	      document.querySelector("#empStatus").textContent = "아직 출근 전 입니다.";
	    }else{
	      document.querySelector("#workRecord").textContent = "출근완료";
	      document.querySelector("#empStatus").textContent = "출근완료 했습니다.";
	    }
	});
	 
 	// 선택시 사원정보 block 표시
    document.querySelector("#orgPopupInfo").style.display = "block";
 	
 	// 사원 정보 넣어주기
 	document.querySelector("#empName").textContent = empName;
 	document.querySelector("#empDept").textContent = empDept;
 	document.querySelector("#empDept2").textContent = empDept;
 	document.querySelector("#empNo").textContent = empNo;
 	document.querySelector("#empJbgd").textContent = jbgdCd;
});
 
//검색 결과가 없을 때
$("#orgJstree").on("search.jstree", function(e, data){
	console.log("검색");
	if(data.nodes.length === 0){
		$("#empSchName").val("").focus();
		$("#empSchName").attr("placeholder", "검색 결과가 없습니다.");
	}
});

// 검색
function empSearch(){
	console.log("검색 실행");
    let empSchName = document.querySelector("#empSchName").value;
    
    orgJstree.jstree("search", empSchName);
    
    console.log(empSchName);
}

document.addEventListener("DOMContentLoaded", () => {
	
	// 조직도 열기
	document.querySelector("#organization").addEventListener("click", function() {
	    console.log("조직도 버튼 클릭됨");
	
	    // 팝업 표시
	    document.querySelector("#orgPopup").style.display = "block";
	
	});
	
	// 조직도 닫기
	document.querySelector("#orgClose").addEventListener("click", function(){
	    document.querySelector("#orgPopup").style.display = "none";
	    document.querySelector("#orgPopupInfo").style.display = "none";
	    document.querySelector("#empSchName").value = "";
	    
    // css 지우기
		document.querySelectorAll(".jstree-anchor").forEach(el => {
			el.classList.remove("jstree-search");
			el.classList.remove("jstree-clicked");
		});
		
		// jstree 닫기
		orgJstree.jstree("close_all");
	});
	
	// 사원정보 닫기
	document.querySelector("#orgInfoClose").addEventListener("click", function(){
		document.querySelector("#orgPopupInfo").style.display = "none";
	});
	
	// 검색 버튼
	document.querySelector("#empSch").addEventListener("click", function(){
		empSearch();
	});
	
	// enter 키
	document.querySelector("#empSchName").addEventListener("keypress", function(e){
		if(e.which === 13){
			empSearch();
		}
	});
	
	// 조직도 메일 연결
	document.querySelector("#mailBtn").addEventListener("click", function(){
		console.log("메일버튼 클릭, empEmail:", empEmail);
		
		// 사원번호 가져온 후, 같이 넘겨주고 컨트롤러에서 그 사번의 메일 주소 가져와서 연결
		location.href = "${pageContext.request.contextPath}/mail/form?empEmail=" + empEmail;
	});
	
	// 조직도 채팅 연결
    const chatBtn = document.getElementById('orgChatBtn');
    if (!chatBtn) return;

    chatBtn.addEventListener('click', async () => {
      try {
        if (!window.empNo || !window.empName) {
          alert('사원을 먼저 선택하세요.');
          return;
        }

        // (선택) 본인에게는 열지 않기
        if (window.MY_EMP_NO && String(window.empNo) === String(window.MY_EMP_NO)) {
          alert('본인과의 채팅은 만들 수 없어요.');
          return;
        }

        // 1) 서버에 개인채팅방 생성 또는 기존 방 조회 (idempotent)
        const resp = await axios.post(
          CPATH + '/chat/roomCreateP',
          { empNo: String(window.empNo) }, // 상대 사번만 보내면 서버가 principal로 본인 사번을 알아냄
          { headers: { 'Content-Type': 'application/json' } }
        );
		console.log("resp ::::::",resp);
		console.log("empNo ::::::",empNo);
        const roomNo = resp?.data?.result;
        const roomNm = resp?.data?.roomNm || window.empName || '1:1 채팅';

        if (!roomNo) {
          throw new Error('roomNo 없음');
        }

        // 2) 채팅 드로어 열기
        const drawerEl = document.getElementById('chatDrawer');
        if (drawerEl) {
          bootstrap.Offcanvas.getOrCreateInstance(drawerEl).show();
        }

        // 3) 채팅 공통 스크립트(chat-js.js)에게 "이 방을 열어!" 신호 보내기
        // 3-1) 공개 함수가 있으면 그걸 호출
        if (typeof window.openChatRoom === 'function') {
          window.openChatRoom(String(roomNo), String(roomNm));
        } else {
          // 3-2) 이벤트로 전달(권장) → chat-js.js에서 리스너만 한 줄 추가하면 됨
          window.dispatchEvent(new CustomEvent('open-chat-room', {
            detail: { roomNo: String(roomNo), roomNm: String(roomNm) }
          }));
        }

      } catch (e) {
        console.error(e);
        alert('채팅방을 열 수 없습니다. 콘솔 로그를 확인하세요.');
      }
    });
	
	
});


</script>
   