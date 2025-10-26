<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <!-- Required meta tags -->
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
  <%@ include file="/module/header.jsp" %>
<style>
  .table-sm td, .table-sm th {
    font-size: 0.85rem;
    padding: 0.4rem 0.5rem;
    white-space: nowrap;
  }

  td:nth-child(3), th:nth-child(3),
  td:nth-child(5), th:nth-child(5) {
    max-width: 180px;
    overflow: hidden;
    text-overflow: ellipsis;
  }
</style>
<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 
      
<div class="body-wrapper">
  <div class="container">

    <!-- 상단 헤더 (등록하기 버튼 오른쪽 정렬) -->
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3 d-flex justify-content-between align-items-center">
        <div>
          <h4 class="fw-semibold mb-0">인사관리</h4>
          <nav aria-label="breadcrumb" class="mt-1">
            <ol class="breadcrumb mb-0">
              <li class="breadcrumb-item">
                <a class="text-muted text-decoration-none" href="/main/index">Home</a>
              </li>
              <li class="breadcrumb-item" aria-current="page">Hr</li>
            </ol>
          </nav>
        </div>
      </div>
    </div>

    <!-- 검색영역 -->
<form name="searchForm" method="get" class="mb-3">
  <input type="hidden" name="page" value="" id="page">
  <!-- ✅ 탭 상태 유지용 -->
  <input type="hidden" name="status" id="status" value="${empty param.status ? 'active' : param.status}">

  <div class="d-flex flex-wrap gap-2 align-items-end">
    <div class="col-md-6 col-lg-5">
      <input type="text" id="searchWord" name="searchWord" value="${fn:escapeXml(param.searchWord)}"
             class="form-control" placeholder="이름으로검색">
    </div>
    <div class="col-md-2 col-lg-1">
      <button id="searchBtn" class="btn btn-outline-secondary w-100" type="button">검색하기</button>
    </div>

    <!-- 오른쪽 끝: 등록 -->
    <div class="ms-auto">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal"
              data-bs-target="#emp-register-modal" onclick="openCreate()">
        등록하기
      </button>
    </div>
  </div>

  <!-- ✅ 재직/퇴사/전체 탭 -->
  <ul class="nav nav-tabs mt-3" role="tablist" id="hrTabs">
    <li class="nav-item" role="presentation">
      <button type="button" class="nav-link ${empty param.status or param.status eq 'active' ? 'active' : ''}"
              data-status="active" role="tab">
        재직

      </button>
    </li>
    <li class="nav-item" role="presentation">
      <button type="button" class="nav-link ${param.status eq 'resigned' ? 'active' : ''}"
              data-status="resigned" role="tab">
        퇴사

      </button>
    </li>
    <li class="nav-item" role="presentation">
      <button type="button" class="nav-link ${param.status eq 'all' ? 'active' : ''}"
              data-status="all" role="tab">
        전체
      </button>
    </li>
  </ul>
</form>
      
   
    </div>
<div class="container my-4">
  <div class="table-responsive">
    <table class="table table-bordered table-striped table-hover align-middle text-nowrap bg-white">
      <thead class="table-light">
        <tr>
          <th>이름</th>
          <th>생년월일</th>
          <th>EMAIL</th>
          <th>휴대전화</th>
          <th>주소</th>
          <th>부서</th>
          <th>직급</th>
          <th>입사일</th>
          <th>은행</th>
          <th>예금주</th>
          <th>계좌번호</th>
          <th>관리</th>
        </tr>
      </thead>
<tbody>
  <c:forEach items="${pagingVO.dataList}" var="list">
    <tr class="${list.enabled == 0 ? 'table-secondary' : ''}">
      <td>${list.empNm}</td>
      <td>${list.brdt}</td>
      <td>${list.email}</td>
      <td>${list.telno}</td>
      <td>${list.homeAddr} ${list.homeDaddr}</td>
      <td>${list.deptNm}</td>
      <td>${list.jbgdCd}</td>
      <td>${list.jncmpYmd}</td>
      <td>${bankNm}</td>
      <td>${list.dpstrNm}</td>
      <td>${list.actno}</td>
      <td class="text-nowrap">
        <div class="btn-group">
          <button class="btn btn-sm btn-outline-primary" onclick="openEdit('${list.empNo}')" type="button">수정</button>
          <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle dropdown-toggle-split"
                  data-bs-toggle="dropdown" aria-expanded="false">
            <span class="visually-hidden">Toggle</span>
          </button>
          <ul class="dropdown-menu dropdown-menu-end">
            <li>
              <button type="button" class="dropdown-item text-danger btn-leave"
                      data-emp-no="${list.empNo}" data-emp-nm="${list.empNm}">
                <i class="ti ti-user-minus me-2"></i>퇴사 처리…
              </button>
            </li>
            <c:if test="${list.enabled == 0}">
              <li><hr class="dropdown-divider"/></li>
              <li>
                <button type="button" class="dropdown-item btn-reactivate"
                        data-emp-no="${list.empNo}">
                  <i class="ti ti-user-check me-2"></i>재직 전환
                </button>
              </li>
            </c:if>
          </ul>
        </div>
      </td>
    </tr>
  </c:forEach>
