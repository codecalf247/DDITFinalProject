<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
      <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
        <%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
          <!DOCTYPE html>
          <html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
          <sec:authentication property="principal.member.empNo" var="loginEmpNo" />
          <sec:authentication property="principal.member.deptNo" var="loginDeptNo" />

          <head>
            <!-- Required meta tags -->
            <meta charset="UTF-8" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>GroupWare</title>
            <%@ include file="/module/headPart.jsp" %>
              <!-- GridStack CSS -->
              <link href="https://cdn.jsdelivr.net/npm/gridstack@12/dist/gridstack.min.css" rel="stylesheet" />
              <link href="https://cdn.jsdelivr.net/npm/gridstack@12/dist/gridstack-extra.min.css" rel="stylesheet" />

          </head>
          <%@ include file="/module/header.jsp" %>
            <style>
              .grid-stack-item-content {
                display: flex;
                justify-content: center;
                /* 가로 중앙 */
                align-items: center;
                /* 세로 중앙 */
}
                .icon-lg {
                  font-size: 64px;
                  /* 원하는 크기 */
                }

                .form-check-input:checked+.form-check-label {
                  text-decoration: line-through;
                  /* 취소선 */
                  color: #afb8c0;
                  /* optional: 회색으로 */
                }

                /* ====== 캘린더 컴팩트 타이포(유지) ====== */
                .fc-compact .fc-toolbar-title {
                  font-size: 1rem;
                }

                .fc-compact .fc-header-toolbar {
                  margin-bottom: .5rem;
                }

                .fc .fc-daygrid-day-number {
                  font-size: .85rem;
                }

                .fc .fc-daygrid-event {
                  font-size: .75rem;
                  padding: 0 .25rem;
                }

                .fc-event-time {
                  display: none;
                }
						.trash-btn {
		  width: 120px;
		  height: 120px;
		  background-color: rgba(210, 53, 69, 0.6); 
		  color: #fff;
		  border-radius: 20px;
		  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
		  cursor: pointer;
		  transition: all 0.3s ease;
		  font-size: 24px;
		}
		
		.trash-btn:hover {
		  background-color: rgba(220, 53, 69, 0.9); /* 호버 시 살짝 진하게 */
		  transform: translateY(-3px) scale(1.05);
		  box-shadow: 0 6px 12px rgba(0,0,0,0.3);
			}

                #todoList {
                  max-height: 200px;
                  /* 원하는 높이 지정 */
                  overflow-y: auto;
                  /* 세로 스크롤 자동 */
                }
                
                .bg-secondary-subtle{
              		
                	background: rgba(65, 171, 229, 0.66) !important; /* Bootstrap secondary 색상 + 투명도 */
                }
                
                .bg-light{
                	color: #000000 !important; /* Bootstrap secondary 색상 + 투명도 */
                }
                
                
                .offcanvas{
                	color: #ffffff !important;
                }
             

            </style>

            <body>

              <!-- 5 -->
              <div class="offcanvas offcanvas-end" style="width: 200px;" data-bs-scroll="true" data-bs-backdrop="false"
                tabindex="-1" id="offcanvasScrolling" aria-labelledby="offcanvasScrollingLabel">
                <div class="offcanvas-header">
                  <h5 class="offcanvas-title" id="offcanvasScrollingLabel">위젯 목록</h5>
                  <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas"
                    aria-label="Close"></button>
                </div>
                <div class="offcanvas-body">
                  <!-- 드래그 할 수 있는 위젯 목록 -->
                  <div id="widgetList" class="d-flex flex-wrap justify-content-center gap-2">
                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26001" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-calendar"></i></div>
                      <div class="widget-label mt-1">캘린더</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26002" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-sun"></i></div>
                      <div class="widget-label mt-1">출퇴근</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26003" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-list-check"></i></div>
                      <div class="widget-label mt-1">투두리스트</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26004" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-clipboard-text"></i></div>
                      <div class="widget-label mt-1">공지사항</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26005" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-rocket"></i></div>
                      <div class="widget-label mt-1">프로젝트</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26006" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-file-stack"></i></div>
                      <div class="widget-label mt-1">일감</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26008" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-jetpack"></i></div>
                      <div class="widget-label mt-1">프로젝트이동</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26009" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-calendar-pin"></i></div>
                      <div class="widget-label mt-1">캘린더이동</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26010" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-chart-infographic"></i></div>
                      <div class="widget-label mt-1">근태이동</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26011" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-pencil-pin"></i></div>
                      <div class="widget-label mt-1">전결이동</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26012" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-address-book"></i></div>
                      <div class="widget-label mt-1">주소록이동</div>
                    </div>

                    <div
                      class="grid-stack-item bg-light text-center rounded-3 shadow-sm d-flex flex-column align-items-center justify-content-center mb-2"
                      data-widget-ty="26013" style="width: 80px; height: 80px;">
                      <div class="grid-stack-item-content fs-8"><i class="ti ti-file-database"></i></div>
                      <div class="widget-label mt-1">자료실이동</div>
                    </div>

                    <button class="btn btn-success w-100" id="widgetModifyBtn">
                      수정완료
                    </button>

          			 <div id="trashBin"
				     class="trash-btn d-flex align-items-center justify-content-center"
				     title="휴지통">
				
				  <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24">
				    <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
				          d="M4 7h16m-10 4v6m4-6v6M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2l1-12M9 7V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3"/>
				  </svg>
				
				</div>

                  </div>
                </div>
              </div>

              <button
                class="btn btn-primary p-3 rounded-circle d-flex align-items-center justify-content-center customizer-btn"
                style="margin-bottom: 70px" type="button" data-bs-toggle="offcanvas"
                data-bs-target="#offcanvasScrolling" aria-controls="offcanvasScrolling">
                <i class="ti ti-triangle-square-circle fs-7"></i>
              </button>

              <%@ include file="/module/aside.jsp" %>

                <div class="body-wrapper">
                  <div class="container mt-3">

                    <!-- 여기에 gridStack 컨테이너 -->
                    <div class="grid-stack" id="mainGrid">

                      <c:forEach var="w" items="${widgets}">
                        <c:choose>

                          <c:when test="${w.widgetTy eq '26008'}">
                            <!-- Projects -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/rocket.svg" width="50" height="50"
                                      class="mb-3" alt="Projects" />
                                    <p class="fw-semibold fs-3 text-info mb-1">Projects</p>
                                    <a href="/project/projectList" class="stretched-link" aria-label="Projects"></a>
                                  </div>
                                </div>
                              </div>
                            </div>

                          </c:when>

                          <c:when test="${w.widgetTy eq '26009'}">
                            <!-- Calendar -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card card-hover bg-danger-subtle shadow-none  ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/calendar.svg" width="50" height="50"
                                      class="mb-3" alt="Calender" />
                                    <p class="fw-semibold fs-3 text-danger mb-1">Calendar</p>
                                    <a href="/schedule/list" class="stretched-link" aria-label="Calendar"></a>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26010'}">
                            <!-- Attendance -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/assign.svg" width="50" height="50"
                                      class="mb-3" alt="Attendance" />
                                    <p class="fw-semibold fs-3 text-info mb-1">Attendance</p>
                                    <a href="/attendance" class="stretched-link" aria-label="Attendance"></a>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26011'}">
                            <!-- Elec. Approval -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card card-hover bg-warning-subtle shadow-none ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/approved.svg" width="50" height="50"
                                      class="mb-3" alt="Elec. Approval" />
                                    <p class="fw-semibold fs-3 text-warning mb-1">Elec. Approval</p>
                                    <a href="/eApproval/dashBoard" class="stretched-link"
                                      aria-label="Elec. Approval"></a>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26012'}">
                            <!-- Address -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/book.svg" width="50" height="50"
                                      class="mb-3" alt="Address" />
                                    <p class="fw-semibold fs-3 text-primary mb-1">Address</p>
                                    <a href="/address/board" class="stretched-link" aria-label="Address"></a>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26013'}">
                            <!-- Library 자료실 -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="card grid-stack-item-content card-hover bg-success-subtle shadow-none ">
                                <div class="card-body">
                                  <div class="text-center">
                                    <img src="/resources/assets/images/svgs/open-book.svg" width="50" height="50"
                                      class="mb-3" alt="Library" />
                                    <p class="fw-semibold fs-3 text-success mb-1">Library</p>
                                    <a href="/main/alllibrary" class="stretched-link" aria-label="Library"></a>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26001'}">
                            <!-- 캘린더 -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">
                              <div
                                class="grid-stack-item-content card text-center shadow-sm ">

                                <!-- 캘린더 -->
                                <!-- Modernize 테마 오버라이드 적용 위해 app-calendar로 감싸기 -->
                                <div class="card-body py-2 app-calendar w-100">
                                  <div id="calendar" class="fc-compact"></div>
                                </div>

                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26002'}">
                            <!-- 출근 체크 -->
                            <c:set value="${attendanceWidgetVO}" var="attdData" />
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">

                              <div class="grid-stack-item-content card shadow-sm ">

                                <div class="card-header d-flex justify-content-between align-items-center w-100">
                                  <span class="badge text-bg-primary">출근 체크</span>
                                  <button class="btn btn-sm" onclick="location.href='/attendance'">
                                    <i class="ti ti-plus fs-5"></i>
                                  </button>
                                </div>

                                <!-- 카드 내부 -->
                                <div class="card-body d-flex align-items-center p-2">

                                  <!-- 프로필 -->
                                  <div class="me-5 text-center">
                                    <img
                                      src="${empty attdData.profileFilePath ? '/resources/assets/images/profile/기본프로필.png' : attdData.profileFilePath}"
                                      class="rounded-circle border border-2" width="80" height="80">
                                    <div class="mt-1">
                                    <h5 class="mb-1 fw-bold">${attdData.empNm}</h5>
                                    <p class="text-muted small mb-2">${attdData.deptNm }</p>
