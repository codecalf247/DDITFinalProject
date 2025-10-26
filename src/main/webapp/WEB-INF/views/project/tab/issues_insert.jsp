<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Issue 등록 - GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
  <sec:authentication property="principal.member" var="member"/>
  
  <style>
    .modal-title { font-weight: 700; color: var(--bs-primary); }
    .thumb-card { width: 140px; }
    .nowrap { white-space: nowrap; }
    
    
    
     /* 기존 업로드 이미지 그리드 */
  .photo-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:16px}
  @media (max-width:1400px){.photo-grid{grid-template-columns:repeat(4,1fr)}}
  @media (max-width:992px){.photo-grid{grid-template-columns:repeat(3,1fr)}}
  @media (max-width:768px){.photo-grid{grid-template-columns:repeat(2,1fr)}}
  @media (max-width:480px){.photo-grid{grid-template-columns:repeat(1,1fr)}}
  .photo-item{position:relative;border-radius:.75rem;overflow:hidden;box-shadow:0 1px 2px rgba(16,24,40,.06)}
  .photo-item img{width:100%;height:180px;object-fit:cover;display:block}
  .photo-check{position:absolute;top:8px;left:8px;background:rgba(255,255,255,.9);border-radius:.5rem;padding:6px 8px}
  .photo-item.selected { outline: 3px solid rgba(220,53,69,.5); }
  </style>
</head>

<%@ include file="/module/header.jsp" %>
<body>
<%@ include file="/module/aside.jsp" %>

<%-- 수정 모드 판단 및 변수 설정 --%>
<c:set var="status" value="${status}" />
<c:set var="isUpdate" value="${status eq 'u'}" />
<c:set var="issueVO" value="${issueVO}" />

