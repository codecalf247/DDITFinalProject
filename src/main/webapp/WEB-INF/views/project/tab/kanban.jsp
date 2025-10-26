<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">


<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>GroupWare - Kanban</title>


<style>
/* 레이아웃 보정 */
.task-list-section {
	--bs-gutter-x: .75rem;
	--bs-gutter-y: .75rem;
}

.task-list-section.row>.kanban-col, .task-list-container,
	.task-list-container .card, .task-list-container .connect-sorting {
	min-width: 0 !important;
	width: 100%;
}

.task-list-container .card-body {
	padding: .9rem 1rem;
}
.task-container-header {
  position: relative;
  z-index: 10;
}

.connect-sorting {
	display: flex;
	flex-direction: column;
	height: 100%;
}
/* 카드 리스트는 뒤로 */
.connect-sorting-content {
  position: relative;  /* 없으면 추가 */
  z-index: 1;
}

.img-task img {
	display: block;
	max-width: 100%;
	height: auto;
}

.kanban-page-wrap {
	padding: 0 2px;
	width: 100%;
	display: inline-block;
	margin-top: 15px;
	clear: both;
}

.scrumboard, .layout-spacing {
	overflow-x: visible !important;
}

:root {
	--kanban-nudge-xl: 6px;
	--kanban-nudge-xxl: 8px;
}

@media ( min-width : 1200px) and (max-width: 1399.98px) {
	.task-list-section.row>.kanban-col {
		flex: 0 0 calc(25% - var(--kanban-nudge-xl));
		max-width: calc(25% - var(--kanban-nudge-xl));
	}
}

@media ( min-width : 1400px) {
	.task-list-section.row>.kanban-col {
		flex: 0 0 calc(25% - var(--kanban-nudge-xxl));
		max-width: calc(25% - var(--kanban-nudge-xxl));
	}
}

body .task-list-section {
	gap: 11px;
}

@media ( max-width : 1200px) {
	body .task-list-section {
		gap: 0;
		flex-wrap: wrap;
	}
}

/* 색상 */
.bg-purple-subtle {
	background-color: #f3e8ff !important;
}

.text-purple {
	color: #6f42c1 !important;
}

.text-bg-purple {
	background-color: #6f42c1 !important;
	color: #fff !important;
}

/* 드래그 placeholder */
.kanban-placeholder {
	border: 2px dashed var(--bs-primary);
	border-radius: .5rem;
	height: 64px;
	margin: .25rem 0;
}

/* 카드 호버 */
.issue-card {
	transition: transform .15s ease, box-shadow .2s ease, border-color .2s
		ease, background-color .2s ease;
}



.issue-card:hover {
	cursor: pointer;
	transform: translateY(-2px);
	border-color: rgba(13, 110, 253, .35);
	box-shadow: 0 .5rem 1rem rgba(13, 110, 253, .12);
	background-color: rgba(13, 110, 253, .02);
}

.issue-card:focus-within {
	outline: 2px solid rgba(13, 110, 253, .25);
	outline-offset: 2px;
}

/* === Kanban 카드 리파인 (교체/추가) === */
.issue-card {
	border: 1px solid var(--bs-border-color-translucent);
	border-radius: .75rem;
	box-shadow: 0 .25rem .75rem rgba(0, 0, 0, .03);
	background: linear-gradient(180deg, #fff, rgba(255, 255, 255, .96));
}

.issue-card .card-body {
	position: relative; /* 드롭다운 절대위치 */
	display: flex; /* 세로 정렬 */
	flex-direction: column;
	gap: .5rem;
	padding-right: 46px; /* 점3개 버튼 공간 확보 */
}

/* 이미지와 유사한 카드 스타일 */
.issue-card .card-body {
	gap: .25rem;
	padding: 1rem 1.2rem;
	padding-right: 2.5rem;
}

.issue-card .kanban-titlebox {
	font-size: 1rem;
	font-weight: 500;
	line-height: 1.4;
	color: #333;
}

.issue-card .small.text-muted {
	font-size: 0.82rem;
	color: #777 !important;
}

.card-actions {
	position: absolute;
	top: .35rem;
	right: .35rem;
	z-index: 2000; /* 드롭다운이 카드 위에 올라오게 */
}

.card-actions .btn-icon {
	width: 32px;
	height: 32px;
}

.card-actions .btn-icon:hover {
	background-color: rgba(0, 0, 0, .05);
}

.card-actions .dropdown-menu {
	border-radius: .5rem;
	padding: .25rem;
}

.card-actions .dropdown-item {
	border-radius: .375rem;
}

.card-actions .dropdown-item:hover {
	background-color: rgba(13, 110, 253, .08);
}

/* 카드 푸터: 좌측(상태/유형), 우측(긴급) */
.kanban-footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: .5rem;
}

