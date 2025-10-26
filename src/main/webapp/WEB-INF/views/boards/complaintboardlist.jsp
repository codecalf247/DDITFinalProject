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
	background-color: #dc3545;
	padding: 0.2em 0.5em;
	border-radius: 0.25rem;
	margin-right: 0.5rem;
}

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
	width: 280px;
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
						<h4 class="fw-semibold mb-8">민원게시판</h4>
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/main/index">Home</a></li>
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/boards/complaintboardlist">Boards</a>
								</li>
								<li class="breadcrumb-item active" aria-current="page">
									ComplaintBoard</li>
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
						<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24"><g fill="none" stroke="#3588df" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path stroke-dasharray="64" stroke-dashoffset="64" d="M12 3c4.97 0 9 4.03 9 9c0 4.97 -4.03 9 -9 9c-4.97 0 -9 -4.03 -9 -9c0 -4.97 4.03 -9 9 -9"><animate fill="freeze" attributeName="stroke-dashoffset" dur="0.6s" values="64;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M9 9v1"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.7s" dur="0.2s" values="2;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M15 9v1"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.9s" dur="0.2s" values="2;0"/></path><path stroke-dasharray="10" stroke-dashoffset="10" d="M8 15h8"><animate fill="freeze" attributeName="stroke-dashoffset" begin="1.1s" dur="0.2s" values="10;0"/></path></g></svg>민원게시판 목록
					</h4>

					<form id="searchForm"
						action="${pageContext.request.contextPath}/boards/complaintboardlist"
						method="get" class="d-flex">
						<div class="btn-group">
							<button id="searchTypeBtn" type="button"
								class="btn bg-secondary-subtle text-secondary dropdown-toggle me-2"
								data-bs-toggle="dropdown" aria-haspopup="true"
								aria-expanded="false">
									<c:choose>
									<c:when test="${searchType eq 'cvplTy'}">민원유형</c:when>
									<c:when test="${searchType eq 'cvplSttus'}">민원상태</c:when>
									<c:otherwise>작성자</c:otherwise> 
									</c:choose>
							</button>
							<ul class="dropdown-menu animated rubberBand">
								<li><a class="dropdown-item" data-search-type="cvplTy"
									href="#">민원유형</a></li>
								<li><a class="dropdown-item" data-search-type="cvplSttus"
									href="#">민원상태</a></li>
								<li><a class="dropdown-item" data-search-type="writer"
									href="#">작성자</a></li>
							</ul>
						</div>
						<input type="hidden" name="searchType" id="hiddenSearchType"
							value="${searchType}">
						<div class="input-group w-80">
							<input type="text" name="searchWord" class="form-control"
								value="${searchWord}" placeholder="검색어를 입력하세요.">
							<button class="btn btn-outline-secondary" type="submit">
								<i class="ti ti-search"></i> 검색
							</button>
						</div>
					</form>
				</div>

				<div class="card">
					<div class="card-body p-4">
						<div class="table-responsive">
							<table class="table board-table">
								<thead>
    <tr>
        <th class="text-center">번호</th>
        <th class="text-center">제목</th>
        <th class="text-center">작성자</th>
        <th class="text-center">등록일시</th>
        <th class="text-center">민원 유형</th>
        <th class="text-center">민원 상태</th>
        <th class="text-center">조회수</th>
    </tr>
</thead>
<tbody>
    <c:choose>
        <c:when test="${not empty pagingVO.dataList}">
            <c:forEach var="board" items="${pagingVO.dataList}" varStatus="status">
                <tr>
                    <!-- 번호 -->
                    <td class="text-center">
                        ${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - status.index}
                    </td>
                    
                    <!-- 제목 (왼쪽 정렬 유지) -->
                   <td class="text-center">
                        <c:if test="${board.imprtncTagYn eq 'Y'}">
                            <span class="important-tag">중요</span>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/boards/complaintboarddetail?boNo=${board.boardNo}">
                            ${board.boardTitle}
                        </a>
                    </td>
                    
                    <!-- 작성자 -->
                    <td class="text-center">${board.empNm}</td>
                    
                    <!-- 등록일시 -->
                    <td class="text-center">${fn:substring(board.boardMdfcnDt, 0, 10)}</td>
                    
                    <!-- 민원 유형 -->
                    <td class="text-center">${board.cvplTy}</td>
                    
                    <!-- 민원 상태 -->
                <td class="text-center">
			<c:choose>
			    <c:when test="${board.cvplSttus eq '처리중'}">
			        <span class="badge bg-warning text-dark">처리중</span>
			    </c:when>
			    <c:when test="${board.cvplSttus eq '처리완료'}">
			        <span class="badge bg-success">처리완료</span>
			    </c:when>
			    <c:when test="${board.cvplSttus eq '반려'}">
			        <span class="badge bg-danger">반려</span>
			    </c:when>
</c:choose>
			</td>
                    
                    <!-- 조회수 -->
                    <td class="text-center">${board.boardRdcnt}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="7" class="text-center">등록된 게시글이 없습니다.</td>
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
        <div class="d-flex align-items-center">
            ${pagingVO.pagingHTML2}
        </div>
    </div>

    <!-- 오른쪽 새 글 작성 버튼 -->
    <div>
        <a href="${pageContext.request.contextPath}/boards/complaintboardinsert"
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
					action="${pageContext.request.contextPath}/boards/complaintboardlist"
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
            });
        });

  /*       window.fn_pagination = function(pageNo) {
            const pageForm = document.getElementById('pageForm');
            document.getElementById('page').value = pageNo;
            pageForm.submit();
        }; */
    });
    
    
    document.addEventListener('DOMContentLoaded', function() {
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
