<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri ="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
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
									<a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/boards/freeboardlist">FreeBoard</a></li> 
								<li class="breadcrumb-item active" aria-current="page">FreeBoardDetail</li>
							</ol>
						</nav>
					</div>
				</div>
			</div>
		</div>

		<div class="card">
			<div class="card-body p-4">
				
				<div class="d-flex justify-content-between align-items-baseline mb-3 pb-2 border-bottom">
					<h3 class="fw-bold fs-2 me-auto fs-6">${board.boardTitle}</h3> <%-- 제목의 폰트 사이즈 조정 --%>
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
				<div class="mb-3">
					<label class="fs-5 form-label fw-bold">내용</label>
					<div class="form-control-plaintext border p-3 rounded fs-4"
						style="min-height: 200px;">${board.boardCn}</div>
				</div>
				<c:if test="${board.fileList[0].fileNo != 0}">   
					 <c:choose>
					<c:when test="${not empty board.fileList}">
						<div class="mb-4">
							<label class="fs-5 form-label fw-bold">첨부파일</label>
							<div class="border p-3 rounded"> <%-- 이 div는 이제 fileList가 있을 때만 렌더링됩니다. --%>
								<div class="row">
									<c:forEach var="fileVO" items="${board.fileList}">
										<div class="col-md-3 col-sm-6 mb-3">
											<div class="card h-100">
												<c:set var="fileMime"
													value="${fn:toLowerCase(fileVO.fileMime)}" />
												<c:choose>
													<c:when test="${fn:startsWith(fileMime, 'image')}">
														<div
															style="width: 100%; height: 150px; display: flex; justify-content: center; align-items: center; overflow: hidden; background-color: #f8f9fa;">
															<a href="#" data-bs-toggle="modal" data-bs-target="#imageModal" 
																data-image-src="${pageContext.request.contextPath}/boards/displayFile?fileName=${fileVO.savedNm}" <%-- 모달 이미지 src를 displayFile로 통일 --%>
																data-image-alt="${fileVO.originalNm}"> 
																<img src="${pageContext.request.contextPath}/boards/displayFile?fileName=${fileVO.savedNm}" style="max-width: 100%; max-height: 100%; object-fit: contain;" alt="${fileVO.originalNm}">
															</a>
														</div>
													</c:when>
													<c:otherwise>
														<div class="card-body text-center d-flex flex-column justify-content-center align-items-center" style="height: 150px; overflow: hidden;">
															<i class="fa fa-file fa-3x mb-2 text-muted"></i>
															<p class="card-text text-truncate w-100 px-2">${fileVO.originalNm}</p>
														</div>
													</c:otherwise>
												</c:choose>
												<div class="card-footer text-center">
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
				<form id="deleteForm" action="${pageContext.request.contextPath}/boards/freeboarddelete" method="post" style="display: none;">
    			<input type="hidden" name="boNo" id="deleteBoNo">
				</form>
					<a href="${pageContext.request.contextPath}/boards/freeboardlist" 
						class="btn btn-primary">목록으로</a> 
					 <c:if test="${board.empNo eq member.empNo}">
        <a href="${pageContext.request.contextPath}/boards/freeboardupdate?boNo=${board.boardNo}"
            class="btn btn-secondary">수정</a>
        <button type="button" class="btn btn-danger"
            onclick="confirmDelete(${board.boardNo})">삭제</button>
    </c:if>
				</div>
			</div>
		</div>
		<div class="card mt-4">
			<div class="card-body p-4">
				<h5 class="fw-semibold mb-3">댓글</h5>
				
				<div class="mb-4">
					<form id="commentForm">
						<input type="hidden" name="boardNo" value="${board.boardNo}">
						<input type="hidden" name="upperCmNo" value="0">
						<textarea class="form-control" id="cmCn" name="cmCn" rows="3" placeholder="댓글을 입력하세요." onkeyup="contentLengthCheck(this)"></textarea>
						<div class="d-flex justify-content-end mt-2">
							<button type="button" id="cmtBtn" class="btn btn-primary btn-sm">등록</button>
						</div>
					</form>
				</div>
				
				<div id="commentList" class="comment-list">
				
					</div>
			</div>
		</div>
		</div>
</div>
	</div>
</div>

<div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="imageModalLabel">이미지 보기</h5>
      </div>
    <div class="modal-body text-center" 
     style="display:flex; justify-content:center; align-items:center; overflow:hidden; padding:0;">
  <img src="" id="modalImage" alt="확대 이미지" 
       style="max-width:100%; max-height:80vh; object-fit:contain;">
