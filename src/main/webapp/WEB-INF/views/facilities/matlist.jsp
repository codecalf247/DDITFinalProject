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
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <style>
    :root{ --surface:#ffffff; --surface-2:#f8fafc; --border:#e5e7eb; --text:#111827; --muted:#64748b; }
    [data-bs-theme="dark"]{ --surface:#0f172a; --surface-2:#111827; --border:#334155; --text:#e5e7eb; --muted:#94a3b8; }

    .stat-tile{border-radius:.9rem;padding:1rem 1.1rem;display:flex;align-items:center;gap:.8rem}
    .stat-tile .icon{width:38px;height:38px;border-radius:.7rem;display:inline-flex;align-items:center;justify-content:center;font-size:1.1rem}
    .tile-blue{background:#eef5ff} .tile-green{background:#ecfdf5} .tile-amber{background:#fff7e6}
    [data-bs-theme="dark"] .tile-blue{background:rgba(59,130,246,.12)}
    [data-bs-theme="dark"] .tile-green{background:rgba(16,185,129,.12)}
    [data-bs-theme="dark"] .tile-amber{background:rgba(245,158,11,.12)}

    .stat-tile .fs-4{ font-size:1.15rem !important; }

    /* 기존 filter-group 스타일 유지 */
    .filter-group.input-group.input-group-sm .form-control{padding-top:.5rem;padding-bottom:.5rem}
    .filter-group .input-group-text{border-right:0;border-top-right-radius:0;border-bottom-right-radius:0}
    .filter-group .form-control{border-left:0;border-right:0;border-radius:0}
    .filter-group .dropdown-toggle{border-top-left-radius:0;border-bottom-left-radius:0}
    .filter-group .form-control:focus{box-shadow:none}
    .filter-group .input-group-text,.filter-group .form-control,.filter-group .dropdown-toggle{
      background:var(--surface); color:var(--text); border-color:var(--border);
    }
    .filter-group .input-group-text i{color:var(--muted)}

    .mat-card{position:relative;border:1px solid var(--border);border-radius:16px;overflow:hidden;background:var(--surface);transition:transform .15s ease, box-shadow .15s ease}
    .mat-card:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.06)}
    .mat-card .thumb{width:100%;aspect-ratio:16/9;object-fit:cover;background:var(--surface-2)}
    .mat-card .body{padding:.9rem .9rem 1rem}

    .mat-title{font-weight:700;color:var(--text)}
    .badge-status{font-size:.8rem;padding:.2rem .6rem;border-radius:999px;border:1px solid var(--border);font-weight:700}
    .status-normal{background:#ecfdf5;color:#059669;border-color:#bbf7d0}
    .status-short{background:#fff7e6;color:#d97706;border-color:#fde68a}

    .qty-row{display:flex;align-items:baseline;justify-content:space-between;margin:6px 0 2px}
    .qty-num{font-size:1.6rem;font-weight:800;line-height:1.1;letter-spacing:.3px}
    .qty-unit{color:var(--muted);margin-left:4px}

    .mat-actions .btn{border-radius:10px;padding:.55rem 1rem;font-weight:700}

  /* === 2번째 이미지와 동일한 검색창 스타일 === */
.search-compact.input-group{  border:1px solid var(--border);        /* 연한 회색 외곽 */  border-radius:999px;  overflow:hidden;  background:var(--surface);}
.search-compact .form-control{  border:0;padding:.55rem .9rem;       /* 세로/가로 여백 */  box-shadow:none;}
.search-compact .btn{  border:0;  background:transparent;  color:#5d87ff;   /* 파란 글자 */  border-left:1px solid rgba(93,135,255,.35); /* 오른쪽 버튼 앞 경계선(연파랑) */  padding:.45rem .9rem;  font-weight:600;}

/* 포커스 시 파란 테두리와 은은한 글로우 */
.search-compact:focus-within{  border-color:#5d87ff;  box-shadow:0 0 0 .2rem rgba(93,135,255,.12);}
  </style>
</head>

<body>
<%@ include file="/module/header.jsp" %>
<%@ include file="/module/aside.jsp" %>

<div class="body-wrapper">
  <div class="container-fluid">
    <div class="container">
    <div class="body-wrapper">
  <div class="container-fluid">

      <!-- 배너 -->
      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
        <div class="card-body px-4 py-3">
          <div class="row align-items-center">
            <div class="col-9">
              <h4 class="fw-semibold mb-8">자재 창고</h4>
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
                  <li class="breadcrumb-item" aria-current="page">Materials</li>
                </ol>
              </nav>
            </div>
          </div>
        </div>
      </div>

      <!-- 요약 타일 -->
      <div class="row g-3 mb-3">
        <div class="col-12 col-sm-6 col-lg-3">
          <div class="stat-tile tile-blue">
            <span class="icon bg-white"><i class="ti ti-package text-primary"></i></span>
            <div><small class="d-block text-primary fw-semibold">전체</small>
              <div class="fs-4 fw-bold text-primary"><c:out value="${totalCount}" default="0"/>개</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-sm-6 col-lg-3">
          <div class="stat-tile tile-green">
            <span class="icon bg-white"><i class="ti ti-circle-check text-success"></i></span>
            <div><small class="d-block text-success fw-semibold">정상</small>
              <div class="fs-4 fw-bold text-success"><c:out value="${normalCount}" default="0"/>개</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-sm-6 col-lg-3">
          <div class="stat-tile tile-amber">
            <span class="icon bg-white"><i class="ti ti-alert-triangle text-warning"></i></span>
            <div><small class="d-block text-warning fw-semibold">재고부족</small>
              <div class="fs-4 fw-bold text-warning"><c:out value="${shortageCount}" default="0"/>개</div>
            </div>
          </div>
        </div>
      </div>

    <!-- 검색 + 상태 필터 (왼쪽=분류, 오른쪽=검색) -->
    <div class="row pb-3">
    	<div class="col-md-3">
	    	<div class="btn-group" role="group">
			    <a href="${pageContext.request.contextPath}/mat/matlist?statusFilter=&searchWord=${fn:escapeXml(param.searchWord)}"
			       class="btn btn-outline-primary <c:if test='${empty statusFilter}'>active</c:if>">전체</a>
			    <a href="${pageContext.request.contextPath}/mat/matlist?statusFilter=normal&searchWord=${fn:escapeXml(param.searchWord)}"
			       class="btn btn-outline-primary <c:if test='${statusFilter eq "normal"}'>active</c:if>">정상</a>
			    <a href="${pageContext.request.contextPath}/mat/matlist?statusFilter=shortage&searchWord=${fn:escapeXml(param.searchWord)}"
			       class="btn btn-outline-primary <c:if test='${statusFilter eq "shortage"}'>active</c:if>">재고부족</a>
			  </div>
    	</div>
    	<div class="col-md-6"></div>
    	<div class="col-md-3">
    		<form id="searchForm"
		        action="${pageContext.request.contextPath}/mat/matlist"
		        method="get"
		        class="search-pill input-group input-group-sm"
		        style="max-width:520px">
		    
				 <div class="input-group">
				  <input type="text" name="searchWord" class="form-control"
				         value="${searchWord}" placeholder="검색어를 입력하세요.">
				  <button class="btn btn-outline-secondary" type="submit">
				    <i class="ti ti-search"></i> 검색
				  </button>
				</div>
		    <input type="hidden" name="page" value="1"/>
		    <input type="hidden" name="statusFilter" value="${statusFilter}"/>
		  </form>
    	</div>
    </div>


      <!-- 자재 카드 목록 -->
      <div class="row gy-3 gx-3 mb-4">
        <c:forEach var="mat" items="${matList}">
          <div class="col-12 col-md-6 col-xl-3">
            <div class="mat-card" data-item-id="${mat.mtrilId}">
              <img class="thumb"
                   src="<c:out value='${mat.filePath}'/>"
                   alt="<c:out value='${mat.mtrilNm}'/>"
                   onerror="this.src='${pageContext.request.contextPath}/resources/img/no-image.png'">
              <div class="body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <div class="mat-title"><c:out value='${mat.mtrilNm}'/></div>
                  <c:choose>
                    <c:when test='${mat.stockStatus eq "normal"}'><span class="badge-status status-normal">정상</span></c:when>
                    <c:otherwise><span class="badge-status status-short">재고부족</span></c:otherwise>
                  </c:choose>
                </div>
                <div class="qty-row">
                  <div class="qty-num" data-stock><c:out value='${empty mat.stock ? 0 : mat.stock}'/></div>
                  <div class="qty-unit" data-unit><c:out value='${mat.unitNm}' default="-"/></div>
                </div>
                <div class="mat-actions d-flex gap-2 mt-2">
                  <!-- 출고 모달 -->
                  <button type="button" class="btn btn-light w-50"
                          data-bs-toggle="modal" data-bs-target="#outModal"
                          data-item='{"id":"${mat.mtrilId}","name":"${fn:escapeXml(mat.mtrilNm)}","stock":${empty mat.stock ? 0 : mat.stock},"unit":"${fn:escapeXml(mat.unitNm)}","img":"${fn:escapeXml(mat.filePath)}"}'>
                    – 출고
                  </button>
                  <!-- 입고 모달 -->
                  <button type="button" class="btn btn-dark w-50"
                          data-bs-toggle="modal" data-bs-target="#inModal"
                          data-item='{"id":"${mat.mtrilId}","name":"${fn:escapeXml(mat.mtrilNm)}","stock":${empty mat.stock ? 0 : mat.stock},"unit":"${fn:escapeXml(mat.unitNm)}","img":"${fn:escapeXml(mat.filePath)}"}'>
                    + 입고
                  </button>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty matList}">
          <div class="col-12"><div class="text-center text-muted py-5">표시할 자재가 없습니다.</div></div>
        </c:if>
      </div>


      <!-- 페이지네이션 -->
      <div class="flex-grow-1 d-flex justify-content-center">
        <div class="d-flex align-items-center">
          ${pagingVO.pagingHTML2}
        </div>
      </div>

      <!-- 페이징 히든폼 -->
      <form id="pageForm" action="${pageContext.request.contextPath}/mat/matlist" method="get">
        <input type="hidden" name="page" id="page">
        <input type="hidden" name="searchWord" value="${fn:escapeXml(searchWord)}">
        <input type="hidden" name="statusFilter" value="${statusFilter}">
      </form>

      <!-- 재고 증감 POST 히든 폼 -->
      <form id="stockForm" method="post" action="${pageContext.request.contextPath}/mat/stock" style="display:none;">
        <input type="hidden" name="mtrilId" id="sfId">
        <input type="hidden" name="type" id="sfType"><!-- in | out -->
        <input type="hidden" name="inoutQy" id="sfInoutQy">
        <input type="hidden" name="sptNm" id="sfSite">
        <input type="hidden" name="memo" id="sfMemo">
        <c:if test="${not empty _csrf}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        </c:if>
      </form>

    </div>
  </div>
</div>
 </div>
</div>

<!-- ===== 입고 모달 ===== -->
<div class="modal fade" id="inModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px;">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">자재 입고</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body pt-0">
        <div class="d-flex align-items-center gap-3 bg-body rounded-3 border p-2 mb-3">
          <img id="inThumb" class="rounded-2" style="width:48px;height:48px;object-fit:cover;" alt="">
          <div class="flex-grow-1">
            <div class="fw-semibold" id="inName">-</div>
            <small class="text-muted">현재 재고: <span id="inStock">0</span> <span id="inUnit">개</span></small>
          </div>
        </div>
        <label class="form-label mb-1">입고 수량 (<span id="inUnitLbl">개</span>)</label>
        <div class="d-flex align-items-center gap-2 mb-2">
          <button class="btn btn-light border btn-sm" type="button" data-in-step="dec">−</button>
          <input type="range" min="0" max="100" value="0" class="form-range flex-grow-1" id="inRange">
          <button class="btn btn-light border btn-sm" type="button" data-in-step="inc">＋</button>
        </div>
        <input type="number" class="form-control form-control-sm mb-3" id="inQty" value="0" min="0" step="1">
        <label class="form-label">메모 (선택)</label>
        <textarea class="form-control" id="inMemo" rows="3" placeholder="입고 사유를 입력하세요..."></textarea>
      </div>
      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-dark" id="inConfirm">입고 확인</button>
      </div>
    </div>
  </div>
</div>

<!-- ===== 출고 모달 ===== -->
<div class="modal fade" id="outModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px;">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">자재 출고</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body pt-0">
        <div class="d-flex align-items-center gap-3 bg-body rounded-3 border p-2 mb-3">
          <img id="outThumb" class="rounded-2" style="width:48px;height:48px;object-fit:cover;" alt="">
          <div class="flex-grow-1">
            <div class="fw-semibold" id="outName">-</div>
            <small class="text-muted">현재 재고: <span id="outStock">0</span> <span id="outUnit">개</span></small>
          </div>
        </div>
        <label class="form-label mb-1">출고 수량 (<span id="outUnitLbl">개</span>)</label>
        <div class="d-flex align-items-center gap-2 mb-2">
          <button class="btn btn-light border btn-sm" type="button" data-out-step="dec">−</button>
          <input type="range" min="0" max="0" value="0" class="form-range flex-grow-1" id="outRange">
          <button class="btn btn-light border btn-sm" type="button" data-out-step="inc">＋</button>
        </div>
        <input type="number" class="form-control form-control-sm mb-3" id="outQty" value="0" min="0" step="1">
        <label class="form-label">현장명 (선택)</label>
        <div class="input-group mb-3">
          <input type="text" class="form-control" id="outSite" placeholder="현장명을 입력하세요">
        </div>
        <label class="form-label">메모 (선택)</label>
        <textarea class="form-control" id="outMemo" rows="3" placeholder="출고 사유를 입력하세요..."></textarea>
      </div>
      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-dark" id="outConfirm">출고 확인</button>
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<script>
$(function(){
  /* ===== SweetAlert 메시지 ===== */
  const message = '${msg}';
  if (message && message.trim() !== '') {
    Swal.fire({ title: message, icon: 'success', confirmButtonText: '확인' });
  }

  /* ===== 변수 캐시 ===== */
  let $page      = $('#page');
  let $pageForm  = $('#pageForm');
  let $inQty     = $('#inQty');
  let $inRange   = $('#inRange');
  let $outQty    = $('#outQty');
  let $outRange  = $('#outRange');
  let $stockForm = $('#stockForm');
  let $sfId      = $('#sfId');
  let $sfType    = $('#sfType');
  let $sfInoutQy = $('#sfInoutQy');
  let $sfSite    = $('#sfSite');
  let $sfMemo    = $('#sfMemo');
  let $doc       = $(document);
  let CURRENT_ITEM = null;

  /* ===== 공통 유틸 ===== */
  let parseItem = function(el){
    try { return JSON.parse(el.getAttribute('data-item') || '{}'); }
    catch(e){ return {}; }
  };
  let readCardStockById = function(id){
    let $card = $('[data-item-id="'+id+'"]');
    let v = parseInt($card.find('[data-stock]').text().trim(), 10);
    return isNaN(v) ? 0 : v;
  };
  let updateCardStock = function(id, newStock){
    let $card = $('[data-item-id="'+id+'"]');
    $card.find('[data-stock]').text(newStock);
  };
  let submitStock = function(mtrilId, type, qty){
    $sfId.val(mtrilId);
    $sfType.val(type);
    $sfInoutQy.val(qty);
    if(type === 'out'){
      $sfSite.val($('#outSite').val() || '');
      $sfMemo.val($('#outMemo').val() || '');
    }else{
      $sfSite.val('');
      $sfMemo.val($('#inMemo').val() || '');
    }
    $stockForm[0].submit();
  };

  /* ===== 페이징 ===== */
  window.fn_pagination = function(pageNo){
    $page.val(pageNo);
    $pageForm.submit();
  };

  /* ===== 모달 오픈(입고) ===== */
  $doc.on('click', '[data-bs-target="#inModal"]', function(){
    CURRENT_ITEM = parseItem(this);
    CURRENT_ITEM.stock = readCardStockById(CURRENT_ITEM.id);
    $('#inThumb').attr('src', CURRENT_ITEM.img || '');
    $('#inName').text(CURRENT_ITEM.name || '-');
    $('#inStock').text(CURRENT_ITEM.stock || 0);
    $('#inUnit, #inUnitLbl').text(CURRENT_ITEM.unit || '개');
    $('#inMemo').val('');
    $inQty.val(0);
    let maxCandidate = Math.max(100, (CURRENT_ITEM.stock || 0));
    $inRange.val(0).attr('max', maxCandidate);
  });

  /* ===== 모달 오픈(출고) ===== */
  $doc.on('click', '[data-bs-target="#outModal"]', function(){
    CURRENT_ITEM = parseItem(this);
    CURRENT_ITEM.stock = readCardStockById(CURRENT_ITEM.id);
    $('#outThumb').attr('src', CURRENT_ITEM.img || '');
    $('#outName').text(CURRENT_ITEM.name || '-');
    $('#outStock').text(CURRENT_ITEM.stock || 0);
    $('#outUnit, #outUnitLbl').text(CURRENT_ITEM.unit || '개');
    $('#outMemo').val(''); $('#outSite').val('');
    $outQty.val(0);
    $outRange.val(0).attr('max', CURRENT_ITEM.stock || 0);
  });

  /* ===== 입고 수량 동기화 ===== */
  $('[data-in-step="dec"]').on('click', function(){
    let v = Math.max(0, (+$inQty.val() || 0) - 1);
    $inQty.val(v); $inRange.val(v);
  });
  $('[data-in-step="inc"]').on('click', function(){
    let v = (+$inQty.val() || 0) + 1;
    $inQty.val(v); $inRange.val(v);
  });
  $inRange.on('input', function(){ $inQty.val($inRange.val()); });
  $inQty.on('input', function(){
    let v = Math.max(0, (+$inQty.val() || 0));
    $inRange.val(v);
  });

  /* ===== 출고 수량 동기화 ===== */
  $('[data-out-step="dec"]').on('click', function(){
    let v = Math.max(0, (+$outQty.val() || 0) - 1);
    $outQty.val(v); $outRange.val(v);
  });
  $('[data-out-step="inc"]').on('click', function(){
    let m = +$outRange.attr('max') || 0;
    let v = Math.min(m, (+$outQty.val() || 0) + 1);
    $outQty.val(v); $outRange.val(v);
  });
  $outRange.on('input', function(){ $outQty.val($outRange.val()); });
  $outQty.on('input', function(){
    let m = +$outRange.attr('max') || 0;
    let v = Math.max(0, Math.min(m, +$outQty.val() || 0));
    $outQty.val(v); $outRange.val(v);
  });

  /* ===== 확인 버튼 ===== */
  $('#inConfirm').on('click', function(){
    let qty = Math.max(0, +$inQty.val() || 0);
    if(qty === 0){ alert('입고 수량을 입력하세요.'); return; }
    if(!CURRENT_ITEM || !CURRENT_ITEM.id){ alert('대상이 없습니다.'); return; }
    submitStock(CURRENT_ITEM.id, 'in', qty);
    bootstrap.Modal.getInstance(document.getElementById('inModal')).hide();
    updateCardStock(CURRENT_ITEM.id, CURRENT_ITEM.stock + qty);
  });

  $('#outConfirm').on('click', function(){
    let qty = Math.max(0, +$outQty.val() || 0);
    let max = +$outRange.attr('max') || 0;
    if(qty === 0){ alert('출고 수량을 입력하세요.'); return; }
    if(qty > max){ alert('현재 재고를 초과할 수 없습니다.'); return; }
    if(!CURRENT_ITEM || !CURRENT_ITEM.id){ alert('대상이 없습니다.'); return; }
    submitStock(CURRENT_ITEM.id, 'out', qty);
    bootstrap.Modal.getInstance(document.getElementById('outModal')).hide();
    updateCardStock(CURRENT_ITEM.id, CURRENT_ITEM.stock - qty);
  });
});
</script>

</body>
</html>
