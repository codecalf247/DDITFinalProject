<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp" %>
<style>
.profile-avatar{
  --size:120px;              /* 필요하면 140px 등으로만 바꿔 쓰기 */
  width:var(--size);
  height:var(--size);
  border-radius:50%;
  object-fit:cover;          /* 중앙 기준으로 꽉 채우기 */
  object-position:center;
  display:block;
  background:#e9f1ff;        /* 로딩 전 배경색 */
  box-shadow:0 2px 6px rgba(0,0,0,.06);
  max-width:none;            /* img-fluid 등에 의해 찌그러지는 것 방지 */
}
</style>
<%@ include file="/module/aside.jsp" %>
<fmt:parseDate value="${empMem.jncmpYmd}" pattern="yyyyMMdd" var="jncmpDate"/>
<c:if test="${not empty empMem.rsgntnYmd}">
  <fmt:parseDate value="${empMem.rsgntnYmd}" pattern="yyyyMMdd" var="rsgntnDate"/>
</c:if>
<c:if test="${not empty empMem.brdt}">
  <fmt:parseDate value="${empMem.brdt}" pattern="yyyyMMdd" var="birthDate"/>
</c:if>

<c:set var="mobileFormatted">
  <c:choose>
    <c:when test="${not empty empMem.telno and fn:length(empMem.telno) == 11}">
      ${fn:substring(empMem.telno,0,3)}-${fn:substring(empMem.telno,3,7)}-${fn:substring(empMem.telno,7,11)}
    </c:when>
    <c:otherwise>${empMem.telno}</c:otherwise>
  </c:choose>
</c:set>

<c:set var="extFormatted">
  <c:choose>
    <c:when test="${not empty empMem.extNo and fn:length(empMem.extNo) == 10}">
      ${fn:substring(empMem.extNo,0,3)}-${fn:substring(empMem.extNo,3,6)}-${fn:substring(empMem.extNo,6,10)}
    </c:when>
    <c:otherwise>${empMem.extNo}</c:otherwise>
  </c:choose>
</c:set>

<!-- 간단 은행명 매핑(옵션) -->
<c:choose>
  <c:when test="${empMem.bankCd == '004'}"><c:set var="bankNm" value="KB국민은행"/></c:when>
  <c:when test="${empMem.bankCd == '088'}"><c:set var="bankNm" value="신한은행"/></c:when>
  <c:when test="${empMem.bankCd == '081'}"><c:set var="bankNm" value="하나은행"/></c:when>
  <c:when test="${empMem.bankCd == '020'}"><c:set var="bankNm" value="우리은행"/></c:when>
  <c:when test="${empMem.bankCd == '011'}"><c:set var="bankNm" value="NH농협은행"/></c:when>
  <c:when test="${empMem.bankCd == '090'}"><c:set var="bankNm" value="카카오뱅크"/></c:when>
  <c:when test="${empMem.bankCd == '092'}"><c:set var="bankNm" value="토스뱅크"/></c:when>
  <c:otherwise><c:set var="bankNm" value="미정"/></c:otherwise>
</c:choose>
<div class="body-wrapper">
  <div class="container">

    <!-- 상단 헤더 -->
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">Form Detail</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="../minisidebar/index.html">Home</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Form Detail</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>
    <!-- start Form with view only -->