</tbody>
    </table>
  </div>
</div>
<nav class="d-flex justify-content-center" aria-label="..." id="pagingArea">
	${pagingVO.pagingHTML }
<!--     <ul class="pagination">
        <li class="page-item disabled">
            <a class="page-link" href="javascript:void(0)" tabindex="-1" aria-disabled="true">Previous</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="javascript:void(0)">1</a>
        </li>
        <li class="page-item active" aria-current="page">
            <a class="page-link" href="javascript:void(0)">2</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="javascript:void(0)">3</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="javascript:void(0)">Next</a>
        </li>
    </ul> -->
</nav>

<!-- 직원 등록/수정 모달 (필수만) -->
<div id="emp-register-modal" class="modal fade" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-lg">
    <div class="modal-content">
      <div class="modal-body">
        <form class="ps-3 pr-3" id="refrm" name="refrm" enctype="multipart/form-data">
          <!-- 모드/사번 -->
          <input type="hidden" id="mode" name="mode" value="create">
          <input type="hidden" id="empNo" name="empNo">

          <!-- 제목/닫기 -->
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 id="empModalTitle" class="mb-0">직원 등록</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>

          <!-- 프로필 이미지 -->
<div class="mb-3">
  <label for="profileImage" class="form-label">프로필 이미지</label>
  <input class="form-control" type="file" id="profileImage" name="profileImage" accept="image/*">
  <img id="profilePreview" class="img-thumbnail mt-2" style="max-height:120px; display:none;" alt="프로필 미리보기">
</div>

          <!-- 이름 / 생년월일 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="empNm">이름</label>
              <input class="form-control" type="text" id="empNm" name="empNm" required placeholder="홍길동">
            </div>
            <div class="col-md-6 mb-3">
              <label for="brdt">생년월일</label>
              <input class="form-control" type="date" id="brdt" name="brdt" required>
            </div>
          </div>

          <!-- 이메일(개인) / 사내이메일 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="email">이메일</label>
              <input class="form-control" type="email" id="email" name="email" required placeholder="user@example.com">
            </div>
            <div class="col-md-6 mb-3">
              <label for="wnmpyEmail">사내 이메일</label>
              <input class="form-control" type="text" id="wnmpyEmail" name="wnmpyEmail" readonly="readonly" placeholder="name@company.com">
            </div>
          </div>

          <!-- 휴대전화 / 내선번호 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="telno">휴대전화</label>
              <input class="form-control" type="text" id="telno" name="telno" maxlength="11" placeholder="01012345678" required>
            </div>
            <div class="col-md-6 mb-3">
				<label for="empExtNo">내선번호</label>
				<input class="form-control" type="text" id="empExtNo" name="empExtNo" maxlength="10" placeholder="342" required>

            </div>
          </div>

          <!-- 주소 -->
<div class="row g-2">
  <div class="col-md-5">
    <label for="empZip">우편번호</label>
    <div class="input-group">
      <input class="form-control clickable" type="text" id="empZip" name="empZip"
             readonly placeholder="우편번호" required>
      <button type="button" onclick="DaumPostcode()" class="btn btn-secondary">우편번호 찾기</button>
    </div>
  </div>
  <div class="col-md-7">
    <label for="homeAddr">주소</label>
    <input class="form-control clickable" type="text" id="homeAddr" name="homeAddr"
           readonly placeholder="주소" required>
  </div>
</div>
<div class="mb-3">
  <input class="form-control mt-2" type="text" id="homeDaddr" name="homeDaddr" placeholder="상세주소" required>
