<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
  

  <style>
    /* ================== 카드 탭 & 아이템 ================== */
    .issue-tab-card { cursor:pointer; transition: transform .08s ease, box-shadow .2s; }
    .issue-tab-card.active { outline: 2px solid var(--bs-primary); box-shadow: 0 0 0 .2rem rgba(13,110,253,.15); }
    .issue-tab-card:active { transform: scale(.98); }

    .issue-item { cursor:pointer; transition: background-color .2s, box-shadow .2s; }
    .issue-item:hover { background-color: var(--bs-primary-bg-subtle); }

    /* ================== 모달 시각 구분 ================== */
    .modal.issue-register .modal-header { background: var(--bs-primary-bg-subtle); border-bottom: 1px solid var(--bs-primary); }
    .modal.issue-register .modal-title { font-weight: 700; color: var(--bs-primary); }
    .modal.issue-register .modal-content { border: 2px solid var(--bs-primary); }
    .thumb-card { width: 140px; }
    .nowrap { white-space: nowrap; }
    
    /* [수정 시작] 이슈 카드 내용 높이 조정 */
    .issue-item .card-body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    /* [수정 끝] */
  </style>
</head>
<%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid">

    <div class="container mt-4">
      
      
      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-9">
              <h4 class="fw-semibold mb-8">프로젝트</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item">
                    <a class="text-muted text-decoration-none" href="/main/dashboard">Home</a>
                  </li>
                  <li class="breadcrumb-item">
                    <a class="text-muted text-decoration-none" href="/project/dashboard">Project</a>
                  </li>
                  <li class="breadcrumb-item" aria-current="page">Issue</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/project/carousels.jsp"%>

      <c:set var="totalCount" value="${fn:length(issueList)}" />
      <c:set var="unresolvedCount" value="0" />
      <c:set var="resolvedCount" value="0" />
      <c:forEach var="issue" items="${issueList}">
          <c:if test="${issue.issueSttus ne '22003'}">
              <c:set var="unresolvedCount" value="${unresolvedCount + 1}" />
          </c:if>
          <c:if test="${issue.issueSttus eq '22003'}">
              <c:set var="resolvedCount" value="${resolvedCount + 1}" />
          </c:if>
      </c:forEach>

      <div class="row g-3 mb-2 issue-tabs-row">
        <div class="col-12 col-md-4">
          <div class="card rounded-3 card-hover issue-tab-card active"
               data-target="#navpill-all" role="button" tabindex="0"
               aria-controls="navpill-all" aria-selected="true">
            <div class="card-body">
              <h3 class="mb-1 fs-3">전체 이슈</h3>
              <h2 class="fw-semibold fs-6"><span id="count-all">${totalCount}</span>건</h2>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="card rounded-3 card-hover issue-tab-card"
               data-target="#navpill-unresolved" role="button" tabindex="0"
               aria-controls="navpill-unresolved" aria-selected="false">
            <div class="card-body">
              <h3 class="mb-1 fs-3">미해결 이슈</h3>
              <h2 class="fw-semibold fs-6"><span id="count-open">${unresolvedCount}</span>건</h2>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="card rounded-3 card-hover issue-tab-card"
               data-target="#navpill-resolved" role="button" tabindex="0"
               aria-controls="navpill-resolved" aria-selected="false">
            <div class="card-body">
              <h3 class="mb-1 fs-3">해결 완료</h3>
              <h2 class="fw-semibold fs-6"><span id="count-done">${resolvedCount}</span>건</h2>
            </div>
          </div>
        </div>
      </div>

      <div class="d-flex justify-content-end align-items-center my-3" id="taskToolbar">
        <div class="input-group me-2" style="max-width: 500px; min-width: 280px;">
          <select id="taskTypeFilter" class="form-select" style="max-width: 140px;">
            <option value="">이슈 유형(전체)</option>
            <option value="현장">현장</option>
            <option value="설계">설계</option>
            <option value="민원">민원</option>
            <option value="기타">기타</option>
          </select>
          <input type="text" class="form-control" id="fileSearchInput" placeholder="검색어를 입력하세요">
          <button class="btn btn-outline-secondary" type="button" id="btnDoSearch">검색</button>
        </div>

        <a class="btn btn-success"
		   href="${pageContext.request.contextPath}/project/issues/insert?prjctNo=${prjctNo}">
		  이슈 등록
		</a>
      </div>

      <div class="tab-content mt-3">
        <div class="tab-pane active show" id="navpill-all" role="tabpanel">
          <div class="row row-cols-1 row-cols-md-2 g-3" id="issue-list-all">
            </div>
        </div>

        <div class="tab-pane" id="navpill-unresolved" role="tabpanel">
          <div class="row row-cols-1 row-cols-md-2 g-3" id="issue-list-unresolved">
            </div>
        </div>

        <div class="tab-pane" id="navpill-resolved" role="tabpanel">
          <div class="row row-cols-1 row-cols-md-2 g-3" id="issue-list-resolved">
            </div>
        </div>
      </div>
      
      <div class="d-flex align-items-center justify-content-between mt-4 mb-3">
        <div class="flex-grow-1 d-flex justify-content-center">
          <nav aria-label="Page navigation" class="m-0">
            <ul id="issuePaging" class="pagination justify-content-center mb-0">
              </ul>
          </nav>
        </div>
      </div>
      
    </div> 
  </div> 