.kanban-badges {
	display: flex;
	flex-wrap: wrap;
	gap: .35rem;
}

/* 드래그 가능한 카드를 위한 커서 변경 */
.connect-sorting-content .issue-card {
	cursor: grab;
}

/* 드래그 중인 카드를 위한 커서 변경 */
.ui-sortable-helper {
	cursor: grabbing !important;
}
/* 드롭다운이 잘 보이도록 */
.task-list-container, .connect-sorting, .connect-sorting-content {
	overflow: visible;
}

.issue-card .dropdown-menu {
	z-index: 2000;
} /* 카드 위로 띄우기 */
.dropdown-menu {
	pointer-events: auto;
} /* 포인터 이벤트 보장 */

/* 혹시 아이콘만 덮일 때 */
.add-kanban-title .addTask {
  position: relative;
  z-index: 11;
}
</style>
</head>
<%@ include file="/module/header.jsp"%>


<body>


	<div class="body-wrapper">
		<div class="container-fluid">
		  <div class="body-wrapper">
        <div class="container">

		<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 견적서</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a>
                </li>
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard?prjctNo=${prjctNo}">Project</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Kanban</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

        

			<%@ include file="/WEB-INF/views/project/carousels.jsp"%>




			<div class="row row-cols-4 g-2" id="summaryRow">
				<div class="col">
					<button type="button"
						class="btn w-100 d-flex align-items-center justify-content-between bg-light-subtle text-dark rounded-3 px-3 py-2">
						<span>대기</span><span id="count-wait"
							class="badge rounded-pill text-bg-light text-dark">0</span>
					</button>
				</div>
				<div class="col">
					<button type="button"
						class="btn w-100 d-flex align-items-center justify-content-between bg-info-subtle text-info rounded-3 px-3 py-2">
						<span>진행중</span><span id="count-progress"
							class="badge rounded-pill text-bg-info">0</span>
					</button>
				</div>
				<div class="col">
					<button type="button"
						class="btn w-100 d-flex align-items-center justify-content-between bg-purple-subtle text-purple rounded-3 px-3 py-2">
						<span>검토중</span><span id="count-review"
							class="badge rounded-pill text-bg-purple">0</span>
					</button>
				</div>
				<div class="col">
					<button type="button"
						class="btn w-100 d-flex align-items-center justify-content-between bg-success-subtle text-success rounded-3 px-3 py-2">
						<span>완료</span><span id="count-done"
							class="badge rounded-pill text-bg-success">0</span>
					</button>
				</div>
			</div>

			<div class="kanban-page-wrap">
				<div class="scrumboard" id="cancel-row">
					<div class="layout-spacing pb-3">
						<div
							class="task-list-section row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3 align-items-stretch">

							<div class="col d-flex kanban-col">
								<div class="task-list-container card h-100 flex-fill"
									data-item="item-todo" data-action="sorting">
									<div class="connect-sorting connect-sorting-todo">
										<div
											class="task-container-header d-flex align-items-center justify-content-between">
											<h6 class="item-head mb-0 fs-4 fw-semibold"
												data-item-title="Todo">대기</h6>
											<div class="hstack gap-2">
												<div class="add-kanban-title">
													<c:set var="prjctNo" value="${prjctNo }"/>
													<a
													  class="gw-add-task d-flex align-items-center justify-content-center gap-1 lh-sm"
													  href="/project/tasks/insert?prjctNo=${prjctNo}"
													  data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="Add Task">
													  <i class="ti ti-plus text-dark"></i>
													</a>
												</div>
											</div>
										</div>
										<div class="connect-sorting-content d-flex flex-column gap-2"
											data-sortable="true"></div>
									</div>
								</div>
							</div>

							<div class="col d-flex kanban-col">
								<div class="task-list-container card h-100 flex-fill"
									data-item="item-inprogress" data-action="sorting">
									<div class="connect-sorting connect-sorting-inprogress">
										<div
											class="task-container-header d-flex align-items-center justify-content-between">
											<h6 class="item-head mb-0 fs-4 fw-semibold"
												data-item-title="In Progress">진행중</h6>
										</div>
										<div class="connect-sorting-content d-flex flex-column gap-2"
											data-sortable="true"></div>
									</div>
								</div>
							</div>

							<div class="col d-flex kanban-col">
								<div class="task-list-container card h-100 flex-fill"
									data-item="item-pending" data-action="sorting">
									<div class="connect-sorting connect-sorting-pending">
										<div
											class="task-container-header d-flex align-items-center justify-content-between">
											<h6 class="item-head mb-0 fs-4 fw-semibold"
												data-item-title="Pending">검토중</h6>
										</div>
										<div class="connect-sorting-content d-flex flex-column gap-2"
											data-sortable="true"></div>
									</div>
								</div>
							</div>

							<div class="col d-flex kanban-col">
								<div class="task-list-container card h-100 flex-fill"
									data-item="item-done" data-action="sorting">
									<div class="connect-sorting connect-sorting-done">
										<div
											class="task-container-header d-flex align-items-center justify-content-between">
											<h6 class="item-head mb-0 fs-4 fw-semibold"
												data-item-title="Done">완료</h6>
										</div>
										<div class="connect-sorting-content d-flex flex-column gap-2"
											data-sortable="true"></div>
									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>




		</div>
	</div>
	<%@ include file="/module/footerPart.jsp"%>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/jquery-ui/dist/jquery-ui.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/apps/kanban.js"></script>