</div>

          <!-- 부서 / 직급 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="deptNo">부서</label>
              <select class="form-select" id="deptNo" name="deptNo" required>
                <option value="">부서를 선택해주세요.</option>
                <c:forEach items="${dept}" var="deptList">
                  <option value="${deptList.deptNo}">${deptList.deptNm}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="jbgdCd">직급</label>
              <select class="form-select" id="jbgdCd" name="jbgdCd" required>
                <option value="">직급을 선택해주세요</option>
                <option value="15002">팀장</option>
                <option value="15006">대리</option>
                <option value="15003">주임</option>
                <option value="15004">사원</option>
              </select>
            </div>
          </div>

          <!-- 입사일 -->
          <div class="mb-3">
            <label for="jncmpYmd">입사일</label>
            <input class="form-control" type="date" id="jncmpYmd" name="jncmpYmd" required>
          </div>

<!-- 은행코드/예금주/계좌 -->
<div class="row">
  <div class="col-md-3 mb-3"> <!-- 은행: 줄이기 -->
    <label for="bankCode">은행</label>
    <select class="form-select" id="bankCode" name="bankCd" required>
      <option value="">은행을 선택해주세요.</option>
      <option value="004">KB국민은행</option>
      <option value="088">신한은행</option>
      <option value="081">하나은행</option>
      <option value="020">우리은행</option>
      <option value="011">NH농협은행</option>
      <option value="090">카카오뱅크</option>
      <option value="092">토스뱅크</option>
    </select>
    <input type="hidden" id="bank" name="bank">
  </div>

  <div class="col-md-5 mb-3"> <!-- 예금주: 키우기 -->
    <label for="dpstrNm">예금주</label>
    <input class="form-control" type="text" id="dpstrNm" name="dpstrNm" required>
  </div>

  <div class="col-md-4 mb-3">
    <label for="actno">계좌번호</label>
    <input class="form-control" type="text" id="actno" name="actno"
           maxlength="20" inputmode="numeric" pattern="\d*" required>
  </div>
</div>

          <!-- 연봉 / 활성여부 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="salary">연봉</label>
              <input class="form-control" type="number" id="salary" name="salary" min="0" step="1000000" required>
            </div>
          </div>

          <!-- 버튼 -->
          <div class="d-flex justify-content-between mt-4">
            <button class="btn btn-danger" type="button" data-bs-dismiss="modal">취소</button>
  <div class="d-flex gap-2">
    <button class="btn btn-outline-secondary" type="button" id="btnAutofill">자동입력(시연)</button>
    <button class="btn btn-primary" type="button" id="sbt">저장</button>
  </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>



<!-- 직원 퇴사 처리 모달 -->
<div id="emp-leave-modal" class="modal fade" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form id="leaveForm" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="ti ti-user-minus me-2"></i>퇴사 처리</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <div class="alert alert-warning small mb-3">
          <b id="leaveEmpName" class="text-dark"></b> 님을 <b>비활성화(퇴사)</b>합니다. 접근이 중단됩니다.
        </div>

        <input type="hidden" id="leaveEmpNo" name="empNo">

        <div class="mb-3">
          <label class="form-label">퇴사일 <span class="text-danger">*</span></label>
          <input type="date" class="form-control" id="leaveDate" name="leaveDate" required>
        </div>

        <div class="mb-3">
          <label class="form-label">사유 <span class="text-danger">*</span></label>
          <select class="form-select" id="leaveReason" name="reason" required>
            <option value="">선택하세요</option>
            <option value="voluntary">자진퇴사</option>
            <option value="involuntary">회사사정</option>
            <option value="retirement">정년</option>
            <option value="etc">기타</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label">비고/메모</label>
          <textarea class="form-control" id="leaveMemo" name="memo" rows="3" placeholder="정산/자산반납/인수인계 메모 등"></textarea>
        </div>

        <div class="form-check mb-3">
          <input class="form-check-input" type="checkbox" id="leaveDisableAccounts" name="disableAccounts" checked>
          <label class="form-check-label" for="leaveDisableAccounts">
            그룹웨어/메일/메신저 계정 비활성화 동시 처리
          </label>
        </div>

        <div class="mb-1">
          <label class="form-label">확인을 위해 이름을 입력하세요 <span class="text-danger">*</span></label>
          <input type="text" class="form-control" id="leaveConfirmName" placeholder="">
          <div class="form-text">정확히 입력 시 버튼이 활성화됩니다.</div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="submit" class="btn btn-danger" id="leaveSubmitBtn" disabled>
          <i class="ti ti-user-minus me-1"></i>퇴사 처리
        </button>
      </div>
    </form>
  </div>
</div>


<%@ include file="/module/footerPart.jsp" %>
<!-- 다음 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath }/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
<script>