</div> 
<div class="modal fade issue-register" id="issueModal" tabindex="-1" aria-labelledby="issueModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title" id="issueModalLabel">이슈 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body">
        <form id="issueForm" action="issues/register" method="post" enctype="multipart/form-data">
          <div class="container-fluid">
            <div class="row g-4">
              <div class="col-12">
                <div class="card rounded-3">
                  <div class="card-body">

                    <div class="mb-3">
                      <label for="title" class="form-label">제목</label>
                      <div class="d-flex align-items-center gap-3">
                        <input type="text" class="form-control" id="title" name="title"
                               placeholder="제목을 입력하세요" required>
                        <div class="form-check form-check-inline m-0">
                          <input class="form-check-input" type="checkbox" id="emergencyCheck" name="emergency" value="Y">
                          <label class="form-check-label mb-0 ms-1 nowrap" for="emergencyCheck">긴급여부</label>
                        </div>
                      </div>
                    </div>

                    <div class="row g-3">
                      <div class="col-md-6">
                        <label for="issueType" class="form-label">이슈 유형</label>
                        <select class="form-select" id="issueType" name="issueType" required>
                          <option value="">선택</option>
                          <option>현장</option>
                          <option>설계</option>
                          <option>민원</option>
                          <option>기타</option>
                        </select>
                      </div>
                      <div class="col-md-6">
                        <label for="status" class="form-label">진행 상태</label>
                        <select class="form-select" id="status" name="status" required>
                          <option value="">선택</option>
                          <option selected>대기</option>
                          <option>처리중</option>
                          <option>완료</option>
                        </select>
                      </div>
                    </div>

                    <div class="mt-3">
                      <label for="assignee" class="form-label">담당자</label>
                      <input type="text" class="form-control" id="assignee" name="assigneeName"
                             placeholder="담당자 이름을 입력하세요">
                    </div>

                    <div class="mt-4">
                      <label for="content" class="form-label">이슈 내용</label>
                      <textarea class="form-control" id="content" name="content" rows="6"
                                placeholder="이슈 상세 내용을 입력하세요"></textarea>
                    </div>

                    <div class="mt-4">
                      <label class="form-label d-block" for="files">첨부파일 업로드</label>
                      <input type="file" class="form-control" id="files" name="files" multiple
                             accept="image/*,application/pdf,.doc,.docx,.xls,.xlsx">
                      <div class="form-text">여러 파일을 선택할 수 있습니다. (이미지/문서 등)</div>

                      <div id="previewList" class="d-flex flex-wrap gap-3 mt-3"></div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                      <button type="button" class="btn btn-light" data-bs-dismiss="modal" aria-label="취소">취소</button>
                      <button type="submit" class="btn btn-primary">등록</button>
                    </div>

                  </div>
                </div>
              </div>
            </div> 
         </div> </form>
      </div> 
    </div>
  </div>
</div>
  