<div class="body-wrapper">
  <div class="container-fluid">

    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 이슈 <c:choose><c:when test="${isUpdate}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard">Project</a></li>
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/issues/lists?prjctNo=${isUpdate ? issueVO.prjctNo : prjctNo}">Issue</a></li>
                <li class="breadcrumb-item active" aria-current="page"><c:choose><c:when test="${isUpdate}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <div class="card rounded-3">
      <div class="card-header bg-primary-subtle">
        <h5 class="modal-title mb-0">이슈 <c:choose><c:when test="${isUpdate}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h5>
      </div>

      <div class="card-body">
        <form id="issueForm"
              action="${pageContext.request.contextPath}/project/issues/<c:choose><c:when test="${isUpdate}">update</c:when><c:otherwise>insert</c:otherwise></c:choose>"
              method="post"
              enctype="multipart/form-data">

          <input type="hidden" name="prjctNo" value="${isUpdate ? issueVO.prjctNo : prjctNo}"/>
          
          <c:if test="${isUpdate}">
              <input type="hidden" name="issueNo" value="${issueVO.issueNo}"/>
              <input type="hidden" name="fileGroupNo" value="${issueVO.fileGroupNo}"/>
          </c:if>

		  <div class="mb-3">
		    <div class="row g-3">
		      <div class="col-md-6">
		        <label for="issueTitle" class="form-label">제목</label>
		        <div class="d-flex align-items-center">
		          <input type="text" class="form-control" id="issueTitle" name="issueTitle"
		                 placeholder="제목을 입력하세요" required 
                         value="${isUpdate ? issueVO.issueTitle : ''}" /> <%-- 기존 값 바인딩 --%>

						 <div class="form-check form-switch ms-3 mb-0">
						                     <input class="form-check-input danger"
						 		                   type="checkbox"
						 		                   id="emrgncyYn"
						 		                   name="emrgncyYn"
						 		                   value="Y" 
                                                   ${isUpdate and issueVO.emrgncyYn eq 'Y' ? 'checked' : ''} /> <%-- 기존 값 바인딩 --%>
						 		            <label class="form-check-label nowrap ms-2" for="emrgncyYn">긴급</label>
						 		          </div>
		        </div>
		      </div>
		    </div>
		  </div>

		  <div class="row g-3">
            <div class="col-md-6">
              <label for="issueTy" class="form-label">이슈 유형</label>
              <select class="form-select" id="issueTy" name="issueTy" required>
                <option value="">선택</option>
                <option value="05002" ${isUpdate and issueVO.issueTy eq '05002' ? 'selected' : ''}>현장</option>
                <option value="05003" ${isUpdate and issueVO.issueTy eq '05003' ? 'selected' : ''}>설계</option>
                <option value="05001" ${isUpdate and issueVO.issueTy eq '05001' ? 'selected' : ''}>민원</option>
                <option value="05004" ${isUpdate and issueVO.issueTy eq '05004' ? 'selected' : ''}>안전</option>
                <option value="05005" ${isUpdate and issueVO.issueTy eq '05005' ? 'selected' : ''}>기타</option>
              </select>
            </div>
			<div class="col-md-6">
              <label for="issueSttus" class="form-label">진행 상태</label>
              <select class="form-select" id="issueSttus" name="issueSttus" required>
                <option value="">선택</option>
                <%-- 등록 시 기본값 '대기' 선택, 수정 시 기존 값 선택 --%>
                <option value="21001" ${!isUpdate or issueVO.issueSttus eq '21001' ? 'selected' : ''}>대기</option> 
				<option value="21002" ${isUpdate and issueVO.issueSttus eq '21002' ? 'selected' : ''}>처리중</option>
                <option value="21003" ${isUpdate and issueVO.issueSttus eq '21003' ? 'selected' : ''}>처리완료</option>
                <option value="22004" ${isUpdate and issueVO.issueSttus eq '22004' ? 'selected' : ''}>반려</option> <%-- 매퍼 기준 추가 --%>
                </select>
            </div>
          </div>

          <div class="mt-3">
            <label for="assignee" class="form-label">담당자</label>
            <select class="form-select" id="assignee" name="issueManager" required>
              <option value="" selected disabled>프로젝트 참여자 목록 로드 중...</option>
              <%-- JS에서 기존 값 선택 처리 --%>
            </select>
          </div>
          <div class="mt-4">
		  <label for="issueCn" class="form-label">이슈 내용</label>
		  <textarea class="form-control" id="issueCn" name="issueCn" rows="6"
		            placeholder="이슈 상세 내용을 입력하세요" required><c:out value="${isUpdate ? issueVO.issueCn : ''}"/></textarea>
			</div>
          
          <%-- 수정 모드: 기존 업로드된 사진들(선택 삭제 표기 방식) --%>
		<c:if test="${isUpdate}">
		  <div class="mt-4">
		    <div class="d-flex justify-content-between align-items-center mb-2">
		      <h5 class="mb-0">업로드된 사진들</h5>
		      <button type="button" class="btn btn-outline-danger btn-sm" id="deleteSelectedBtn">
		        <i class="ti ti-trash"></i> 선택 삭제(표시만)
		      </button>
		    </div>
		
		    <div class="photo-grid" id="existingGrid">
		      <c:set var="hasAnyImage" value="false"/>
		      <c:forEach var="f" items="${issueVO.fileList}">
		        <c:if test="${not empty f.fileMime and fn:startsWith(fn:toLowerCase(f.fileMime), 'image/')}">
		          <c:set var="hasAnyImage" value="true"/>
		          <div class="photo-item" data-file-no="${f.fileNo}">
		            <label class="photo-check d-flex align-items-center gap-2">
		              <input type="checkbox" class="form-check-input delete-check" value="${f.fileNo}">
		              <span class="small">삭제</span>
		            </label>
		            <!-- 이슈 파일 경로는 프로젝트 기준으로 맞춤 -->
		            <img src="${pageContext.request.contextPath}${f.filePath}" alt="${fn:escapeXml(f.originalNm)}">
		          </div>
		        </c:if>
		      </c:forEach>
		
		      <c:if test="${not hasAnyImage}">
		        <div class="text-muted py-5" style="grid-column:1/-1;">등록된 사진이 없습니다.</div>
		      </c:if>
		    </div>
		    <div class="form-text mt-2">체크한 사진은 하단의 [저장/수정] 제출 시 삭제 처리됩니다.</div>
		  </div>
		</c:if>


          <div class="mt-4">
            <label class="form-label d-block" for="uploadFiles">첨부파일 업로드</label>
            <input type="file" class="form-control" id="uploadFiles" name="uploadFiles" multiple
                   accept="image/*,application/pdf,.doc,.docx,.xls,.xlsx" />
            <div class="form-text">여러 파일을 선택할 수 있습니다. (이미지/문서 등)</div>

            <div id="previewList" class="d-flex flex-wrap gap-3 mt-3"></div>
          </div>

          <div class="d-flex justify-content-end gap-2 mt-4">
            <a class="btn btn-light" href="${pageContext.request.contextPath}/project/issues/lists?prjctNo=${isUpdate ? issueVO.prjctNo : prjctNo}">취소</a>
            <button type="submit" class="btn btn-primary"><c:choose><c:when test="${isUpdate}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></button>
          </div>
        </form>
      </div>
    </div>

  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>