<div class="card">
  <div class="card-header text-bg-primary">
    <h5 class="mb-0 text-white">내프로필</h5>
  </div>

  <form class="form-horizontal">
    <div class="form-body">
      <div class="card-body text-center">

        <!-- 프로필 사진(항상 이미지) -->
		<div class="d-flex justify-content-center">
		  <img
		    class="profile-avatar"
		    src="${empMem.profileFilePath}"
		    alt="${empMem.empNm} 프로필"
		    loading="lazy"
		    >
		</div>

        <!-- 이름/부서/상태 -->
        <h5 class="mt-3 mb-0">${empMem.empNm}</h5>
        <p class="text-muted mb-2">${empMem.deptNm}</p>
        <span class="badge ${empMem.enabled == 1 ? 'bg-success' : 'bg-secondary'} rounded-pill">
          ${empMem.enabled == 1 ? '재직중' : '퇴사'}
        </span>

        <hr class="my-3">

        <!-- ✅ 항상 3열 정렬: row-cols-lg-3로 고정 -->
        <div class="profile-grid row row-cols-1 row-cols-md-2 row-cols-lg-3 g-3 text-start">

          <!-- 사번 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">사번</div>
              <div class="value">${empMem.empNo}</div>
            </div>
          </div>

          <!-- 입사일 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">입사일</div>
              <div class="value">
                <fmt:formatDate value="${jncmpDate}" pattern="yyyy-MM-dd"/>
              </div>
            </div>
          </div>

          <!-- 생년월일 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">생년월일</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty birthDate}">
                    <fmt:formatDate value="${birthDate}" pattern="yyyy-MM-dd"/>
                  </c:when>
                  <c:otherwise>${empMem.brdt}</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- 사내 이메일 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">사내 이메일</div>
              <div class="value" id="displayEmail">
                <c:out value="${empty empMem.wnmpyEmail ? '-' : empMem.wnmpyEmail}"/>
              </div>
            </div>
          </div>

          <!-- 개인 이메일 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">개인 이메일</div>
              <div class="value">
                <c:out value="${empty empMem.email ? '-' : empMem.email}"/>
              </div>
            </div>
          </div>

          <!-- 휴대전화 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">휴대전화</div>
              <div class="value" id="displayMobile">
                <c:out value="${empty mobileFormatted ? '-' : fn:trim(mobileFormatted)}"/>
              </div>
            </div>
          </div>

          <!-- 내선번호 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">내선번호</div>
              <div class="value" id="displayExt">
                <c:out value="${empty extFormatted ? '-' : fn:trim(extFormatted)}"/>
              </div>
            </div>
          </div>

          <!-- 우편번호 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">우편번호</div>
              <div class="value">[<c:out value="${empty empMem.empZip ? '—' : empMem.empZip}"/>]</div>
            </div>
          </div>

          <!-- 주소 (2줄 트렁케이트로 높이 유지) -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">주소</div>
              <div class="value text-truncate-2">
                <c:out value="${empty empMem.homeAddr ? '' : empMem.homeAddr}"/> <c:out value="${empty empMem.homeDaddr ? '' : empMem.homeDaddr}"/>
              </div>
            </div>
          </div>

          <!-- 부서 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">부서</div>
              <div class="value"><c:out value="${empty empMem.deptNm ? '-' : empMem.deptNm}"/></div>
            </div>
          </div>

          <!-- 은행 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">은행</div>
              <div class="value"><c:out value="${empty bankNm ? '-' : bankNm}"/></div>
            </div>
          </div>

          <!-- 예금주 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">예금주</div>
              <div class="value"><c:out value="${empty empMem.dpstrNm ? '-' : empMem.dpstrNm}"/></div>
            </div>
          </div>

          <!-- 계좌번호 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">계좌번호</div>
              <div class="value"><c:out value="${empty empMem.actno ? '-' : empMem.actno}"/></div>
            </div>
          </div>

          <!-- 연봉 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">연봉</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty empMem.salary}">
                    <fmt:formatNumber value="${empMem.salary}" type="number" groupingUsed="true"/> 원
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- 서명 (높이 깨지지 않게 제한) -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">서명</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty empMem.signFilePath}">
                    <img src="${empMem.signFilePath}" alt="서명" style="max-width:160px; max-height:40px; object-fit:contain;">
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- 자료실 사용량 -->
          <div class="col">
            <div class="profile-chip border p-3 h-100">
              <div class="label">자료실 사용량</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty empMem.userFolderUsgqty}">
                    <fmt:formatNumber value="${empMem.userFolderUsgqty}" maxFractionDigits="2"/> MB
                  </c:when>
                  <c:otherwise>0 MB</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

        </div> <!-- /row -->
      </div>

      <!-- 버튼 영역 -->
<div class="form-actions border-top">
  <div class="card-body text-center">
    <!-- 연락처 수정 모달 -->
    <button type="button"
            id="openContactModal"
            class="btn btn-primary"
            data-email="${empMem.wnmpyEmail}"
            data-mobile="${empMem.telno}"
            data-ext="${empMem.extNo}">
      <i class="ti ti-edit fs-5"></i> 프로필 수정
    </button>

    <!-- 비밀번호 2단계 모달 -->
    <button type="button" id="openPwdModal" class="btn btn-outline-secondary ms-2">
      <i class="ti ti-lock"></i> 비밀번호 변경
    </button>

    <button type="button" class="btn bg-danger-subtle text-danger ms-2">
      Cancel
    </button>
  </div>