//전역: 등록 모드 초기화(폼 전체 리셋)
function resetEmpFormToCreate() {
  var form = document.querySelector('#refrm');
  if (!form) return;

  form.reset();                           // 브라우저 기본 리셋
  var mode = document.querySelector('#mode');
  var empNo = document.querySelector('#empNo');
  if (mode) mode.value = 'create';
  if (empNo) empNo.value = '';

  // 제목/버튼문구
  var title = document.querySelector('#empModalTitle');
  var saveBtn = document.querySelector('#sbt');
  if (title)  title.textContent = '직원 등록';
  if (saveBtn) saveBtn.textContent = '저장';

  // 셀렉트는 첫 옵션으로
  form.querySelectorAll('select').forEach(function(sel){ sel.selectedIndex = 0; });

  // 파일/미리보기 클리어
  var fileInput = document.querySelector('#profileImage');
  if (fileInput) fileInput.value = '';
  var preview = document.querySelector('#profilePreview');
  if (preview) { preview.removeAttribute('src'); preview.style.display = 'none'; }

  // 은행 hidden 값도 비우기
  var bankHidden = document.querySelector('#bank');
  if (bankHidden) bankHidden.value = '';
}

// 등록 버튼에서 호출
function openCreate() {
  resetEmpFormToCreate();
}

// 모달 show/hidden 시에도 안전장치
document.addEventListener('DOMContentLoaded', function () {
  var modalEl = document.querySelector('#emp-register-modal');
  if (!modalEl) return;

  // 열릴 때: edit가 아닌 경우는 무조건 등록모드 초기화
  modalEl.addEventListener('show.bs.modal', function () {
    var mode = document.querySelector('#mode')?.value;
    if (mode !== 'edit') resetEmpFormToCreate();
  });

  // 닫힐 때: 다음에 열릴 때 잔상이 남지 않도록 항상 초기화
  modalEl.addEventListener('hidden.bs.modal', function () {
    resetEmpFormToCreate();
  });
});

// ✅ 전역 Daum 주소 함수 (openEdit 내부에 두지 말고, 이 전역 버전만 유지)
function DaumPostcode() {
  if (!window.daum || !window.daum.Postcode) {
    alert('주소 검색 스크립트가 아직 로드되지 않았어요.');
    return;
  }
  new daum.Postcode({
    oncomplete: function (data) {
      var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
      var zipEl   = document.querySelector('#empZip');
      var addrEl  = document.querySelector('#homeAddr');
      var daddrEl = document.querySelector('#homeDaddr');
      if (zipEl)  zipEl.value  = data.zonecode || '';
      if (addrEl) addrEl.value = addr || '';
      if (daddrEl) daddrEl.focus();
    }
  }).open();
}


