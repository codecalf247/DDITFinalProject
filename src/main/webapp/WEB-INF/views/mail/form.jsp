<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>

  <!-- SweetAlert2 -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <!-- CKEditor -->
  <script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>

  <style>
    :root{ --surface:#fff; --surface-2:#fafafa; --border:#e5e7eb; --text:#111827; --muted:#6b7280; --hint:#94a3b8; }
    [data-bs-theme="dark"]{ --surface:#0f172a; --surface-2:#111827; --border:#334155; --text:#e5e7eb; --muted:#94a3b8; --hint:#9aa8be; }
    .compose-wrap .nav-actions .btn{border-radius:.5rem;padding:.42rem .9rem}
    .compose-row{display:flex;align-items:center;gap:.75rem;padding:.6rem 0;border-top:1px solid var(--border)}
    .compose-row:first-of-type{border-top:0}
    .compose-label{width:110px;flex:0 0 110px;color:var(--muted);font-weight:500;display:flex;align-items:center;gap:.5rem}
    .compose-field{flex:1 1 auto;min-width:0}
    .compose-tools{flex:0 0 auto;display:flex;align-items:center;gap:.5rem;color:var(--muted)}
    .form-control.compose-input{background:var(--surface);color:var(--text);border:1px solid var(--border);border-radius:.6rem;padding:.58rem .8rem;box-shadow:none}
    .form-control.compose-input:focus{border-color:var(--bs-primary);box-shadow:0 0 0 .18rem rgba(var(--bs-primary-rgb),.16);background:var(--surface)}
    .form-control.compose-input::placeholder{color:var(--hint)}
    .btn-soft{background:var(--surface);border:1px solid var(--border)}
    .btn-soft:hover{border-color:var(--bs-primary);color:var(--bs-primary)}
    .attach-drop{background:var(--surface);border:1px dashed var(--border);border-radius:.6rem;min-height:54px;display:flex;align-items:center;justify-content:center;color:var(--muted)}
    .editor-actions{ display:flex; justify-content:flex-end; gap:.5rem; margin-top:.6rem; }
    .reserve-note{color:var(--muted);font-size:.9rem}
    .w-date{max-width:220px}
    .w-time{max-width:120px}
    .reserve-inline{display:flex;align-items:center;gap:.5rem;flex-wrap:nowrap;}
    .dow-text{font-size:.85rem;color:#6c757d;margin-top:.5rem;}
    .reserve-chip{display:inline-flex;align-items:center;gap:.35rem;border:1px solid var(--border);background:var(--surface);padding:.25rem .5rem;border-radius:.5rem;color:#0d6efd;font-size:.85rem;box-shadow:0 1px 0 rgba(0,0,0,.02)}
    .reserve-chip .ti{font-size:1rem}
    .reserve-chip .btn-close{transform:scale(.8)}
    .compose-ig .form-control.compose-input{ border-top-right-radius:0; border-bottom-right-radius:0; }
    .compose-ig .btn-addr{ border-top-left-radius:0; border-bottom-left-radius:0; border:1px solid var(--border); background:var(--surface); padding:.58rem .9rem; }
    .cke_notifications_area{display:none;}
    .ab-list{border:1px solid var(--border);border-radius:.5rem;height:300px;overflow:auto;background:var(--surface);}
    .ab-row{display:flex;align-items:center;gap:.5rem;padding:.35rem .6rem;border-bottom:1px solid rgba(0,0,0,.03)}
    .ab-row:last-child{border-bottom:0}
    .ab-row .text-muted{color:var(--muted)}
    .ab-box{border:1px solid var(--border);border-radius:.5rem;min-height:120px;padding:.5rem;background:var(--surface);overflow:auto;}
    .ab-chip{display:inline-flex;align-items:center;gap:.35rem;border:1px solid var(--border);background:var(--surface);padding:.2rem .45rem;border-radius:.5rem;margin:.2rem;font-size:.9rem;}
    .ab-chip .btn-close{transform:scale(.8)}
    .arrow-col .btn{min-width:42px}
    #addrBookModal .input-group > .form-control{ border-top-right-radius:0; border-bottom-right-radius:0; }
    #addrBookModal .input-group > .btn{ border-top-left-radius:0; border-bottom-left-radius:0; white-space:nowrap; }
    #addrBookModal .modal-dialog{ max-width: 1100px; }
    #addrBookModal .ab-list{ overflow: auto; }
    #addrBookModal .ab-row{ white-space: nowrap; }
    #addrBookModal .ab-row .ms-2, #addrBookModal .ab-row .text-muted{ white-space: nowrap; }
  </style>
</head>

<body>
  <%@ include file="/module/header.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <div class="body-wrapper">
    <div class="container-fluid">

      <div class="body-wrapper">
        <div class="container compose-wrap">
          <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-3">
            <div class="card-body px-4 py-3">
              <div class="d-flex align-items-center justify-content-between">
                <div><h5 class="fw-semibold mb-0">메일쓰기</h5></div>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-body pt-3">
              <form id="composeForm" method="post" action="${pageContext.request.contextPath}/mail/insert" enctype="multipart/form-data">
                <sec:csrfInput/>

                <div class="nav-actions d-flex gap-2 mb-2">
                  <button class="btn btn-soft" type="button" data-bs-toggle="modal" data-bs-target="#sendReserveModal" id="btnReserve">예약</button>
                  <button class="btn btn-soft" type="button" id="btnDraft">임시저장</button>
                


				<div style="text-align:right">
					<button type="button" class="btn btn-outline-warning" onclick="fillDummyData()">
			   <i class="fa fa-magic"></i> 더미데이터
				</button>
		       </div>

				</div>

                <div id="reserveSummaryArea" class="mb-3" style="min-height:28px;">
                  <span id="reserveChip" class="reserve-chip d-none">
                    <i class="ti ti-clock"></i>
                    <span id="reserveText">--</span>
                    <button type="button" class="btn-close" aria-label="예약 해제" id="reserveClearBtn"></button>
                  </span>
                </div>

                <input type="hidden" id="reserveAt"     name="reserveAt"     value="">
                <input type="hidden" id="resveDsptchDt" name="resveDsptchDt" value="">
                <input type="hidden" id="tempSaveYn"    name="tempSaveYn"    value="N">

                <div class="compose-row">
                  <div class="compose-label">받는사람</div>
                  <div class="compose-field">
                    <div class="input-group compose-ig">
                      <input type="text" class="form-control compose-input" name="toList" value="${empEmail }" placeholder="이메일 입력 후 Enter">
                      <button class="btn btn-soft btn-addr" type="button" id="btnAddr">주소록</button>
                    </div>
                  </div>
                </div>

                <div class="compose-row">
                  <div class="compose-label">참조</div>
                  <div class="compose-field">
                    <input type="text" class="form-control compose-input" name="ccList" placeholder="이메일 입력 후 Enter">
                  </div>
                </div>

                <div class="compose-row">
                  <div class="compose-label">제목</div>
                  <div class="compose-field">
                    <input type="text" class="form-control compose-input" name="emailTitle" placeholder="제목을 입력하세요" value="${email.emailTitle}">
                  </div>
                </div>

                <div class="compose-row">
                  <div class="compose-label">파일첨부</div>
                  <div class="compose-field">
                    <input class="form-control" type="file" id="uploadFiles" name="uploadFiles" multiple>
                  </div>
                </div>

                <div class="form-group">
                  <label for="boContent" class="visually-hidden">내용을 입력해주세요..</label>
                  <textarea id="boContent" name="emailCn" class="form-control bg-white" rows="14" placeholder="내용을 입력해주세요">${email.emailCn}</textarea>
                </div>

                <div class="editor-actions">
                  <a href="${pageContext.request.contextPath}/mail/inbox" class="btn btn-danger btn-sm">취소</a>
                  <button type="button" class="btn btn-success btn-sm text-white" id="btnSend">보내기</button>
                </div>

                <div id="hiddenRecipients"></div>
              </form>
            </div>
          </div>

        </div>
      </div>

    </div>
  </div>

  <!-- 예약 모달 -->
  <div class="modal fade" id="sendReserveModal" tabindex="-1" aria-labelledby="sendReserveLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-semibold" id="sendReserveLabel">발송 예약</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>
        <div class="modal-body">
          <div class="reserve-note mb-2">설정한 <b>예약시간</b>에 자동 발송됩니다.</div>
          <label class="form-label fw-semibold">예약시간</label>
          <div class="reserve-inline mb-1">
            <input type="date" class="form-control w-date" id="rvDate">
            <select class="form-select w-time" id="rvHour" aria-label="시"></select>
            <select class="form-select w-time" id="rvMin" aria-label="분"></select>
          </div>
          <div id="rvDow" class="dow-text">예약시간을 선택하세요.</div>
          <div class="mt-3"><button type="button" class="btn btn-outline-secondary btn-sm" id="rvTodayBtn">오늘로 입력</button></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn bg-secondary-subtle text-secondary" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary" id="rvApplyBtn">적용</button>
        </div>
      </div>
    </div>
  </div>

  <!-- 주소록 모달 -->
  <div class="modal fade" id="addrBookModal" tabindex="-1" aria-labelledby="addrBookLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-semibold" id="addrBookLabel">메일 주소록</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>

        <div class="modal-body">
          <div class="row g-3 align-items-stretch">
            <div class="col-6">
              <div class="input-group mb-2">
                <input type="text" id="abSearch" class="form-control" placeholder="이름/부서/이메일 검색">
                <button class="btn btn-soft text-nowrap" type="button" id="abClear">지우기</button>
              </div>
              <div id="abList" class="ab-list"></div>
            </div>

            <div class="col-1 d-flex flex-column align-items-center justify-content-center gap-2 arrow-col">
              <button class="btn btn-outline-primary btn-sm w-100" id="abAddTo" title="받는사람으로">→</button>
              <button class="btn btn-outline-secondary btn-sm w-100" id="abAddCc" title="참조로">→</button>
            </div>

            <div class="col-5">
              <div class="mb-3">
                <div class="d-flex align-items-center justify-content-between mb-1">
                  <div class="fw-semibold">받는 사람 <span class="text-primary" id="abToCnt">0</span></div>
                  <button type="button" class="btn btn-sm btn-soft" id="abToClear">초기화</button>
                </div>
                <div id="abToBox" class="ab-box"></div>
              </div>

              <div>
                <div class="d-flex align-items-center justify-content-between mb-1">
                  <div class="fw-semibold">참조 <span class="text-primary" id="abCcCnt">0</span></div>
                  <button type="button" class="btn btn-sm btn-soft" id="abCcClear">초기화</button>
                </div>
                <div id="abCcBox" class="ab-box"></div>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn bg-secondary-subtle text-secondary" data-bs-dismiss="modal" id="abCancelBtn">취소</button>
          <button type="button" class="btn btn-primary" id="abApplyBtn">확인</button>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="/module/footerPart.jsp" %>
  
  
  <script>
function fillDummyData() {
  // 입력 요소
  const toInput   = document.querySelector('input[name="toList"]');
  const ccInput   = document.querySelector('input[name="ccList"]');
  const titleInput= document.querySelector('input[name="emailTitle"]');
  const ta        = document.getElementById('boContent'); // CKEditor가 붙는 textarea

  // 더미 값
  const dummyTo   = '202508001@groovier.com';
  const dummyCc   = 'khj_w@example.com';
  const dummyTitle= '회의 요약본 보내드립니다.';
  const dummyBody =
    '회의 요약본 보내드립니다.<br><br>';

  // 값 주입
  if (toInput)   toInput.value    = dummyTo;
  if (ccInput)   ccInput.value    = dummyCc;
  if (titleInput)titleInput.value = dummyTitle;

  // 에디터/텍스트 영역 주입
  if (window.CKEDITOR && CKEDITOR.instances.boContent) {
    CKEDITOR.instances.boContent.setData(dummyBody);
  } else if (ta) {
    ta.value = dummyBody.replace(/<br>/g, '\n').replace(/<hr>/g, '\n--------------------\n');
  }

  // 예약값은 초기화(원하면 주석 해제해서 특정 예약시간도 세팅 가능)
  const reserveAt     = document.getElementById('reserveAt');
  const resveDsptchDt = document.getElementById('resveDsptchDt');
  const reserveChip   = document.getElementById('reserveChip');
  if (reserveAt)      reserveAt.value = '';
  if (resveDsptchDt)  resveDsptchDt.value = '';
  if (reserveChip)    reserveChip.classList.add('d-none');

  // 입력 포커스 이동(선택)
  if (titleInput) titleInput.focus();
}
</script>
  

  <script type="text/javascript">
  $(function () {
    // ===== CKEditor =====
    let contextPath = "${pageContext.request.contextPath}";
    if (window.CKEDITOR) {
      CKEDITOR.replace("boContent", { filebrowserUploadUrl: contextPath + "/imageUpload.do" });
      CKEDITOR.config.height = "600px";
    }

    // ===== 엘리먼트 =====
    let $form      = $("#composeForm");
    let $btnDraft  = $("#btnDraft");
    let $btnSend   = $("#btnSend");
    let $btnAddr   = $("#btnAddr");

    // 예약 관련
    let $rvModal   = $("#sendReserveModal");
    let $rvDate    = $("#rvDate");
    let $rvHour    = $("#rvHour");
    let $rvMin     = $("#rvMin");
    let $rvToday   = $("#rvTodayBtn");
    let $rvPreview = $("#rvDow");

    let $reserveChip  = $("#reserveChip");
    let $reserveText  = $("#reserveText");
    let $reserveClear = $("#reserveClearBtn");
    let $reserveAt    = $("#reserveAt");
    let $resveDt      = $("#resveDsptchDt");
    let $tempSaveYn   = $("#tempSaveYn");

    // ===== 예약 시간 Select 옵션 =====
    let pad2  = n => (n < 10 ? "0" + n : "" + n);
    let hOpts = "", mOpts = "";
    for (let h = 0; h < 24; h++) hOpts += '<option value="' + pad2(h) + '">' + pad2(h) + '시</option>';
    for (let m = 0; m < 60; m += 5) mOpts += '<option value="' + pad2(m) + '">' + pad2(m) + '분</option>';
    $rvHour.html(hOpts);
    $rvMin.html(mOpts);

    let DOW = ["일","월","화","수","목","금","토"];
    let fmtDate = d => d.getFullYear() + "-" + pad2(d.getMonth()+1) + "-" + pad2(d.getDate());

    function updateReservePreview(){
      let d  = $rvDate.val(), hh = $rvHour.val(), mm = $rvMin.val();
      if (!d || !hh || !mm) { $rvPreview.text("예약시간을 선택하세요."); return; }
      let p  = d.split("-");
      let dt = new Date(+p[0], +p[1]-1, +p[2], +hh, +mm, 0);
      $rvPreview.text(d + " (" + DOW[dt.getDay()] + ") " + hh + ":" + mm);
    }

    function setToNowRounded(){
      let now = new Date();
      let add = (5 - (now.getMinutes() % 5)) % 5;
      now.setMinutes(now.getMinutes() + add, 0, 0);
      $rvDate.val(fmtDate(now));
      $rvHour.val(pad2(now.getHours()));
      $rvMin.val(pad2(now.getMinutes()));
      updateReservePreview();
    }
    setToNowRounded();

    $rvDate.on("change", updateReservePreview);
    $rvHour.on("change", updateReservePreview);
    $rvMin.on("change", updateReservePreview);
    $rvToday.on("click", setToNowRounded);

    let rvModalEl   = document.getElementById("sendReserveModal");
    let bsRvModal   = (window.bootstrap && bootstrap.Modal && bootstrap.Modal.getOrCreateInstance)
                    ? bootstrap.Modal.getOrCreateInstance(rvModalEl)
                    : null;
    let hideRvModal = () => { bsRvModal ? bsRvModal.hide() : $rvModal.modal("hide"); };

    // 모달 열릴 때 기본값 보정 & 프리뷰 갱신
    $rvModal.on('shown.bs.modal', function () {
      if (!$rvDate.val()) setToNowRounded();
      if (!$rvHour.val()) $rvHour.val($rvHour.find('option:first').val());
      if (!$rvMin.val())  $rvMin.val($rvMin.find('option:first').val());
      updateReservePreview();
    });

    // ── 예약 적용 버튼: 형식 고정 + 과거 방지 ─────────────────
    $(document).on("click", "#rvApplyBtn", function (e) {
      e.preventDefault();
      let d  = $rvDate.val(), hh = $rvHour.val(), mm = $rvMin.val();

      if (!d)  { let now=new Date(); d = fmtDate(now); $rvDate.val(d); }
      if (!hh) { hh = $rvHour.find('option:selected').val() || $rvHour.find('option:first').val(); $rvHour.val(hh); }
      if (!mm) { mm = $rvMin.find('option:selected').val()  || $rvMin.find('option:first').val();  $rvMin.val(mm); }

      let p  = d.split("-");
      let dt = new Date(+p[0], +p[1]-1, +p[2], +hh, +mm, 0);
      if (dt.getTime() <= Date.now()) {
        Swal.fire({ title:'안내', text:'예약시간은 현재 이후여야 합니다.', icon:'warning', confirmButtonText:'확인' });
        return;
      }

      let pretty = d + " (" + DOW[dt.getDay()] + ") " + hh + ":" + mm;
      let serverStr = d + " " + hh + ":" + mm + ":00"; // yyyy-MM-dd HH:mm:ss

      $reserveText.text(pretty);
      $reserveAt.val(pretty);
      $reserveChip.removeClass("d-none");
      $resveDt.val(serverStr);

      hideRvModal();
    });

    // 예약 해제
    $reserveClear.on("click", function(){
      $reserveChip.addClass("d-none");
      $reserveAt.val("");
      $resveDt.val("");
    });

    // 에디터 내용 동기화
    function syncEditor(){
      if (window.CKEDITOR && CKEDITOR.instances.boContent) {
        $("#boContent").val(CKEDITOR.instances.boContent.getData());
      }
    }

    // ===== 주소록 관련 =====
    let $addrModal = $("#addrBookModal");
    let $abSearch  = $("#abSearch");
    let $abClear   = $("#abClear");
    let $abList    = $("#abList");
    let $abAddTo   = $("#abAddTo");
    let $abAddCc   = $("#abAddCc");
    let $abToBox   = $("#abToBox");
    let $abCcBox   = $("#abCcBox");
    let $abToCnt   = $("#abToCnt");
    let $abCcCnt   = $("#abCcCnt");
    let $abToClear = $("#abToClear");
    let $abCcClear = $("#abCcClear");
    let $applyBtn  = $("#abApplyBtn");

    let $toInput = $("input[name='toList']");
    let $ccInput = $("input[name='ccList']");

    let addrModalEl   = document.getElementById("addrBookModal");
    let bsAddrModal   = (window.bootstrap && bootstrap.Modal && bootstrap.Modal.getOrCreateInstance)
                      ? bootstrap.Modal.getOrCreateInstance(addrModalEl)
                      : null;
    let showAddrModal = () => { bsAddrModal ? bsAddrModal.show() : $addrModal.modal("show"); };
    let hideAddrModal = () => { bsAddrModal ? bsAddrModal.hide() : $addrModal.modal("hide"); };

    let normalizeEmail = s => (s||"").replace(/[<>]/g,"").trim().toLowerCase();
    let emailValid     = em => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(em);

    let parseEmails = function(str){
      if(!str) return [];
      let raw = str.split(/[,\s;]+/);
      let out = [], seen = {};
      for(let i=0;i<raw.length;i++){
        let t = (raw[i]||"").trim();
        if(!t) continue;
        let m = t.match(/<([^>]+)>/);
        let em = normalizeEmail(m ? m[1] : t);
        if(!em || !emailValid(em)) continue;
        if(!seen[em]){ seen[em]=true; out.push(em); }
      }
      return out;
    };

    let createChipHtml = function(name,email){
      let key = normalizeEmail(email);
      return '<span class="ab-chip" data-email="'+email+'" data-key="'+key+'">'
           +   '<span class="ab-name">'+(name||"")+'</span> <span class="text-muted">&lt;'+email+'&gt;</span>'
           +   '<button type="button" class="btn-close ab-del" aria-label="삭제"></button>'
           + '</span>';
    };

    let getKeysFromBox = function($box){
      let arr=[]; $box.find(".ab-chip").each(function(){ arr.push($(this).attr("data-key")); }); return arr;
    };

    let updateCounts = function(){
      $abToCnt.text($abToBox.find(".ab-chip").length);
      $abCcCnt.text($abCcBox.find(".ab-chip").length);
    };

    let refreshInputsFromChips = function(){
      let toArr=[], ccArr=[];
      $abToBox.find(".ab-chip").each(function(){ toArr.push($(this).attr("data-email")); });
      $abCcBox.find(".ab-chip").each(function(){ ccArr.push($(this).attr("data-email")); });
      $toInput.val(toArr.join(", "));
      $ccInput.val(ccArr.join(", "));
    };

    let disableAlreadySelectedCheckboxes = function(){
      let selected = {};
      getKeysFromBox($abToBox).forEach(k => { if(k) selected[k]=true; });
      getKeysFromBox($abCcBox).forEach(k => { if(k) selected[k]=true; });

      $abList.find(".ab-chk").each(function(){
        let key = normalizeEmail($(this).data("email"));
        let used = !!selected[key];
        $(this).prop("checked", false).prop("disabled", used);
        $(this).closest("label").toggleClass("opacity-50", used);
      });
    };

    let rehydrateFromInputs = function(){
      let toRaw = parseEmails($toInput.val());
      let ccRaw = parseEmails($ccInput.val());

      let seen = {};
      let uniqTo=[], uniqCc=[];
      for(let i=0;i<toRaw.length;i++){ let e1=toRaw[i]; if(!seen[e1]){ seen[e1]=true; uniqTo.push(e1);} }
      for(let j=0;j<ccRaw.length;j++){ let e2=ccRaw[j]; if(!seen[e2]){ seen[e2]=true; uniqCc.push(e2);} }

      $abToBox.empty(); uniqTo.forEach(e => $abToBox.append(createChipHtml("", e)));
      $abCcBox.empty(); uniqCc.forEach(e => $abCcBox.append(createChipHtml("", e)));

      updateCounts();
      disableAlreadySelectedCheckboxes();
    };

    (function prefillToCc(){ rehydrateFromInputs(); })();

    $("#btnAddr").on("click", function(){
      showAddrModal();
      loadEmpList(($abSearch.val()||"").trim());
    });

    let loadEmpList = function(q){
      $.ajax({
        url: contextPath + "/mail/addressbook/emp",
        method: "GET",
        dataType: "json",
        data: { q: q, limit: 200 }
      })
      .done(function(list){ renderList(list || []); })
      .fail(function(){ renderList([]); });
    };

    let renderList = function(arr){
      if (!arr || arr.length === 0){
        $abList.html('<div class="text-center text-muted py-5">주소록 데이터가 없습니다.</div>');
        return;
      }
      let html = "";
      for (let i=0; i<arr.length; i++){
        let x = arr[i] || {};
        let nm = x.empNm || "";
        let dp = x.deptNm || "";
        let em = x.email || "";
        if (!em) continue;
        html += '<label class="ab-row">'
             +  '  <input type="checkbox" class="form-check-input ab-chk" data-name="'+nm+'" data-email="'+em+'">'
             +  '  <span class="ms-2">'+nm+'</span>'
             +  '  <span class="text-muted ms-1">['+dp+']</span>'
             +  '  <span class="text-muted ms-2">&lt;'+em+'&gt;</span>'
             +  '</label>';
      }
      $abList.html(html);
      disableAlreadySelectedCheckboxes();
    };

    let searchTimer = null;
    $abSearch.on("input", function(){
      if (searchTimer) clearTimeout(searchTimer);
      searchTimer = setTimeout(function(){ loadEmpList($abSearch.val().trim()); }, 180);
    });
    $abClear.on("click", function(){ $abSearch.val(""); loadEmpList(""); });

    let addSelectedTo = function($box){
      let used = {};
      getKeysFromBox($abToBox).forEach(k => { if(k) used[k]=true; });
      getKeysFromBox($abCcBox).forEach(k => { if(k) used[k]=true; });

      let added = 0;
      $abList.find(".ab-chk:checked").each(function(){
        let name  = $(this).data("name")||"";
        let email = $(this).data("email")||"";
        let key   = normalizeEmail(email);
        if (!emailValid(key)) return;
        if (used[key]) return;
        $box.append(createChipHtml(name, email));
        used[key]=true; added++;
        $(this).prop("checked", false).prop("disabled", true).closest("label").addClass("opacity-50");
      });

      if (added>0){ updateCounts(); refreshInputsFromChips(); }
    };
    $abAddTo.on("click", function(){ addSelectedTo($abToBox); });
    $abAddCc.on("click", function(){ addSelectedTo($abCcBox); });

    $(document).on("click", ".ab-del", function(){
      $(this).closest(".ab-chip").remove();
      updateCounts();
      refreshInputsFromChips();
      disableAlreadySelectedCheckboxes();
    });

    $abToClear.on("click", function(){
      $abToBox.empty(); updateCounts(); refreshInputsFromChips(); disableAlreadySelectedCheckboxes();
    });
    $abCcClear.on("click", function(){
      $abCcBox.empty(); updateCounts(); refreshInputsFromChips(); disableAlreadySelectedCheckboxes();
    });

    $applyBtn.on("click", function(){
      refreshInputsFromChips();
      hideAddrModal();
    });

    let syncTimerTo=null, syncTimerCc=null;
    $toInput.on("input blur", function(){
      if (syncTimerTo) clearTimeout(syncTimerTo);
      syncTimerTo = setTimeout(rehydrateFromInputs, 180);
    });
    $ccInput.on("input blur", function(){
      if (syncTimerCc) clearTimeout(syncTimerCc);
      syncTimerCc = setTimeout(rehydrateFromInputs, 180);
    });

    function buildRecipientHiddenFields(){
      $("#hiddenRecipients").empty();
      let toArr = parseEmails($toInput.val());
      let ccArr = parseEmails($ccInput.val());
      for (let i=0;i<toArr.length;i++){
        $('<input type="hidden" name="toEmails">').val(toArr[i]).appendTo("#hiddenRecipients");
      }
      for (let j=0;j<ccArr.length;j++){
        $('<input type="hidden" name="ccEmails">').val(ccArr[j]).appendTo("#hiddenRecipients");
      }
      return { toCount: toArr.length, ccCount: ccArr.length };
    }

    // ── 제출(임시/즉시 공통) : 예약 문자열 검증 포함 ────────────────
    function submitForm(){
      syncEditor();
      let counts = buildRecipientHiddenFields();

      if ($tempSaveYn.val() !== "Y" && counts.toCount === 0){
        Swal.fire({ title:'안내', text:'받는사람을 입력하세요.', icon:'warning', confirmButtonText:'확인' });
        return;
      }

      // 예약 필드가 있으면 형식 & 과거검증
      let rs = ($resveDt.val() || "").trim(); // yyyy-MM-dd HH:mm:ss
      if (rs) {
        let m = rs.match(/^(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})$/);
        if (!m) {
          Swal.fire({ title:'안내', text:'예약시간 형식이 올바르지 않습니다. 다시 설정해주세요.', icon:'warning', confirmButtonText:'확인' });
          return;
        }
        let rd = new Date(+m[1], +m[2]-1, +m[3], +m[4], +m[5], +m[6]);
        if (rd.getTime() <= Date.now()) {
          Swal.fire({ title:'안내', text:'예약시간은 현재 이후여야 합니다.', icon:'warning', confirmButtonText:'확인' });
          return;
        }
      }

      $form.trigger("submit");
    }

    // 임시저장
    $btnDraft.on("click", function(){
      Swal.fire({
        title:'임시저장',
        text:'임시저장 하시겠습니까?',
        icon:'question',
        showCancelButton:true,
        confirmButtonText:'임시저장',
        cancelButtonText:'취소'
      }).then(res => {
        if (!res.isConfirmed) return;
        $tempSaveYn.val("Y");
        submitForm();
      });
    });

    // 보내기
    $btnSend.on("click", function(){
      $tempSaveYn.val("N");
      submitForm();
    });

    // 서버 플래시 메시지 → SweetAlert2
    let message = '${msg}';
    if (message && message.trim() !== '') {
      Swal.fire({ title: message, icon: 'success', confirmButtonText: '확인' });
    }
  });
  </script>
</body>
</html>
