<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
.board-table th, .board-table td {
	vertical-align: middle;
}

.pagination {
    margin: 0;          /* 위/아래 margin 제거 */
}

.board-table a {
	text-decoration: none;
	color: #495057;
}

.board-table a:hover {
	color: #2c7be5;
	text-decoration: underline;
}

.important-tag {
	font-size: 0.75rem;
	font-weight: bold;
	color: #fff;
	background-color: #dc3545; /* 빨간색 */
	padding: 0.2em 0.5em;
	border-radius: 0.25rem;
	margin-right: 0.5rem;
}
/* 사이드바 메뉴 스타일 */
.list-group-menu .list-group-item.active a {
	color: #fff !important;
}

.list-group-menu .menu-link {
	display: flex;
	align-items: center;
}

.list-group-menu .menu-link i {
	font-size: 1.2rem;
	margin-right: 6px;
}

.left-part {
	/* 기존: 너비 20%로 설정 */
	width: 280px; /* 고정 너비로 변경하여 더 넓게 설정 */
}

.btn {
  white-space: nowrap; /* 줄바꿈 금지 */
}

.btn svg {
  vertical-align: middle; /* 텍스트랑 높이 맞추기 */
}
</style>

<c:set var="uri" value="${pageContext.request.requestURI}" />

<div class="body-wrapper">
	<div class="container-fluid">
		<div
			class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">자유게시판</h4>
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/main/index">Home</a></li>
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/boards/freeboardlist">Boards</a>
								</li>
								<li class="breadcrumb-item active" aria-current="page">
									FreeBoard</li>
							</ol>
						</nav>
					</div>
				</div>
			</div>
		</div>
		<div class="d-flex w-100 flex-column">
			<div class="w-100 p-4">
				<!-- 검색 및 필터 섹션 -->
				<div class="d-flex justify-content-between align-items-center mb-3">
					<h4 class="mb-0 d-flex align-items-center">
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24"><path fill="#3588df" d="M12 15c-2.5 0 -3.25 0 -4 0c-0.55 0 -1 0 -1 0c0 0 1.5 0 5 0c3.5 0 5 0 5 0c0 0 -0.45 0 -1 0c-0.75 0 -1.5 0 -4 0Z"><animate fill="freeze" attributeName="d" begin="1.1s" dur="0.2s" values="M12 15c-2.5 0 -3.25 0 -4 0c-0.55 0 -1 0 -1 0c0 0 1.5 0 5 0c3.5 0 5 0 5 0c0 0 -0.45 0 -1 0c-0.75 0 -1.5 0 -4 0Z;M12 14c-2.5 0 -3.25 -1 -4 -1c-0.55 0 -1 0.45 -1 1c0 0.75 1.5 4 5 4c3.5 0 5 -3.25 5 -4c0 -0.55 -0.45 -1 -1 -1c-0.75 0 -1.5 1 -4 1Z"/></path><g fill="none" stroke="#3588df" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path stroke-dasharray="64" stroke-dashoffset="64" d="M12 3c4.97 0 9 4.03 9 9c0 4.97 -4.03 9 -9 9c-4.97 0 -9 -4.03 -9 -9c0 -4.97 4.03 -9 9 -9"><animate fill="freeze" attributeName="stroke-dashoffset" dur="0.6s" values="64;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M9 9v1"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.7s" dur="0.2s" values="2;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M15 9v1"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.9s" dur="0.2s" values="2;0"/></path></g></svg>
						자유게시판 목록
					</h4>

					<form id="searchForm"
						action="${pageContext.request.contextPath}/boards/freeboardlist"
						method="get" class="d-flex">
						<div class="btn-group">
							<button id="searchTypeBtn" type="button"
								class="btn bg-secondary-subtle text-secondary dropdown-toggle me-2"
								data-bs-toggle="dropdown" aria-haspopup="true"
								aria-expanded="false">
								<c:choose>
									<c:when test="${searchType eq 'writer'}">작성자</c:when>
									<c:when test="${searchType eq 'content'}">내용</c:when>
									<c:otherwise>제목</c:otherwise>
								</c:choose>
							</button>
							<ul class="dropdown-menu animated rubberBand">
								<li><a class="dropdown-item" data-search-type="title"
									href="#">제목</a></li>
								<li><a class="dropdown-item" data-search-type="writer"
									href="#">작성자</a></li>
								<li><a class="dropdown-item" data-search-type="content"
									href="#">내용</a></li>
							</ul>
						</div>
						<input type="hidden" name="searchType" id="hiddenSearchType"
							value="${searchType}">
						<div class="input-group w-80">
							<input type="text" name="searchWord" class="form-control"
								value="${searchWord}" placeholder="검색어를 입력하세요.">
							<button class="btn btn-outline-secondary" type="submit"><i class="ti ti-search"></i> 검색</button>
						</div>
					</form>
				</div>

				<div class="card">
					<div class="card-body p-4">
						<div class="table-responsive">
							<table class="table board-table">
								<thead>
									<tr>
										<th>번호</th>
										<th>제목</th>
										<th>작성자</th>
										<th>등록일시</th>
										<th>조회수</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${not empty pagingVO.dataList}">
											<c:forEach var="board" items="${pagingVO.dataList}"
												varStatus="status">
												<tr>
													<!-- 번호: (전체 레코드 수 - (현재 페이지 - 1) * 페이지 당 레코드 수 - 현재 인덱스) -->
													<td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - status.index}</td>
													<td><c:if test="${board.imprtncTagYn eq 'Y'}">
															<span class="important-tag">중요</span>
														</c:if> <a
														href="${pageContext.request.contextPath}/boards/freeboarddetail?boNo=${board.boardNo}">
															${board.boardTitle} </a></td>
													<td>${board.empNm}</td>
													<td>${fn:substring(board.boardMdfcnDt, 0, 10)}</td>
													<td>${board.boardRdcnt}</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td colspan="5" class="text-center">등록된 게시글이 없습니다.</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
					</div>
				</div>
