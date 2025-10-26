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
                  <h4 class="fw-semibold mb-8">전자결재 대시보드</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="../main/index.html">Home</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">Project</li>
                    </ol>
                  </nav>
                </div>
                <div class="col-3">
                  <div class="text-center mb-n5">
                    <img src="../assets/images/breadcrumb/ChatBc.png" alt="modernize-img" class="img-fluid mb-n4" />
                  </div>
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
              <div class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
                <div class="px-6 pt-4">
				  <div class="card">
				    <div class="card-header">
					  <div class="d-flex align-items-center">
					    <h6 class="card-title 1h-base">전자결재</h6>
						<div class="ms-auto">
						  <div class="link d-flex btn-minimize px-2 text-white align-items-center">
						    <button class="btn btn-sm btn-outline-primary">새 결제 작성</button>
						  </div>
						</div>
					  </div>
						<div class="row px-6">
						  김지후 (디자인팀 사원)
						</div>
					</div>
				  </div>
                </div>
                <ul class="list-group list-group-menu mh-n100">
					<li class="border-bottom my-3"></li>
					<li class="list-group-item has-submenu">
						<a class="menu-link" href="#">
							<i class="ti ti-folder fs-5"></i>
							결재 상신함
							<i class="ti ti-chevron-right menu-toggle"></i>
						</a>
						<ul class="submenu">
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-file-text fs-5"></i>
									결재대기
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									결재진행
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									결재완료
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									임시저장
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									반려함
								</a>
							</li>
						</ul>
					</li>
					<li class="list-group-item has-submenu">
						<a class="menu-link" href="#">
							<i class="ti ti-folder fs-5"></i>
							결재 수신함
							<i class="ti ti-chevron-right menu-toggle"></i>
						</a>
						<ul class="submenu">
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-file-text fs-5"></i>
									수신결재
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									결재내역
								</a>
							</li>
							<li class="list-group-item">
								<a class="menu-link" href="#">
									<i class="ti ti-trash fs-5"></i>
									수신참조
								</a>
							</li>
						</ul>
					</li>
					<li class="border-bottom my-3"></li>
					<li class="fw-semibold text-dark text-uppercase mx-9 my-2 px-3 fs-2">
						LABELS
					</li>
					<li class="list-group-item">
						<a class="menu-link" href="#">
							<i class="ti ti-folder fs-5 text-primary"></i>
							전자결재 양식
						</a>
					</li>
					<li class="list-group-item">
						<a class="menu-link" href="#">
							<i class="ti ti-folder fs-5 text-warning"></i>
							휴지통
						</a>
					</li>
				</ul>
              </div>
              <div class="d-flex w-100">
                <div class="w-100">
				프로젝트 UI를 만들어주세요.
                </div>
              </div>

              <div class="offcanvas offcanvas-start user-chat-box" tabindex="-1" id="chat-sidebar" aria-labelledby="offcanvasExampleLabel">
                <div class="offcanvas-header">
                  <h5 class="offcanvas-title" id="offcanvasExampleLabel">
                    Email
                  </h5>
                  <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                </div>
                <div class="px-9 pt-4 pb-3">
                  <button class="btn btn-primary fw-semibold py-8 w-100" data-bs-toggle="modal" data-bs-target="#compose">
                    Compose
                  </button>
                </div>
                <ul class="list-group h-n150" data-simplebar>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-inbox fs-5"></i>Inbox
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-brand-telegram fs-5"></i>Sent
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-file-text fs-5"></i>Draft
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-inbox fs-5"></i>Spam
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-trash fs-5"></i>Trash
                    </a>
                  </li>
                  <li class="border-bottom my-3"></li>
                  <li class="fw-semibold text-dark text-uppercase mx-9 my-2 px-3 fs-2">
                    IMPORTANT
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-star fs-5"></i>Starred
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)" class="d-block">
                      <i class="ti ti-badge fs-5"></i>Important
                    </a>
                  </li>
                  <li class="border-bottom my-3"></li>
                  <li class="fw-semibold text-dark text-uppercase mx-9 my-2 px-3 fs-2">
                    LABELS
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-bookmark fs-5 text-primary"></i>Promotional
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-bookmark fs-5 text-warning"></i>Social
                    </a>
                  </li>
                  <li class="list-group-item border-0 p-0 mx-9">
                    <a class="d-flex align-items-center gap-6 list-group-item-action text-dark px-3 py-8 mb-1 rounded-1" href="javascript:void(0)">
                      <i class="ti ti-bookmark fs-5 text-success"></i>Health
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
      
  
        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

      
 <%@ include file="/module/footerPart.jsp" %>
 </body>