<script>
$(function () {
  // EL 표현식의 안전한 사용을 위해 JSTL로 감싸진 변수를 사용합니다.
  const PRJCT_NO_STR = '<c:out value="${isUpdate ? issueVO.prjctNo : (empty prjctNo ? param.prjctNo : prjctNo)}" default=""/>';
  const PRJCT_NO = PRJCT_NO_STR && PRJCT_NO_STR.trim() !== '' ? parseInt(PRJCT_NO_STR, 10) : null;

  const CONTEXT_PATH = '${pageContext.request.contextPath}';
  const IS_UPDATE = ${isUpdate};
  const CURRENT_MANAGER = IS_UPDATE ? '${issueVO.issueManager}' : '';
  /**
   * 프로젝트 참여자 목록을 AJAX로 로드하여 드롭다운을 채우는 함수
   */
  const loadParticipants = function() {
      const $assigneeSelect = $('#assignee');
      $assigneeSelect.empty().append('<option value="" selected disabled>담당자 목록 로드 중...</option>');
   
      // === 가드: prjctNo 없으면 호출하지 않음
      if (PRJCT_NO === null || Number.isNaN(PRJCT_NO)) {
        console.warn('prjctNo가 없어 참여자 목록 요청을 생략합니다.');
        $assigneeSelect.empty().append('<option value="" selected disabled>프로젝트를 먼저 선택하세요.</option>');
        return;
      }
      $.ajax({
          url: CONTEXT_PATH + '/project/issues/participants',
          type: 'GET',
          data: { prjctNo: PRJCT_NO },
          dataType: 'json',
          success: function(participants) {
              $assigneeSelect.empty().append('<option value="" selected disabled>담당자 선택</option>');
              if (participants && participants.length > 0) {
                  $.each(participants, function(index, p) {
                      const empNm = p.empNm || "";
                      const jbgdNm = p.jbgdNm || "";
                      const deptNm = p.deptNm || "";
                      const optionText = `\${empNm} (\${jbgdNm}) - \${deptNm}`;
                      const $option = $('<option/>').val(p.empNo).text(optionText);
                      if (IS_UPDATE && p.empNo === CURRENT_MANAGER) { $option.attr('selected', true); }
                      $assigneeSelect.append($option);
                  });
              } else {
                  $assigneeSelect.empty().append('<option value="" selected disabled>참여자가 존재하지 않습니다. 프로젝트 관리자에게 문의하세요.</option>');
              }
          },
          error: function(xhr) {
              console.error("참여자 목록 로드 실패:", xhr);
              $assigneeSelect.empty().append('<option value="" selected disabled>목록 로드 실패 (F12 콘솔 확인)</option>');
          }
      });
  };

  // 페이지 로드 시 참여자 목록 로드 실행
  loadParticipants();

  // 폼 관련 로직 (기존 유지)
  const $form    = $('#issueForm');
  const $files   = $('#uploadFiles');
  const $preview = $('#previewList');

  // ====== 기존 업로드 이미지 그리드 셀렉터 ======
  const $existingGrid = $('#existingGrid');            // photos_update 스타일 그리드
  const $deleteSelectedBtn = $('#deleteSelectedBtn');  // "선택 삭제(표시만)" → 즉시삭제로 변경

  // (이전 카드UI 호환) 삭제할 파일 번호
  const deletedFiles = [];

  // 신규 파일 미리보기
  $files.on('change', function () {
    $preview.empty();
    const files = this.files ? Array.from(this.files) : [];
    files.forEach(function (file) {
      const $card = $('<div/>', { class: 'card shadow-sm thumb-card' });

      if (file.type && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function (e) {
          $('<img/>', { class: 'img-fluid rounded-2', alt: file.name, src: e.target.result }).appendTo($card);
        };
        reader.readAsDataURL(file);
      } else {
        const $body = $('<div/>', { class: 'card-body p-2' });
        $('<div/>', { class: 'small text-truncate', title: file.name, text: file.name }).appendTo($body);
        $card.append($body);
      }
      $preview.append($card);
    });
  });

  // ====== 헬퍼: 그리드 비었을 때 빈 상태 표시 ======
  function ensureEmptyState() {
    if (!$existingGrid.length) return;
    const hasItems = $existingGrid.find('.photo-item').length > 0;
    $existingGrid.find('.empty-state-row').remove();
    if (!hasItems) {
      $existingGrid.append('<div class="text-muted py-5 empty-state-row" style="grid-column:1/-1;">등록된 사진이 없습니다.</div>');
    }
  }

  // ====== 헬퍼: 즉시 삭제 AJAX (photos 컨트롤러 사용) ======
  function deleteFilesImmediately(fileNos, onDone) {
    if (!fileNos || !fileNos.length) return;
    $.ajax({
      url: CONTEXT_PATH + '/project/photos/delete-files',
      type: 'POST',
      dataType: 'json',
      data: { 'fileNos[]': fileNos },   // 컨트롤러 시그니처에 맞춤
      success: function(res) {
        if (res && res.success) {
          onDone && onDone(res.deleted || fileNos);
          Swal.fire({ icon:'success', title:'삭제 완료', timer: 900, showConfirmButton:false });
        } else {
          Swal.fire({ icon:'error', title:'삭제 실패', text:(res && res.message) || '다시 시도해 주세요.' });
        }
      },
      error: function(xhr) {
        console.error(xhr);
        Swal.fire({ icon:'error', title:'오류', text:'삭제 중 문제가 발생했습니다.' });
      }
    });
  }

  // ====== (이전 UI 호환) 기존 카드UI 버튼 .delete-existing-file → 즉시삭제로 변경 ======
  $(document).on('click', '.delete-existing-file', function() {
    const fileNo = $(this).data('fileNo');
    const $fileCard = $(this).closest('.thumb-card');

    Swal.fire({
      title: '정말 삭제하시겠습니까?',
      text: '삭제 후 복구할 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((r) => {
      if (!r.isConfirmed) return;
      deleteFilesImmediately([fileNo], function(){
        $fileCard.remove();
      });
    });
  });

  // ====== 그리드: 아이템 아무 곳이나 클릭 → 체크 토글 ======
  if ($existingGrid.length) {
    $existingGrid.on('click', '.photo-item', function(e){
      if ($(e.target).is('input.delete-check')) return;
      const $item = $(this);
      const $chk  = $item.find('.delete-check');
      const on    = !$chk.prop('checked');
      $chk.prop('checked', on);
      $item.toggleClass('selected', on);
    });

    // ====== [변경] 선택 삭제 버튼 → 즉시 삭제 ======
    $deleteSelectedBtn.on('click', function(){
      const ids = $existingGrid.find('.delete-check:checked').map(function(){ return this.value; }).get();
      if (!ids.length) {
        Swal.fire({icon:'info', title:'선택 없음', text:'삭제할 사진을 먼저 선택해 주세요.'});
        return;
      }

      Swal.fire({
        title: '선택한 사진을 삭제할까요?',
        text: '삭제 후 복구할 수 없습니다.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '삭제',
        cancelButtonText: '취소',
        confirmButtonColor: '#d33'
      }).then((res)=>{
        if (!res.isConfirmed) return;

        deleteFilesImmediately(ids, function(deleted){
          // 화면에서도 제거
          deleted.forEach(function(no){
            $existingGrid.find('.photo-item[data-file-no="'+ no +'"]').remove();
          });
          ensureEmptyState();
        });
      });
    });
  }

  // ====== 제출 검증 ======
  $form.on('submit', function (e) {
	    const title     = $.trim($('#issueTitle').val());
	    const issueType = $.trim($('#issueTy').val());
	    const status    = $.trim($('#issueSttus').val());
	    const assignee  = $.trim($('#assignee').val());
	    const issueCn   = $.trim($('#issueCn').val()); // issueCn 값 가져오기

	    if (!title || !issueType || !status || !assignee || !issueCn) { // issueCn 검증 추가
	      e.preventDefault();
	      Swal.fire('경고', '제목, 이슈 유형, 진행 상태, 담당자, 이슈 내용은 필수입니다.', 'warning'); // 메시지 수정
	      return false;
	    }

	    // (참고) 지금은 즉시삭제로 바뀌었기 때문에 아래 hidden 전송은 굳이 필요 없지만,
	    // 혹시 남아있는 이전 UI(카드형)의 예약삭제 케이스를 대비해 유지합니다.
	    if (IS_UPDATE && deletedFiles.length) {
	      deletedFiles.forEach(function(fileNo) {
	        $('<input>', {type:'hidden', name:'deleteFileNos', value:fileNo}).appendTo($form);
	      });
	    }
	  });
});
</script>


</body>
</html>