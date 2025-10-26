<%@page import="kr.or.ddit.vo.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>

<style>
.cke_notifications_area{
display: none;
}
</style>

<div class="body-wrapper">
	<div class="container-fluid">
		<div
			class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">
							<c:choose>
								<c:when test="${empty board.boardNo}">자유게시판 등록</c:when>
								<c:otherwise>자유게시판 수정</c:otherwise>
							</c:choose>
						</h4>
					<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none" href="../main/index">Home</a>
								</li>
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/boards/freeboardlist">FreeBoard</a>
								</li>
							</ol>
						</nav>
					</div>
				</div>
			</div>
		</div>

		<div class="card">
			<div class="card-body p-4">
				<h5 class="card-title fw-semibold mb-4">
					<c:choose>
						<c:when test="${empty board.boardNo}">새 자유게시판 작성</c:when>
						<c:otherwise>자유게시판 수정하기</c:otherwise>
					</c:choose>
				</h5>

				<form
					action="${pageContext.request.contextPath}/boards/${empty board.boardNo ? 'freeboardinsert' : 'freeboardupdate'}"
					method="post" enctype="multipart/form-data">

					<c:if test="${not empty board.boardNo}">
						<input type="hidden" name="boardNo" value="${board.boardNo }">
					</c:if>
					
				<!-- 사원번호 -->
				<input type="hidden" value="202508001" id="empNo" name="empNo">
					
		

					<!-- 작성자 -->
					<div class="mb-3">
						<label for="empNo" class="form-label">작성자</label> <input
							type="text" class="form-control" id="empNm" name="empNm"
							value="${empty board.empNm ? empNm : board.empNm }"
							readonly>
					</div>

					<!-- 제목 -->
					<div class="mb-3">
						<label for="boardTitle" class="form-label">제목</label> <input
							type="text" class="form-control" id="boardTitle"
							name="boardTitle" value="${board.boardTitle}"
							placeholder="제목을 입력하세요." required maxlength="200">
					</div>

					<!-- 내용 -->
					<div class="mb-3">
						<label for="boardCn" class="form-label">내용</label>
						<textarea class="form-control" id="boardCn" name="boardCn"
							rows="10" placeholder="내용을 입력하세요." required required maxlength="500">${board.boardCn}</textarea>
					</div>

					<!-- 첨부파일 -->
					<div class="mb-4">
						<label for="uploadFiles" class="form-label">첨부파일</label> <input
							class="form-control" type="file" id="uploadFiles"
							name="uploadFiles" multiple>
					</div>

					<div id="alert-area"
						style="position: fixed; top: 20px; right: 20px; width: 350px; z-index: 9999;"></div>

					<!-- 공지사항 유형 -->
					<input type="hidden" name="boardTy" value="02002">

					<!-- 게시글 번호 (수정일 때만) -->
					<c:if test="${not empty board.boardNo}">
						<input type="hidden" name="boNo" value="${board.boardNo}">
					</c:if>
					<c:if test="${not empty board.boardNo}">
						<input type="hidden" name="fileGroupNo"
							value="${board.fileGroupNo}">
					</c:if>

					<!-- 기존 첨부파일 목록 표시 -->
					<c:if test="${not empty board.fileList}">
					    <c:if test="${not empty board.fileList[0].savedNm}">
    					<div class="mb-4">
        				<label class="fs-5 form-label fw-bold">기존 첨부파일</label>
        				<div class="border p-3 rounded">
            			<div class="row">
                		<c:forEach var="fileVO" items="${board.fileList}">
                    		<div class="col-md-3 col-sm-6 mb-3">
                       	 <div class="card h-100">
                         	   <c:set var="fileMime" value="${fn:toLowerCase(fileVO.fileMime)}" />
                           	 <c:choose>
                            	    <c:when test="${fn:startsWith(fileMime, 'image')}">
														<!-- 이미지 썸네일 -->
														<div
															style="width: 100%; height: 150px; display: flex; justify-content: center; align-items: center; overflow: hidden; background-color: #f8f9fa;">
															<img
																src="${pageContext.request.contextPath}/boards/freeboarddisplayFile?fileName=${fileVO.savedNm}"
																style="max-width: 100%; max-height: 100%; object-fit: contain;"
																alt="${fileVO.savedNm}">
														</div>
													</c:when>
													<c:otherwise>
														<!-- 이미지 외 파일 -->
														<div
															class="card-body text-center d-flex flex-column justify-content-center align-items-center"
															style="height: 150px; overflow: hidden;">
															<i class="fa fa-file fa-3x mb-2 text-muted"></i>
															<p class="card-text text-truncate w-100 px-2">${fileVO.originalNm}</p>
														</div>
												     </c:otherwise>
                            </c:choose>
                            <div class="card-footer d-flex justify-content-center align-items-center gap-2">
                               <a href="${pageContext.request.contextPath}/boards/freeboard/download/${fileVO.savedNm}" class="btn btn-sm btn-outline-info">
                                    <i class="fa fa-download"></i> 다운로드 (${fileVO.fileFancysize})
                               		 	</a>
                                	<button type="button" class="btn btn-sm btn-danger" onclick="deleteFile(${fileVO.fileNo}, this)">삭제</button>
                            	</div>
                        	</div>
                    	</div>
                	</c:forEach>
            	</div>
        	</div>
    	</div>
	</c:if>			
	</c:if>
</div>
		</div>



		<!-- 버튼 영역 -->
		<div class="d-flex justify-content-end gap-2">
			<button type="submit" class="btn btn-outline-primary">
				<c:choose>
					<c:when test="${empty board.boardNo}">등록</c:when>
					<c:otherwise>수정</c:otherwise>
				</c:choose>
			</button>
			<button type="button" class="btn btn-outline-secondary"
				onclick="location.href='${pageContext.request.contextPath}/boards/freeboardlist'">취소</button>

		</div>

	</div>
</div>

<script>
function deleteFile(fileNo, btn){
    Swal.fire({
        title: '삭제하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '네',
        cancelButtonText: '취소'
    }).then((result) => {
        if(result.isConfirmed){
            $.ajax({
                url: '${pageContext.request.contextPath}/boards/deleteFile',
                type: 'post',
                data: { fileNo: fileNo },
                success: function(res){
                    if(res === 'OK'){
                        // 버튼 눌린 파일 카드 제거
                        $(btn).closest('.col-md-3').remove();
                        Swal.fire('삭제가 완료 되었습니다!', '', 'success');
                    } else {
                        Swal.fire('삭제 실패', '', 'error');
                    }
                }
            });
        }
    });
}
</script>

<script>
document.addEventListener('DOMContentLoaded', function() {
	CKEDITOR.replace("boardCn");
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