</div>
    </div>
  </form>
</div>

  </div>
</div>
<!-- Contact Edit Modal (단일) -->
<div class="modal fade" id="contactEditModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0 pb-0">
        <h5 class="modal-title">프로필 수정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body pt-2">
        <form id="contactForm">
          <div class="mb-3">
            <label for="editEmail" class="form-label">이메일</label>
            <input type="email" class="form-control" id="editEmail" name="email" required>
          </div>
          <div class="mb-3">
            <label for="editMobile" class="form-label">휴대전화</label>
            <input type="text" class="form-control" id="editMobile" maxlength="11" name="telno" placeholder="010-1234-5678" required>
          </div>
          <div class="mb-1">
            <label for="editExt" class="form-label">내선번호</label>
            <input type="text" class="form-control" id="editExt" maxlength="10" name="extNo" placeholder="042-123-5678">
          </div>
        </form>
      </div>

      <div class="modal-footer border-0 pt-0">
        <button type="button" class="btn bg-danger-subtle text-danger" data-bs-dismiss="modal">취소</button>
        <button type="button" id="saveContactBtn" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>


<!-- Password Change Modal (2단계) -->
<div class="modal fade" id="passwordModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0 pb-0">
        <h5 class="modal-title">비밀번호 변경</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body pt-2">
        <!-- Step 1: 현재 비밀번호 확인 -->
        <div id="pwd-step1">
          <form id="pwdVerifyForm" autocomplete="off">
            <div class="mb-3">
              <label for="currentPwd" class="form-label">현재 비밀번호</label>
              <input type="password" class="form-control" id="currentPwd" required>
            </div>
          </form>
          <div class="d-flex justify-content-end">
            <button type="button" id="verifyPwdBtn" class="btn btn-primary">확인</button>
          </div>
        </div>

        <!-- Step 2: 새 비밀번호 입력 (초기 숨김) -->
        <div id="pwd-step2" class="d-none">
          <form id="pwdChangeForm" autocomplete="off">
            <div class="mb-3">
              <label for="newPwd" class="form-label">새 비밀번호</label>
              <input type="password" class="form-control" id="newPwd" minlength="8" required>
              <div class="form-text">영문 대/소문자, 숫자, 특수문자 조합 권장 (8자 이상)</div>
            </div>
            <div class="mb-1">
              <label for="confirmPwd" class="form-label">새 비밀번호 확인</label>
              <input type="password" class="form-control" id="confirmPwd" minlength="8" required>
            </div>
          </form>
          <div class="d-flex justify-content-between">
            <button type="button" id="backToVerifyBtn" class="btn btn-light">뒤로</button>
            <button type="button" id="changePwdBtn" class="btn btn-primary">변경</button>
          </div>
        </div>
      </div>

      <div class="modal-footer border-0 pt-0 d-none" id="pwdFooter"></div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath }/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', () => {
  // 공통
  const csrfToken  = document.querySelector('meta[name="_csrf"]')?.content;
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

  // 보기영역
  const displayEmail  = document.getElementById('displayEmail');
  const displayMobile = document.getElementById('displayMobile');
  const displayExt    = document.getElementById('displayExt');

  // ===== 연락처 수정 =====
  const openContactBtn = document.getElementById('openContactModal');
  const contactModalEl = document.getElementById('contactEditModal');
  const contactModal   = contactModalEl ? new bootstrap.Modal(contactModalEl) : null;
  const contactForm    = document.getElementById('contactForm');
  const editEmail      = document.getElementById('editEmail');
  const editMobile     = document.getElementById('editMobile');
  const editExt        = document.getElementById('editExt');
  const saveContactBtn = document.getElementById('saveContactBtn');

  openContactBtn?.addEventListener('click', () => {
    editEmail.value  = openContactBtn.dataset.email  || '';
    editMobile.value = openContactBtn.dataset.mobile || '';
    editExt.value    = openContactBtn.dataset.ext    || '';
    contactModal?.show();
  });

  saveContactBtn?.addEventListener('click', async () => {
    if (!contactForm.reportValidity()) return;

    const payload = {
      wnmpyEmail: editEmail.value.trim(),
      telno: editMobile.value.trim(),
      extNo: editExt.value.trim()
    };

    var headers = { 'Content-Type': 'application/json' };

    fetch('/hr/infoChange', {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(payload)
    })
    .then(function (res) {
      // 실패: 서버 메시지 최대한 파싱(JSON/텍스트 모두 대응)
      return res.json()
    })
    .then(function (data) {
      // 보기영역 업데이트
      if (displayEmail)  displayEmail.textContent  = payload.email || '-';
      if (displayMobile) displayMobile.textContent = payload.telno || '-';
      if (displayExt)    displayExt.textContent    = payload.extNo || '-';

      if (contactModal && typeof contactModal.hide === 'function') {
        contactModal.hide();
      }
      if(data === "OK"){
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
      
    })
    .catch(function (err) {
      alert(err.message);
    });
  });

  // ===== 비밀번호 변경(2단계) =====
  const openPwdBtn       = document.getElementById('openPwdModal');
  const pwdModalEl       = document.getElementById('passwordModal');
  const pwdModal         = pwdModalEl ? new bootstrap.Modal(pwdModalEl) : null;

  const step1            = document.getElementById('pwd-step1');
  const step2            = document.getElementById('pwd-step2');
  const currentPwd       = document.getElementById('currentPwd');
  const verifyPwdBtn     = document.getElementById('verifyPwdBtn');
  const backToVerifyBtn  = document.getElementById('backToVerifyBtn');
  const newPwd           = document.getElementById('newPwd');
  const confirmPwd       = document.getElementById('confirmPwd');
  const changePwdBtn     = document.getElementById('changePwdBtn');

  function gotoStep(which) {
    if (which === 1) {
      step1.classList.remove('d-none');
      step2.classList.add('d-none');
      currentPwd.value = '';
      newPwd.value = '';
      confirmPwd.value = '';
      currentPwd.focus();
    } else {
      step1.classList.add('d-none');
      step2.classList.remove('d-none');
      newPwd.focus();
    }
  }

  openPwdBtn?.addEventListener('click', () => {
    gotoStep(1);
    pwdModal?.show();
  });

  // Step1: 현재 비밀번호 확인
  verifyPwdBtn?.addEventListener('click', async () => {
    if (!currentPwd.value) {
      alert('현재 비밀번호를 입력하세요.');
      currentPwd.focus();
      return;
    }
    fetch('/hr/passwordVerify', {
    	  method: 'POST',
    	  headers: { 'Content-Type': 'application/json' },
    	  body: JSON.stringify({
    	    inputPassword: currentPwd.value   // 서버가 currentPassword 기대하면 키 이름 변경
    	  })
    	})
		.then(function (res) { return res.json(); })
		.then(function (data) {
		  console.log("data",data);
		  if (data !== 'OK') throw new Error('현재 비밀번호가 올바르지 않습니다.');
		  gotoStep(2);
		})
    	.catch(function (err) {
    	  alert(err.message);
    	});
  });

  // Step2: 뒤로가기
  backToVerifyBtn?.addEventListener('click', () => gotoStep(1));

  // Step2: 비밀번호 변경
  changePwdBtn?.addEventListener('click', async () => {
    if (!newPwd.value || !confirmPwd.value) {
      alert('새 비밀번호와 확인을 입력하세요.');
      return;
    }
    if (newPwd.value !== confirmPwd.value) {
      alert('새 비밀번호와 확인이 일치하지 않습니다.');
      confirmPwd.focus();
      return;
    }

    let headers = { 'Content-Type': 'application/json' };
    if (csrfToken && csrfHeader) { headers[csrfHeader] = csrfToken; }

    fetch('/hr/chagnePassword', {
      method: 'POST',
      headers: headers,
      body: JSON.stringify({
        newPassword: newPwd.value
      })
    })
    .then(function (res) {
      if (res.ok) return res; // 성공
      // 실패: 서버 메시지 최대한 파싱
      return res.text().then(function (t) {
        var d;
        try { d = JSON.parse(t); } catch (e) { d = {}; }
        throw new Error((d && d.message) || '비밀번호 변경 실패');
      });
    })
    .then(function () {
      alert('비밀번호가 변경되었습니다. 보안을 위해 다시 로그인해 주세요.');
      if (pwdModal && typeof pwdModal.hide === 'function') { pwdModal.hide(); }
      // location.href = '/logout'; // 필요 시
    })
    .catch(function (err) {
      alert(err.message);
    });
  });
});
</script>

<%@ include file="/module/footerPart.jsp" %>
