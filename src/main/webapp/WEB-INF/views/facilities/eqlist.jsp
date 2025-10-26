<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
<%@ include file="/module/header.jsp" %>

<style>
  :root{ --surface:#ffffff; --surface-2:#f8fafc; --border:#e5e7eb; --text:#111827; --muted:#64748b; }
  [data-bs-theme="dark"]{ --surface:#0f172a; --surface-2:#111827; --border:#334155; --text:#e5e7eb; --muted:#94a3b8; }
  .stat-tile{border-radius:.9rem;padding:1rem 1.1rem;display:flex;align-items:center;gap:.8rem}
  .stat-tile .icon{width:38px;height:38px;border-radius:.7rem;display:inline-flex;align-items:center;justify-content:center;font-size:1.1rem}
  .tile-blue{background:#eef5ff} .tile-green{background:#ecfdf5} .tile-amber{background:#fff7e6} .tile-red{background:#fff1f2}
  [data-bs-theme="dark"] .tile-blue{background:rgba(59,130,246,.12)}
  [data-bs-theme="dark"] .tile-green{background:rgba(16,185,129,.12)}
  [data-bs-theme="dark"] .tile-amber{background:rgba(245,158,11,.12)}
  [data-bs-theme="dark"] .tile-red{background:rgba(239,68,68,.12)}

  .filter-group.input-group.input-group-sm .form-control{padding-top:.5rem;padding-bottom:.5rem}
  .filter-group .input-group-text{border-right:0;border-top-right-radius:0;border-bottom-right-radius:0}
  .filter-group .form-control{border-left:0;border-right:0;border-radius:0}
  .filter-group .dropdown-toggle{border-top-left-radius:0;border-bottom-left-radius:0}
  .filter-group .form-control:focus{box-shadow:none}
  .filter-group .input-group-text,.filter-group .form-control,.filter-group .dropdown-toggle{background:var(--surface); color:var(--text); border-color:var(--border);}
  .filter-group .input-group-text i{color:var(--muted)}

  .eq-grid .eq-card{position:relative;border:1px solid var(--border);border-radius:14px;overflow:hidden;background:var(--surface);transition:transform .15s ease, box-shadow .15s ease}
  .eq-grid .eq-card:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.06)}
  .eq-card .thumb{  width:100%;  aspect-ratio:16/9;  object-fit:contain;  background:#fff;  padding:8px;}
  .eq-card .body{padding:.9rem .9rem 1rem}
  .eq-card .title{font-weight:600;margin-bottom:.35rem;color:var(--text)}
  .eq-card .meta{font-size:.82rem;color:var(--muted)}
  .badge-ok{background:#ecfdf5;color:#059669}
  .badge-rent{background:#fff7e6;color:#d97706}
  .badge-repair{background:#fff1f2;color:#e11d48}
  .eq-actions .btn{border-radius:10px}

  .repair-overlay{position:absolute;inset:0;background:rgba(0,0,0,.78);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;letter-spacing:.05em}

  .equip-mini{display:flex;gap:.65rem;align-items:center;border:1px solid var(--border);border-radius:12px;padding:.55rem .65rem;background:var(--surface)}
  .equip-mini img{width:48px;height:48px;object-fit:cover;border-radius:10px;background:var(--surface-2)}
  .equip-mini .name{font-weight:600}
  .modal-footer .btn{border-radius:10px}
</style>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid">

<div class="body-wrapper">
  <div class="container">
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">장비 창고</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
                <li class="breadcrumb-item" aria-current="page">Facilities</li>
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
              <div class="fs-4 fw-bold text-primary"><c:out value="${equipTotalCount}" default="0"/>개</div>
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
              <div class="fs-4 fw-bold text-warning"><c:out value="${rentCount}" default="0"/>개</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-sm-6 col-lg-3">
          <div class="stat-tile tile-amber">
            <span class="icon bg-white"><i class="ti ti-alert-triangle text-warning"></i></span>
            <div><small class="d-block text-warning fw-semibold">재고부족</small>
              <div class="fs-4 fw-bold text-warning"><c:out value="${repairCount}" default="0"/>개</div>
            </div>
          </div>
        </div>
      </div>




     <!-- 검색 + 상태 필터 (왼쪽=분류, 가운데=공백, 오른쪽=검색/추가) -->
<div class="row align-items-center pb-3">
  <!-- 왼쪽: 상태 필터 (내용만큼) -->
  <div class="col-auto">
    <div class="btn-group" role="group">
       <a href="${pageContext.request.contextPath}/equip/eqlist?statusFilter=&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${empty statusFilter}'>active</c:if>">전체</a>
          <a href="${pageContext.request.contextPath}/equip/eqlist?statusFilter=normal&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "normal"}'>active</c:if>">정상</a>
          <a href="${pageContext.request.contextPath}/equip/eqlist?statusFilter=rent&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "rent"}'>active</c:if>">대여중</a>
          <a href="${pageContext.request.contextPath}/equip/eqlist?statusFilter=repair&searchWord=${param.searchWord}"
             class="btn btn-outline-primary <c:if test='${statusFilter eq "repair"}'>active</c:if>">고장</a>
    </div>
  </div>

  <!-- 가운데: 유연한 공간 -->
  <div class="col"></div>

  <!-- 오른쪽: 검색 + 자재추가 (내용만큼) -->
  <div class="col-md-6"></div>
    	<div class="col-md-3">
    		<form id="searchForm"
		        action="${pageContext.request.contextPath}/equip/eqlist"
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

    <div class="row gy-3 gx-3 eq-grid">
      <c:forEach var="equip" items="${equipList}">
        <div class="col-12 col-md-6 col-xl-3">
          <div class="eq-card">
            <c:if test="${equip.eqpmnSttus eq '13003'}">
              <div class="repair-overlay">고장</div>
            </c:if>
            <img class="thumb" src="<c:out value='${equip.filePath }'/>" alt="장비이미지">
            <div class="body">
              <div class="d-flex align-items-center justify-content-between">
                <div class="title"><c:out value='${equip.eqpmnNm} (${equip.eqpmnDc})' /></div>
                <c:choose>
                  <c:when test='${equip.eqpmnSttus eq "13001"}'><span class="badge badge-ok rounded-pill px-2 py-1">${equip.eqpmnSttusNm}</span></c:when>
                  <c:when test='${equip.eqpmnSttus eq "13002"}'><span class="badge badge-rent rounded-pill px-2 py-1">${equip.eqpmnSttusNm}</span></c:when>
                  <c:otherwise><span class="badge badge-repair rounded-pill px-2 py-1">${equip.eqpmnSttusNm}</span></c:otherwise>
                </c:choose>
              </div>
              <div class="meta mb-2">장비등록일: <c:out value='${equip.eqpmnRegYmd}'/></div>

              <div class="d-flex eq-actions gap-2">
                <c:choose>
                  <%-- 정상 -> 대여 버튼 --%>
                  <c:when test='${equip.eqpmnSttus eq "13001"}'>
                    <button type="button"
                            class="btn btn-sm btn-outline-secondary flex-fill btn-rent"
                            data-id="${equip.eqpmnNo}"
                            data-name="${equip.eqpmnNm}"
                            data-status="${equip.eqpmnSttusNm}"
                            data-thumb="${equip.filePath}"
                            data-bs-toggle="modal"
                            data-bs-target="#rentModal">
                      <i class="ti ti-lock-open me-1"></i>대여
                    </button>
                  </c:when>

                  <c:when test='${equip.eqpmnSttus eq "13002"}'>
                    <c:choose>
                      <%-- ★ 로그인 사번으로 대여자만 반납 가능 --%>
                      <c:when test='${loginEmpNo eq equip.empNo}'>
                        <button type="button"
                                class="btn btn-sm btn-dark flex-fill btn-return"
                                data-id="${equip.eqpmnNo}"
                                data-name="${equip.eqpmnNm}"
                                data-status="${equip.eqpmnSttusNm}"
                                data-thumb="${equip.filePath}"
                                data-due="<c:out value='${equip.resveEndDt}'/>"
                                data-bs-toggle="modal"
                                data-bs-target="#returnModal">
                          반납
                        </button>
                      </c:when>
                      <c:otherwise>
                        <button type="button" class="btn btn-sm btn-outline-secondary flex-fill" disabled
                                title="대여자 본인만 반납 가능합니다.">반납 불가</button>
                      </c:otherwise>
                    </c:choose>
                  </c:when>

                  <%-- 고장 --%>
                  <c:otherwise>
                    <button type="button" class="btn btn-sm btn-outline-secondary flex-fill" disabled>수리 중</button>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty equipList}">
        <div class="col-12">
          <div class="text-center text-muted py-5">표시할 장비가 없습니다.</div>
        </div>
      </c:if>
    </div>

    <div class="flex-grow-1 d-flex justify-content-center mb-2">
      <nav aria-label="Page navigation" class="m-4">
        <ul class="pagination justify-content-center mb-0">
          ${pagingVO.pagingHTML2}
        </ul>
      </nav>
    </div>

    <form id="pageForm" action="${pageContext.request.contextPath}/equip/eqlist" method="get">
      <input type="hidden" name="page" id="page">
      <input type="hidden" name="searchWord" value="${searchWord}">
      <input type="hidden" name="statusFilter" value="${statusFilter}">
    </form>

  </div>
</div>
  </div>
</div>

<!-- 대여 모달 -->
<div class="modal fade" id="rentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">장비 대여</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body pt-0">
        <div class="equip-mini mb-3">
          <img id="rentThumb" src="" alt="">
          <div>
            <div class="name" id="rentName">장비명</div>
            <small class="text-muted">현재 상태: <span id="rentStatus">-</span></small>
          </div>
        </div>

        <form id="rentForm" action="${pageContext.request.contextPath}/equip/rent" method="post">
          <input type="hidden" name="eqpmnNo" id="rentEquipId">
          <!-- ★ 로그인 사번 주입 -->
          <input type="hidden" name="empNo" value="${loginEmpNo}">
          <div class="mb-3">
            <label class="form-label">현장명 <span class="text-danger">*</span></label>
            <input type="text" class="form-control" name="sptNm" placeholder="현장명을 입력하세요" required>
          </div>
          <div class="mb-3">
            <label class="form-label">대여 시작일 <span class="text-danger">*</span></label>
            <input type="date" class="form-control" name="resveStartDt" id="rentStartDt" required>
          </div>
          <div class="mb-3">
            <label class="form-label">반납 예정일 <span class="text-danger">*</span></label>
            <input type="date" class="form-control" name="resveEndDt" id="rentEndDt" required>
          </div>
          <div class="mb-1">
            <label class="form-label">메모 (선택)</label>
            <textarea class="form-control" name="memo" rows="3" placeholder="대여 관련 메모를 입력해주세요..."></textarea>
          </div>
        </form>
      </div>

      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-secondary" id="rentDummyBtn">더미입력</button>
        <button type="button" class="btn btn-dark" id="rentSubmitBtn">대여 확인</button>
      </div>
    </div>
  </div>
</div>

<!-- 반납 모달 -->
<div class="modal fade" id="returnModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:560px">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold">장비 반납</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body pt-0">
        <div class="equip-mini mb-3">
          <img id="returnThumb" src="" alt="">
          <div>
            <div class="name" id="returnName">장비명</div>
            <small class="text-muted">현재 상태: <span id="returnStatus">-</span></small><br/>
            <small class="text-muted">반납 예정일: <span id="returnDue">-</span></small>
          </div>
        </div>

        <!-- 서버로 전송되는 반납 폼 -->
        <form id="returnForm" action="${pageContext.request.contextPath}/equip/return" method="post">
          <input type="hidden" name="equipId" id="returnEquipId">
          <div class="mb-3">
            <label class="form-label">장비 상태 <span class="text-danger">*</span></label>
            <select class="form-select" name="returnCondition" required>
              <option value="정상">정상</option>
              <option value="고장">고장</option>
            </select>
          </div>
          <div class="mb-1">
            <label class="form-label">메모 (선택)</label>
            <textarea class="form-control" name="returnMemo" rows="3" placeholder="반납 관련 메모를 입력해주세요..."></textarea>
          </div>
        </form>
      </div>

      <div class="modal-footer border-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-dark" id="returnSubmitBtn">반납 확인</button>
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script>
$(function(){
	//===== 대여 모달 - 더미데이터 채우기 (위임 바인딩) =====
	$(document).on('click', '#rentDummyBtn', function(){
	  let pad = n => String(n).padStart(2, '0');
	  let fmt = function(d){
	    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate());
	  };

	  let $form  = $('#rentForm');
	  let $start = $('#rentStartDt');
	  let $end   = $('#rentEndDt');

	  let today = new Date();
	  let in7   = new Date(today);
	  in7.setDate(today.getDate() + 7);

	  // 값 채우기
	  $form.find('input[name="sptNm"]').val('테스트현장 A');
	  $start.val(fmt(today)).trigger('change'); // min 갱신 로직과 연동
	  $end.val(fmt(in7));
	  $form.find('textarea[name="memo"]').val('테스트 대여 건입니다.');
	});

	
  // ===== 페이징 =====
  window.fn_pagination = function(pageNo){
    $("#page").val(pageNo);
    $("#pageForm").submit();
  };

  // ===== 대여 모달 바인딩 =====
  $(document).on("click", ".btn-rent", function(){
    let rentEquipId = $("#rentEquipId");
    let rentName = $("#rentName");
    let rentStatus = $("#rentStatus");
    let rentThumb = $("#rentThumb");

    rentEquipId.val($(this).data("id"));
    rentName.text($(this).data("name") || "");
    rentStatus.text($(this).data("status") || "");
    rentThumb.attr("src", $(this).data("thumb") || "");

    const pad = n => String(n).padStart(2, "0");
    const now = new Date();
    const yyyy = now.getFullYear();
    const MM = pad(now.getMonth() + 1);
    const dd = pad(now.getDate());
    const today = `${yyyy}-${MM}-${dd}`;

    const $start = $("#rentStartDt");
    const $end   = $("#rentEndDt");
    if (!$start.val()) $start.val(today);
    $start.attr("min", today);
    $end.attr("min", $start.val());

    $start.off("change._rent").on("change._rent", function(){
      const v = $(this).val();
      $end.attr("min", v);
      if ($end.val() && $end.val() < v) $end.val(v);
    });
  });

  // ===== 반납 모달 바인딩 =====
  $(document).on("click", ".btn-return", function(){
    let returnEquipId = $("#returnEquipId");
    let returnName = $("#returnName");
    let returnStatus = $("#returnStatus");
    let returnThumb = $("#returnThumb");
    let returnDue = $("#returnDue");

    returnEquipId.val($(this).data("id"));
    returnName.text($(this).data("name") || "");
    returnStatus.text($(this).data("status") || "");
    returnThumb.attr("src", $(this).data("thumb") || "");
    returnDue.text($(this).data("due") || "-");
  });

  // ===== 대여/반납 로직 =====
  $("#rentSubmitBtn").on("click", function(){
    const rentForm = $("#rentForm")[0];
    if (rentForm.checkValidity()) {
      rentForm.submit();
      bootstrap.Modal.getInstance(document.getElementById("rentModal")).hide();
    } else {
      rentForm.reportValidity();
    }
  });

  $("#returnSubmitBtn").on("click", function(){
    const returnForm = $("#returnForm")[0];
    if (returnForm.checkValidity()) {
      returnForm.submit();
      bootstrap.Modal.getInstance(document.getElementById("returnModal")).hide();
    } else {
      returnForm.reportValidity();
    }
  });
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
</body>
</html>