<div class="d-flex align-items-center justify-content-between mb-3">
    <!-- 가운데 페이지네이션 -->
    <div class="flex-grow-1 d-flex justify-content-center">
        <nav aria-label="Page navigation" class="m-0"> <!-- nav에 margin 0 적용 -->
            <ul class="pagination justify-content-center mb-0"> <!-- ul 기본 margin 제거 -->
                ${pagingVO.pagingHTML2}
            </ul>
        </nav>
    </div>

    <!-- 오른쪽 버튼 -->
    <div>
        <a href="${pageContext.request.contextPath}/boards/freeboardinsert" 
           class="btn btn-primary d-flex align-items-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                 viewBox="0 0 24 24" class="me-1">
              <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
                <path stroke-dasharray="20" stroke-dashoffset="20" d="M3 21h18">
                  <animate fill="freeze" attributeName="stroke-dashoffset" dur="0.2s" values="20;0" />
                </path>
                <path stroke-dasharray="48" stroke-dashoffset="48" d="M7 17v-4l10 -10l4 4l-10 10h-4">
                  <animate fill="freeze" attributeName="stroke-dashoffset" begin="0.2s" dur="0.6s" values="48;0" />
                </path>
                <path stroke-dasharray="8" stroke-dashoffset="8" d="M14 6l4 4">
                  <animate fill="freeze" attributeName="stroke-dashoffset" begin="0.8s" dur="0.2s" values="8;0" />
                </path>
              </g>
            </svg>
            새 글 작성
        </a>
    </div>
</div>

				<form id="pageForm"
					action="${pageContext.request.contextPath}/boards/freeboardlist"
					method="get">
					<input type="hidden" name="page" id="page"> <input
						type="hidden" name="searchType" value="${searchType}"> <input
						type="hidden" name="searchWord" value="${searchWord}">
				</form>
				<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownItems = document.querySelectorAll('.dropdown-menu .dropdown-item');
        const searchTypeBtn = document.getElementById('searchTypeBtn');
        const hiddenSearchType = document.getElementById('hiddenSearchType');
        const searchForm = document.getElementById('searchForm'); 

        dropdownItems.forEach(item => {
            item.addEventListener('click', function(event) {
                event.preventDefault(); 
                
                const selectedText = this.textContent;
                const selectedSearchType = this.getAttribute('data-search-type');
                
                searchTypeBtn.textContent = selectedText;
                hiddenSearchType.value = selectedSearchType;
                
                // 검색 유형 변경 시 자동으로 폼을 제출
//                 searchForm.submit(); 
            });
        });

//         window.fn_pagination = function(pageNo) {
//             const pageForm = document.getElementById('pageForm');
//             document.getElementById('page').value = pageNo;
//             pageForm.submit();
//         };
    });
    
    
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
    
</script>



				<%@ include file="/module/footerPart.jsp"%>