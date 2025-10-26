<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <sec:authentication property="principal.member" var="member"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/dropzone/dist/min/dropzone.min.css"/>
  <style>
    .modal-title { font-weight: 700; color: var(--bs-primary); }
    .thumb-card { width: 140px; }
    .nowrap { white-space: nowrap; }

    /* 댓글 */
    .comment-list-item { border-bottom: 1px solid #eee; padding: 10px 0; }
    .comment-meta { font-size: 0.9em; color: #666; }
    .comment-content { margin-top: 5px; }
    .comment-section-card { max-height: 800px; }
    #commentListContainer { max-height: 450px; overflow-y: auto; }

    /* ===== 첨부 이미지 그리드 & 오버레이 ===== */
    .section-header{ display:flex; align-items:center; justify-content:space-between; }
    .section-header .title{ display:flex; align-items:center; gap:.5rem; font-weight:700; letter-spacing:.2px; }
    .section-header .title .ti{ font-size:1.15rem; opacity:.85; }
    .section-meta{ display:flex; align-items:center; gap:.5rem; }
    .section-meta .hint{ color:var(--bs-secondary-color); font-size:.85rem; }

    .photo-grid{ display:grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap:12px; }
    .photo-grid-item{ position:relative; overflow:hidden; border-radius:.75rem; background:var(--bs-body-bg); }
    .photo-grid-img{ width:100%; height:160px; object-fit:cover; transition:transform .25s ease; display:block; }
    .photo-grid-item:hover .photo-grid-img{ transform:scale(1.03); }

    .photo-grid-item .el-overlay{
      position:absolute; inset:0; background:rgba(0,0,0,.38);
      border-radius:.75rem; opacity:0; transition:opacity .2s ease;
    }
    .photo-grid-item:hover .el-overlay{ opacity:1; }

    .photo-grid-item .el-overlay .el-info{
      position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
      display:flex; gap:8px; margin:0; padding:0; list-style:none;
    }
    .photo-grid-item .el-overlay .el-info .btn{
      width:42px; height:42px; display:flex; align-items:center; justify-content:center;
      border-radius:.6rem; border:2px solid rgba(255,255,255,.85);
      background:rgba(255,255,255,.15); color:#fff !important;
      box-shadow:0 6px 16px rgba(0,0,0,.25);
      transition:transform .15s ease, background .15s ease;
    }
    .photo-grid-item .el-overlay .el-info .btn:hover{
      background:rgba(255,255,255,.25); transform:translateY(-1px);
    }

    .empty-state{
      display:flex; align-items:center; gap:.6rem;
      background:var(--bs-light-bg-subtle, #f8f9fa);
      border:1px dashed var(--bs-border-color);
      color:var(--bs-secondary-color);
      border-radius:.75rem;
      padding:.9rem 1rem;
    }

    /* 좌측 정렬 보장 */
    .text-left { text-align: left !important; }
    
    /* 댓글 액션 아이콘 정렬 */
    .comment-content {
      margin-top: 5px;
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      gap: 12px;
    }
    .comment-actions {
      display: flex;
      gap: 8px;
      flex-shrink: 0;
    }
    .comment-actions .btn i { font-size: 1rem; }
    
    .badge-action {
      cursor: pointer;
      user-select: none;
      padding: .35em .5em;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .badge-action i { font-size: 0.85rem; }
    .badge-action:hover { filter: brightness(0.95); }
    .badge-action:active { transform: translateY(1px); }
	
    .comment-content .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      white-space: nowrap;
    }
  </style>
</head>

<%@ include file="/module/header.jsp" %>
<body>
<%@ include file="/module/aside.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setTimeZone value="Asia/Seoul" />
<c:set var="files" value="${issueVO.fileList}" />

<%-- ========================================================================= --%>
<%-- [시작] 권한 변수 설정 --%>
<c:set var="ADMIN_EMP_NO" value="202508001" />
<c:set var="currentEmpNo" value="${member.empNo}" />

<c:set var="isAdmin" value="${currentEmpNo eq ADMIN_EMP_NO}" />
<c:set var="isAuthor" value="${currentEmpNo eq issueVO.empNo}" />
<c:set var="isManager" value="${currentEmpNo eq issueVO.issueManager}" />

<c:set var="canModifyOrDelete" value="${isAdmin or isAuthor or isManager}" />
<%-- [끝] 권한 변수 설정 --%>
<%-- ========================================================================= --%>

<%-- 이슈 유형/상태 라벨 계산 --%>
<c:choose>
  <c:when test="${issueVO.issueTy eq '05001'}"><c:set var="issueTypeLabel" value="민원"/></c:when>
  <c:when test="${issueVO.issueTy eq '05002'}"><c:set var="issueTypeLabel" value="현장"/></c:when>
  <c:when test="${issueVO.issueTy eq '05003'}"><c:set var="issueTypeLabel" value="설계"/></c:when>
  <c:when test="${issueVO.issueTy eq '05004'}"><c:set var="issueTypeLabel" value="안전"/></c:when>
  <c:otherwise><c:set var="issueTypeLabel" value="기타"/></c:otherwise>
</c:choose>

<c:choose>
  <c:when test="${issueVO.issueSttus eq '21002' or issueVO.issueSttus eq '22002'}"><c:set var="issueStatusLabel" value="처리중"/></c:when>
  <c:when test="${issueVO.issueSttus eq '21003' or issueVO.issueSttus eq '22003'}"><c:set var="issueStatusLabel" value="처리완료"/></c:when>
  <c:when test="${issueVO.issueSttus eq '22004'}"><c:set var="issueStatusLabel" value="반려"/></c:when>
  <c:otherwise><c:set var="issueStatusLabel" value="대기"/></c:otherwise>
</c:choose>

<%-- 파일 존재/유형/카운트 계산 --%>
<c:set var="hasAnyFiles" value="${not empty files}" />
<c:set var="hasImage" value="false" />
<c:set var="hasOther" value="false" />
<c:set var="imgCount" value="0" />
<c:if test="${hasAnyFiles}">
  <c:forEach var="f" items="${files}">
    <c:choose>
      <c:when test="${not empty f.fileMime and fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
        <c:set var="hasImage" value="true"/>
        <c:set var="imgCount" value="${imgCount + 1}"/>
      </c:when>
      <c:otherwise>
        <c:set var="hasOther" value="true"/>
      </c:otherwise>
    </c:choose>
  </c:forEach>
</c:if>

<div class="body-wrapper">
  <div class="container-fluid">

    <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

    <div class="row g-4 mt-3">

      <div class="col-lg-8">
        <div class="card rounded-3 h-100">
          <div class="card-body">

            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
              <h4 class="fw-semibold mb-0 d-flex align-items-center">
                <c:out value="${issueVO.issueTitle}"/>
                <c:if test="${issueVO.emrgncyYn eq 'Y'}">
                  <span class="badge bg-danger fs-6 ms-2">긴급</span>
                </c:if>
              </h4>
            </div>

            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label">이슈 유형</label>
                <input type="text" class="form-control text-left" readonly value="${issueTypeLabel}">
              </div>
              <div class="col-md-6">
                <label class="form-label">진행 상태</label>
                <input type="text" class="form-control text-left" readonly value="${issueStatusLabel}">
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label">담당자</label>
              <input type="text" class="form-control text-left" readonly value="${issueVO.issueManagerNm}">
            </div>

            <div class="mb-4">
              <label class="form-label">이슈 내용</label>
              <div class="form-control" style="white-space: pre-line; min-height: 150px;">
                ${issueVO.issueCn}
              </div>
            </div>

          <div class="mb-4">
  <div class="section-header mb-2">
    <div class="title">
      <i class="ti ti-paperclip"></i>
      <span>첨부파일</span>
    </div>
    <div class="section-meta">
      <span class="badge rounded-pill text-bg-secondary"><c:out value="${imgCount}"/>장</span>
      <span class="hint">이미지는 썸네일 클릭 시 크게 보기</span>
    </div>
  </div>

  <c:choose>
   
    <c:when test="${empty files}">
      <div class="empty-state">
        <i class="ti ti-file-off"></i>
        <span>업로드된 파일이 없습니다.</span>
      </div>
    </c:when>


    <c:otherwise>

  
      <c:if test="${hasImage}">
        <div class="photo-grid" id="photoGrid">
          <c:set var="imgIdx" value="0"/>
          <c:forEach var="f" items="${files}">
            <c:if test="${not empty f.fileMime and fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
              <div class="photo-grid-item" data-index="${imgIdx}">
                <img class="photo-grid-img" src="${ctx}${f.filePath}" alt="${f.originalNm}">
                <div class="el-overlay w-100 overflow-hidden">
                  <ul class="el-info text-white p-0 m-0">
                    <li class="el-item">
                      <a class="btn default btn-outline text-white border-white js-preview"
                         href="javascript:void(0)"
                         data-src="${ctx}${f.filePath}">
                        <i class="ti ti-search"></i>
                      </a>
                    </li>
                    <li class="el-item">
                      <a class="btn default btn-outline text-white border-white"
                         href="${ctx}/project/issues/download/${f.savedNm}">
                        <i class="ti ti-download"></i>
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
              <c:set var="imgIdx" value="${imgIdx + 1}"/>
            </c:if>
          </c:forEach>
        </div>
      </c:if>

   
      <c:if test="${not hasImage and hasOther}">
        <div class="empty-state">
          <i class="ti ti-photo-off"></i>
          <span>업로드된 파일이 없습니다.</span>
        </div>
      </c:if>

    
      <c:if test="${hasOther}">
        <div class="list-group mt-3">
          <c:forEach var="f" items="${files}">
            <c:if test="${(empty f.fileMime or not fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')) and not empty f.savedNm}">
              <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                 href="${ctx}/project/issues/download/${f.savedNm}">
                <span class="d-inline-flex align-items-center gap-2 text-truncate" style="max-width: 480px;">
                  <i class="ti ti-file-text"></i>
                  <span class="text-truncate"><c:out value="${f.originalNm}"/></span>
                </span>
                <small class="text-muted"><c:out value="${f.fileFancysize}"/></small>
              </a>
            </c:if>
          </c:forEach>
        </div>
      </c:if>

    </c:otherwise>
  </c:choose>
</div>


            <div class="d-flex justify-content-between mt-5 pt-3 border-top">
              <a href="${ctx}/project/issues/lists?prjctNo=${issueVO.prjctNo}"
                 class="btn btn-outline-secondary" id="listBtn">
                <i class="ti ti-list me-1"></i> 목록으로
              </a>

              <%-- [수정/삭제 버튼 노출]: 관리자, 작성자, 담당자만 노출 --%>
              <c:if test="${canModifyOrDelete}">
                <div>
                  <a href="${ctx}/project/issues/update?issueNo=${issueVO.issueNo}"
                     class="btn btn-warning me-2" id="updateBtn">
                    <i class="ti ti-edit"></i> 수정
                  </a>
                  <button type="button" class="btn btn-danger" id="deleteBtn">
                    <i class="ti ti-trash"></i> 삭제
                  </button>
                </div>
              </c:if>
            </div>

          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="card rounded-3 comment-section-card">
          <div class="card-body">
            <h5 class="fw-semibold mb-3 border-bottom pb-2">댓글 (<c:out value="${fn:length(issueVO.commentList)}"/>)</h5>

            <form id="commentInsertForm"
                  action="${ctx}/project/issues/comment/insert"
                  method="post" class="mb-4">
              <input type="hidden" name="issueNo" value="${issueVO.issueNo}">
              <div class="input-group">
                <textarea id="issueCmCn" name="issueCmCn" class="form-control" rows="1" placeholder="댓글을 입력하세요" required></textarea>
                <button type="submit" class="btn btn-primary" style="width: 100px;">등록</button>
              </div>
            </form>

            <div id="commentListContainer">
              <c:choose>
                <c:when test="${not empty issueVO.commentList}">
                  <c:forEach var="comment" items="${issueVO.commentList}">
                    <div class="comment-list-item" data-cm-no="${comment.issueCmNo}">
                      <div class="comment-meta d-flex justify-content-between">
                        <span>
                          <i class="ti ti-user me-1"></i>
                          <strong><c:out value="${comment.empNm}"/></strong>
                          (<c:out value="${comment.empNo}"/>)
                          <span class="ms-3 text-muted">
                            <fmt:formatDate value="${comment.issueCmWrtDt}" pattern="yyyy-MM-dd HH:mm"/>
                          </span>
                        </span>
                      </div>

                      <div class="comment-content position-relative">
                        <div class="comment-text"><c:out value="${comment.issueCmCn}"/></div>

                        <%-- 댓글 수정/삭제 권한: 작성자 본인만 노출 --%>
                        <c:if test="${comment.empNo eq member.empNo}">
                          <div class="comment-actions mt-2">
                            <button type="button"
                                    class="badge text-bg-secondary border-0 badge-action comment-modify-btn"
                                    title="수정">
                              <i class="ti ti-pencil"></i>
                            </button>
                            <button type="button"
                                    class="badge text-bg-danger border-0 badge-action comment-delete-btn"
                                    data-cm-no="${comment.issueCmNo}"
                                    title="삭제">
                              <i class="ti ti-trash"></i>
                            </button>
                          </div>
                        </c:if>

                      </div>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <div class="text-muted text-center p-3">등록된 댓글이 없습니다.</div>
                </c:otherwise>
              </c:choose>
            </div>

          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<div class="modal fade" id="photoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl">
    <div class="modal-content bg-dark">
      <div class="modal-body p-0 position-relative">
        <button type="button" class="btn-close btn-close-white position-absolute end-0 m-3 z-3"
                data-bs-dismiss="modal" aria-label="Close"></button>
        <img id="photoModalImg" src="" class="w-100 h-100 object-fit-contain" style="max-height:85vh;">
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script src="${ctx}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<script>
$(function(){
  const CONTEXT_PATH = '${ctx}';
  const ISSUE_NO = '${issueVO.issueNo}';
  const PRJCT_NO = '${issueVO.prjctNo}';

  // ===== 첨부 이미지 미리보기 =====
  (function initPreview(){
    var $grid = $("#photoGrid");
    if (!$grid.length) return;

    var imgSrcList = [];
    var cur = 0;
    var $modal = $("#photoModal");
    var $modalImg = $("#photoModalImg");

    $grid.find(".js-preview").each(function(){ imgSrcList.push($(this).data("src")); });

    function openAt(idx){
      if (!imgSrcList.length) return;
      cur = Math.max(0, Math.min(idx, imgSrcList.length - 1));
      $modalImg.attr("src", imgSrcList[cur]);
      new bootstrap.Modal(document.getElementById('photoModal')).show();
    }

    $grid.on("click", ".js-preview", function(){
      var src = $(this).data("src");
      var idx = imgSrcList.indexOf(src);
      openAt(idx < 0 ? 0 : idx);
    });

    $(document).on("keydown", function(e){
      if (!$modal.hasClass("show") || !imgSrcList.length) return;
      if (e.key === "ArrowLeft") {
        cur = (cur - 1 + imgSrcList.length) % imgSrcList.length;
        $modalImg.attr("src", imgSrcList[cur]);
      } else if (e.key === "ArrowRight") {
        cur = (cur + 1) % imgSrcList.length;
        $modalImg.attr("src", imgSrcList[cur]);
      }
    });
  })();

  // ===== 이슈 삭제 (AJAX) =====
  $(document).on('click', '#deleteBtn', function(){
    Swal.fire({
      title: '정말 삭제하시겠습니까?',
      text: '삭제하면 복구할 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((result) => {
      if (!result.isConfirmed) return;
      $.post(CONTEXT_PATH + '/project/issues/delete', { issueNo: ISSUE_NO })
        .done(function(){
          Swal.fire('삭제 완료', '이슈가 삭제되었습니다.', 'success').then(() => {
            location.href = CONTEXT_PATH + '/project/issues/lists?prjctNo=' + PRJCT_NO;
          });
        })
        .fail(function(){
          Swal.fire('오류', '이슈 삭제 중 오류가 발생했습니다.', 'error');
        });
    });
  });

  // ===== 댓글 등록 =====
  $(document).on('submit', '#commentInsertForm', function(e){
    e.preventDefault();
    const $form = $(this);
    const issueCmCn = $.trim($('#issueCmCn').val());
    if (!issueCmCn) { Swal.fire('경고', '댓글 내용을 입력해주세요.', 'warning'); return; }

    $.ajax({
      url: $form.attr('action'),
      type: 'POST',
      data: $form.serialize(),
      success: function(resp){
        if (resp.status === 'SUCCESS') { location.reload(); }
        else { Swal.fire('오류', '댓글 등록에 실패했습니다.', 'error'); }
      },
      error: function(){ Swal.fire('오류', '서버 통신 중 오류가 발생했습니다.', 'error'); }
    });
  });

  // ===== 댓글 수정 모드 =====
  $(document).on('click', '.comment-modify-btn', function(){
    const $item = $(this).closest('.comment-list-item');
    const $content = $item.find('.comment-content');

    // 원본 HTML 저장
    if (!$content.data('prevHtml')) {
      $content.data('prevHtml', $content.html());
    }

    const currentText = $.trim($item.find('.comment-text').text());

    // 이미 편집 중이면 무시
    if ($content.find('textarea').length) return;

    const $textarea = $('<textarea/>', {
      'class': 'form-control mb-2',
      'rows': 3,
      'name': 'issueCmCn'
    }).val(currentText);

    const $buttonGroup = $('<div>', {
      'class': 'd-flex justify-content-end align-items-center gap-2 mt-2 flex-row'
    })
    .append(
      $('<button/>', {
        'type': 'button',
        'class': 'btn btn-sm btn-primary comment-save-btn',
        'text': '저장'
      })
    )
    .append(
      $('<button/>', {
        'type': 'button',
        'class': 'btn btn-sm btn-light comment-cancel-btn',
        'text': '취소'
      })
    );

    // 편집 UI로 교체
    $content.html('').append($textarea, $buttonGroup);
  });

  // 수정 취소
  $(document).on('click', '.comment-cancel-btn', function(){
    const $item = $(this).closest('.comment-list-item');
    const $content = $item.find('.comment-content');
    const prevHtml = $content.data('prevHtml') || '';
    $content.html(prevHtml);
    $content.removeData('prevHtml');
  });

  // 수정 저장
  $(document).on('click', '.comment-save-btn', function(){
    const $item = $(this).closest('.comment-list-item');
    const cmNo = $item.attr('data-cm-no');
    const newCn = $.trim($item.find('textarea[name="issueCmCn"]').val());
    if (!newCn) { Swal.fire('경고', '수정 내용을 입력해주세요.', 'warning'); return; }

    $.ajax({
      url: CONTEXT_PATH + '/project/issues/comment/update',
      type: 'POST',
      data: { issueCmNo: cmNo, issueCmCn: newCn },
      success: function(resp){
        if (resp.status === 'SUCCESS') {
          Swal.fire('수정 완료', '댓글이 성공적으로 수정되었습니다.', 'success').then(() => location.reload());
        } else {
          Swal.fire('오류', '댓글 수정에 실패했습니다.', 'error');
        }
      },
      error: function(){ Swal.fire('오류', '서버 통신 중 오류가 발생했습니다.', 'error'); }
    });
  });

  // 댓글 삭제
  $(document).on('click', '.comment-delete-btn', function(){
    const cmNo = $(this).data('cmNo');
    Swal.fire({
      title: '댓글 삭제',
      text: '정말 이 댓글을 삭제하시겠습니까?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((result) => {
      if (!result.isConfirmed) return;
      $.post(CONTEXT_PATH + '/project/issues/comment/delete', { issueCmNo: cmNo, issueNo: ISSUE_NO })
        .done(function(resp){
          if (resp.status === 'SUCCESS') {
            Swal.fire('삭제 완료', '댓글이 삭제되었습니다.', 'success').then(() => location.reload());
          } else {
            Swal.fire('오류', '댓글 삭제에 실패했습니다.', 'error');
          }
        })
        .fail(function(){ Swal.fire('오류', '서버 통신 중 오류가 발생했습니다.', 'error'); });
    });
  });

});
</script>
</body>
</html>
