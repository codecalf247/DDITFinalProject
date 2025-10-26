<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <!-- Required meta tags -->
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
  <%@ include file="/module/header.jsp" %>

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
                  <h4 class="fw-semibold mb-8">결재내역</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="../main/index">Home</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">
                        <a class="text-muted text-decoration-none" href="/eApproval/dashBoard">Approval</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">approvalHistory</li>
                    </ol>
                  </nav>
                </div>
                <div class="col-3">
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
							<%@ include file="/WEB-INF/views/eApproval/approvalAside.jsp"%>

							<div class="d-flex w-100 right-part">
								<div class="w-100 ps-0 ps-xl-5">
									<div
										class="card bg-light-info shadow-none position-relative overflow-hidden mb-4">
										<div class="card-body">
											<div class="row">
												<div
													class="col-12 d-flex justify-content-between align-items-center">
													<h5 class="text-dark">전체 ${cnt }건</h5>
													<div class="d-flex flex-wrap gap-2 align-items-center">
														<form id="searchForm"
															action="${pageContext.request.contextPath}/eApproval/history"
															method="get" class="d-flex">
															<input type="hidden" name="page" id="page" />
															<div class="btn-group">
																<div class="dropdown">
																	<select class="form-select me-2" name="searchType"
																		style="width: auto; display: inline-block;">
																		<option value="title"
																			<c:if test="${searchType == 'title' }">selected</c:if>>제목</option>
																		<option value="empNm"
																			<c:if test="${searchType == 'empNm' }">selected</c:if>>기안자</option>
																	</select>
																</div>
															</div>
															<div class="input-group w-80">
																<input type="text" name="searchWord"
																	class="form-control" value="${searchWord }"
																	placeholder="검색어를 입력하세요.">
																<button class="btn btn-outline-secondary" type="submit">
																	<i class="ti ti-search"></i> 검색
																</button>
															</div>
														</form>
													</div>
												</div>
												<hr class="mt-3">
												<br />
												<div class="table-responsive">
													<table class="table align-middle table-hover">
														<thead>
															<tr>
																<th>문서번호</th>
																<th>제목</th>
																<th>기안자</th>
																<th>부서</th>
																<th>기안일시</th>
																<th>상태</th>
																<th>파일첨부</th>
															</tr>
														</thead>
														<tbody>
															<c:if test="${empty sanctnDocList}">
																<tr>
																	<td colspan="7"
																		style="text-align: center; color: black; font-size: 15px;">
																		결재내역 문서가 없습니다.</td>
																</tr>
															</c:if>
															<c:forEach items="${sanctnDocList }" var="historySanctnDoc">
																<tr>
																	<td>${historySanctnDoc.sanctnDocNo }</td>
																	<td><c:if test="${historySanctnDoc.emrgncyYn eq 'Y' }">
																			<span class="mb-1 badge text-bg-danger">긴급</span>
																		</c:if> <a
																		href="${pageContext.request.contextPath }/eApproval/detail/${historySanctnDoc.sanctnDocNo}?drafterId=${historySanctnDoc.empNo}">
																			${historySanctnDoc.sanctnTitle } </a></td>
																	<td><i class="ti ti-user fs-4 me-1"></i>${historySanctnDoc.empNm }
																	</td>
																	<td>${historySanctnDoc.deptNm }</td>
																	<td>${fn:substring(historySanctnDoc.wrtDt, 0, 4) }-
																		${fn:substring(historySanctnDoc.wrtDt, 5, 7) }-
																		${fn:substring(historySanctnDoc.wrtDt, 8, 10) }</td>
																	<td>
																		<c:if test="${historySanctnDoc.sanctnSttus eq '20003'}">
																			<div class="mb-1 badge text-bg-primary">승인</div>
																		</c:if>
																		<c:if test="${historySanctnDoc.sanctnSttus eq '20004'}">
																			<div class="mb-1 badge text-bg-success">대결</div>
																		</c:if>
																		<c:if test="${historySanctnDoc.sanctnSttus eq '20005'}">
																			<div class="mb-1 badge text-bg-secondary">전결</div>
																		</c:if>
																		<c:if test="${historySanctnDoc.sanctnSttus eq '20007'}">
																			<div class="mb-1 badge text-bg-danger">반려</div>
																		</c:if>
																	</td>
																	<td>
																		<c:choose>
																			<c:when test="${historySanctnDoc.hasFile eq 'Y' }">
																				<svg xmlns="http://www.w3.org/2000/svg" width="20"
																					height="20" viewBox="0 0 24 24">
																					<g fill="none" stroke="currentColor"
																						stroke-linejoin="round" stroke-width="1.5">
																					<path stroke-linecap="round"
																						d="M4 4v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8.342a2 2 0 0 0-.602-1.43l-4.44-4.342A2 2 0 0 0 13.56 2H6a2 2 0 0 0-2 2m5 9h6m-6 4h3" />
																					<path d="M14 2v4a2 2 0 0 0 2 2h4" /></g></svg>
																			</c:when>
																			<c:otherwise>
																			</c:otherwise>
																		</c:choose>
																	</td>
																</tr>
															</c:forEach>
														</tbody>
													</table>
												</div>
											</div>

											<!-- 페이지네이션 -->
											<div id="paging">${pagingVO.pagingHTML2}</div>

										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
 
        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

 <script type="text/javascript">

 </script>
<%@ include file="/module/footerPart.jsp" %>
</body>

 </html>