<%--                                       <span class="badge bg-primary rounded-pill">${attdData.jbgdNm}</span> --%>
                                    </div>
                                  </div>

                                  <!-- 사원 정보 & 출퇴근 시간 -->
                                  <div class="flex-grow-1">
									
                                    <div class="d-flex gap-3 mb-4">
                                      <div class="flex-fill p-2 bg-light rounded-3 d-flex align-items-center">
                                        <i class="ti ti-clock-hour-9 fs-5 text-secondary"></i>
                                        <div class="ms-2">
                                          <small class="text-muted">출근시간</small>
                                          <div class="fw-semibold" id="startTimeDisplay">
                                            ${empty attdData.beginTime ? '--:--' :
                                            fn:substring(attdData.beginTime,0,2).concat(':').concat(fn:substring(attdData.beginTime,2,4))}
                                          </div>
                                        </div>
                                      </div>

                                      <div class="flex-fill p-2 bg-light rounded-3 d-flex align-items-center">
                                        <i class="ti ti-clock-hour-6 fs-5 text-secondary"></i>
                                        <div class="ms-2">
                                          <small class="text-muted">퇴근시간</small>
                                          <div class="fw-semibold" id="endTimeDisplay">
                                            ${empty attdData.endTime ? '--:--' :
                                            fn:substring(attdData.endTime,0,2).concat(':').concat(fn:substring(attdData.endTime,2,4))}
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                    
                                    <!-- 버튼 -->
	                                <div class="d-flex justify-content-center gap-3 mb-3">
	                                  <button class="btn btn-primary px-4" id="startWorkBtn" 
	                                  <c:if test="${not empty attdData.beginTime}">disabled</c:if>
	                                  >출근하기</button>
	                                  <button class="btn btn-danger px-4" id="endWorkBtn"
	                                  <c:if test="${empty attdData.beginTime}">disabled</c:if>
	                                  >퇴근하기</button>
	                                </div>
	                                
                                  </div>
                                  
	                  

                                </div>



                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26003'}">
                            <!-- To Do List -->
                            <c:set value="${todoList}" var="todoList" />
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">

                              <div class="grid-stack-item-content card shadow-sm ">

                                <div class="card-header d-flex justify-content-between align-items-center w-100">
                                  <span class="badge text-bg-primary">To Do List</span>
                                  <div>
                                    <!-- 투두리스트 추가 -->
                                    <button class="btn btn-sm btn-primary" id="todoListAddBtn">
                                      <i class="ti ti-edit fs-5"></i>
                                    </button>
                                    <!-- 투두리스트 삭제 -->
                                    <button class="btn btn-sm btn-danger" id="todoListDeleteBtn">
                                      <i class="ti ti-trash fs-5"></i>
                                    </button>
                                  </div>
                                </div>

                                <div class="card-body w-100 text-start p-2">
                                  <ul class="list-group list-group-flush w-100 border border-1 rounded" id="todoList">
                                    <c:if test="${not empty todoList }">

                                      <c:forEach items="${todoList}" var="todo">
                                        <li class="list-group-item">
                                          <div class="form-check flex-grow-1">
                                            <input class="form-check-input todo-checkbox" type="checkbox"
                                              value="${todo.todoNo}" id="${'todo' += todo.todoNo }" ${todo.todoCheckYn
                                              eq 'Y' ? 'checked' : '' }>
                                            <label class="form-check-label"
                                              for="${'todo' += todo.todoNo }">${todo.todoCn}</label>
                                          </div>
                                        </li>
                                      </c:forEach>

                                    </c:if>
                                  </ul>
                                </div>

                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26004'}">
                            <c:set value="${noticeList}" var="noticeList" />
                            <!-- 공지 사항 -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">

                              <div class="grid-stack-item-content card shadow-sm ">

                                <div class="card-header d-flex justify-content-between align-items-center w-100">
                                  <span class="badge text-bg-primary">공지사항</span>
                                  <button class="btn btn-sm" onclick="location.href='/boards/noticelist'">
                                    <i class="ti ti-plus fs-5"></i>
                                  </button>
                                </div>

                                <!-- 공지사항 내용 -->
                                <div class="card-body w-100 text-start p-2">
                                  <table class="table table-sm table-hover align-middle mb-0 notice-table"
                                    style="table-layout: fixed;">

                                    <thead class="bg-body-tertiary text-center">
                                      <tr>
                                        <th>제목</th>
                                        <th>날짜</th>
                                      </tr>
                                    </thead>

                                    <tbody>
                                      <c:forEach items="${noticeList}" var="n">
                                        <tr data-id="${n.boardNo}" class="cursor-pointer">
                                          <td class="text-truncate">
                                            <c:if test="${not empty n.imprtncTagYn}">
                                              <span class="badge rounded-pill text-bg-danger">중요</span>&nbsp;
                                            </c:if>
                                            ${n.boardTitle}
                                          </td>
                                          <td class="text-center"> ${fn:substring(n.boardRegDt, 0, 10)}</td>
                                        </tr>
                                      </c:forEach>
                                    </tbody>

                                  </table>
                                </div>

                              </div>
                            </div>
                          </c:when>

                          <c:when test="${w.widgetTy eq '26005'}">
                            <c:set value="${projectList}" var="projectList" />

                            <!-- 진행중인 프로젝트 -->
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">

                              <div class="grid-stack-item-content card shadow-sm ">

                                <div class="card-header d-flex justify-content-between align-items-center w-100">
                                  <span class="badge text-bg-primary">진행중인 프로젝트</span>
                                  <div>
                                    <button id="prevCard" class="btn btn-sm">
                                      <i class="ti ti-chevron-left fs-5"></i>
                                    </button>
                                    <button id="nextCard" class="btn btn-sm">
                                      <i class="ti ti-chevron-right fs-5"></i>
                                    </button>
                                    <button class="btn btn-sm" onclick="location.href='/project/projectList'">
                                      <i class="ti ti-plus fs-5"></i>
                                    </button>
                                  </div>
                                </div>

                                <div class="card-body w-100 text-start p-2">

                                  <div id="cardContainer">
                                    <c:if test="${empty projectList}">
                                      <div class="card text-center mb-0">
                                        <div class="card-header">
                                          <span class="fs-5 fw-semibold">프로젝트</span>
                                        </div>
                                        <div class="card-body p-3">
                                          <h5 class="card-title">진행중인 프로젝트가 없습니다</h5>
                                          <p class="card-text">새로운 프로젝트를 시작해 보세요.</p>
                                          <a href="/project/projectList" class="btn btn-primary">프로젝트 이동</a>
                                        </div>
                                      </div>
                                    </c:if>
                                    <c:if test="${not empty projectList}">
                                      <c:forEach items="${projectList}" var="project">
                                        <div class="card text-center mb-0">
                                          <div class="card-header">
                                            <span class="fs-5 fw-semibold">${project.sptNm}</span>
                                          </div>
                                          <div class="card-body p-3">
                                            <h5 class="card-title">${project.sptAddr}</h5>
                                            <p class="card-text">
                                              ${project.prjctStartYmd} ~ ${project.prjctDdlnYmd}
                                            </p>
                                            <a href="/project/dashboard?prjctNo=${project.prjctNo}" class="btn btn-primary">페이지로 이동</a>
                                          </div>
                                        </div>
                                      </c:forEach>
                                    </c:if>

                                  </div>

                                </div>
                              </div>
                            </div>

                          </c:when>

                          <c:when test="${w.widgetTy eq '26006'}">
                            <!-- 나의 일감 -->
                            <c:set value="${taskList}" var="taskList" />
                            <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
                              gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}"
                              data-grid-master-no="${w.gridMasterNo}">

                              <div class="grid-stack-item-content card shadow-m ">

                                <div class="card-header d-flex justify-content-between align-items-center w-100">
                                  <span class="badge text-bg-primary">나의 일감</span>
                                  <div>
                                    <button id="prevTask" class="btn btn-sm">
                                      <i class="ti ti-chevron-left fs-5"></i>
                                    </button>
                                    <button id="nextTask" class="btn btn-sm">
                                      <i class="ti ti-chevron-right fs-5"></i>
                                    </button>
                                  </div>
                                </div>

                                <div class="card-body w-100 text-start p-2">

                                  <div id="taskContainer">
                                    <c:if test="${empty taskList}">
                                      <div class="card text-center mb-0">
                                        <div class="card-header">
                                          <span class="fs-5 fw-semibold">진행중인 일감이 없습니다</span>
                                        </div>
                                        <div class="card-body p-3">
                                          <p class="card-text">새로운 일감을 등록해 보세요.</p>
                                        </div>
                                      </div>
                                    </c:if>

                                    <c:if test="${not empty taskList}">
                                      <c:forEach items="${taskList}" var="task">
                                        <div class="card text-center mb-0">
                                          <div class="card-header">
                                            <c:if test="${task.emrgncyYn eq 'Y'}">
                                              <span class="badge rounded-pill  bg-danger-subtle text-danger">긴급</span>
                                            </c:if>
                                            <span class="fs-5 fw-semibold"> ${task.taskTitle}</span>
                                          </div>
                                          <div class="card-body p-3">
                                            <h5 class="card-title">${task.procsTy}</h5>
                                            <p class="card-text">
                                              ${task.taskBeginYmd} ~ ${task.taskDdlnYmd}
                                            </p>
                                            <span>진행률</span>

                                            <c:choose>
                                              <c:when test="${task.taskProgrs <= 30}">
                                                <c:set value="text-bg-danger" var="progreesBarColor" />
                                              </c:when>
                                              <c:when test="${task.taskProgrs >= 70}">
                                                <c:set value="text-bg-success" var="progreesBarColor" />
                                              </c:when>
                                              <c:otherwise>
                                                <c:set value="text-bg-warning" var="progreesBarColor" />
                                              </c:otherwise>
                                            </c:choose>
                                            <div class="progress" style="height: 15px">
                                              <div class="progress-bar ${progreesBarColor}"
                                                style="width: ${task.taskProgrs}%" role="progressbar">
                                                ${task.taskProgrs}%
                                              </div>
                                            </div>
                                          </div>
                                        </div>
                                      </c:forEach>
                                    </c:if>
                                  </div>

                                </div>
                              </div>
                            </div>
                          </c:when>
                        </c:choose>
                      </c:forEach>

                      <!--캘린더 모달: row 밖 -->
                      <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel"
                        aria-hidden="true">

                        <div class="modal-dialog modal-dialog-scrollable modal-lg">

                          <div class="modal-content">

                            <!-- 모달 헤더 -->
                            <div class="modal-header">
                              <h5 class="modal-title" id="eventModalLabel">일정</h5>
                              <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                            </div>

                            <div class="modal-body">

                              <div class="mb-2">
                                <label class="form-label">일정 제목</label>
                                <input id="event-title" type="text" class="form-control" placeholder="일정 제목을 입력하세요" />
                                <div class="invalid-feedback"></div>
                              </div>

                              <div class="mb-2">
                                <label class="form-label">일정 유형</label>
                                <div class="d-flex flex-wrap gap-3">
                                  <div class="form-check form-check-inline">
                                    <input class="form-check-input primary" type="radio" name="event-type" value="11001"
                                      id="radioPersonal" checked />
                                    <label class="form-check-label" for="radioPersonal">개인</label>
                                  </div>
                                  <div class="form-check form-check-inline">
                                    <input class="form-check-input success" type="radio" name="event-type" value="11002"
                                      id="radioTeam" />
                                    <label class="form-check-label" for="radioTeam">팀</label>
                                  </div>
                                  <div class="form-check form-check-inline">
                                    <input class="form-check-input warning" type="radio" name="event-type" value="11003"
                                      id="radioCompany" />
                                    <label class="form-check-label" for="radioCompany">전사</label>
                                  </div>
                                </div>
                              </div>

                              <div class="mb-2">
                                <label class="form-label">일정 내용</label>
                                <textarea id="event-content" class="form-control" style="resize: none;" rows="6"
                                  placeholder="일정 내용을 입력하세요"></textarea>
                                <div class="invalid-feedback"></div>
                              </div>

                              <div class="row g-2">
                                <div class="col-md-6">
                                  <label class="form-label">시작일</label>
                                  <input id="event-start-date" type="date" class="form-control" />
                                  <div class="invalid-feedback"></div>
                                </div>
                                <div class="col-md-6">
                                  <label class="form-label">종료일</label>
                                  <input id="event-end-date" type="date" class="form-control" />
                                  <div class="invalid-feedback"></div>
                                </div>
                              </div>

                            </div>

                            <div class="modal-footer">
                              <button type="button" class="btn bg-danger-subtle text-danger btn-delete-event"
                                data-bs-dismiss="modal">삭제</button>
                              <button type="button" class="btn btn-success btn-update-event"
                                data-fc-event-public-id="">수정</button>
                              <button type="button" class="btn btn-success btn-update-complete-event">수정완료</button>
                              <button type="button" class="btn btn-primary btn-add-event">등록</button>
                            </div>
                          </div>

                        </div>

                      </div>
                      <!-- 모달 끝 -->


                    </div> <!-- grid Stack-->

                  </div><!-- container -->
                </div><!-- body-wrapper -->

                <%@ include file="/module/footerPart.jsp" %>

                  <!-- GridStack JS -->
                  <script src="https://cdn.jsdelivr.net/npm/gridstack@12/dist/gridstack-all.min.js"></script>

                  <!-- jQuery UI 라이브러리(GridStack을 위해 필요)-->
                  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

                  <!-- 스크립트: FullCalendar → calendar-init.js (원본 유지) -->
                  <script src="/resources/assets/libs/fullcalendar/index.global.min.js"></script>
                  <script src="/resources/assets/libs/fullcalendar/calendarScript.js"></script>

                  <!-- SweetAlert -->
                  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                  <!-- CustomWidget -->
                  <script src="/resources/assets/js/widget.js"></script>

                  <script>

                    const loginEmpNo = "${loginEmpNo}";
                    const loginDeptNo = "${loginDeptNo}";
                    const widgetModifyBtn = $("#widgetModifyBtn");
	
                    // gridStack =======================
                    // DOM이 로드 되었을 때 실행할 함수 (gridStack + calendar 초기화)
                    document.addEventListener("DOMContentLoaded", function () {
                      const grid = GridStack.init({
                        column: 6,  		 // 6칸 그리드
                        float: false,  		 // 자유롭게 배치(막기) 
                        cellHeight: 30, 	 // 세로 높이(px)
                        margin: 10,			 // margin 값
                        disableResize: true, // 전체 리사이즈 금지
                        animate: true,       // true면 위젯 이동 시 애니메이션 적용
                        acceptWidgets: true, // 외부에서 드래그된 위젯 허용
                        draggable: { handle: '.grid-stack-item-content' }, // 드래그 핸들,
                        minRow: 20,
                        removable: '#trashBin', // drag-out delete class
                      });
                      const trash = document.getElementById('trashBin');

                      widgetModifyBtn.on("click", function () {
                        let data = grid.engine.nodes.map(node => ({
                          empNo: loginEmpNo,
                          gridX: node.x,
                          gridY: node.y,
                          widgetTy: node.el.dataset.widgetType,
                          gridMasterNo: node.el.dataset.gridMasterNo
                        }));
                        
                        $.ajax({
                            url: "/main/modifyWidget",
                            method: "POST",
                            contentType: "application/json",
                            data: JSON.stringify(data),
                            success: function (res) {
                              if (res === "OK") {
                            	Swal.fire("알림", "위젯 수정 완료", "success");
                              } else {
                                Swal.fire("알림", "수정에 실패했습니다.", "warning");
                              }
                            },
                            error: function () {
                              Swal.fire("알림", "수정에 실패했습니다.", "warning");
                            }
                          });
                 
                    	 // Offcanvas 엘리먼트 선택
                        const offcanvasEl = document.getElementById('offcanvasScrolling');

                        // Bootstrap Offcanvas 인스턴스 생성
                        const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(offcanvasEl);

                        // Offcanvas 닫기
                        bsOffcanvas.hide();
                      });

                      function refreshWidgetDraggable() {
                        const widgetListItems = document.querySelectorAll("#widgetList .grid-stack-item");

                        widgetListItems.forEach(item => {
                          const type = item.dataset.widgetTy;
                          const existsInGrid = document.querySelector(`.grid-stack .grid-stack-item[data-widget-type="\${type}"]`);
                          console.log(type);
                          console.log(item);
                          console.log(existsInGrid);

                          if (existsInGrid) {
                            $(item).draggable('disable');
                            item.classList.remove("bg-light");
                            item.classList.add("bg-secondary-subtle");
                          } else {
                            $(item).draggable('enable');
                            item.classList.remove("bg-secondary-subtle");
                            item.classList.add("bg-light");
                          }
                        });
                      }

                      // 위젯 목록에서 드래그 가능하도록 jQuery UI 설정
                      $('#widgetList .grid-stack-item').draggable({
                        helper: 'clone',   // 드래그 시 원본이 아닌 복제본을 사용
                        revert: 'invalid', // 드롭 실패 시 원래 위치로
                        scroll: false,	 // 드래그 중 스크롤 방지
                      });

                      refreshWidgetDraggable();

                      // GridStack 영역을 드롭 가능하도록 설정
                      $('.grid-stack').droppable({
                        accept: '#widgetList .grid-stack-item',		// 위젯 목록만 허용
                        drop: async function (event, ui) {					// 드롭 발생 시 실행

                          const x = 5;
                          const y = 8;
                          const widgetTy = ui.helper.data('widget-ty') || '';	// 위젯 타입

                          console.log("그리드 삽입 ========================");
                          console.log(grid);
                          console.log(widgetTy);

                          // 1. HTML 문자열 생성
                          let widgetHTML = await renderWidget(widgetTy, x, y);

                          // 2. DOM Element로 변환
                          let tempDiv = document.createElement('div');
                          console.log(widgetHTML);
                          tempDiv.innerHTML = widgetHTML;
                          console.log(tempDiv);
                          let widgetEl = tempDiv.firstElementChild; // 첫 번째 자식만 가져오기
                          console.log(widgetEl);

                          // 3. GridStack에 추가
                          document.querySelector('.grid-stack').appendChild(widgetEl)
                          grid.addWidget(widgetEl);

                          refreshWidgetDraggable();
                        }
                      });

                      // 위젯 삭제 이벤트 감지
                      grid.on('removed', function (event, items) {
                        items.forEach(item => {
                          const type = item.el.dataset.widgetType;
                          const listWidget = document.querySelector(`#widgetList .grid-stack-item[data-widget-ty="\${type}"]`);

                          $(listWidget).draggable('enable');
                          listWidget.classList.remove("bg-secondary-subtle");
                          listWidget.classList.add("bg-light");
                        });
                      });

                      // GridStack에 아이템이 추가될 때 콘솔에 확인
                      grid.on('added', function (e, items) {
                        items.forEach(item => {
                          const widgetEl = item.el;

                          if (widgetEl.dataset.widgetType == '26001') {
                            const calendarEventsList = [];

                            $.ajax({
                              url: "/main/schdulList",
                              type: "post",
                              contentType: "application/json;charset=utf-8",
                              success: function (result) {
                                if (result != null && result.length > 0) {
                                  result.map(function (v, i) {
                                    let endD = v.endDt.substring(0, 10) + 'T01:00'
                                    calendarEventsList.push({
                                      id: v.schdulNo,            // 일정번호
                                      title: v.schdulTitle,      // 제목
                                      start: v.startDt,          // 시작일
                                      end: endD,              	 // 종료일
                                      backgroundColor: v.backgroundColor,  // 배경색
                                      textColor: v.textColor,     // 글자색
                                      borderColor: 'transparent',  // 테두리 없애기
                                      display: 'block',				// 이벤트 랜더링 유형
                                      extendedProps: {			  // 사용자 정보
                                        schdulCn: v.schdulCn,	// 설명
                                        empNo: v.empNo,			// 사원번호
                                        schdulTy: v.schdulTy,	// 일정유형
                                        deptNo: v.deptNo,		// 부서번호
                                        prjctNo: v.prjctNo		// 프로젝트번호
                                      }
                                    });
                                  });
                                }
                                // 캘린더 초기화 (그리드 안에 캘린더가 있어서 그리드가 생성되고 난 다음에 캘린더를 초기화 해야함)
                                initCalendar(calendarEventsList, loginEmpNo, loginDeptNo);
                              },
                              error: function (error, status, thrown) {
                                console.log(error);
                                console.log(status);
                                console.log(thrown);
                              }
                            });
                          }

                          // 프로젝트 카드 이동
                          else if (widgetEl.dataset.widgetType == '26005') {
                            // cardContainer 카드 슬라이드 초기화
                            const projectCards = widgetEl.querySelectorAll("#cardContainer .card");
                            if (projectCards.length > 0) {
                              let currentProjectIndex = 0;

                              const showProjectCard = (index) => {
                                projectCards.forEach((card, i) => {
                                  card.classList.toggle("d-none", i !== index);
                                });
                              };

                              // 버튼 이벤트 연결 (동적으로 추가된 위젯 기준)
                              const prevBtn = widgetEl.querySelector("#prevCard");
                              const nextBtn = widgetEl.querySelector("#nextCard");

                              if (prevBtn) prevBtn.addEventListener("click", () => {
                                currentProjectIndex = (currentProjectIndex - 1 + projectCards.length) % projectCards.length;
                                showProjectCard(currentProjectIndex);
                              });

                              if (nextBtn) nextBtn.addEventListener("click", () => {
                                currentProjectIndex = (currentProjectIndex + 1) % projectCards.length;
                                showProjectCard(currentProjectIndex);
                              });

                              // 초기 카드 표시
                              showProjectCard(currentProjectIndex);
                            }
                          }

                          else if (widgetEl.dataset.widgetType == '26006') {
                            // taskContainer 카드 슬라이드 초기화
                            const taskCards = widgetEl.querySelectorAll("#taskContainer .card");
                            if (taskCards.length > 0) {
                              let currentTaskIndex = 0;
                              const showTaskCard = (index) => {
                                taskCards.forEach((card, i) => {
                                  card.classList.toggle("d-none", i !== index);
                                });
                              };

                              // 버튼 이벤트 연결 (동적으로 추가된 위젯 기준)
                              const prevBtn = widgetEl.querySelector("#prevTask");
                              const nextBtn = widgetEl.querySelector("#nextTask");

                              if (prevBtn) prevBtn.addEventListener("click", () => {
                                currentTaskIndex = (currentTaskIndex - 1 + taskCards.length) % taskCards.length;
                                showTaskCard(currentTaskIndex);
                              });

                              if (nextBtn) nextBtn.addEventListener("click", () => {
                                currentTaskIndex = (currentTaskIndex + 1) % taskCards.length;
                                showTaskCard(currentTaskIndex);
                              });

                              showTaskCard(currentTaskIndex); // 초기 표시
                            }
                          }

                        });
                      });
                      
      
                      if (document.querySelector("#calendar") != null) {
                        const calendarEventsList = [];

                        $.ajax({
                          url: "/main/schdulList",
                          type: "post",
                          contentType: "application/json;charset=utf-8",
                          success: function (result) {
                            if (result != null && result.length > 0) {
                              result.map(function (v, i) {
                                let endD = v.endDt.substring(0, 10) + 'T01:00'
                                calendarEventsList.push({
                                  id: v.schdulNo,            // 일정번호
                                  title: v.schdulTitle,      // 제목
                                  start: v.startDt,          // 시작일
                                  end: endD,              	 // 종료일
                                  backgroundColor: v.backgroundColor,  // 배경색
                                  textColor: v.textColor,     // 글자색
                                  borderColor: 'transparent',  // 테두리 없애기
                                  display: 'block',				// 이벤트 랜더링 유형
                                  extendedProps: {			  // 사용자 정보
                                    schdulCn: v.schdulCn,	// 설명
                                    empNo: v.empNo,			// 사원번호
                                    schdulTy: v.schdulTy,	// 일정유형
                                    deptNo: v.deptNo,		// 부서번호
                                    prjctNo: v.prjctNo		// 프로젝트번호
                                  }
                                });
                              });
                            }
                            // 캘린더 초기화 (그리드 안에 캘린더가 있어서 그리드가 생성되고 난 다음에 캘린더를 초기화 해야함)
                            initCalendar(calendarEventsList, loginEmpNo, loginDeptNo);
                          },
                          error: function (error, status, thrown) {
                            console.log(error);
                            console.log(status);
                            console.log(thrown);
                          }

                        });
                      }

                    });

                    // todoList 추가 버튼 클릭
                    $(document).on("click", "#todoListAddBtn", function () {
                      const todoList = $("#todoList");

                      // 1. 새로운 리스트 아이템 생성
                      const newli = document.createElement('li');
                      newli.className = "list-group-item";

                      // 2. 새로운 input 태그 생성 및 li에 추가
                      const newInput = document.createElement('input');
                      newInput.type = 'text';
                      newInput.className = 'form-control form-control-sm border-0 shadow-none'; // 부트스트랩 클래스 적용
                      newInput.placeholder = "내용 입력 후 Enter";

                      newli.appendChild(newInput);

                      // 3.ul 목록의 맨 앞에 새로운 li 추가
                      // todoList.prepend(newli);
                      todoList.append(newli); // 뒤에 추가

                      // 4. 생성된 input에 자동으로 포커스
                      newInput.focus();

                      // 5. input에서 Enter 키를 눌렀을 때 처리
                      newInput.addEventListener("keypress", function (e) {
                        if (e.key == 'Enter') {
                          const value = newInput.value.trim();
                          if (value === "") {
                            newli.remove();
                            return;
                          }

                          // 6. 서버에 저장
                          $.ajax({
                            url: '/main/addTodo',
                            method: 'POST',
                            contentType: "text/plain;charset=utf-8",
                            data: value,
                            success: function (result) {

                              const todoNo = result.todoNo;
                              const todoCn = result.todoCn;

                              // 2. li 구조 완성
                              const div = $('<div class="form-check flex-grow-1"></div>');
                              const checkbox = $(`<input class="form-check-input" type="checkbox" value="\${todoNo}" id="todo\${todoNo}">`);
                              const label = $(`<label class="form-check-label" for="todo\${todoNo}">\${todoCn}</label>`);

                              div.append(checkbox).append(label);

                              $(newli).empty().append(div);

                            },
                            error: function (error, status, thrown) {
                              console.log(error);
                              console.log(status);
                              console.log(thrown);
                              Swal.fire('오류 발생', '등록 중 오류가 발생했습니다.', 'error');
                            }
                          });

                        }
                      });
                    });

                    $(document).on("click", "#todoListDeleteBtn", function () {
                      // 체크된 항목 찾기
                      const checkedItems = $("#todoList .form-check-input:checked");

                      if (checkedItems.length === 0) {
                        return;
                      }

                      // 체크된 항목들의 ID 저장
                      const ids = [];
                      checkedItems.each(function () {
                        ids.push($(this).val());
                      });

                      // 서버로 삭제 요청
                      $.ajax({
                        url: "/main/deleteTodo",
                        method: "POST",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify(ids),
                        success: function (res) {
                          if (res === "OK") {
                            console.log("삭제 성공")

                            // 성공하면 화면에서도 제거
                            checkedItems.closest("li").remove();
                          } else {
                            Swal.fire('오류 발생', '삭제 실패.', 'error');
                          }
                        },
                        error: function (error, status, thrown) {
                          console.log(error);
                          console.log(status);
                          console.log(thrown);
                          Swal.fire('오류 발생', '삭제 중 오류가 발생했습니다.', 'error');
                        }
                      });
                    });

                    // 테이블 tbody안에 있는 tr을 클릭했을 때 실행시킬 함수
                    $(document).on("click", ".notice-table tbody tr", function () {
                      const id = $(this).data("id");
                      location.href = "/boards/noticedetail?boNo=" + id;
                    });

                    // 카드 이동 버튼 이벤트 위임
                    $(document).on("click", ".prevCard, .nextCard", function () {
                      // 클릭된 버튼이 속한 위젯 선택
                      const widgetEl = $(this).closest(".grid-stack-item");
                      const cards = widgetEl.find("#cardContainer .card");
                      if (cards.length === 0) return;

                      // 현재 보이는 카드 인덱스 찾기
                      let currentIndex = cards.index(cards.filter(":not(.d-none)"));
                      if (currentIndex === -1) currentIndex = 0;

                      // 버튼에 따라 인덱스 변경
                      if ($(this).hasClass("prevCard")) {
                        currentIndex = (currentIndex - 1 + cards.length) % cards.length;
                      } else if ($(this).hasClass("nextCard")) {
                        currentIndex = (currentIndex + 1) % cards.length;
                      }

                      // 카드 표시
                      cards.each(function (i, card) {
                        $(card).toggleClass("d-none", i !== currentIndex);
                      });
                    });
                    
                    // 나의 프로젝트 카드 이동 -------------------------
                    const projectCards = document.querySelectorAll("#cardContainer .card");
                    let currentCardIndex = 0;

                    if (projectCards.length > 0) { // 카드가 있을 때만
                      const showProjectCard = (index) => {
                    	  projectCards.forEach((card, i) => {
                          if (i === index) card.classList.remove("d-none");
                          else card.classList.add("d-none");
                        });
                      };

                      document.getElementById("prevCard").addEventListener("click", () => {
                        currentCardIndex = (currentCardIndex - 1 + projectCards.length) % projectCards.length;
                        showProjectCard(currentCardIndex);
                      });

                      document.getElementById("nextCard").addEventListener("click", () => {
                    	  currentCardIndex = (currentCardIndex + 1) % projectCards.length;
                        showProjectCard(currentCardIndex);
                      });

                      // 초기 카드 표시
                      showProjectCard(currentCardIndex);
                    }


                    // 나의 일감 카드 이동 -------------------------
                    const taskCards = document.querySelectorAll("#taskContainer .card");
                    let currentTaskIndex = 0;

                    if (taskCards.length > 0) { // 카드가 있을 때만
                      const showTaskCard = (index) => {
                        taskCards.forEach((card, i) => {
                          if (i === index) card.classList.remove("d-none");
                          else card.classList.add("d-none");
                        });
                      };

                      document.getElementById("prevTask").addEventListener("click", () => {
                        currentTaskIndex = (currentTaskIndex - 1 + taskCards.length) % taskCards.length;
                        showTaskCard(currentTaskIndex);
                      });

                      document.getElementById("nextTask").addEventListener("click", () => {
                        currentTaskIndex = (currentTaskIndex + 1) % taskCards.length;
                        showTaskCard(currentTaskIndex);
                      });

                      // 초기 카드 표시
                      showTaskCard(currentTaskIndex);
                    }


                    // 체크박스가 바뀔 때마다 update
                    $(document).on("change", ".todo-checkbox", function () {
                      const todoNo = $(this).val();
                      const checked = $(this).is(":checked") ? "Y" : "N";

                      const data = {
                        todoNo: todoNo,
                        todoCheckYn: checked
                      }

                      $.ajax({
                        url: "/main/updateTodoCheck",
                        method: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(data),
                        success: function (res) {
                          if (res === "OK") {
                            console.log("업데이트 성공", res);
                          } else {
                            Swal.fire("알림", "수정에 실패했습니다.", "warning");
                          }
                        },
                        error: function () {
                          Swal.fire("알림", "수정에 실패했습니다.", "warning");
                        }
                      });
                    });
                    
                 	// document(전체) 또는 항상 유지되는 상위 div에 위임
                    $(document).on("click", "#startWorkBtn", function() {

                        $.ajax({
                          url: "/main/startWork",
                          method: "POST",
                          contentType: "application/json",
                          success: function (res) {
                        	  
                        	console.log(res);
                            if (res) {
                              console.log("업데이트 성공", res);
                              
                              // 화면의 출근시간 부분 업데이트
                              const formatted = res.beginTime.substring(0,2) + ":" + res.beginTime.substring(2,4);
                              $("#startTimeDisplay").text(formatted); 

                              // 버튼 활성화 / 비활성화
                              $("#startWorkBtn").prop("disabled", true);
                              $("#endWorkBtn").prop("disabled", false);
                              
                              Swal.fire("알림", "출근 완료", "success");
                              
                            } else {
                              Swal.fire("알림", "출근에 실패했습니다.", "warning");
                            }
                          },
                          error: function () {
                              Swal.fire("알림", "출근에 실패했습니다.", "warning");
                          }
                        });
                      
                    });
                 	
                 	// document(전체) 또는 항상 유지되는 상위 div에 위임
                    $(document).on("click", "#endWorkBtn", function() {
                        $.ajax({
                            url: "/main/endWork",
                            method: "POST",
                            contentType: "application/json",
                            success: function (res) {
                          	  
                          	console.log(res);
                              if (res) {
                                if(res.result == 'not_found'){
                                	Swal.fire("알림", "퇴근에 실패했습니다.", "warning");
                                	return;
                                }else if (res.result == 'early'){
                                	const formatted = res.workType.workEndTime.substring(0,2) + ":" + res.workType.workEndTime.substring(2,4);
		                        	Swal.fire("알림", `정규퇴근시간(\${formatted}) 이전입니다.`, "warning");
		                        }else if (res.result == 'flexEarly'){
		                        	Swal.fire("알림", "근무시간을 못 채웠습니다(유연근무제)", "warning");
		                        }else if (res.result == 'success'){
		                        	 Swal.fire("알림", "퇴근 완료", "success");
		                        }
                                
                                // 화면의 출근시간 부분 업데이트
                                const formatted = res.record.endTime.substring(0,2) + ":" + res.record.endTime.substring(2,4);
                                $("#endTimeDisplay").text(formatted); 

                              } else {
                                Swal.fire("알림", "퇴근에 실패했습니다.", "warning");
                              }
                            },
                            error: function () {
                                Swal.fire("알림", "퇴근에 실패했습니다.", "warning");
                            }
                          });
                    });
                    
                  </script>

            </body>