(function () {
	  var formEl       = document.querySelector('#refrm');
	  var saveBtn      = document.querySelector('#sbt');
	  var modeInput    = document.querySelector('#mode');
	  var profileInput = document.querySelector('#profileImage');
	  var bankSel      = document.querySelector('#bankCode');
	  var bankHidden   = document.querySelector('#bank');
	  let pagingArea = document.querySelector("#pagingArea");

	  if (profileInput) {
		  profileInput.addEventListener('change', function () {
		    var preview = document.querySelector('#profilePreview');
		    if (!preview) return;

		    var file = this.files && this.files[0];
		    if (!file) {                       // 선택 취소 등
		      preview.removeAttribute('src');
		      preview.style.display = 'none';
		      return;
		    }

		    if (!/^image\//.test(file.type)) { // 이미지 아닌 경우 방어
		      alert('이미지 파일만 업로드할 수 있습니다.');
		      this.value = '';
		      preview.removeAttribute('src');
		      preview.style.display = 'none';
		      return;
		    }

		    var url = URL.createObjectURL(file);
		    preview.src = url;
		    preview.style.display = 'block';
		    preview.onload = function () { URL.revokeObjectURL(url); }; // 메모리 정리
		  });
		}	  
	  
	  function toYYYYMMDD(v) { return v ? String(v).replace(/-/g, '') : ''; }

	  var actno = document.querySelector('#actno');
	  if (actno) {
	    actno.addEventListener('input', function () {
	      this.value = this.value.replace(/\D/g, ''); // 숫자만 남기기
	    });
	  }
	  
	  ['empZip','homeAddr'].forEach(function(id){
		    var el = document.getElementById(id);
		    if (!el) return;
		    el.addEventListener('click', function (e) {
		      e.preventDefault();
		      if (typeof DaumPostcode === 'function') DaumPostcode();
		    });
		    el.addEventListener('keydown', function (e) {
		      if (e.key === 'Enter' || e.key === ' ') {
		        e.preventDefault();
		        if (typeof DaumPostcode === 'function') DaumPostcode();
		      }
		    });
		  });
	  
	  pagingArea.addEventListener("click", function(event) {
	    if (event.target.tagName.toLowerCase() === "a") {
	      event.preventDefault();
	      const pageNo = event.target.dataset.page;
	      if(pageNo == null){ return false; }
	      document.querySelector("#page").value = pageNo;
	      document.searchForm.submit();
	    }
	  });
	  
	  if (!saveBtn) {
	    console.warn('#sbt 버튼을 찾지 못했습니다. id 확인하세요.');
	    return;
	  }

	  saveBtn.addEventListener('click', function (e) {
	    e.preventDefault();
	    
	    // 기본 유효성
	    if (!formEl || !formEl.reportValidity || !formEl.reportValidity()) return;

	    // FormData 구성
	    var fd = new FormData(formEl);

	    // 날짜를 yyyymmdd로 변환
	    fd.set('brdt',     toYYYYMMDD(fd.get('brdt')));
	    fd.set('jncmpYmd', toYYYYMMDD(fd.get('jncmpYmd')));

	 // ✅ 여기 추가: empExtNo를 extNo로 치환해서 백엔드로 보냄
	    fd.set('extNo', fd.get('empExtNo') || '');
	    fd.delete('empExtNo'); // 선택: 서버에 불필요한 필드 안 보낼 거면 삭제
	    
	    // 은행명(hidden) 동기화
	    if (bankSel && bankHidden) {
	      var opt = bankSel.options[bankSel.selectedIndex];
	      bankHidden.value = opt ? opt.text : '';
	    }

	    // 파일 미선택 시 업로드 제외
	    if (!profileInput || !profileInput.files || profileInput.files.length === 0) {
	      fd.delete('profileImage');
	    }

	    // 수정/등록 분기
	    var mode = (modeInput && modeInput.value ? modeInput.value : 'create').toLowerCase();
	    var url  = (mode === 'edit') ? '/hr/hrupdate' : '/hr/hrinsert';

	    // (디버그) 전송 전에 확인하고 싶으면 주석 해제
	    // for (const [k, v] of fd.entries()) console.log('FD:', k, v);
		fd.set('empNo', document.querySelector('#empNo')?.value || '');
		
	    // 전송
	    fetch(url, { method: 'POST', body: fd })
	      .then(function (res) {
	        if (!res.ok) throw new Error('저장 실패 (' + res.status + ')');
	        return res.json();
	      })
	      .then(function (data) {
	        // 모달 닫기 (BS5/BS4 호환)
	        var modalNode = document.querySelector('#emp-register-modal');
	        if (window.bootstrap && window.bootstrap.Modal) {
	          (window.bootstrap.Modal.getInstance(modalNode) || new window.bootstrap.Modal(modalNode)).hide();
	        } else if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) {
	          window.jQuery(modalNode).modal('hide');
	        }
	        // 새로고침
	        if(data.trim() === "OK"){
	              Swal.fire({
	                  title:'완료됐습니다.',
	                  icon: 'success',
	                  scrollbarPadding: false,
	                  heightAuto: false                        
	                }).then(function (result) {
                	  if (result.isConfirmed) {
                		    window.location.reload(); // 또는 window.location.href = window.location.href;
                		  }
               		});
	        }
	        //location.reload();
	      })
	      .catch(function (err) {
	        alert(err.message);
	        console.error(err);
	      });
	  });
	})();

// === 모달 열기 (BS5/BS4 호환) ===
function showEmpModal() {
  var modalNode = document.querySelector('#emp-register-modal');
  if (!modalNode) return;
  if (window.bootstrap && window.bootstrap.Modal) {
    (window.bootstrap.Modal.getInstance(modalNode) || new window.bootstrap.Modal(modalNode)).show();
  } else if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) {
    window.jQuery(modalNode).modal('show');
  }
}

// 'yyyyMMdd' -> 'yyyy-MM-dd' (input[type=date] 표기용)
function fmtDateForInput(raw) {
  return (raw && raw.indexOf('-') > -1) ? raw :
         (raw ? raw.replace(/^(\d{4})(\d{2})(\d{2})$/, '$1-$2-$3') : '');
}