<script type="text/javascript">
$(function(){
  var ctx     = '${pageContext.request.contextPath}';
  var prjctNo = ('${prjctNo}' && '${prjctNo}'.trim() !== '' ? '${prjctNo}' : '${param.prjctNo}')
  || (new URLSearchParams(window.location.search).get('prjctNo') || '');

  var COLS = {
    todo:       '.task-list-container[data-item="item-todo"] .connect-sorting-content',
    inprogress: '.task-list-container[data-item="item-inprogress"] .connect-sorting-content',
    pending:    '.task-list-container[data-item="item-pending"] .connect-sorting-content',
    done:       '.task-list-container[data-item="item-done"] .connect-sorting-content'
  };

  //카드 템플릿
  function buildCard(t){
	  console.log("#########################");
	  console.log(t);
	  
	  let typeBadge = t.procsTy ? '<span class="badge rounded-pill text-bg-warning">' + t.procsTy + '</span>' : '';
	  let urgent    = (t.emrgncyYn === 'Y') ? '<span class="badge rounded-pill bg-danger">긴급</span>' : '';

    let html  = ``;
    html += `
    	<div data-draggable="true" class="card" data-task-no="\${t.taskNo}">
			<div class="card-body">
				<div class="task-header">
					<div>
						<h4 data-item-title="Design navigation changes">\${t.taskTitle}</h4>
					</div>
					<div class="dropdown">
						<a class="dropdown-toggle" href="javascript:void(0)" role="button"
							id="dropdownMenuLink-1" data-bs-toggle="dropdown"
							aria-haspopup="true" aria-expanded="true"> <i
							class="ti ti-dots-vertical text-dark"></i>
						</a>
						<div class="dropdown-menu dropdown-menu-end"
							aria-labelledby="dropdownMenuLink-1">
							<a class="dropdown-item kanban-item-edit cursor-pointer d-flex align-items-center gap-1" href="\${ctx}/project/tasks/update?prjctNo=\${t.prjctNo}&taskNo=\${t.taskNo}"> 
								<i class="ti ti-pencil fs-5"></i>Edit
							</a> 
							<button class="dropdown-item kanban-item-delete cursor-pointer text-danger d-flex align-items-center gap-1 btn-delete" data-task-no="\${t.taskNo}"> 
								<i class="ti ti-trash fs-5"></i>Delete
							</button>
						</div>
					</div>
				</div>
				 <div class="task-content">
					<p class="mb-0 small text-truncate">
						<strong class="text-secondary">담당자:</strong> \${t.taskChargerNm} 
                     
					</p>
				</div>
             
				<div class="task-body">
					<div class="task-bottom">
						<div class="tb-section-1">
							<span class="hstack gap-2 fs-2">
								\${typeBadge}
							</span>
						</div>
						<div class="tb-section-2">
							<span class="badge fs-1">\${urgent}</span>
						</div>
					</div>
				</div>
			</div>
    	</div>
    `;
    

    return html;
  }

  // 안전한 셀렉터 결합
  var selectors = [COLS.todo, COLS.inprogress, COLS.pending, COLS.done]
    .map(function(s){ return (s||'').trim(); })
    .filter(function(s){ return s.length>0; })
    .join(',');
  if (!selectors) {
    console.warn('[Kanban] No column selectors found.');
  }

  function clearAll(){
    $(COLS.todo).empty();
    $(COLS.inprogress).empty();
    $(COLS.pending).empty();
    $(COLS.done).empty();
  }

  // 카운트 갱신
  function recalcCounts(){
    var sel = '[data-draggable="true"].card';
    $('#count-wait').text($(COLS.todo).find(sel).length);
    $('#count-progress').text($(COLS.inprogress).find(sel).length);
    $('#count-review').text($(COLS.pending).find(sel).length);
    $('#count-done').text($(COLS.done).find(sel).length);
  }

  // 초기 로딩
  function loadKanban(){
    if (!prjctNo) {
      console.error('[Kanban] prjctNo is empty.');
      return;
    }
    $.getJSON(ctx + '/project/kanban/listAjax', { prjctNo: prjctNo })
      .done(function(data){
        clearAll();
        $.each(data.todo||[],       function(_,t){ $(COLS.todo).append(buildCard(t)); });
        $.each(data.inprogress||[], function(_,t){ $(COLS.inprogress).append(buildCard(t)); });
        $.each(data.pending||[],    function(_,t){ $(COLS.pending).append(buildCard(t)); });
        $.each(data.done||[],       function(_,t){ $(COLS.done).append(buildCard(t)); });
        recalcCounts();
      })
      .fail(function(){
        // 폴백: task 목록 전체 받아 분류
        $.getJSON(ctx + '/project/tasks/listAjax', {
          prjctNo: prjctNo, status: 'all', currentPage: 1
        }).done(function(pagingVO){
          var list = pagingVO.dataList || [];
          clearAll();
          $.each(list, function(_, t){
            var p = parseInt(t.taskProgrs||0,10);
            var card = buildCard(t);
            if (p === 0)        $(COLS.todo).append(card);
            else if (p === 90)  $(COLS.pending).append(card);
            else if (p === 100) $(COLS.done).append(card);
            else                $(COLS.inprogress).append(card); // 10~80 or 기타
          });
          recalcCounts();
        });
      });
  }

//드래그 연결
  if (selectors && $.fn.sortable) {
    $(selectors).sortable({
      connectWith: '.connect-sorting-content[data-sortable="true"]',
      placeholder: 'kanban-placeholder',
      forcePlaceholderSize: true,

      cancel: '.dropdown, .dropdown *, .btn, a, input, textarea, select, label',
      distance: 5,

      receive: function(e, ui){
        const $card = $(ui.item);
        const taskNo = $card.data('task-no');
        const $listContainer = $(this); // 카드가 '새로' 드롭된 컨테이너

        if(!taskNo){ return; }

        let column = 'todo';
        const $container = $listContainer.closest('.task-list-container');
        if ($container.is('[data-item="item-inprogress"]')) column = 'inprogress';
        else if ($container.is('[data-item="item-pending"]')) column = 'pending';
        else if ($container.is('[data-item="item-done"]')) column = 'done';

        // 서버 요청
        $.post(ctx + '/project/kanban/move', {
          prjctNo: prjctNo, taskNo: taskNo, column: column
        }).done(function(res){
          if(res === 'SUCCESS'){
            recalcCounts();
          } else if (res === 'NO_PERMISSION') {
            
            // 1. 카드를 원래 위치로 즉시 되돌림 (시각적으로 먼저 되돌려야 함)
            $listContainer.sortable('cancel'); 
            
            // 2. 경고 메시지를 띄우고, 닫히면 목록을 리로드하여 데이터 일관성 확보
            Swal.fire({
              title: '권한 없음',
              text: '담당자, 작성자 또는 관리자만 일감 상태를 수정할 수 있습니다.',
              icon: 'warning',
              confirmButtonText: '확인',
              buttonsStyling: false,
              customClass: { confirmButton: 'btn btn-primary' }
            }).then(() => loadKanban()); 
            
          } else {
            // 기타 서버 오류/실패
            // 카드를 원래 위치로 되돌림
            $listContainer.sortable('cancel');
            
            Swal.fire({
              title: '상태 변경 실패',
              text: '일시적인 오류가 발생했어요. 페이지를 새로고침합니다.',
              icon: 'error',
              confirmButtonText: '확인',
              buttonsStyling: false,
              customClass: { confirmButton: 'btn btn-primary' }
            }).then(() => loadKanban()); 
          }
        }).fail(function(){
          // 통신 오류
          // 카드를 원래 위치로 되돌림
          $listContainer.sortable('cancel');
          
          Swal.fire({
            title: '통신 오류',
            text: '서버와 통신 중 문제가 발생했습니다. 페이지를 새로고침합니다.',
            icon: 'error',
            confirmButtonText: '확인',
            buttonsStyling: false,
            customClass: { confirmButton: 'btn btn-primary' }
          }).then(() => loadKanban()); 
        });
      }
    }).disableSelection();
  } else if (!$.fn.sortable) {
    console.warn('[Kanban] jQuery UI sortable not loaded.');
  }

  // 드롭다운 메뉴 내부 클릭은 카드 클릭으로 전달되지 않도록
  $(document).on('click', '.dropdown-menu', function(e){
    e.stopPropagation();
  });

  // 삭제(드롭다운) - SweetAlert2 적용
  $(document).on('click', '.btn-delete', async function (e) {
    e.stopPropagation();

    const $btn = $(this);
    const taskNo = $btn.data('task-no');
    if (!taskNo) return;

    const result = await Swal.fire({
      title: '이 일감을 삭제할까요?',
      html: '<small class="text-muted">삭제 후 되돌릴 수 없습니다.</small>',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: '삭제',
      cancelButtonText: '취소',
      reverseButtons: true,
      buttonsStyling: false,
      customClass: {
        confirmButton: 'btn btn-danger mx-1',
        cancelButton: 'btn btn-light mx-1'
      }
    });

    if (!result.isConfirmed) return;

    Swal.showLoading();

    $.post(ctx + '/project/tasks/delete', { taskNo: taskNo, prjctNo: prjctNo })
      .done(function (res) {
        if (res === 'SUCCESS') {
          // .issue-card 또는 공통 카드 제거 대응
          const $card = $btn.closest('.issue-card').length
            ? $btn.closest('.issue-card')
            : $btn.closest('[data-draggable="true"].card');

          $card.remove();
          recalcCounts();

          Swal.fire({
            title: '삭제 완료',
            icon: 'success',
            timer: 1200,
            showConfirmButton: false
          });
        } else {
          Swal.fire({
            title: '삭제 실패',
            text: '일시적인 오류가 발생했어요.',
            icon: 'error',
            confirmButtonText: '확인',
            buttonsStyling: false,
            customClass: { confirmButton: 'btn btn-primary' }
          });
        }
      })
      .fail(function () {
        Swal.fire({
          title: '통신 오류',
          text: '서버와 통신 중 문제가 발생했습니다.',
          icon: 'error',
          confirmButtonText: '확인',
          buttonsStyling: false,
          customClass: { confirmButton: 'btn btn-primary' }
        });
      }); 
  });

  // 카드 클릭 → 상세 이동 (issue-card, card 둘 다 대응)
  $(document).on('click', '.issue-card, [data-draggable="true"].card', function(e){
    if ($(e.target).closest('.dropdown, .dropdown-menu, .btn, a').length) {
      return;
    }
    const taskNo = $(this).data('task-no');
    if (!taskNo) return;
    window.location.href = ctx + '/project/tasks/detail?prjctNo=' + prjctNo + '&taskNo=' + taskNo;
  });

  // 최초 로딩
  loadKanban();
});
</script>
</body>
</html>