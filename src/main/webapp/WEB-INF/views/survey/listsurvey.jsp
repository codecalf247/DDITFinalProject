<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light"
	data-color-theme="Blue_Theme" data-layout="vertical">
<sec:authentication property="principal.member" var="member" />

<head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare</title>
<%@ include file="/module/headPart.jsp"%>
</head>
<%@ include file="/module/header.jsp"%>
<style>
.list-group-item .menu-link {
	display: flex;
	align-items: center; /* 아이콘과 텍스트 세로 가운데 정렬 */
}

.list-group-item .menu-link i {
	font-size: 1.2rem;
	margin-right: 6px;
}

.list-group-item.active a {
	color: #fff !important;
}
</style>
<body>
	<%@ include file="/module/aside.jsp"%>
	<div class="body-wrapper">
		<div class="container-fluid">

			<c:set var="uri" value="${pageContext.request.requestURI}" />
			<div class="body-wrapper">
				<div class="container">

					<div
						class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
						<div class="card-body px-4 py-3">
							<div class="row align-items-center">
								<div class="col-9">
									<h4 class="fw-semibold mb-8">참여가능한 설문</h4>
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a
												class="text-muted text-decoration-none" href="../main/index">Home</a>
											</li>
											<li class="breadcrumb-item" aria-current="page">Survey</li>
											<li class="breadcrumb-item" aria-current="page">ListSurvey</li>
										</ol>
									</nav>
								</div>
								<div class="col-3">
									<div class="text-center mb-n5"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="card overflow-hidden chat-application">
						<div
							class="d-flex align-items-center justify-content-between gap-6 m-3 d-lg-none">
							<button class="btn btn-primary d-flex" type="button"
								data-bs-toggle="offcanvas" data-bs-target="#chat-sidebar"
								aria-controls="chat-sidebar">
								<i class="ti ti-menu-2 fs-5"></i>
							</button>
							<form class="position-relative w-100">
								<input type="text" class="form-control search-chat py-2 ps-5"
									id="text-srh" placeholder="Search Contact" /> <i
									class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
							</form>
						</div>
						<div class="d-flex w-100">
				<div
					class="left-part border-end w-20 flex-shrink-0 d-none d-lg-block">
					<div class="px-6 pt-4">
						<div class="card">
							<div class="card-header">
								<div class="d-flex align-items-center">
									<h6 class="card-title lh-base">설문/투표</h6>
									<div class="ms-auto">
									<c:if test="${member.empNo eq '202508001'}">
									<a href="${pageContext.request.contextPath}/main/insertsurvey" class="btn btn-sm btn-outline-primary"> 새 설문 작성 </a>
									</c:if>
									</div>
								</div>
								<div class="row px-6"> ${member.empNm} (${member.deptNm})</div>
							</div>
						</div>
					</div>

								<ul class="list-group list-group-menu mh-n100" id="survey-menu">
									<li
										class="list-group-item <c:if test='${fn:contains(uri, "/survey/listsurvey")}'>active</c:if>"><a
										class="menu-link"
										href="${pageContext.request.contextPath}/main/listsurvey">
											<i class="ti ti-user-check fs-5"></i> 참여 가능한 설문
									</a></li>
									<li
										class="list-group-item <c:if test='${fn:contains(uri, "/survey/joinedsurvey")}'>active</c:if>">
										<a class="menu-link"
										href="${pageContext.request.contextPath}/main/joinedsurvey">
											<i class="ti ti-square-check"></i> 내가 참여한 설문
									</a>
									</li>
									<li
										class="list-group-item <c:if test='${fn:contains(uri, "/survey/endsurvey")}'>active</c:if>">
										<a class="menu-link"
										href="${pageContext.request.contextPath}/main/endsurvey">
											<i class="ti ti-clock fs-5"></i> 마감된 설문
									</a>
									</li>
								</ul>
							</div>
							<div class="d-flex w-100">
								<div class="w-100 p-4">
									<h4 class="mb-3">참여가능한 설문</h4>
									<table class="table table-bordered table-hover align-middle">
										<thead class="table-primary text-center">
											<tr>
												<th>번호</th>
												<th>설문 제목</th>
												<th>설문 등록일시</th>
												<th>설문 마감일시</th>
												<th>마감 상태</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="survey" items="${pagingVO.dataList}"
												varStatus="status">
												<tr>
													<td class="text-center">${survey.surveyNo}</td>
													<td><a
														href="${pageContext.request.contextPath}/main/surveyDo?surveyNo=${survey.surveyNo}">
															<c:if test="${survey.othbcYn eq 'N'}">
																<i class="ti ti-lock"></i>
															</c:if> ${survey.surveyTitle}
													</a></td>
													<td>${fn:substring(survey.surveyRegDt, 0, 10)}</td>
													<td>${fn:substring(survey.surveyDdlnDt, 0, 10)}</td>
													<td class="text-center">
														<button class="btn btn-sm btn-primary">참여가능</button>
													</td>
												</tr>
											</c:forEach>
											<c:if test="${empty pagingVO.dataList}">
												<tr>
													<td colspan="5" class="text-center">참여 가능한 설문이 없습니다.</td>
												</tr>
											</c:if>
										</tbody>
									</table>
									<div class="d-flex w-100 justify-content-center py-3">
										    <!-- 가운데 페이지네이션 -->
								    <div class="flex-grow-1 d-flex justify-content-center">
								        <nav aria-label="Page navigation" class="m-0">
								            <ul class="pagination justify-content-center mb-0">
								                ${pagingVO.pagingHTML2} <!-- 실제 li 내용 -->
								            </ul>
								        </nav>
								    </div>
									</div>
									<form id="pageForm"
										action="${pageContext.request.contextPath}/main/listsurvey"
										method="get">
										<input type="hidden" name="page" id="page">
									</form>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/module/footerPart.jsp"%>
		<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    // 모든 메뉴 항목을 가져옵니다.
    const menuItems = document.querySelectorAll('#survey-menu .list-group-item');

    // 각 메뉴 항목에 클릭 이벤트를 추가합니다.
    menuItems.forEach(item => {
        item.addEventListener('click', function(event) {
            // 모든 메뉴 항목에서 'active' 클래스를 제거합니다.
            menuItems.forEach(el => el.classList.remove('active'));
            
            // 클릭된 메뉴 항목에만 'active' 클래스를 추가합니다.
            this.classList.add('active');

            // 링크 이동을 막지 않고 기본 동작을 수행합니다.
            // event.preventDefault(); // 페이지 이동을 막으려면 이 줄을 활성화하세요.
        });
    });
});
</script>

		<script>
document.addEventListener('DOMContentLoaded', function() {
    // 컨트롤러에서 RedirectAttributes로 보낸 'msg'가 있는지 확인
    const message = '${msg}';
    if (message && message.trim() !== '') {
        Swal.fire({
            title: message,
            icon: 'success',
            confirmButtonText: '확인'
        });
    }
});

// 페이지네이션 함수
function fn_pagination(pageNo) {
	const pageForm = document.getElementById('pageForm');
	document.getElementById('page').value = pageNo;
	pageForm.submit();
}
</script>
</body>
</html>