function setSelectByCode(selector, code, padLen) {
	  var sel = document.querySelector(selector);
	  if (!sel) return;

	  // 코드가 없으면 비우고 종료
	  if (code == null || code === '') { sel.value = ''; return; }

	  var str = String(code).trim();

	  // padLen이 지정되고 숫자면 앞자리 0 채움 (예: 4 -> "004")
	  if (padLen && /^\d+$/.test(str)) {
	    str = str.padStart(padLen, '0');
	  }

	  sel.value = str;

	  // 혹시 일치 옵션이 없으면 콘솔 경고 (값 확인용)
	  if (sel.value !== str) {
	    console.warn('옵션을 찾을 수 없습니다:', selector, '코드=', str);
	  }
	}


// 필드 값 세터(빈값 안전)
function setVal(selector, value) {
  var node = document.querySelector(selector);
  if (node) node.value = (value != null ? value : '');
}

// ====== 수정모드 오픈 (fetch 사용) ======
window.openEdit = function(empNo) {
  if (!empNo) { alert('empNo 없음'); return; }

  // 모달 먼저 열기 → 안열림 이슈 방지

  // 기본 UI 상태 전환
  setVal('#mode', 'edit');
  var titleNode = document.querySelector('#empModalTitle');
  var saveBtn   = document.querySelector('#sbt');
  if (titleNode) titleNode.textContent = '직원 수정';
  if (saveBtn)   saveBtn.textContent   = '수정';
  setVal('#empNo', empNo);

  showEmpModal();
  // 상세조회
  fetch('/hr/hrmodify?empNo=' + encodeURIComponent(empNo), { headers: { 'Accept': 'application/json' } })
    .then(function(resp){
      if (!resp.ok) throw new Error('상세 조회 실패 (' + resp.status + ')');
      return resp.text();
    })
    .then(function(respText){
      try {
        var respJson = JSON.parse(respText || '{}');
        return respJson;
      } catch (e) {
        console.warn('JSON 파싱 실패, 응답 미리보기:', (respText || '').slice(0, 200));
        throw new Error('JSON 형식이 아님(세션만료/권한 문제 가능)');
      }
    })
    .then(function(detail){
      // 기본 인풋
      setVal('#empNm',      detail.empNm);
      setVal('#brdt',       fmtDateForInput(detail.brdt));
      setVal('#email',      detail.email);
      setVal('#wnmpyEmail', detail.wnmpyEmail);
      setVal('#telno',      detail.telno);
      setVal('#empExtNo',   detail.extNo);
      setVal('#empZip',     detail.empZip);
      setVal('#homeAddr',   detail.homeAddr);
      setVal('#homeDaddr',  detail.homeDaddr);
      setVal('#jncmpYmd',   fmtDateForInput(detail.jncmpYmd));
      setVal('#dpstrNm',    detail.dpstrNm);
      setVal('#actno',      detail.actno);
      setVal('#salary',     (detail.salary != null ? detail.salary : ''));

      // 부서/직급/은행: 느슨 선택 (코드 없으면 명칭으로도 매칭)
   	  // 부서(숫자 코드) - 패딩 필요 없음
   	  console.log(detail)
      setSelectByCode('#deptNo',  detail.deptNo);

      // 직급(예: "15002") - 문자열 코드 그대로
      setSelectByCode('#jbgdCd',  detail.jbgdCd);

      // 은행(예: "004", "088") - 3자리로 패딩 필요할 수 있음
      setSelectByCode('#bankCode', detail.bankCd || detail.bankCode, 3);


      // 은행명 hidden 동기화
      var bankSel    = document.querySelector('#bankCode');
      var bankHidden = document.querySelector('#bank');
      if (bankSel && bankHidden) {
        var currentOpt = bankSel.options[bankSel.selectedIndex];
        bankHidden.value = currentOpt ? currentOpt.text : (detail.bank || detail.bankNm || '');
      }

      // 프로필 미리보기
      var previewImg = document.querySelector('#profilePreview');
      if (previewImg) {
        if (detail.profileImageUrl) {
          previewImg.src = detail.profileImageUrl;
          previewImg.style.display = 'block';
        } else {
          previewImg.style.display = 'none';
          previewImg.removeAttribute('src');
        }
      }

      // 디버그(필요 없으면 삭제 가능)
      console.log('[hrmodify 응답]', detail);
      console.log('서버 deptNo=', detail.deptNo, ', deptNm=', detail.deptNm, ' / 선택된 deptNo=', document.querySelector('#deptNo')?.value);
    })
    .catch(function(err){
      alert(err.message);
      console.error(err);
    });
  
};


