<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri ="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
    
    <sec:authentication property="principal.member" var="member"/>
    

<div class="body-wrapper">
	<div class="container-fluid">
		<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">상세보기</h4>
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
								<li class="breadcrumb-item">
									<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/boards/noticelist">Board</a></li> 
								<li class="breadcrumb-item active" aria-current="page">NoticeDetail</li>
							</ol>
						</nav>
					</div>
				</div>
			</div>
		</div>

		<div class="card">
			<div class="card-body p-4">
				
				<!-- 제목 (왼쪽) 과 작성자, 등록일시, 조회수 (오른쪽)를 같은 선상에 배치 -->
				<div class="d-flex justify-content-between align-items-baseline mb-3 pb-2 border-bottom">
					<!-- 제목을 더욱 크게 표시 (fs-2로 변경) -->
					<h3 class="fw-bold fs-2 me-auto fs-6">${board.boardTitle}</h3> <%-- 제목의 폰트 사이즈 조정 --%>
					<!-- 작성자, 등록일시, 조회수 (오른쪽 정렬, text-sm으로 조정) -->
					<div class="d-flex align-items-center flex-wrap text-muted text-sm">
						<span class="d-flex align-items-center me-3 mb-1 mb-md-0">
							<i class="ti ti-user me-1"></i><span class="fw-semibold me-1">작성자:</span>
							<span>${board.empNm}</span>
						</span> <span class="d-flex align-items-center me-3 mb-1 mb-md-0">
							<i class="ti ti-calendar me-1"></i><span class="fw-semibold me-1">작성일시:</span>
							<span>${board.boardMdfcnDt}</span>

						</span> <span class="d-flex align-items-center mb-1 mb-md-0"> <i
							class="ti ti-eye me-1"></i><span class="fw-semibold me-1">조회수:</span>
							<span>${board.boardRdcnt}</span>

						</span>
					</div>
				</div>
				<!-- 제목 및 작성자, 등록일시, 조회수 정보 끝 -->

				<!-- 내용 영역 시작 -->
				<div class="mb-3">
					<label class="fs-5 form-label fw-bold">내용</label>
					<div class="form-control-plaintext border p-3 rounded fs-4"
						style="min-height: 200px;">${board.boardCn}</div>
				</div>
				<!-- 내용 영역 끝 -->


				<!-- 파일 목록 및 썸네일 표시 영역 시작 -->
					 <c:if test="${board.fileList[0].fileNo != 0}">   
					 <c:choose>
					<c:when test="${not empty board.fileList}">
						<div class="mb-4">
							<label class="fs-5 form-label fw-bold">첨부파일</label>
							<div class="border p-3 rounded"> <%-- 이 div는 이제 fileList가 있을 때만 렌더링됩니다. --%>
							<div class="d-flex flex-nowrap overflow-x-auto" style="gap: 1rem;">
								  <c:forEach var="fileVO" items="${board.fileList}">
								    <div style="flex: 0 0 auto; width: 200px;">
								      <div class="card h-100">
												<c:set var="fileMime"
													value="${fn:toLowerCase(fileVO.fileMime)}" />
												<c:choose>
													<c:when test="${fn:startsWith(fileMime, 'image')}">
														<!-- 썸네일 컨테이너: 고정 크기와 중앙 정렬을 위해 Flexbox 사용 -->
														<div
															style="width: 100%; height: 150px; display: flex; justify-content: center; align-items: center; overflow: hidden; background-color: #f8f9fa;">
															<!-- 이미지 클릭 시 모달 팝업을 띄우도록 수정 -->
															<a href="#" data-bs-toggle="modal" data-bs-target="#imageModal" 
																data-image-src="${pageContext.request.contextPath}/boards/displayFile?fileName=${fileVO.savedNm}" <%-- 모달 이미지 src를 displayFile로 통일 --%>
																data-image-alt="${fileVO.originalNm}"> 
																<img src="${pageContext.request.contextPath}/boards/displayFile?fileName=${fileVO.savedNm}" style="max-width: 100%; max-height: 100%; object-fit: contain;" alt="${fileVO.originalNm}">
															</a>
														</div>
													</c:when>
													<c:otherwise>
														<!-- 이미지 외 파일은 아이콘과 파일명 표시 -->
														<div class="card-body text-center d-flex flex-column justify-content-center align-items-center" style="height: 150px; overflow: hidden;">
															<i class="fa fa-file fa-3x mb-2 text-muted"></i>
															<p class="card-text text-truncate w-100 px-2">${fileVO.originalNm}</p>
														</div>
													</c:otherwise>
												</c:choose>
												<div class="card-footer text-center">
													<!-- 다운로드 버튼은 그대로 다운로드 기능을 유지 (경로 수정) -->
													<a href="${pageContext.request.contextPath}/boards/download/${fileVO.savedNm}" class="btn btn-sm btn-outline-info"> 
														<i class="fa fa-download"></i> 다운로드 (${fileVO.fileFancysize})
													</a>
												</div>
											</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div class="mb-4"> <%-- 파일이 없을 때만 이 div가 렌더링됩니다. --%>
							<p class="text-muted">첨부된 파일이 없습니다.</p>
						</div>
					</c:otherwise>
				</c:choose>
					 </c:if>
			
				<%-- 파일 목록 및 썸네일 표시 영역 끝 --%>

				<div class="d-flex justify-content-end gap-2">
				<form id="deleteForm" action="${pageContext.request.contextPath}/boards/delete" method="post" style="display: none;">
    			<input type="hidden" name="boNo" id="deleteBoNo">
				</form>
					<a href="${pageContext.request.contextPath}/boards/noticelist" 
						class="btn btn-primary">목록으로</a> 
					<c:if test="${board.empNo eq member.empNo}">
        <a href="${pageContext.request.contextPath}/boards/noticeupdate?boNo=${board.boardNo}"
            class="btn btn-secondary">수정</a>
        <button type="button" class="btn btn-danger"
            onclick="confirmDelete(${board.boardNo})">삭제</button>
    </c:if>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 이미지 모달 팝업 추가 -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="imageModalLabel">이미지 보기</h5>
      </div>
    <div class="modal-body text-center" style="display:flex; justify-content:center; align-items:center; overflow:hidden; padding:0;">
  <img src="" id="modalImage" alt="확대 이미지" style="max-width:100%; max-height:80vh; object-fit:contain;">
</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<script>
function confirmDelete(boNo) {
    Swal.fire({
        title: '정말로 삭제하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '네',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            // 숨겨진 폼의 input에 게시글 번호를 설정
            document.getElementById('deleteBoNo').value = boNo;
            // 폼 전송
            document.getElementById('deleteForm').submit();
        }
    });
}

// 모달이 열릴 때 이미지 소스를 업데이트하는 스크립트
document.addEventListener('DOMContentLoaded', function() {
    var imageModal = document.getElementById('imageModal');
    imageModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // 클릭된 썸네일 링크
        var imageSrc = button.getAttribute('data-image-src');
        var imageAlt = button.getAttribute('data-image-alt');
        
        var modalImage = imageModal.querySelector('#modalImage');
        modalImage.src = imageSrc;
        modalImage.alt = imageAlt;
        
        var modalTitle = imageModal.querySelector('.modal-title');
        modalTitle.textContent = imageAlt; // 모달 제목을 파일명으로 설정
    });
});
</script>

       </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>
</body>
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
</script>
</html>