</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
</body>

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

<script type="text/javascript">
$(document).ready(function() {
    let cmtBtn = $("#cmtBtn");       		   // 댓글 등록 버튼 (상위 폼)
    let cmCn = $("#cmCn");					   // 댓글 입력 textarea
    let commentList = $("#commentList");       // 댓글 목록을 출력할 area
    
    // 세션 정보 및 게시글 번호
    const boardNo = ${board.boardNo};

    // 댓글 등록 처리
    cmtBtn.on("click", function(){
        let comment = cmCn.val();
        console.log(comment);
        
        if(comment == null || comment.trim() == ""){
            Swal.fire("알림", "댓글 내용을 입력해주세요!", "warning");
            return false;
        }
        
        let data = {
        	boardNo: boardNo,
            cmCn: comment
        };
        
        $.ajax({
            url: "${pageContext.request.contextPath}/boards/insertCmt",
            type: "post",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            success: function(result) {
                if(result === "OK"){
                    Swal.fire("댓글 등록 완료!", "", "success");
                    cmCn.val("");
                    selectCommentList();
                }
            },
            
            error : function(error, status, thrown) {
            	console.log(error);
            	console.log(status);
            	console.log(thrown);
                Swal.fire("오류 발생", "댓글 등록 중 오류가 발생했습니다.", "error");
            }
          });
    });

	// 답글 버튼 이벤트
	commentList.on("click", ".cmtReply", function(){
		let html = ``;
		let text = $(this).text(); 	// 버튼 text(답글/답글 접기)
		
		commentList.find(".cmt-sub-area").find(".cmt-sub-text").hide();
		commentList.find(".cmtReply").text("답글");
		
		if(text == "답글"){
			html += `
				<div class="img-push pt-3 cmt-sub-text">
				<textarea class="form-control form-control-sm cmCn"
					rows="5" cols="20"
					placeholder="Press enter to post comment" onkeyup="contentLengthCheck(this)"></textarea>
				<div class="text-right pt-2">
					<span class="pt-1"><span class="cmt-sub-size">0</span>/650</span>
					<button type="button" class="btn btn-sm btn-primary cmtBtn">등록</button>
				</div>
			</div>
			`;
			$(this).parents(".cmt-sub-area").find(".cmt-sub-write-area").html(html);
			$(this).text("답글 접기");
		}else{
			$(this).parents(".cmt-sub-area").find(".cmt-sub-text").hide();
			$(this).text("답글");
		}
	});
	
	commentList.on("click", ".cmtBtn", function(){
		let goPage = "${pageContext.request.contextPath}/boards/insertSubCmt";
		let cmNo = $(this).parents(".cmt-sub-area").data("cmt-no");
		let cmCn = $(this).parents(".cmt-sub-text").find(".cmCn").val();
		
		console.log("# 대댓글 입력 no " + cmNo);
		console.log("# 대댓글 입력 content : " + cmCn);
		
		if(cmCn == null || cmCn.trim() == "") {
			Swal.fire("알림", "댓글 내용을 입력해주세요!", "warning");
			return false;
		}
		
		let data = {
				cmNo : cmNo,
				boardNo: boardNo,
				upperCmNo : cmNo,
				cmCn : cmCn
		}
		
		let successMessage = "댓글 등록 완료!";
        if($(this).text() == "수정") {
            goPage = "${pageContext.request.contextPath}/boards/updateSubCmt";
            successMessage = "댓글 수정 완료!";
        }
		
		$.ajax({
			url : goPage,
			type : "post",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			success : function(result){
				if(result === "OK"){
                    Swal.fire(successMessage, "", "success");
					selectCommentList();
				}
				
			},
			error : function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
                Swal.fire("오류 발생", "작업 중 오류가 발생했습니다.", "error");
			}
			
		})
		
	});

	//댓글 수정 버튼 이벤트
	commentList.on("click", ".cmtEdit", function(){
		// 답글 버튼을 눌렀다가 다시 수정을 할 수도 있기 때문에 초기화를 진행한다.
		commentList.find(".cmt-sub-area").find(".cmt-sub-text").hide();
		commentList.find(".cmtReply").text("답글");
		
		// 수정된 내용을 가져온다.
		let content = $(this).parents(".cmt-sub-area").find(".cmt-sub-content").text().trim();
		let html = `
			<div class="img-push pt-3 cmt-sub-text">
			<textarea class="form-control form-control-sm cmCn"
				rows="5" cols="20"
				placeholder="Press enter to post comment" onkeyup="contentLengthCheck(this)">${content}</textarea>
			<div class="text-right pt-2">
				<span class="pt-1"><span class="cmt-sub-size">${content.length}</span>/650</span>
				<button type="button" class="btn btn-sm btn-primary cmtBtn">수정</button>
			</div>
		</div>
		`;
		$(this).parents(".cmt-sub-area").find(".cmt-sub-write-area").html(html);
	});

	// 댓글 삭제 버튼 이벤트
	commentList.on("click", ".cmtDelete", function(){	
        Swal.fire({
            title: '댓글을 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '네',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                let cmNo = $(this).parents(".cmt-sub-area").data("cmt-no");
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/boards/deleteCmt",
                    type: "post",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify({ cmNo: cmNo }),
                    success: function(result) {
                        if (result === "OK") {
                            Swal.fire('삭제가 완료 되었습니다!', '', 'success');
                            selectCommentList();
                        } else {
                            Swal.fire('삭제 실패', '', 'error');
                        }
                    },
                    error: function(error, status, thrown) {
                        console.log(error);
                        console.log(status);
                        console.log(thrown);
                        Swal.fire('오류 발생', '댓글 삭제 중 오류가 발생했습니다.', 'error');
                    }
                });
            }
        });
	});
	
	function selectCommentList(){
	    let data = {
	        boardNo: boardNo
	    }
	    
	    $.ajax({
	        url : "${pageContext.request.contextPath}/boards/selectCommentList",
	        type : "post",
	        contentType : "application/json;charset=utf-8",
	        data : JSON.stringify(data),
	        success : function(result) {
	            let html = ``;
	            if(result != null && result.length > 0){
	                result.map(function(v, i){
	                    let marginStyle = "";
	                    if(v.cmDp > 0){	// 대댓글이면 들여쓰기
	                        marginStyle = "margin-left:" + (v.cmDp * 40) + "px;";
	                    }
	                    
	                    // 로그인한 사용자와 댓글 작성자가 동일한 경우에만 수정/삭제 버튼을 표시
	                    let buttonsHtml = `
	                        <button type="button" class="btn btn-sm btn-outline-secondary cmtReply">답글</button>
	                    `;
	                    if ('${member.empNo}' === v.empNo) {
	                        buttonsHtml += `
	                            <button type="button" class="btn btn-sm btn-outline-primary cmtEdit">수정</button>
	                            <button type="button" class="btn btn-sm btn-outline-danger cmtDelete">삭제</button>
	                        `;
	                    }

	                    html += `
	                        <div class="cmt-sub-area mb-3" data-cmt-no="\${v.cmNo}" style="\${marginStyle}">
	                            <div class="d-flex align-items-center mb-1">
	                                <strong class="me-2">\${v.empNm}</strong>
	                                <small class="text-muted">\${v.cmWrtDt}</small>
	                            </div>
	                            <div class="cmt-sub-content border rounded p-2 mb-2">
	                                \${v.cmCn}
	                            </div>
	                            <div class="cmt-sub-actions">
	                                \${buttonsHtml}
	                            </div>
	                            <div class="cmt-sub-write-area mt-2"></div>
	                        </div>
	                    `;
	                });
	            } else {
	                html = `<p class="text-muted">등록된 댓글이 없습니다.</p>`;
	            }
	            $("#commentList").html(html);
	        },
	        error : function(error, status, thrown){
	            console.log(error);
	            console.log(status);
	            console.log(thrown);
	        }
	    });
	}
	selectCommentList();
});
	
//댓글 내용 길이 체크 이벤트
function contentLengthCheck(ele) {
	let size = ele.value.length; // textarea 작성한 텍스트 길이
	let text = ele.value;         // textarea 작성된 텍스트 값
	
	// 제한 글자 수, 650자 초과일 때
	// 제한 글자 수는 내용을 담은 공간의 데이터 사이즈에 맞게 처리(2000byte)
	// 650 x 2 = 1300, 650 x 3 = 1950
	if(size > 650) {
		Swal.fire("알림", "더이상 작성할 수 없습니다!", "warning");
		let subText = text.substring(0, 650); // 650자 텍스트 자르기(제한된 텍스트로 설정)
		ele.value = subText;  // 제한된 텍스트로 textarea 채우기
		// 제한된 텍스트 길이(650) 설정
		$(ele).parents(".cmt-sub-text").find(".cmt-sub-size").text(subText.length);
		return false;
	}
	$(ele).parents(".cmt-sub-text").find(".cmt-sub-size").text(size);
}
</script>


</html>