document.addEventListener('click', function(e) {
	  const btn = e.target.closest('.btn-leave');
	  if (!btn) return;

	  const empNo = btn.dataset.empNo;
	  const empNm = btn.dataset.empNm;

	  // 모달 필드 세팅
	  document.getElementById('leaveEmpNo').value = empNo;
	  document.getElementById('leaveEmpName').textContent = empNm;
	  document.getElementById('leaveConfirmName').value = '';
	  document.getElementById('leaveConfirmName').setAttribute('placeholder', empNm);
	  document.getElementById('leaveSubmitBtn').disabled = true;
	  document.getElementById('leaveDate').value = ''; // 필요 시 오늘 날짜 세팅 가능
	  document.getElementById('leaveReason').value = '';
	  document.getElementById('leaveMemo').value = '';

	  // 모달 오픈
	  const modalEl = document.getElementById('emp-leave-modal');
	  if (window.bootstrap && window.bootstrap.Modal) {
	    (window.bootstrap.Modal.getInstance(modalEl) || new window.bootstrap.Modal(modalEl)).show();
	  } else if (window.jQuery) {
	    window.jQuery(modalEl).modal('show');
	  }
	});

	// 이름 확인 일치 시에만 제출 가능
	document.getElementById('leaveConfirmName').addEventListener('input', function() {
	  const expected = document.getElementById('leaveEmpName').textContent.trim();
	  document.getElementById('leaveSubmitBtn').disabled = (this.value.trim() !== expected);
	});

	// 퇴사 제출
	document.getElementById('leaveForm').addEventListener('submit', async function(e) {
		  e.preventDefault();
		  let leaveDate = document.querySelector("#leaveDate").value;
		  let rsgntnYmd = leaveDate.replaceAll("-","");
		  const payload = {
		    empNo: document.getElementById('leaveEmpNo').value,
		    rsgntnYmd: rsgntnYmd,
		  };
	  // 기본 유효성
	  if (!payload.empNo || !payload.rsgntnYmd) {
	    alert('퇴사일/사유를 입력하세요.');
	    return;
	  }

	  try {
	    const res = await fetch('/hr/leave', {
	      method: 'POST',
	      headers: {'Content-Type': 'application/json'},
	      body: JSON.stringify(payload)
	    });
	    if (!res.ok) throw new Error('퇴사 처리 실패 (' + res.status + ')');

	    // 닫고 새로고침
	    const modalEl = document.getElementById('emp-leave-modal');
	    if (window.bootstrap && window.bootstrap.Modal) {
	      (window.bootstrap.Modal.getInstance(modalEl) || new window.bootstrap.Modal(modalEl)).hide();
	    } else if (window.jQuery) {
	      window.jQuery(modalEl).modal('hide');
	    }
	    
        Swal.fire({
            title:'퇴사처리 되었습니다.',
            icon: 'success',
            scrollbarPadding: false,
            heightAuto: false                        
          }).then(function (result) {
      	  if (result.isConfirmed) {
      		    window.location.reload(); // 또는 window.location.href = window.location.href;
      		  }
     		});
	  } catch (err) {
	    alert(err.message || '처리 중 오류가 발생했습니다.');
	    console.error(err);
	  }
	});

	// 재직 전환(복직) 처리
