<%@ page import="kr.or.ddit.vo.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri ="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>

<style>
.cke_notifications_area{
display: none;
}
</style>
<sec:authentication property="principal.member" var="member"/>
<div class="body-wrapper">
	<div class="container-fluid">
		<div
			class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">
							<c:choose>
								<c:when test="${empty board.boardNo}">민원게시판 등록</c:when>
								<c:otherwise>민원게시판 수정</c:otherwise>
							</c:choose>
						</h4>
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a>
								</li>
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/boards/complaintboardlist">ComplaintBoard</a>
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
						<c:when test="${empty board.boardNo}">새 민원게시판 작성</c:when>
						<c:otherwise>민원게시판 수정하기</c:otherwise>
					</c:choose>
				</h5>
                
				<form
					action="${pageContext.request.contextPath}/boards/${empty board.boardNo ? 'complaintboardinsert' : 'complaintboardupdate'}"
					method="post" enctype="multipart/form-data">

					<c:if test="${not empty board.boardNo}">
						<input type="hidden" name="boardNo" value="${board.boardNo }">
						<input type="hidden" name="fileGroupNo" value="${board.fileGroupNo}">
						<!-- 수정 시 작성자 정보는 변경되지 않으므로 hidden으로 유지 -->
						<input type="hidden" name="empNo" value="${board.empNo}">
					</c:if>
					
					<c:if test="${empty board.boardNo}">
						<!-- 새 글 작성 시 작성자(empNo)는 로그인 정보에서 가져와야 합니다. -->
						<input type="hidden" name="empNo" value="${member.empNo}">
					</c:if>
					
				<input type="hidden" name="boardTy" value="02003">
				
				<div style="text-align:right">
					<button type="button" class="btn btn-outline-warning" onclick="fillDummyData()">
			   <i class="fa fa-magic"></i> 더미데이터
			</button>
			</div>
					
					<!-- 작성자 -->
					<div class="mb-3">
						<label for="empNo" class="form-label">작성자</label> 
						<input type="text" class="form-control" id="empNm" name="empNm"
							value="${empty board.empNm ? member.empNm : board.empNm }"
							readonly>
					</div>

					<!-- 제목 -->
					<div class="mb-3">
						<label for="boardTitle" class="form-label">제목</label> <input
							type="text" class="form-control" id="boardTitle"
							name="boardTitle" value="${board.boardTitle}"
							placeholder="제목을 입력하세요." required maxlength="200">
					</div>
					
					<!-- 민원 유형 -->
					<div class="mb-3">
   					 <label for="cvplTy" class="form-label">민원 유형</label>
    				<select class="form-select" id="cvplTy" name="cvplTy">
        			<option value="">유형을 선택해주세요.</option>
        			<option value="04001" ${board.cvplTy eq '04001' ? 'selected' : ''}>회의실</option>
        			<option value="04002" ${board.cvplTy eq '04002' ? 'selected' : ''}>창고</option>
        			<option value="04003" ${board.cvplTy eq '04003' ? 'selected' : ''}>사무실</option>
        			<option value="04004" ${board.cvplTy eq '04004' ? 'selected' : ''}>기타</option>
    				</select>
					</div>
					
					<!-- 민원 상태 (관리자 전용) -->
					<c:if test="${member.empNo eq '202508001' and not empty board.boardNo}">
						<div class="mb-3">
							<label for="cvplSttus" class="fs-5 form-label fw-bold">민원 처리 상태</label>
							<select class="form-select" id="cvplSttus" name="cvplSttus">
							<option value="19002" ${board.cvplSttus eq '처리중' ? 'selected' : ''}>처리중</option>
								<option value="19003" ${board.cvplSttus eq '처리완료' ? 'selected' : ''}>처리완료</option>
								<option value="19004" ${board.cvplSttus eq '반려' ? 'selected' : ''}>반려</option>
							</select>
						</div>
					</c:if>

					<!-- 내용 -->
					<div class="mb-3">
						<label for="boardCn" class="form-label">내용</label>
						<textarea class="form-control" id="boardCn" name="boardCn"
							rows="10" placeholder="내용을 입력하세요." required maxlength="500">${board.boardCn}</textarea>
					</div>

					<!-- 첨부파일 -->
					<div class="mb-4">
						<label for="uploadFiles" class="form-label">새 파일 추가</label> 
						<input class="form-control" type="file" id="uploadFiles"
							name="uploadFiles" multiple>
					</div>

					<div id="alert-area"
						style="position: fixed; top: 20px; right: 20px; width: 350px; z-index: 9999;"></div>
					
					<!-- 기존 첨부파일 목록 표시 -->
					<c:if test="${not empty board.fileList}">
					    <c:if test="${not empty board.fileList[0].savedNm}">
    					<div class="mb-4">
        				<label class="fs-5 form-label fw-bold">기존 첨부파일</label>
        				<div class="border p-3 rounded">
            			<div class="row" id="existingFiles">
                		<c:forEach var="fileVO" items="${board.fileList}">
                    		<div class="col-md-3 col-sm-6 mb-3" id="file-${fileVO.fileNo}">
                       	 <div class="card h-100">
                         	   <c:set var="fileMime" value="${fn:toLowerCase(fileVO.fileMime)}" />
                           	 <c:choose>
                            	    <c:when test="${fn:startsWith(fileMime, 'image')}">
														<!-- 이미지 썸네일 -->
														<div
															style="width: 100%; height: 150px; display: flex; justify-content: center; align-items: center; overflow: hidden; background-color: #f8f9fa;">
															<img
																src="${pageContext.request.contextPath}/boards/complaintboarddisplayFile?fileName=${fileVO.savedNm}"
																style="max-width: 100%; max-height: 100%; object-fit: contain;"
																alt="${fileVO.originalNm}">
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
                                <a href="${pageContext.request.contextPath}/boards/complaintboard/download/${fileVO.savedNm}" class="btn btn-sm btn-outline-info">
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
			<button type="submit" class="btn btn-primary">
				<c:choose>
					<c:when test="${empty board.boardNo}">등록</c:when>
					<c:otherwise>수정</c:otherwise>
				</c:choose>
			</button>
			<button type="button" class="btn btn-secondary"
				onclick="location.href='${pageContext.request.contextPath}/boards/complaintboardlist'">취소</button>
		</div>

	</div>
</div>

<script>
function fillDummyData(){
    document.getElementById("boardTitle").value = "📢사내 유리 파손 관련 민원";
    document.getElementById("cvplTy").value = "04004";

    CKEDITOR.instances.boardCn.setData(
    		"안녕하세요. 신입사원 이 예빈입니다.<br><br>" + "금일 출근 중 회사 1층 로비 유리에서 살짝 금이 간 부분을 발견하여 민원을 요청드립니다.<br>" + "아직 파손이 심각하지는 않으나, 추후 안전사고로 이어질 수 있어 빠른 확인과 조치가 필요할 것 같습니다.<br><br> <hr>" + "📌 민원 내용<br>" + "- 1층 로비 우측 출입문 근처 유리에 세로 방향 금 발생<br>" + "- 현재는 사용에 지장은 없으나 추가 충격 시 파손 위험 존재<br>" + "- 임직원 및 방문객 안전을 위해 조속한 보수 필요<br><br> <hr>" + "빠른 점검과 조치를 부탁드립니다.<br>" + "감사합니다. 🙏"
    );
}
</script>

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
