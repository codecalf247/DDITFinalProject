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
  
<style type="text/css">
 .jstree-default .jstree-search {
   /* 텍스트 색상 변경 */
   color: #007bff !important; 
	font-style: normal !important;
}
 </style>
 <link rel="stylesheet" 
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
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
                  <h4 class="fw-semibold mb-8">전자결재</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="../main/index">Home</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">Approval</li>
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
              <%@ include file="/WEB-INF/views/eApproval/approvalAside.jsp" %>

              <div class="right-part w-100 ps-0 ps-xl-5">

                  <div class="row">
                      <div class="col-md-6 col-lg-3">
                        <div class="card rounded-3 card-hover">
                          <div class="card-body">
                            <div class="d-flex align-items-center">
                              <span class="flex-shrink-0">
                                <i class="ti ti-location-share text-success display-6"></i>
                              </span>
                              <div class="ms-4">
	                          	<a href="${pageContext.request.contextPath }/eApproval/inProcess">
	                                <h3 class="mb-1 fs-3">상신 진행 문서</h3>
	                                <h2 class="fw-semibold fs-6">${getInProcessCnt }건</h2>
	                            </a>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      
                      <div class="col-md-6 col-lg-3">
                        <div class="card rounded-3 card-hover">
                          <div class="card-body">
                            <div class="d-flex align-items-center">
                              <span class="flex-shrink-0">
                                <i class="ti ti-file-alert text-warning display-6"></i>
                              </span>
                              <div class="ms-4">
	                             <a href="${pageContext.request.contextPath }/eApproval/inbox">
	                                <h3 class="mb-1 fs-3">결재 요청 문서</h3>
	                                <h2 class="fw-semibold fs-6">${getInBoxCnt }건</h2>
	                              </a>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      
                      <div class="col-md-6 col-lg-3">
                        <div class="card rounded-3 card-hover">
                          <div class="card-body">
                            <div class="d-flex align-items-center">
                              <span class="flex-shrink-0">
                                <i class="ti ti-rubber-stamp text-primary display-6"></i>
                              </span>
                              <div class="ms-4">
	                              <a href="${pageContext.request.contextPath }/eApproval/history">
	                                <h3 class="mb-1 fs-3">처리 완료된 결재</h3>
	                                <h2 class="fw-semibold fs-6">${getCompletedCnt }건</h2>
	                              </a>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      
                      <div class="col-md-6 col-lg-3">
                        <div class="card rounded-3 card-hover">
                          <div class="card-body">
                            <div class="d-flex align-items-center">
                              <span class="flex-shrink-0">
                                <i class="ti ti-file-sad text-danger display-6"></i>
                              </span>
                              <div class="ms-4">
	                              <a href="${pageContext.request.contextPath }/eApproval/rejectDocument">
	                                <h3 class="mb-1 fs-3">반려된 결재</h3>
	                                <h2 class="fw-semibold fs-6">${getRejectDocCnt }건</h2>
	                              </a>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                  </div>

				  <div class="right-part w-100 ps-0 ps-xl-0">
                    <div class="card bg-light-info shadow-none position-relative overflow-hidden mb-4">
                      <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between gap-6 m-3 d-lg-none">
                          <button class="btn btn-primary d-flex" type="button" data-bs-toggle="offcanvas" data-bs-target="#chat-sidebar" aria-controls="chat-sidebar">
                            <i class="ti ti-menu-2 fs-5"></i>
                          </button>
                        </div>
                        <div class="d-flex w-100">
                          <div class="w-100">
                            <div class="row">
                              <div class="col-12 mb-3">
                                <h5 class="fw-semibold">
	                                <a href="${pageContext.request.contextPath }/eApproval/approvalFormFolder">
	                              	  즐겨찾는 결재 양식
	                                </a>
                                </h5>
                              </div>
                            </div>
                            
							<div class="row g-4 mb-5" id="approvalWrite">
							  <c:forEach items="${sanctnFormBkmkList }" var="bkmk">
	                            <div class="col-md-6 col-lg-3">
	                                <div class="card rounded-3 card-hover text-center">
	                                  <div class="card-body">
	                                    <span class="flex-shrink-0">
	                                      <i class="ti ti-pencil-up display-6"></i>
	                                    </span>
	                                    <div class="mt-3">
	                                      <h3 class="mb-1 fs-3">${bkmk.formNm }</h3>
	                                      <h2 class="card-subtitle fs-2">${bkmk.formDc }</h2>
	                                    </div>
	                                  </div>
	                                </div>
	                              </div>
							  </c:forEach>
							</div>
                            
							<div class="row">
                              <div class="col-12 mb-3">
                                <h5 class="fw-semibold">최근 기안 문서 목록</h5>
                              </div>
                            </div>
                            <div class="table-responsive">
                              <table class="table align-middle table-hover">
                                <thead>
                                  <tr>
                                    <th>문서번호</th>
                                    <th>제목</th>
                                    <th>기안자</th>
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
												최근 기안 결재내역 문서가 없습니다.</td>
										</tr>
									</c:if>
									<c:forEach items="${sanctnDocList }" var="recentSanctnDoc">
										<tr>
											<td>${recentSanctnDoc.sanctnDocNo }</td>
											<td><c:if test="${recentSanctnDoc.emrgncyYn eq 'Y' }">
													<span class="mb-1 badge text-bg-danger">긴급</span>
												</c:if> 
												<c:choose>
													<c:when test="${recentSanctnDoc.docProcessSttus eq '09001' or recentSanctnDoc.docProcessSttus eq '09005'}">
														<a href="${pageContext.request.contextPath }/eApproval/register/${recentSanctnDoc.sanctnDocNo}?drafterId=${recentSanctnDoc.empNo}">
															${recentSanctnDoc.sanctnTitle }</a>
													</c:when>
													<c:otherwise>
														<a href="${pageContext.request.contextPath }/eApproval/detail/${recentSanctnDoc.sanctnDocNo}?drafterId=${recentSanctnDoc.empNo}">
															${recentSanctnDoc.sanctnTitle }</a>
												</c:otherwise>
												</c:choose>
											</td>
											<td><i class="ti ti-user fs-4 me-1"></i>${recentSanctnDoc.empNm }
											</td>
											<td>${fn:substring(recentSanctnDoc.wrtDt, 0, 4) }-
												${fn:substring(recentSanctnDoc.wrtDt, 5, 7) }-
												${fn:substring(recentSanctnDoc.wrtDt, 8, 10) }</td>
											<td>
												<c:if test="${recentSanctnDoc.docProcessSttus eq '09001'}">
													<div class="mb-1 badge text-bg-primary">대기</div>
												</c:if>
												<c:if test="${recentSanctnDoc.docProcessSttus eq '09002'}">
													<div class="mb-1 badge text-bg-success">진행중</div>
												</c:if>
												<c:if test="${recentSanctnDoc.docProcessSttus eq '09003'}">
													<div class="mb-1 badge text-bg-secondary">완료</div>
												</c:if>
												<c:if test="${recentSanctnDoc.docProcessSttus eq '09004'}">
													<div class="mb-1 badge text-bg-danger">반려</div>
												</c:if>
												<c:if test="${recentSanctnDoc.docProcessSttus eq '09005'}">
													<div class="mb-1 badge text-bg-info">임시저장</div>
												</c:if>
											</td>
											<td>
												<c:choose>
													<c:when test="${recentSanctnDoc.hasFile eq 'Y' }">
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
                        </div>
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
document.addEventListener("DOMContentLoaded", function(){
	
	// 즐겨찾는 결재 양식 클릭시
	document.querySelector("#approvalWrite").addEventListener("click", function(e){
	    // 카드 안 h3 제목 가져오기
	    let title = e.target.closest(".card").querySelector("h3").textContent.trim();
	    console.log(title);

		new bootstrap.Modal(document.querySelector("#newApprovalModal")).show();
		
		document.querySelector("#docSchName").value = title;
		document.querySelector("#docSch").click();
		
		// 첫 번째 검색 결과
		let firstResult = document.querySelector(".jstree-search"); 
		// 첫번째 검색 결과로 data 넣어주기
        if(firstResult) firstResult.click();
	});
	
	
});

</script>

<%@ include file="/module/footerPart.jsp" %>
</body>