document.addEventListener('click', function (e) {
  const btn = e.target.closest('.btn-reactivate');
  if (!btn) return;

  const empNo = btn.dataset.empNo;
  const today = new Date().toISOString().slice(0,10); // yyyy-MM-dd

  Swal.fire({
    title: '재직 전환',
    text: '해당 직원을 재직 상태로 전환하시겠습니까?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: '재직 전환',
    cancelButtonText: '취소',
    reverseButtons: true,
    heightAuto: false,
    scrollbarPadding: false
  }).then(async (result) => {
    if (!result.isConfirmed) return;

    const payload = {
      empNo: empNo,
      // 날짜 입력을 받지 않으므로, 기본값으로 오늘 날짜 사용(yyyyMMdd)
      rehireYmd: today.replaceAll('-', '')
    };

    try {
      const res = await fetch('/hr/reactivate', {
        method: 'POST',
        headers: { 'Content-Type':'application/json' },
        body: JSON.stringify(payload)
      });
      if (!res.ok) throw new Error('재직 전환 실패 (' + res.status + ')');

      Swal.fire({
        title: '재직 전환되었습니다.',
        icon: 'success',
        heightAuto: false,
        scrollbarPadding: false
      }).then(() => window.location.reload());
    } catch (err) {
      Swal.fire({ icon:'error', title:'오류', text: err.message || '처리 중 오류가 발생했습니다.' });
      console.error(err);
    }
  });
});
	
	
	
	
	  // 탭 전환
	  document.getElementById('hrTabs')?.addEventListener('click', function(e){
	    const btn = e.target.closest('[data-status]');
	    if(!btn) return;
	    document.getElementById('status').value = btn.dataset.status;
	    document.getElementById('page').value = '1'; // 탭 바꾸면 첫 페이지로
	    document.searchForm.submit();
	  });

	  // 검색 버튼도 페이지 1부터
	  document.getElementById('searchBtn')?.addEventListener('click', function(){
	    document.getElementById('page').value = '1';
	    document.searchForm.submit();
	  });
	
	  
	// ====== 자동입력(시연) ======
	  function autofillDemo(){
	    // 시연용: 항상 '등록' 모드로 전환하고 사번 비우기
	    setVal('#mode', 'create');
	    setVal('#empNo', '');

	    // ★여기 값들은 네가 원하는 대로 바꿔서 시연하면 됨
	    const demo = {
	      empNm: '홍석천',                 // 이름
	      brdt: '1993-05-21',            // 생년월일 (yyyy-MM-dd)
	      email: 'calf247@naver.com',     // 개인 이메일
	      wnmpyEmail: '',// 사내 이메일 (readonly)
	      telno: '01012345678',          // 휴대전화 (숫자만)
	      extNo: '151515',                  // 내선
	      empZip: '06236',               // 우편번호
	      homeAddr: '서울특별시 강남구 테헤란로 152', // 주소
	      homeDaddr: '17층',             // 상세주소
	      jncmpYmd: '2024-03-01',        // 입사일 (yyyy-MM-dd)

	      // 아래 3개는 선택값. 실제 코드값으로 바꿔 써!
	      deptNo: '9',    // TODO: 부서 코드값 (예: "10010")
	      jbgdCd: '15004',  // 직급 코드 (예: 사원 15004)
	      bankCd: '090',    // 은행 코드 (카카오뱅크 090 예시)

	      dpstrNm: '홍석천',             // 예금주
	      actno: '3333333333333',       // 계좌번호(숫자)
	      salary: '42000000',           // 연봉 (원 단위, 숫자)
	      profilePreviewUrl: ''         // TODO: 프리뷰 이미지 경로 (선택)
	    };
		console.log(demo)
	    // 기본 인풋 채우기
	    setVal('#empNm', demo.empNm);
	    setVal('#brdt', demo.brdt);
	    setVal('#email', demo.email);
	    setVal('#wnmpyEmail', demo.wnmpyEmail);
	    setVal('#telno', demo.telno);
	    setVal('#empExtNo', demo.extNo);
	    setVal('#empZip', demo.empZip);
	    setVal('#homeAddr', demo.homeAddr);
	    setVal('#homeDaddr', demo.homeDaddr);
	    setVal('#jncmpYmd', demo.jncmpYmd);
	    setVal('#dpstrNm', demo.dpstrNm);
	    setVal('#actno', demo.actno);
	    setVal('#salary', demo.salary);

	    // 셀렉트(부서/직급/은행)
	    setSelectByCode('#deptNo',  demo.deptNo);          // 부서코드는 네 프로젝트 값으로 채워줘
	    setSelectByCode('#jbgdCd',  demo.jbgdCd);          // "15002/15006/15003/15004" 중 하나
	    setSelectByCode('#bankCode', demo.bankCd, 3);      // 3자리 패딩

	    // 은행 hidden(#bank) 동기화
	    const bankSel = document.querySelector('#bankCode');
	    const bankHidden = document.querySelector('#bank');
	    if (bankSel && bankHidden){
	      const opt = bankSel.options[bankSel.selectedIndex];
	      bankHidden.value = opt ? opt.text : '';
	    }

	    // 프로필 미리보기(파일 인풋은 보안상 JS로 직접 채울 수 없음!)
	    if (demo.profilePreviewUrl){
	      const preview = document.querySelector('#profilePreview');
	      if (preview){
	        preview.src = demo.profilePreviewUrl;
	        preview.style.display = 'block';
	      }
	    }

	    // 첫 필드 포커스
	    document.querySelector('#empNm')?.focus();
	  }

	  // 버튼 클릭 시 자동입력 실행
	  document.getElementById('btnAutofill')?.addEventListener('click', autofillDemo);	  
	  
</script>


</body>