<%@ include file="/module/footerPart.jsp" %>

<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
<script>
// ... (나머지 스크립트는 동일)
document.addEventListener('DOMContentLoaded', function() {
	
    const message = '${msg}';
    
    console.log(message);
    console.log("여기옴 --------------------------");
    if (message && message.trim() !== '') {
        Swal.fire({
            title: message,
            icon: 'success',
            confirmButtonText: '확인'
        });
    }
});

/* =========================================================
   jQuery 전용 스크립트
   ========================================================= */
$(function(){

  // [수정 시작] const를 사용하여 변수 정의
  const PRJCT_NO = ${prjctNo};
  const CONTEXT_PATH = '${pageContext.request.contextPath}';

  // 이슈 상태 코드 맵핑 (서버 요청 시 사용될 코드)
  const STATUS_MAP = {
    '#navpill-all': '',         // 전체
    '#navpill-unresolved': 'UNRESOLVED', // 미해결 (처리완료(22003)가 아닌 경우)
    '#navpill-resolved': '22003'        // 해결 완료
  };
  
  /**
   * 이슈 데이터를 받아 HTML 카드 마크업을 생성하는 함수
   * @param {Object} issue - 이슈 상세 정보 객체
   * @returns {string} - 이슈 카드 HTML 문자열
   */
  const createIssueCard = function(issue) {
    // 이슈 유형 뱃지 생성
    let typeBadge = '';
    switch (issue.issueTy) {
      case '05001': typeBadge = '<span class="badge bg-warning-subtle text-warning">민원</span>'; break;
      case '05002': typeBadge = '<span class="badge bg-secondary-subtle text-secondary">현장</span>'; break;
      case '05003': typeBadge = '<span class="badge bg-primary-subtle text-primary">설계</span>'; break;
      case '05004': typeBadge = '<span class="badge bg-danger-subtle text-danger">안전</span>'; break;
      default: typeBadge = '<span class="badge bg-info-subtle text-info">기타</span>';
    }

    // 진행 상태 뱃지 생성
    let statusBadge = '';
    switch (issue.issueSttus) {
      // 🚨 DB 코드 2100x로 변경 가정
      case '21002': statusBadge = '<span class="badge bg-info">처리중</span>'; break;
      case '21003': statusBadge = '<span class="badge bg-success">처리완료</span>'; break;
      case '22003': statusBadge = '<span class="badge bg-success">처리완료</span>'; break; // '22003' 코드 추가
      // case '22004': statusBadge = '<span class="badge bg-warning">반려</span>'; break; // 반려 삭제
      default: statusBadge = '<span class="badge bg-light text-dark">대기</span>'; // 21001 (대기)
    }
    
    // 긴급 뱃지 생성
    const emergencyBadge = issue.emrgncyYn === 'Y' ? '<span class="badge bg-danger text-truncate flex-shrink-0">긴급</span>' : '';
    // issueCmtCnt는 서버에서 0으로 넘어올 수 있음
    const commentCount = issue.issueCmtCnt || 0; 
    
    return `
      <div class="col">
        <div class="card h-100 mb-0 issue-item" data-issue-id="\${issue.issueNo}">
          <div class="card-body">
            <h5 class="card-title d-flex justify-content-between mb-2">
              <span class="fs-5 fw-semibold text-truncate me-2" title="\${issue.issueTitle}">\${issue.issueTitle}</span>
              \${emergencyBadge}
            </h5>
            
            <p class="mb-3 text-muted flex-grow-1">
              <small>
                <i class="ti ti-user me-1"></i> 담당자: <span class="fw-medium">\${issue.issueManagerNm}</span> 
                <i class="ti ti-message-2 ms-3 me-1"></i> 댓글: <span class="fw-semibold">\${commentCount}</span>개
              </small>
            </p>

            <div class="d-flex justify-content-between align-items-center">
              <div>\${typeBadge}</div>
              <div>\${statusBadge}</div>
            </div>
            
            <a href="\${CONTEXT_PATH}/project/issues/detail?issueNo=\${issue.issueNo}&prjctNo=\${PRJCT_NO}"
               class="stretched-link" aria-label="상세 이동"></a>
          </div>
        </div>
      </div>
    `;
  };

  /* ================= 페이지네이션 렌더 ================= */
  // 이 함수는 현재 사용되지 않으며, loadIssuesByStatus 내에서 처리됩니다.
  /*
  function renderPaging(pagingHTML) {
    $("#issuesPaging").html(pagingHTML || "");
  }
  */
  
  
  const loadIssuesByStatus = function(targetSel, status, page) {
    const $listContainer = $(targetSel).find('.row');
    const q = $.trim($('#fileSearchInput').val() || '');
    const type = $('#taskTypeFilter').val() || '';
    const currentPage = page || 1; // 페이지 번호 추가

    // 로딩 인디케이터 표시
    $listContainer.html('<div class="col-12 text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>');
    $('#issuePaging').empty(); // 페이징 초기화
    
    // AJAX 요청
    $.ajax({
      // ★ Controller 경로가 /project/issues/listAjax로 변경되었다고 가정하고 수정
      url: CONTEXT_PATH + '/project/issues/listAjax', 
      type: 'GET',
      data: {
        prjctNo: PRJCT_NO,
        status: status, 
        // ★ Controller의 파라미터 이름에 맞춰 'q'를 'searchWord'로 수정했다고 가정
        searchWord: q, 
        type: type,
        currentPage: currentPage // ★ 페이지 번호 추가
      },
      dataType: 'json'
    }).done(function(resp) {
      
      // 탭 카운트 업데이트 로직
      if (resp.totalCount !== undefined) {
          $('#count-all').text(resp.totalCount);
          $('#count-open').text(resp.unresolvedCount);
          $('#count-done').text(resp.resolvedCount);
      }
	  
      // 성공: 목록을 비우고 새로운 카드 추가
      $listContainer.empty();
      if (resp.issueList && resp.issueList.length > 0) {
        $.each(resp.issueList, function(_, issue) {
          $listContainer.append(createIssueCard(issue));
        });
      } else {
        // 이슈가 없을 경우 메시지 출력
        $listContainer.html('<div class="col-12 text-center p-5 text-muted">해당하는 이슈가 없습니다.</div>');
      }
      
      // ★ 페이지네이션 렌더링 추가 (Controller에서 pagingHTML 키로 전달한다고 가정)
      // 이슈 페이징 ID: issuePaging 으로 통일
      $('#issuePaging').html(resp.pagingHTML || ""); 

    }).fail(function(xhr) {
      console.error("이슈 로드 실패:", xhr);
      $listContainer.html('<div class="col-12 text-center p-5 text-danger">이슈 목록을 불러오지 못했습니다. (서버 응답 확인 필요)</div>');
    });
  };

  
  const activatePane = function(targetSel, page){ // ★page 파라미터 추가
    // 1. 탭 시각적 활성화
    $('.issue-tab-card').removeClass('active').attr('aria-selected', 'false');
    $('.tab-pane').removeClass('active show');
    const $targetCard = $('.issue-tab-card[data-target="' + targetSel + '"]');
    $targetCard.addClass('active').attr('aria-selected', 'true');
    $(targetSel).addClass('active show');
    
    // 2. AJAX로 이슈 목록 로드
    const status = STATUS_MAP[targetSel];
    loadIssuesByStatus(targetSel, status, page); // ★page 전달
  };

  /* ---------- 카드 탭 전환 (page=1로 초기화) ---------- */
  $(document).on('click', '.issue-tab-card', function(){
    const targetSel = $(this).data('target');
    activatePane(targetSel, 1); // 탭 클릭 시 1페이지 로드
  });

  $(document).on('keydown', '.issue-tab-card', function(e){
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      activatePane($(this).data('target'), 1); // 탭 클릭 시 1페이지 로드
    }
  });

  // 초기 로드 시 '전체 이슈' 탭 활성화 및 로드
  const $firstActive = $('.issue-tab-card.active');
  const initialTarget = $firstActive.data('target') || '#navpill-all';
  // ★ 초기 로드 시 1페이지 로드
  activatePane(initialTarget, 1); 

  /* ---------- 검색/필터 (page=1로 초기화) ---------- */
  const doSearchOrFilter = function(){
    // 현재 활성화된 탭의 타겟 선택자를 가져옴
    const targetSel = $('.issue-tab-card.active').data('target');
    // 검색/필터 시 1페이지 로드
    activatePane(targetSel, 1); 
  };
  
  // 기존 검색/필터 함수를 새로운 AJAX 로직으로 대체
  $('#btnDoSearch').off('click').on('click', doSearchOrFilter);
  $('#fileSearchInput').off('keydown').on('keydown', function(e){
    if (e.key === 'Enter') { e.preventDefault(); doSearchOrFilter(); }
  });
  $('#taskTypeFilter').off('change').on('change', doSearchOrFilter);

  /* ---------- 카드 클릭 → 상세 ---------- */
  // on("click", ...) 형태로 변경
  $(document).on('click', '.issue-item', function(e){
    // 드롭다운/버튼/링크 등의 인터랙티브 요소 클릭 시는 무시
    if ($(e.target).closest('a,button,.btn').length) return; 
    const id = $(this).data('issueId');
    if (id) location.href = `\${CONTEXT_PATH}/project/issues/detail?issueNo=\${id}&prjctNo=\${PRJCT_NO}`;
  });

  /* ---------- [추가] 페이지네이션 클릭 이벤트 (AJAX 처리) ---------- */
  // HTML에서 issuePaging으로 ID 통일했으므로, 이벤트 셀렉터도 issuePaging으로 유지
  $(document).on("click", "#issuePaging a", function (e) {
      e.preventDefault();

      const $this = $(this);
      let pageNo;
      
      // 1) data-page 속성 사용 (PaginationInfoVO의 getPagingHTML() 등에서 생성)
      const dp = $this.data("page");
      if (dp) { pageNo = parseInt(dp, 10); } 
      // 2) href 쿼리스트링 사용 (PaginationInfoVO의 getPagingHTML2() 등에서 생성)
      else {
          const href = $this.attr("href") || "";
          const m = href.match(/(?:currentPage|page)=(\d+)/);
          if (m) { pageNo = parseInt(m[1], 10); }
      }
      
      if (pageNo) {
        const targetSel = $('.issue-tab-card.active').data('target');
        activatePane(targetSel, pageNo); // 추출된 페이지 번호로 로드
      }
  });


  /* ---------- 모달: 파일 미리보기 ---------- */
  $(document).on('change', '#files', function(){
    const $list = $('#previewList');
    $list.empty();

    const files = this.files ? Array.from(this.files) : [];
    $.each(files, function(_, file){
      const $card = $('<div/>', { 'class': 'card shadow-sm thumb-card' });

      if (/^image\//.test(file.type)) {
        const reader = new FileReader();
        reader.onload = function(e){
          $('<img/>', {
            'class': 'img-fluid rounded-2',
            'alt': file.name,
            'src': e.target.result
          }).appendTo($card);
        };
        reader.readAsDataURL(file);
      } else {
        const $body = $('<div/>', { 'class': 'card-body p-2' })
          .append($('<div/>', {
            'class': 'small text-truncate',
            'title': file.name,
            'text': file.name
          }));
        $card.append($body);
      }

      $list.append($card);
    });
  });

  /* ---------- 모달: 등록 제출 (AJAX) ---------- */
  $(document).on('submit', '#issueForm', function(e){
    e.preventDefault();

    const fd = new FormData(this);
    if (!$('#emergencyCheck').is(':checked')) {
      fd.set('emergency', 'N');
    } // 체크 시 'Y' 그대로 전송

    $.ajax({
      url: $(this).attr('action'),     // "issues/register"
      type: 'post',
      data: fd,
      processData: false,
      contentType: false
    }).done(function(){
      // 성공: 모달 닫고 새로고침(또는 현재 탭에 prepend)
      $('#issueModal').modal('hide');
      // TODO: 필요 시 새 카드 prepend 로직 작성
      location.reload();
    }).fail(function(xhr){
      alert('등록 중 오류가 발생했습니다.');
      console.error(xhr.responseText);
    });
  });

});
</script>

</body>
</html>